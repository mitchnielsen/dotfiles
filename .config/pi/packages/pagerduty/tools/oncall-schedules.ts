import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_oncalls",
    label: "PagerDuty: List On-Calls",
    description:
      "List current on-call entries. Shows who is on call for which escalation policy/schedule.",
    parameters: Type.Object({
      schedule_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by schedule IDs" })),
      escalation_policy_ids: Type.Optional(
        Type.Array(Type.String(), { description: "Filter by escalation policy IDs" })
      ),
      user_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by user IDs" })),
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
      earliest: Type.Optional(
        Type.Boolean({ description: "Return only earliest on-call per escalation level" })
      ),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.schedule_ids) p["schedule_ids"] = params.schedule_ids;
      if (params.escalation_policy_ids) p["escalation_policy_ids"] = params.escalation_policy_ids;
      if (params.user_ids) p["user_ids"] = params.user_ids;
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      if (params.earliest !== undefined) p.earliest = params.earliest;
      const limit = params.limit || 25;
      const oncalls = await pdPaginate("/oncalls", "oncalls", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: oncalls.length, oncalls }) }],
      };
    },
  },
  {
    name: "pd_list_schedules",
    label: "PagerDuty: List Schedules",
    description: "List PagerDuty on-call schedules.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      const limit = params.limit || 25;
      const schedules = await pdPaginate("/schedules", "schedules", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: schedules.length, schedules }) }],
      };
    },
  },
  {
    name: "pd_get_schedule",
    label: "PagerDuty: Get Schedule",
    description: "Retrieve details of a specific PagerDuty schedule.",
    parameters: Type.Object({
      id: Type.String({ description: "Schedule ID" }),
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      const result = await pdRequest(`/schedules/${params.id}`, { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result.schedule) }] };
    },
  },
  {
    name: "pd_list_schedule_users",
    label: "PagerDuty: List Schedule Users",
    description: "List users in a PagerDuty schedule.",
    parameters: Type.Object({
      id: Type.String({ description: "Schedule ID" }),
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      const result = await pdRequest(`/schedules/${params.id}/users`, { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result.users) }] };
    },
  },
  {
    name: "pd_list_escalation_policies",
    label: "PagerDuty: List Escalation Policies",
    description: "List PagerDuty escalation policies.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      user_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by user IDs" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      if (params.user_ids) p["user_ids"] = params.user_ids;
      const limit = params.limit || 25;
      const policies = await pdPaginate(
        "/escalation_policies",
        "escalation_policies",
        { params: p, signal },
        limit
      );
      return {
        content: [{ type: "text", text: formatResult({ total: policies.length, escalation_policies: policies }) }],
      };
    },
  },
  {
    name: "pd_get_escalation_policy",
    label: "PagerDuty: Get Escalation Policy",
    description: "Retrieve details of a specific escalation policy.",
    parameters: Type.Object({
      id: Type.String({ description: "Escalation policy ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/escalation_policies/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.escalation_policy) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_schedule_override",
    label: "PagerDuty: Create Schedule Override",
    description: "Create an override for a PagerDuty schedule.",
    parameters: Type.Object({
      schedule_id: Type.String({ description: "Schedule ID" }),
      user_id: Type.String({ description: "User ID for the override" }),
      start: Type.String({ description: "Override start time (ISO 8601)" }),
      end: Type.String({ description: "Override end time (ISO 8601)" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/schedules/${params.schedule_id}/overrides`, {
        method: "POST",
        body: {
          override: {
            start: params.start,
            end: params.end,
            user: { id: params.user_id, type: "user_reference" },
          },
        },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.override) }] };
    },
  },
  {
    name: "pd_create_schedule",
    label: "PagerDuty: Create Schedule",
    description: "Create a new on-call schedule.",
    parameters: Type.Object({
      name: Type.String({ description: "Schedule name" }),
      time_zone: Type.String({ description: "Time zone (e.g. America/Chicago)" }),
      schedule_layers: Type.Array(
        Type.Object({
          start: Type.String({ description: "Layer start time (ISO 8601)" }),
          rotation_virtual_start: Type.String({ description: "Virtual start for rotation" }),
          rotation_turn_length_seconds: Type.Number({ description: "Rotation turn length in seconds" }),
          users: Type.Array(
            Type.Object({
              user: Type.Object({
                id: Type.String(),
                type: Type.String({ description: "user_reference" }),
              }),
            })
          ),
        }),
        { description: "Schedule layers" }
      ),
      description: Type.Optional(Type.String({ description: "Schedule description" })),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest("/schedules", {
        method: "POST",
        body: {
          schedule: {
            type: "schedule",
            name: params.name,
            time_zone: params.time_zone,
            description: params.description || "",
            schedule_layers: params.schedule_layers,
          },
        },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.schedule) }] };
    },
  },
  {
    name: "pd_update_schedule",
    label: "PagerDuty: Update Schedule",
    description: "Update an existing on-call schedule.",
    parameters: Type.Object({
      id: Type.String({ description: "Schedule ID" }),
      name: Type.Optional(Type.String({ description: "Schedule name" })),
      time_zone: Type.Optional(Type.String({ description: "Time zone" })),
      description: Type.Optional(Type.String({ description: "Schedule description" })),
      schedule_layers: Type.Optional(Type.Array(Type.Any(), { description: "Schedule layers" })),
    }),
    async execute(_id, params, signal) {
      // Fetch current schedule first for merge
      const current = await pdRequest(`/schedules/${params.id}`, { signal });
      const schedule: any = { ...current.schedule };
      if (params.name) schedule.name = params.name;
      if (params.time_zone) schedule.time_zone = params.time_zone;
      if (params.description !== undefined) schedule.description = params.description;
      if (params.schedule_layers) schedule.schedule_layers = params.schedule_layers;
      const result = await pdRequest(`/schedules/${params.id}`, {
        method: "PUT",
        body: { schedule },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.schedule) }] };
    },
  },
];
