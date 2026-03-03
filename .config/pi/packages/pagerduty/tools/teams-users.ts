import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { pdRequest, pdPaginate, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "pd_list_teams",
    label: "PagerDuty: List Teams",
    description: "List PagerDuty teams.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      const limit = params.limit || 25;
      const teams = await pdPaginate("/teams", "teams", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: teams.length, teams }) }],
      };
    },
  },
  {
    name: "pd_get_team",
    label: "PagerDuty: Get Team",
    description: "Retrieve details of a specific PagerDuty team.",
    parameters: Type.Object({
      id: Type.String({ description: "Team ID" }),
    }),
    async execute(_id, params, signal) {
      const result = await pdRequest(`/teams/${params.id}`, { signal });
      return { content: [{ type: "text", text: formatResult(result.team) }] };
    },
  },
  {
    name: "pd_list_team_members",
    label: "PagerDuty: List Team Members",
    description: "List members of a PagerDuty team.",
    parameters: Type.Object({
      id: Type.String({ description: "Team ID" }),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const limit = params.limit || 25;
      const members = await pdPaginate(
        `/teams/${params.id}/members`,
        "members",
        { signal },
        limit
      );
      return {
        content: [{ type: "text", text: formatResult({ total: members.length, members }) }],
      };
    },
  },
  {
    name: "pd_list_users",
    label: "PagerDuty: List Users",
    description: "List users in the PagerDuty account.",
    parameters: Type.Object({
      query: Type.Optional(Type.String({ description: "Filter by name or email" })),
      team_ids: Type.Optional(Type.Array(Type.String(), { description: "Filter by team IDs" })),
      limit: Type.Optional(Type.Number({ description: "Max results (default 25)" })),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, any> = {};
      if (params.query) p.query = params.query;
      if (params.team_ids) p["team_ids"] = params.team_ids;
      const limit = params.limit || 25;
      const users = await pdPaginate("/users", "users", { params: p, signal }, limit);
      return {
        content: [{ type: "text", text: formatResult({ total: users.length, users }) }],
      };
    },
  },
  {
    name: "pd_get_current_user",
    label: "PagerDuty: Get Current User",
    description: "Get the current authenticated user's data.",
    parameters: Type.Object({}),
    async execute(_id, _params, signal) {
      const result = await pdRequest("/users/me", { signal });
      return { content: [{ type: "text", text: formatResult(result.user) }] };
    },
  },
];

export const writeTools: ToolDef[] = [
  {
    name: "pd_create_team",
    label: "PagerDuty: Create Team",
    description: "Create a new PagerDuty team.",
    parameters: Type.Object({
      name: Type.String({ description: "Team name" }),
      description: Type.Optional(Type.String({ description: "Team description" })),
      parent_id: Type.Optional(Type.String({ description: "Parent team ID" })),
    }),
    async execute(_id, params, signal) {
      const team: any = { type: "team", name: params.name };
      if (params.description) team.description = params.description;
      if (params.parent_id) team.parent = { id: params.parent_id, type: "team_reference" };
      const result = await pdRequest("/teams", { method: "POST", body: { team }, signal });
      return { content: [{ type: "text", text: formatResult(result.team) }] };
    },
  },
  {
    name: "pd_update_team",
    label: "PagerDuty: Update Team",
    description: "Update an existing PagerDuty team.",
    parameters: Type.Object({
      id: Type.String({ description: "Team ID" }),
      name: Type.Optional(Type.String({ description: "Team name" })),
      description: Type.Optional(Type.String({ description: "Team description" })),
    }),
    async execute(_id, params, signal) {
      const team: any = { type: "team" };
      if (params.name) team.name = params.name;
      if (params.description) team.description = params.description;
      const result = await pdRequest(`/teams/${params.id}`, {
        method: "PUT",
        body: { team },
        signal,
      });
      return { content: [{ type: "text", text: formatResult(result.team) }] };
    },
  },
  {
    name: "pd_delete_team",
    label: "PagerDuty: Delete Team",
    description: "Delete a PagerDuty team.",
    parameters: Type.Object({
      id: Type.String({ description: "Team ID" }),
    }),
    async execute(_id, params, signal) {
      await pdRequest(`/teams/${params.id}`, { method: "DELETE", signal });
      return { content: [{ type: "text", text: "Team deleted successfully." }] };
    },
  },
  {
    name: "pd_add_team_member",
    label: "PagerDuty: Add Team Member",
    description: "Add a user to a PagerDuty team.",
    parameters: Type.Object({
      team_id: Type.String({ description: "Team ID" }),
      user_id: Type.String({ description: "User ID" }),
      role: Type.Optional(
        StringEnum(["manager", "responder", "observer"] as const, { description: "Team role" })
      ),
    }),
    async execute(_id, params, signal) {
      const body: any = {};
      if (params.role) body.role = params.role;
      await pdRequest(`/teams/${params.team_id}/users/${params.user_id}`, {
        method: "PUT",
        body,
        signal,
      });
      return { content: [{ type: "text", text: "User added to team successfully." }] };
    },
  },
  {
    name: "pd_remove_team_member",
    label: "PagerDuty: Remove Team Member",
    description: "Remove a user from a PagerDuty team.",
    parameters: Type.Object({
      team_id: Type.String({ description: "Team ID" }),
      user_id: Type.String({ description: "User ID" }),
    }),
    async execute(_id, params, signal) {
      await pdRequest(`/teams/${params.team_id}/users/${params.user_id}`, {
        method: "DELETE",
        signal,
      });
      return { content: [{ type: "text", text: "User removed from team successfully." }] };
    },
  },
];
