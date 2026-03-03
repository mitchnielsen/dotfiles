import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_log_entries",
    label: "PagerDuty: List Log Entries",
    description: "List log entries across the account with optional time filtering.",
    parameters: Type.Object({
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
      is_overview: Type.Optional(
        Type.Boolean({ description: "If true, return overview (compact) log entries" })
      ),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      if (params.is_overview !== undefined) p.is_overview = params.is_overview;
      const limit = params.limit || 25;
      const entries = await pdPaginate("/log_entries", "log_entries", { params: p, signal }, limit);
      return {
        content: [
          { type: "text", text: formatResult({ total: entries.length, log_entries: entries }) },
        ],
      };
    },
  },
  {
    name: "pd_get_log_entry",
    label: "PagerDuty: Get Log Entry",
    description: "Retrieve a specific log entry by ID.",
    parameters: Type.Object({
      id: Type.String({ description: "Log entry ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/log_entries/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.log_entry) }] };
    },
  },
];

export const writeTools: ToolDef[] = [];
