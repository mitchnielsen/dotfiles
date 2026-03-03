/**
 * Linear MCP Extension for pi
 *
 * Connects to Linear's MCP server (https://mcp.linear.app/sse) and exposes
 * all Linear tools to the LLM. Requires a LINEAR_API_KEY environment variable
 * or an OAuth token configured in Linear.
 *
 * Setup:
 *   1. Get a Linear API key from https://linear.app/settings/api
 *   2. Set LINEAR_API_KEY in your environment
 *   3. Reload pi with /reload
 *
 * Commands:
 *   /linear-reconnect  - Reconnect to the Linear MCP server
 *   /linear-status     - Show connection status
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { Type, type TObject, type TProperties } from "@sinclair/typebox";
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { SSEClientTransport } from "@modelcontextprotocol/sdk/client/sse.js";

// Map JSON Schema types to TypeBox schemas
function jsonSchemaToTypebox(schema: Record<string, any>): TObject<TProperties> {
  if (!schema || schema.type !== "object" || !schema.properties) {
    return Type.Object({});
  }

  const properties: TProperties = {};
  const required = new Set(schema.required ?? []);

  for (const [key, prop] of Object.entries(schema.properties)) {
    const p = prop as Record<string, any>;
    let field: any;

    switch (p.type) {
      case "string":
        field = Type.String({ description: p.description });
        break;
      case "number":
      case "integer":
        field = Type.Number({ description: p.description });
        break;
      case "boolean":
        field = Type.Boolean({ description: p.description });
        break;
      case "array":
        field = Type.Array(Type.Any(), { description: p.description });
        break;
      default:
        field = Type.Any({ description: p.description });
    }

    properties[key] = required.has(key) ? field : Type.Optional(field);
  }

  return Type.Object(properties);
}

export default function linearMcpExtension(pi: ExtensionAPI) {
  let mcpClient: Client | null = null;
  let transport: SSEClientTransport | null = null;
  let connected = false;
  let toolCount = 0;

  async function connect(ctx?: ExtensionContext): Promise<boolean> {
    const apiKey = process.env.LINEAR_API_KEY;
    if (!apiKey) {
      ctx?.ui.notify("LINEAR_API_KEY not set. Get one from https://linear.app/settings/api", "error");
      return false;
    }

    // Disconnect existing connection
    await disconnect();

    try {
      transport = new SSEClientTransport(new URL("https://mcp.linear.app/sse"), {
        requestInit: {
          headers: {
            Authorization: `Bearer ${apiKey}`,
          },
        },
      });

      mcpClient = new Client({ name: "pi-linear", version: "1.0.0" });
      await mcpClient.connect(transport);

      // Discover and register tools
      const { tools } = await mcpClient.listTools();
      toolCount = tools.length;

      for (const tool of tools) {
        const params = jsonSchemaToTypebox(tool.inputSchema as Record<string, any>);

        pi.registerTool({
          name: `linear_${tool.name}`,
          label: `Linear: ${tool.name}`,
          description: tool.description ?? `Linear tool: ${tool.name}`,
          parameters: params,

          async execute(_toolCallId, toolParams, signal) {
            if (!mcpClient || !connected) {
              return {
                content: [{ type: "text", text: "Not connected to Linear. Use /linear-reconnect" }],
                isError: true,
                details: {},
              };
            }

            try {
              const result = await mcpClient.callTool({
                name: tool.name,
                arguments: toolParams,
              });

              const text = (result.content as any[])
                .map((c: any) => (c.type === "text" ? c.text : JSON.stringify(c)))
                .join("\n");

              return {
                content: [{ type: "text", text }],
                isError: result.isError === true,
                details: {},
              };
            } catch (err: any) {
              return {
                content: [{ type: "text", text: `Linear MCP error: ${err.message}` }],
                isError: true,
                details: {},
              };
            }
          },
        });
      }

      connected = true;
      ctx?.ui.notify(`Connected to Linear MCP — ${toolCount} tools registered`, "success");
      ctx?.ui.setStatus("linear", "Linear ✓");
      return true;
    } catch (err: any) {
      ctx?.ui.notify(`Failed to connect to Linear: ${err.message}`, "error");
      ctx?.ui.setStatus("linear", "Linear ✗");
      connected = false;
      return false;
    }
  }

  async function disconnect() {
    connected = false;
    if (transport) {
      try {
        await transport.close();
      } catch {}
      transport = null;
    }
    mcpClient = null;
  }

  // Auto-connect on session start
  pi.on("session_start", async (_event, ctx) => {
    if (process.env.LINEAR_API_KEY) {
      await connect(ctx);
    } else {
      ctx.ui.setStatus("linear", "Linear (no key)");
    }
  });

  // Clean up on shutdown
  pi.on("session_shutdown", async () => {
    await disconnect();
  });

  // Reconnect command
  pi.registerCommand("linear-reconnect", {
    description: "Reconnect to Linear MCP server",
    handler: async (_args, ctx) => {
      await connect(ctx);
    },
  });

  // Status command
  pi.registerCommand("linear-status", {
    description: "Show Linear MCP connection status",
    handler: async (_args, ctx) => {
      if (connected) {
        ctx.ui.notify(`Connected to Linear MCP — ${toolCount} tools available`, "info");
      } else {
        ctx.ui.notify("Not connected to Linear MCP", "warning");
      }
    },
  });
}
