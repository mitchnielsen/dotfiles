import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_services",
    label: "PagerDuty: List Services",
    description: "List PagerDuty services with optional filtering by name or team.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      team_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by team IDs" })),
      include: Type.Optional(
        Type.Array(Type.String(), {
          description: "Additional data to include (e.g. integrations, escalation_policies)",
        })
      ),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      if (params.team_ids) p["team_ids"] = params.team_ids;
      if (params.include) p["include"] = params.include;
      const limit = params.limit || 25;
      const services = await pdPaginate("/services", "services", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: services.length, services }) }],
      };
    },
  },
  {
    name: "pd_get_service",
    label: "PagerDuty: Get Service",
    description: "Retrieve details of a specific PagerDuty service.",
    parameters: Type.Object({
      id: Type.String({ description: "Service ID" }),
      include: Type.Optional(
        Type.Array(Type.String(), { description: "Additional data to include" })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.include) p["include"] = params.include;
      const result = await pdRequest(`/services/${params.id}`, { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result.service) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_service",
    label: "PagerDuty: Create Service",
    description: "Create a new PagerDuty service.",
    parameters: Type.Object({
      name: Type.String({ description: "Service name" }),
      escalation_policy_id: Type.String({ description: "Escalation policy ID" }),
      description: Type.Optional(Type.String({ description: "Service description" })),
      auto_resolve_timeout: Type.Optional(
        Type.Number({ description: "Auto-resolve timeout in seconds (null to disable)" })
      ),
      acknowledgement_timeout: Type.Optional(
        Type.Number({ description: "Acknowledgement timeout in seconds (null to disable)" })
      ),
    }),
    async execute(_id, params, signal) {
      const service: any = {
        type: "service",
        name: params.name,
        escalation_policy: { id: params.escalation_policy_id, type: "escalation_policy_reference" },
      };
      if (params.description) service.description = params.description;
      if (params.auto_resolve_timeout !== undefined)
        service.auto_resolve_timeout = params.auto_resolve_timeout;
      if (params.acknowledgement_timeout !== undefined)
        service.acknowledgement_timeout = params.acknowledgement_timeout;
      const result = await pdRequest("/services", {
        method: "POST",
        body: { service },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.service) }] };
    },
  },
  {
    name: "pd_update_service",
    label: "PagerDuty: Update Service",
    description: "Update an existing PagerDuty service.",
    parameters: Type.Object({
      id: Type.String({ description: "Service ID" }),
      name: Type.Optional(Type.String({ description: "Service name" })),
      description: Type.Optional(Type.String({ description: "Service description" })),
      escalation_policy_id: Type.Optional(Type.String({ description: "Escalation policy ID" })),
      auto_resolve_timeout: Type.Optional(Type.Number({ description: "Auto-resolve timeout" })),
      acknowledgement_timeout: Type.Optional(Type.Number({ description: "Ack timeout" })),
    }),
    async execute(_id, params, signal) {
      const service: any = { type: "service" };
      if (params.name) service.name = params.name;
      if (params.description) service.description = params.description;
      if (params.escalation_policy_id) {
        service.escalation_policy = {
          id: params.escalation_policy_id,
          type: "escalation_policy_reference",
        };
      }
      if (params.auto_resolve_timeout !== undefined)
        service.auto_resolve_timeout = params.auto_resolve_timeout;
      if (params.acknowledgement_timeout !== undefined)
        service.acknowledgement_timeout = params.acknowledgement_timeout;
      const result = await pdRequest(`/services/${params.id}`, {
        method: "PUT",
        body: { service },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.service) }] };
    },
  },
];
