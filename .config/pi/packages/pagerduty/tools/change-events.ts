import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_change_events",
    label: "PagerDuty: List Change Events",
    description: "List change events with optional filtering.",
    parameters: Type.Object({
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
      team_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by team IDs" })),
      service_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by service IDs" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      if (params.team_ids) p["team_ids"] = params.team_ids;
      if (params.service_ids) p["service_ids"] = params.service_ids;
      const limit = params.limit || 25;
      const events = await pdPaginate("/change_events", "change_events", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: events.length, change_events: events }) }],
      };
    },
  },
  {
    name: "pd_get_change_event",
    label: "PagerDuty: Get Change Event",
    description: "Retrieve a specific change event.",
    parameters: Type.Object({
      id: Type.String({ description: "Change event ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/change_events/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.change_event) }] };
    },
  },
  {
    name: "pd_list_incident_change_events",
    label: "PagerDuty: List Incident Change Events",
    description: "List change events related to a specific incident.",
    parameters: Type.Object({
      incident_id: Type.String({ description: "Incident ID" }),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const limit = params.limit || 25;
      const events = await pdPaginate(
        `/incidents/${params.incident_id}/related_change_events`,
        "change_events",
        { signal },
        limit
      );
      return {
        content: [{ type: "text", text: formatResult({ total: events.length, change_events: events }) }],
      };
    },
  },
  {
    name: "pd_list_service_change_events",
    label: "PagerDuty: List Service Change Events",
    description: "List change events for a specific service.",
    parameters: Type.Object({
      service_id: Type.String({ description: "Service ID" }),
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      const limit = params.limit || 25;
      const events = await pdPaginate(
        `/services/${params.service_id}/change_events`,
        "change_events",
        { params: p, signal },
        limit
      );
      return {
        content: [{ type: "text", text: formatResult({ total: events.length, change_events: events }) }],
      };
    },
  },
];

export const writeTools: ToolDef[] = [];
