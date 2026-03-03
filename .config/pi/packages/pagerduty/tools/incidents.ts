import { Type, type Static } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_incidents",
    label: "PagerDuty: List Incidents",
    description:
      "List PagerDuty incidents with filtering by status, urgency, service, date range, etc.",
    parameters: Type.Object({
      statuses: Type.Optional(
        Type.Array(StringEnum(["triggered", "acknowledged", "resolved"] as const), {
          description: "Filter by statuses (default: triggered,acknowledged)",
        })
      ),
      urgencies: Type.Optional(
        Type.Array(StringEnum(["high", "low"] as const), { description: "Filter by urgencies" })
      ),
      service_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by service IDs" })),
      since: Type.Optional(Type.String({ description: "Start of date range (ISO 8601)" })),
      until: Type.Optional(Type.String({ description: "End of date range (ISO 8601)" })),
      sort_by: Type.Optional(Type.String({ description: "Sort field (e.g. incident_number:desc)" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.statuses) p["statuses"] = params.statuses;
      if (params.urgencies) p["urgencies"] = params.urgencies;
      if (params.service_ids) p["service_ids"] = params.service_ids;
      if (params.since) p.since = params.since;
      if (params.until) p.until = params.until;
      if (params.sort_by) p.sort_by = params.sort_by;
      const limit = params.limit || 25;
      const incidents = await pdPaginate("/incidents", "incidents", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: incidents.length, incidents }) }],
      };
    },
  },
  {
    name: "pd_get_incident",
    label: "PagerDuty: Get Incident",
    description: "Retrieve details of a specific PagerDuty incident by ID.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.incident) }] };
    },
  },
  {
    name: "pd_list_incident_notes",
    label: "PagerDuty: List Incident Notes",
    description: "List all notes for a specific PagerDuty incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/notes`, { signal });
      return { content: [{ type: "text", text: formatResult(result.notes) }] };
    },
  },
  {
    name: "pd_list_alerts_from_incident",
    label: "PagerDuty: List Incident Alerts",
    description: "List all alerts for a specific PagerDuty incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const alerts = await pdPaginate(`/incidents/${params.id}/alerts`, "alerts", { signal });
      return { content: [{ type: "text", text: formatResult(alerts) }] };
    },
  },
  {
    name: "pd_get_alert_from_incident",
    label: "PagerDuty: Get Incident Alert",
    description: "Retrieve a specific alert from a PagerDuty incident.",
    parameters: Type.Object({
      incident_id: Type.String({ description: "Incident ID" }),
      alert_id: Type.String({ description: "Alert ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/incidents/${params.incident_id}/alerts/${params.alert_id}`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.alert) }] };
    },
  },
  {
    name: "pd_get_outlier_incident",
    label: "PagerDuty: Get Outlier Incident",
    description: "Retrieve outlier incident information for a specific incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/outlier_incident`, { signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
  {
    name: "pd_get_past_incidents",
    label: "PagerDuty: Get Past Incidents",
    description: "Retrieve past incidents related to a specific incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/past_incidents`, { signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
  {
    name: "pd_get_related_incidents",
    label: "PagerDuty: Get Related Incidents",
    description: "Retrieve related incidents for a specific incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/related_incidents`, { signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_incident",
    label: "PagerDuty: Create Incident",
    description: "Create a new PagerDuty incident.",
    parameters: Type.Object({
      title: Type.String({ description: "Incident title" }),
      service_id: Type.String({ description: "Service ID to create incident on" }),
      urgency: Type.Optional(StringEnum(["high", "low"] as const, { description: "Urgency level" })),
      body: Type.Optional(Type.String({ description: "Incident body/details" })),
      escalation_policy_id: Type.Optional(Type.String({ description: "Escalation policy ID" })),
      assignment_ids: Type.Optional(
        Type.Array(Type.String(), { description: "User IDs to assign to" })
      ),
    }),
    async execute(_id, params, signal) {
      const incident: any = {
        type: "incident",
        title: params.title,
        service: { id: params.service_id, type: "service_reference" },
      };
      if (params.urgency) incident.urgency = params.urgency;
      if (params.body) incident.body = { type: "incident_body", details: params.body };
      if (params.escalation_policy_id) {
        incident.escalation_policy = {
          id: params.escalation_policy_id,
          type: "escalation_policy_reference",
        };
      }
      if (params.assignment_ids) {
        incident.assignments = params.assignment_ids.map((id) => ({
          assignee: { id, type: "user_reference" },
        }));
      }
      const result = await pdRequest("/incidents", {
        method: "POST",
        body: { incident },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.incident) }] };
    },
  },
  {
    name: "pd_manage_incidents",
    label: "PagerDuty: Manage Incidents",
    description:
      "Update one or more incidents: acknowledge, resolve, change urgency, reassign, or escalate.",
    parameters: Type.Object({
      incidents: Type.Array(
        Type.Object({
          id: Type.String({ description: "Incident ID" }),
          type: Type.String({ description: "Must be 'incident_reference'" }),
          status: Type.Optional(
            StringEnum(["acknowledged", "resolved"] as const, { description: "New status" })
          ),
          urgency: Type.Optional(StringEnum(["high", "low"] as const, { description: "New urgency" })),
          escalation_level: Type.Optional(Type.Number({ description: "Escalation level" })),
          assignments: Type.Optional(
            Type.Array(
              Type.Object({
                assignee: Type.Object({
                  id: Type.String(),
                  type: Type.String({ description: "user_reference" }),
                }),
              })
            )
          ),
        }),
        { description: "Array of incident updates" }
      ),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest("/incidents", {
        method: "PUT",
        body: { incidents: params.incidents },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.incidents) }] };
    },
  },
  {
    name: "pd_add_note_to_incident",
    label: "PagerDuty: Add Incident Note",
    description: "Add a note to an existing PagerDuty incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
      content: Type.String({ description: "Note content" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/notes`, {
        method: "POST",
        body: { note: { content: params.content } },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.note) }] };
    },
  },
  {
    name: "pd_add_responders",
    label: "PagerDuty: Add Responders",
    description: "Add responders to a PagerDuty incident.",
    parameters: Type.Object({
      id: Type.String({ description: "Incident ID" }),
      requester_id: Type.String({ description: "ID of user requesting responders" }),
      message: Type.Optional(Type.String({ description: "Message to send to responders" })),
      responder_request_targets: Type.Array(
        Type.Object({
          responder_request_target: Type.Object({
            id: Type.String(),
            type: StringEnum(
              ["user_reference", "escalation_policy_reference"] as const,
              { description: "Target type" }
            ),
          }),
        }),
        { description: "Responder targets" }
      ),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/incidents/${params.id}/responder_requests`, {
        method: "POST",
        body: {
          requester_id: params.requester_id,
          message: params.message || "",
          responder_request_targets: params.responder_request_targets,
        },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];
