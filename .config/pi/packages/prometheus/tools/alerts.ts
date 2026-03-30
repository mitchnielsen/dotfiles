import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { promRequest, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "prom_get_alerts",
    label: "Prometheus: Get Alerts",
    description:
      "Get all active alerts from Prometheus. Shows currently firing and pending alerts.",
    parameters: Type.Object({}),
    async execute(_id, _params, signal) {
      const result = await promRequest("/alerts", { signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },

  {
    name: "prom_get_rules",
    label: "Prometheus: Get Rules",
    description:
      "Get all alerting and recording rules from Prometheus. Includes rule definitions, health status, and evaluation details.",
    parameters: Type.Object({
      type: Type.Optional(
        StringEnum(["alert", "record"] as const, {
          description: "Filter by rule type",
        })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        type: params.type,
      };
      const result = await promRequest("/rules", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];

export const writeTools: ToolDef[] = [];
