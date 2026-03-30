/**
 * Prometheus Extension for pi
 *
 * Replaces the prometheus-mcp-server Docker containers (dev/stg/prd) with native
 * pi tools that support environment switching. Instead of running three separate
 * MCP server containers, this single extension handles all three environments.
 *
 * Environments:
 *   - dev: https://prometheus.private.prefect.dev
 *   - stg: https://prometheus.private.stg.prefect.dev
 *   - prd: https://prometheus.private.prefect.cloud
 *
 * The LLM picks the environment from context (e.g. "check staging metrics") or
 * you can set it explicitly with /prom-env or the prom_set_environment tool.
 * Defaults to dev.
 *
 * Tools:
 *   - prom_set_environment / prom_get_environment — switch/show environment
 *   - prom_execute_query — instant PromQL query
 *   - prom_execute_range_query — range PromQL query
 *   - prom_list_metrics — list available metrics
 *   - prom_get_metric_metadata — metric type/help/unit info
 *   - prom_get_targets — scrape target status
 *   - prom_get_label_values — values for a label
 *   - prom_get_series — find matching time series
 *   - prom_get_alerts — active alerts
 *   - prom_get_rules — alerting/recording rules
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ToolDef, Environment } from "./types.js";
import { ENVIRONMENTS } from "./types.js";
import { setEnvironment, getEnvironment, getEnvironmentLabel, getEnvironmentUrl } from "./api.js";

// Import tool modules
import * as environment from "./tools/environment.js";
import * as query from "./tools/query.js";
import * as discovery from "./tools/discovery.js";
import * as alerts from "./tools/alerts.js";

const modules = [environment, query, discovery, alerts];

const allReadTools: ToolDef[] = modules.flatMap((m) => m.readTools);
const allWriteTools: ToolDef[] = modules.flatMap((m) => m.writeTools);

export default function prometheusExtension(pi: ExtensionAPI) {
  // Register --prom-env flag for startup environment selection
  pi.registerFlag("prom-env", {
    description: "Set initial Prometheus environment (dev, stg, prd)",
    type: "string",
    default: "dev",
  });

  // Register all read tools
  for (const tool of allReadTools) {
    pi.registerTool({
      name: tool.name,
      label: tool.label,
      description: tool.description,
      promptSnippet:
        tool.name === "prom_execute_query"
          ? "Execute PromQL queries against Prometheus (dev/stg/prd environments)"
          : undefined,
      parameters: tool.parameters,
      execute: tool.execute,
    });
  }

  // Register all write tools
  for (const tool of allWriteTools) {
    pi.registerTool({
      name: tool.name,
      label: tool.label,
      description: tool.description,
      parameters: tool.parameters,
      execute: tool.execute,
    });
  }

  // /prom-env command with autocomplete
  pi.registerCommand("prom-env", {
    description: "Switch Prometheus environment (dev/stg/prd)",
    getArgumentCompletions: (prefix: string) => {
      const envs = Object.entries(ENVIRONMENTS).map(([key, config]) => ({
        value: key,
        label: `${key} — ${config.label} (${config.url})`,
      }));
      const filtered = envs.filter((e) => e.value.startsWith(prefix));
      return filtered.length > 0 ? filtered : envs;
    },
    handler: async (args, ctx) => {
      const env = args?.trim() as Environment;
      if (!env || !ENVIRONMENTS[env]) {
        const current = getEnvironment();
        ctx.ui.notify(
          `Current: ${current} (${getEnvironmentLabel()})\nUsage: /prom-env <dev|stg|prd>`,
          "info"
        );
        return;
      }
      setEnvironment(env);
      ctx.ui.notify(
        `Prometheus → ${ENVIRONMENTS[env].label} (${ENVIRONMENTS[env].url})`,
        "success"
      );
    },
  });

  // Set environment from flag on session start
  pi.on("session_start", async (_event, _ctx) => {
    const flagValue = pi.getFlag("--prom-env") as string | undefined;
    if (flagValue && ENVIRONMENTS[flagValue as Environment]) {
      setEnvironment(flagValue as Environment);
    }
  });
}
