import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { isAbsolute, relative } from "node:path";
import {
  createBashToolDefinition,
  createEditToolDefinition,
  createFindToolDefinition,
  createGrepToolDefinition,
  createLsToolDefinition,
  createReadToolDefinition,
  createWriteToolDefinition,
  stripFrontmatter,
  type ExtensionAPI,
  type ToolDefinition,
} from "@earendil-works/pi-coding-agent";
import { Container, Text } from "@earendil-works/pi-tui";
import type { TSchema } from "typebox";

type ToolFactory<TParams extends TSchema, TDetails, TState> = (
  cwd: string,
) => ToolDefinition<TParams, TDetails, TState>;

const parseCommandArgs = (input: string): string[] => {
  const args: string[] = [];
  let current = "";
  let quote: "'" | '"' | null = null;

  for (const character of input) {
    if (quote) {
      if (character === quote) {
        quote = null;
      } else {
        current += character;
      }
    } else if (character === "'" || character === '"') {
      quote = character;
    } else if (/\s/.test(character)) {
      if (current) {
        args.push(current);
        current = "";
      }
    } else {
      current += character;
    }
  }

  if (current) args.push(current);
  return args;
};

const substituteArgs = (content: string, args: string[]): string => {
  const allArgs = args.join(" ");

  return content.replace(
    /\$\{(\d+):-([^}]*)\}|\$\{@:(\d+)(?::(\d+))?\}|\$(ARGUMENTS|@|\d+)/g,
    (_match, defaultNumber, defaultValue, sliceStart, sliceLength, simple) => {
      if (defaultNumber) {
        return args[Number(defaultNumber) - 1] || defaultValue;
      }

      if (sliceStart) {
        const start = Math.max(0, Number(sliceStart) - 1);
        return sliceLength
          ? args.slice(start, start + Number(sliceLength)).join(" ")
          : args.slice(start).join(" ");
      }

      if (simple === "ARGUMENTS" || simple === "@") return allArgs;
      return args[Number(simple) - 1] ?? "";
    },
  );
};

const compactPath = (value: unknown, cwd: string): string => {
  if (typeof value !== "string" || !value) return "…";

  const home = homedir();
  if (value === home) return "~";
  if (value.startsWith(`${home}/`)) return `~${value.slice(home.length)}`;

  if (isAbsolute(value)) {
    const local = relative(cwd, value);
    if (local && !local.startsWith("..") && !isAbsolute(local)) return local;
  }

  return value;
};

const compactText = (value: unknown, maxLength = 140): string => {
  const text = typeof value === "string" ? value.replace(/\s+/g, " ").trim() : "";
  if (text.length <= maxLength) return text || "…";
  return `${text.slice(0, maxLength - 1)}…`;
};

const formatCall = (name: string, args: unknown, cwd: string): { label: string; detail: string } => {
  const input = args && typeof args === "object" ? (args as Record<string, unknown>) : {};

  switch (name) {
    case "bash":
      return { label: "$", detail: compactText(input.command) };
    case "edit": {
      const count = Array.isArray(input.edits) ? input.edits.length : 0;
      return {
        label: "edit",
        detail: `${compactPath(input.path, cwd)}${count ? ` (${count} block${count === 1 ? "" : "s"})` : ""}`,
      };
    }
    case "write": {
      const lines = typeof input.content === "string" ? input.content.split("\n").length : 0;
      return {
        label: "write",
        detail: `${compactPath(input.path, cwd)}${lines ? ` (${lines} line${lines === 1 ? "" : "s"})` : ""}`,
      };
    }
    case "read": {
      const offset = typeof input.offset === "number" ? input.offset : undefined;
      const limit = typeof input.limit === "number" ? input.limit : undefined;
      const range = offset !== undefined || limit !== undefined
        ? `:${offset ?? 1}${limit !== undefined ? `-${(offset ?? 1) + limit - 1}` : ""}`
        : "";
      return { label: "read", detail: `${compactPath(input.path, cwd)}${range}` };
    }
    case "grep":
      return {
        label: "grep",
        detail: `/${compactText(input.pattern, 80)}/ in ${compactPath(input.path ?? ".", cwd)}`,
      };
    case "find":
      return {
        label: "find",
        detail: `${compactText(input.pattern, 80)} in ${compactPath(input.path ?? ".", cwd)}`,
      };
    case "ls":
      return { label: "ls", detail: compactPath(input.path ?? ".", cwd) };
    default:
      return { label: name, detail: "" };
  }
};

const registerCompactTool = <TParams extends TSchema, TDetails, TState>(
  pi: ExtensionAPI,
  factory: ToolFactory<TParams, TDetails, TState>,
): void => {
  const definitions = new Map<string, ToolDefinition<TParams, TDetails, TState>>();
  const getDefinition = (cwd: string) => {
    let definition = definitions.get(cwd);
    if (!definition) {
      definition = factory(cwd);
      definitions.set(cwd, definition);
    }
    return definition;
  };

  const initial = getDefinition(process.cwd());

  pi.registerTool({
    ...initial,
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getDefinition(ctx.cwd).execute(toolCallId, params, signal, onUpdate, ctx);
    },
    renderCall(args, theme, context) {
      const definition = getDefinition(context.cwd);
      if (context.expanded && definition.renderCall) {
        return definition.renderCall(args, theme, { ...context, lastComponent: undefined });
      }

      const call = formatCall(initial.name, args, context.cwd);
      const text = theme.fg("toolTitle", theme.bold(call.label));
      const detail = call.detail ? ` ${theme.fg("accent", call.detail)}` : "";
      return new Text(`${text}${detail}`, 0, 0);
    },
    renderResult(result, options, theme, context) {
      const definition = getDefinition(context.cwd);
      if ((options.expanded || context.isError) && definition.renderResult) {
        return definition.renderResult(result, options, theme, { ...context, lastComponent: undefined });
      }
      return new Container();
    },
  });
};

export default function (pi: ExtensionAPI): void {
  registerCompactTool(pi, createReadToolDefinition);
  registerCompactTool(pi, createBashToolDefinition);
  registerCompactTool(pi, createEditToolDefinition);
  registerCompactTool(pi, createWriteToolDefinition);
  registerCompactTool(pi, createGrepToolDefinition);
  registerCompactTool(pi, createFindToolDefinition);
  registerCompactTool(pi, createLsToolDefinition);

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode === "tui") ctx.ui.setToolsExpanded(false);
  });

  pi.on("input", (event) => {
    const match = event.text.match(/^\/([^\s]+)(?:\s+([\s\S]*))?$/);
    if (!match) return { action: "continue" };

    const command = pi.getCommands().find(
      (candidate) => candidate.name === match[1] && candidate.source === "prompt",
    );
    if (!command) return { action: "continue" };

    try {
      const body = stripFrontmatter(readFileSync(command.sourceInfo.path, "utf8"));
      const expanded = substituteArgs(body, parseCommandArgs(match[2] ?? "")).trim();
      const location = command.sourceInfo.path.replaceAll('"', "&quot;");
      return {
        action: "transform",
        text: `<skill name="/${command.name}" location="${location}">\n${expanded}\n</skill>`,
      };
    } catch {
      return { action: "continue" };
    }
  });
}
