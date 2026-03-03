import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_status_pages",
    label: "PagerDuty: List Status Pages",
    description: "List all status pages with optional filtering.",
    parameters: Type.Object({
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const limit = params.limit || 25;
      const pages = await pdPaginate("/status_pages", "status_pages", { signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: pages.length, status_pages: pages }) }],
      };
    },
  },
  {
    name: "pd_get_status_page_post",
    label: "PagerDuty: Get Status Page Post",
    description: "Retrieve details of a specific status page post.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
      post_id: Type.String({ description: "Post ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/posts/${params.post_id}`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.post) }] };
    },
  },
  {
    name: "pd_list_status_page_post_updates",
    label: "PagerDuty: List Status Page Post Updates",
    description: "List all updates for a specific status page post.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
      post_id: Type.String({ description: "Post ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/posts/${params.post_id}/post_updates`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.post_updates) }] };
    },
  },
  {
    name: "pd_list_status_page_impacts",
    label: "PagerDuty: List Status Page Impacts",
    description: "List available impact levels for a status page.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/impacts`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.impacts) }] };
    },
  },
  {
    name: "pd_list_status_page_severities",
    label: "PagerDuty: List Status Page Severities",
    description: "List available severity levels for a status page.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/severities`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.severities) }] };
    },
  },
  {
    name: "pd_list_status_page_statuses",
    label: "PagerDuty: List Status Page Statuses",
    description: "List available statuses for a status page.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/statuses`,
        { signal }
      );
      return { content: [{ type: "text", text: formatResult(result.statuses) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_status_page_post",
    label: "PagerDuty: Create Status Page Post",
    description: "Create a new post (incident or maintenance) on a status page.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
      post_type: StringEnum(["incident", "maintenance"] as const, { description: "Post type" }),
      title: Type.String({ description: "Post title" }),
      starts_at: Type.Optional(Type.String({ description: "Start time (ISO 8601, for maintenance)" })),
      ends_at: Type.Optional(Type.String({ description: "End time (ISO 8601, for maintenance)" })),
      updates: Type.Optional(
        Type.Array(
          Type.Object({
            message: Type.String({ description: "Update message" }),
            status: Type.Optional(Type.String({ description: "Status ID" })),
            severity: Type.Optional(Type.String({ description: "Severity ID" })),
            impacted_services: Type.Optional(
              Type.Array(
                Type.Object({
                  id: Type.String({ description: "Service/business service ID" }),
                  type: Type.String({ description: "status_page_service or status_page_business_service" }),
                  impact: Type.Optional(Type.String({ description: "Impact ID" })),
                })
              )
            ),
          }),
          { description: "Initial updates for the post" }
        )
      ),
    }),
    async execute(_id, params, signal) {
      const post: any = {
        type: "status_page_post",
        post_type: params.post_type,
        title: params.title,
      };
      if (params.starts_at) post.starts_at = params.starts_at;
      if (params.ends_at) post.ends_at = params.ends_at;
      if (params.updates) post.updates = params.updates;
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/posts`,
        { method: "POST", body: { post }, signal }
      );
      return { content: [{ type: "text", text: formatResult(result.post) }] };
    },
  },
  {
    name: "pd_create_status_page_post_update",
    label: "PagerDuty: Create Status Page Post Update",
    description: "Add a new update to an existing status page post.",
    parameters: Type.Object({
      status_page_id: Type.String({ description: "Status page ID" }),
      post_id: Type.String({ description: "Post ID" }),
      message: Type.String({ description: "Update message" }),
      status: Type.Optional(Type.String({ description: "Status ID" })),
      severity: Type.Optional(Type.String({ description: "Severity ID" })),
      impacted_services: Type.Optional(
        Type.Array(
          Type.Object({
            id: Type.String(),
            type: Type.String(),
            impact: Type.Optional(Type.String()),
          }),
          { description: "Impacted services" }
        )
      ),
    }),
    async execute(_id, params, signal) {
      const post_update: any = { message: params.message };
      if (params.status) post_update.status = params.status;
      if (params.severity) post_update.severity = params.severity;
      if (params.impacted_services) post_update.impacted_services = params.impacted_services;
      const result = await pdRequest(
        `/status_pages/${params.status_page_id}/posts/${params.post_id}/post_updates`,
        { method: "POST", body: { post_update }, signal }
      );
      return { content: [{ type: "text", text: formatResult(result.post_update) }] };
    },
  },
];
