import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_incident_workflows",
    label: "PagerDuty: List Incident Workflows",
    description: "List incident workflows with optional filtering.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      const limit = params.limit || 25;
      const workflows = await pdPaginate(
        "/incident_workflows",
        "incident_workflows",
        { params: p, signal },
        limit
      );
      return {
        content: [
          { type: "text", text: formatResult({ total: workflows.length, incident_workflows: workflows }) },
        ],
      };
    },
  },
  {
    name: "pd_get_incident_workflow",
    label: "PagerDuty: Get Incident Workflow",
    description: "Retrieve a specific incident workflow.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident workflow ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incident_workflows/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.incident_workflow) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_start_incident_workflow",
    label: "PagerDuty: Start Incident Workflow",
    description: "Start a workflow instance for an incident.",
    parameters: Type.Object({
      workflow_id: Type.String({ description: "Incident workflow ID" }),
      incident_id: Type.String({ description: "Incident ID to run the workflow on" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/incident_workflows/${params.workflow_id}/instances`,
        {
          method: "POST",
          body: {
            instance: {
              incident: { id: params.incident_id, type: "incident_reference" },
            },
          },
          signal,
        }
      );
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];
