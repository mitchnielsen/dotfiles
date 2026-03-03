/**
 * PagerDuty Extension for pi
 *
 * Replaces the PagerDuty MCP server (https://mcp.pagerduty.com/mcp) with native pi tools.
 * Covers all tool areas: incidents, services, on-call, schedules, teams, users,
 * event orchestrations, change events, log entries, incident workflows,
 * alert grouping, and status pages.
 *
 * Configuration:
 *   - Set PAGERDUTY_API_KEY (or PAGERDUTY_USER_API_KEY) environment variable
 *   - Optionally set PAGERDUTY_API_HOST for EU accounts (https://api.eu.pagerduty.com)
 *
 * Usage:
 *   Copy this directory to ~/.pi/agent/extensions/pagerduty/
 *   By default, only read-only tools are enabled.
 *   Use `--pd-write` flag or `/pd-write` command to enable write tools.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ToolDef } from "./types.js";

// Import tool modules
import * as incidents from "./tools/incidents.js";
import * as services from "./tools/services.js";
import * as oncallSchedules from "./tools/oncall-schedules.js";
import * as teamsUsers from "./tools/teams-users.js";
import * as eventOrchestrations from "./tools/event-orchestrations.js";
import * as changeEvents from "./tools/change-events.js";
import * as logEntries from "./tools/log-entries.js";
import * as incidentWorkflows from "./tools/incident-workflows.js";
import * as alertGrouping from "./tools/alert-grouping.js";
import * as statusPages from "./tools/status-pages.js";

const modules = [
  incidents,
  services,
  oncallSchedules,
  teamsUsers,
  eventOrchestrations,
  changeEvents,
  logEntries,
  incidentWorkflows,
  alertGrouping,
  statusPages,
];

const allReadTools: ToolDef[] = modules.flatMap((m) => m.readTools);
const allWriteTools: ToolDef[] = modules.flatMap((m) => m.writeTools);

export default function pagerdutyExtension(pi: ExtensionAPI) {
  let writeEnabled = false;

  // Register --pd-write flag
  pi.registerFlag("pd-write", {
    description: "Enable PagerDuty write tools (create, update, delete operations)",
    type: "boolean",
    default: false,
  });

  // Register all read tools
  for (const tool of allReadTools) {
    pi.registerTool({
      name: tool.name,
      label: tool.label,
      description: tool.description,
      parameters: tool.parameters,
      execute: tool.execute,
    });
  }

  // Register all write tools (initially they may be inactive)
  for (const tool of allWriteTools) {
    pi.registerTool({
      name: tool.name,
      label: tool.label,
      description: tool.description,
      parameters: tool.parameters,
      execute: tool.execute,
    });
  }

  function applyWriteToolState() {
    if (writeEnabled) {
      // All tools active (read + write + any others)
      // No filtering needed, all registered tools are active by default
      return;
    }
    // Disable write tools by setting active tools to exclude them
    const writeToolNames = new Set(allWriteTools.map((t) => t.name));
    const currentActive = pi.getActiveTools();
    const filtered = currentActive.filter((name) => !writeToolNames.has(name));
    pi.setActiveTools(filtered);
  }

  // /pd-write command to toggle write tools
  pi.registerCommand("pd-write", {
    description: "Toggle PagerDuty write tools (create, update, delete)",
    handler: async (_args, ctx) => {
      writeEnabled = !writeEnabled;
      applyWriteToolState();
      const state = writeEnabled ? "ENABLED" : "DISABLED";
      ctx.ui.notify(`PagerDuty write tools ${state}`, writeEnabled ? "warning" : "info");
    },
  });

  pi.on("session_start", async (_event, _ctx) => {
    if (pi.getFlag("--pd-write")) {
      writeEnabled = true;
    }
    applyWriteToolState();
  });
}
