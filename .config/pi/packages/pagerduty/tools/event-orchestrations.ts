import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_event_orchestrations",
    label: "PagerDuty: List Event Orchestrations",
    description: "List event orchestrations with optional filtering.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      const limit = params.limit || 25;
      const orchestrations = await pdPaginate(
        "/event_orchestrations",
        "orchestrations",
        { params: p, signal },
        limit
      );
      return {
        content: [
          { type: "text", text: formatResult({ total: orchestrations.length, orchestrations }) },
        ],
      };
    },
  },
  {
    name: "pd_get_event_orchestration",
    label: "PagerDuty: Get Event Orchestration",
    description: "Retrieve a specific event orchestration.",
    parameters: Type.Object({
      id: Type.String({ description: "Event orchestration ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/event_orchestrations/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.orchestration) }] };
    },
  },
  {
    name: "pd_get_event_orchestration_router",
    label: "PagerDuty: Get Event Orchestration Router",
    description: "Get the router configuration for an event orchestration.",
    parameters: Type.Object({
      id: Type.String({ description: "Event orchestration ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/event_orchestrations/${params.id}/router`,
        { signal }
      );
      return {
        content: [{ type: "text", text: formatResult(result.orchestration_path) }],
      };
    },
  },
  {
    name: "pd_get_event_orchestration_global",
    label: "PagerDuty: Get Event Orchestration Global",
    description: "Get the global orchestration configuration for an event orchestration.",
    parameters: Type.Object({
      id: Type.String({ description: "Event orchestration ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/event_orchestrations/${params.id}/global`,
        { signal }
      );
      return {
        content: [{ type: "text", text: formatResult(result.orchestration_path) }],
      };
    },
  },
  {
    name: "pd_get_event_orchestration_service",
    label: "PagerDuty: Get Service Event Orchestration",
    description: "Get the service orchestration configuration for a specific service.",
    parameters: Type.Object({
      service_id: Type.String({ description: "Service ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/event_orchestrations/services/${params.service_id}`,
        { signal }
      );
      return {
        content: [{ type: "text", text: formatResult(result.orchestration_path) }],
      };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_update_event_orchestration_router",
    label: "PagerDuty: Update Event Orchestration Router",
    description: "Update the router configuration for an event orchestration.",
    parameters: Type.Object({
      id: Type.String({ description: "Event orchestration ID" }),
      orchestration_path: Type.Any({ description: "Router configuration object" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/event_orchestrations/${params.id}/router`,
        {
          method: "PUT",
          body: { orchestration_path: params.orchestration_path },
          signal,
        }
      );
      return {
        content: [{ type: "text", text: formatResult(result.orchestration_path) }],
      };
    },
  },
  {
    name: "pd_append_event_orchestration_router_rule",
    label: "PagerDuty: Append Event Orchestration Router Rule",
    description: "Add a new routing rule to an event orchestration router.",
    parameters: Type.Object({
      id: Type.String({ description: "Event orchestration ID" }),
      rule: Type.Any({ description: "Rule object to append" }),
    }),
    async execute(_id, params, signal) {
      // Fetch current router config
      const current = await pdRequest(
        `/event_orchestrations/${params.id}/router`,
        { signal }
      );
      const path = current.orchestration_path;
      if (!path.sets || !path.sets[0]) {
        return { content: [{ type: "text", text: "Error: No rule sets found in router." }] };
      }
      path.sets[0].rules = [...(path.sets[0].rules || []), params.rule];
      const result = await pdRequest(
        `/event_orchestrations/${params.id}/router`,
        {
          method: "PUT",
          body: { orchestration_path: path },
          signal,
        }
      );
      return {
        content: [{ type: "text", text: formatResult(result.orchestration_path) }],
      };
    },
  },
];
