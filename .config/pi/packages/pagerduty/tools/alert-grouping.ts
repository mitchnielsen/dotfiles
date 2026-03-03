import { Type } from "@sinclair/typebox";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_alert_grouping_settings",
    label: "PagerDuty: List Alert Grouping Settings",
    description: "List alert grouping settings with optional filtering.",
    parameters: Type.Object({
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const limit = params.limit || 25;
      const settings = await pdPaginate(
        "/alert_grouping_settings",
        "alert_grouping_settings",
        { signal },
        limit
      );
      return {
        content: [
          {
            type: "text",
            text: formatResult({ total: settings.length, alert_grouping_settings: settings }),
          },
        ],
      };
    },
  },
  {
    name: "pd_get_alert_grouping_setting",
    label: "PagerDuty: Get Alert Grouping Setting",
    description: "Retrieve a specific alert grouping setting.",
    parameters: Type.Object({
      id: Type.String({ description: "Alert grouping setting ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/alert_grouping_settings/${params.id}`, { signal });
      return {
        content: [{ type: "text", text: formatResult(result.alert_grouping_setting) }],
      };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_alert_grouping_setting",
    label: "PagerDuty: Create Alert Grouping Setting",
    description: "Create a new alert grouping setting.",
    parameters: Type.Object({
      alert_grouping_setting: Type.Any({
        description: "Alert grouping setting configuration object",
      }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest("/alert_grouping_settings", {
        method: "POST",
        body: { alert_grouping_setting: params.alert_grouping_setting },
        signal,
      });
      return {
        content: [{ type: "text", text: formatResult(result.alert_grouping_setting) }],
      };
    },
  },
  {
    name: "pd_update_alert_grouping_setting",
    label: "PagerDuty: Update Alert Grouping Setting",
    description: "Update an existing alert grouping setting.",
    parameters: Type.Object({
      id: Type.String({ description: "Alert grouping setting ID" }),
      alert_grouping_setting: Type.Any({
        description: "Updated alert grouping setting configuration",
      }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/alert_grouping_settings/${params.id}`, {
        method: "PUT",
        body: { alert_grouping_setting: params.alert_grouping_setting },
        signal,
      });
      return {
        content: [{ type: "text", text: formatResult(result.alert_grouping_setting) }],
      };
    },
  },
  {
    name: "pd_delete_alert_grouping_setting",
    label: "PagerDuty: Delete Alert Grouping Setting",
    description: "Delete an alert grouping setting.",
    parameters: Type.Object({
      id: Type.String({ description: "Alert grouping setting ID" }),
    }),
    async execute(_id, params, signal) {
      await pdRequest(`/alert_grouping_settings/${params.id}`, { method: "DELETE", signal });
      return { content: [{ type: "text", text: "Alert grouping setting deleted successfully." }] };
    },
  },
];
