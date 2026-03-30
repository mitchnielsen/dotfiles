import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { promRequest, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "prom_list_metrics",
    label: "Prometheus: List Metrics",
    description:
      "List all available metric names in Prometheus. Supports optional filtering by pattern. Returns paginated results.",
    parameters: Type.Object({
      search: Type.Optional(
        Type.String({
          description:
            "Filter pattern to match against metric names (case-insensitive substring match)",
        })
      ),
      limit: Type.Optional(
        Type.Number({
          description: "Max number of metrics to return (default 100)",
        })
      ),
    }),
    async execute(_id, params, signal) {
      const result = await promRequest<{ data: string[] }>("/label/__name__/values", {
        signal,
      });
      let metrics = result.data || [];

      if (params.search) {
        const pattern = params.search.toLowerCase();
        metrics = metrics.filter((m: string) => m.toLowerCase().includes(pattern));
      }

      const limit = params.limit || 100;
      const total = metrics.length;
      metrics = metrics.slice(0, limit);

      return {
        content: [
          {
            type: "text",
            text: formatResult({ total, returned: metrics.length, metrics }),
          },
        ],
      };
    },
  },

  {
    name: "prom_get_metric_metadata",
    label: "Prometheus: Get Metric Metadata",
    description:
      "Get metadata (type, help text, unit) for a specific metric or all metrics. Useful for understanding what a metric measures.",
    parameters: Type.Object({
      metric: Type.Optional(
        Type.String({
          description: "Metric name to get metadata for. Omit for all metrics.",
        })
      ),
      limit: Type.Optional(
        Type.Number({
          description: "Max number of metrics to return metadata for (default 50)",
        })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        metric: params.metric,
        limit: params.limit ? String(params.limit) : "50",
      };
      const result = await promRequest("/metadata", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },

  {
    name: "prom_get_targets",
    label: "Prometheus: Get Targets",
    description:
      "Get information about all configured scrape targets and their current status (up/down).",
    parameters: Type.Object({
      state: Type.Optional(
        StringEnum(["active", "dropped", "any"] as const, {
          description: "Filter by target state (default: active)",
        })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        state: params.state,
      };
      const result = await promRequest("/targets", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },

  {
    name: "prom_get_label_values",
    label: "Prometheus: Get Label Values",
    description:
      "Get all values for a specific label name. Useful for discovering available namespaces, jobs, instances, etc.",
    parameters: Type.Object({
      label: Type.String({
        description: "Label name (e.g. 'namespace', 'job', 'instance')",
      }),
      match: Type.Optional(
        Type.String({
          description:
            "Series selector to filter results (e.g. '{job=\"prometheus\"}')",
        })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {};
      if (params.match) p["match[]"] = params.match;
      const result = await promRequest(`/label/${params.label}/values`, {
        params: p,
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },

  {
    name: "prom_get_series",
    label: "Prometheus: Get Series",
    description:
      "Find time series matching a set of label matchers. Returns the list of time series that match the given selectors.",
    parameters: Type.Object({
      match: Type.String({
        description:
          "Series selector (e.g. '{__name__=~\"http_.*\",job=\"api-server\"}')",
      }),
      start: Type.Optional(
        Type.String({ description: "Start timestamp (RFC3339 or Unix)" })
      ),
      end: Type.Optional(
        Type.String({ description: "End timestamp (RFC3339 or Unix)" })
      ),
      limit: Type.Optional(
        Type.Number({ description: "Max number of series to return" })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        "match[]": params.match,
        start: params.start,
        end: params.end,
        limit: params.limit ? String(params.limit) : undefined,
      };
      const result = await promRequest("/series", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];

export const writeTools: ToolDef[] = [];
