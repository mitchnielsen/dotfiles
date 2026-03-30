import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import { promRequest, formatResult } from "../api.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "prom_execute_query",
    label: "Prometheus: Execute Query",
    description:
      "Execute a PromQL instant query against Prometheus. Returns the current value of a PromQL expression. The environment (dev/stg/prd) is controlled by the prom_set_environment tool or /prom-env command.",
    parameters: Type.Object({
      query: Type.String({ description: "PromQL query expression" }),
      time: Type.Optional(
        Type.String({
          description:
            "Evaluation timestamp (RFC3339 or Unix timestamp). Defaults to current server time.",
        })
      ),
      timeout: Type.Optional(
        Type.String({ description: "Evaluation timeout (e.g. '30s')" })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        query: params.query,
        time: params.time,
        timeout: params.timeout,
      };
      const result = await promRequest("/query", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },

  {
    name: "prom_execute_range_query",
    label: "Prometheus: Execute Range Query",
    description:
      "Execute a PromQL range query with start time, end time, and step interval. Returns a matrix of values over the specified time range.",
    parameters: Type.Object({
      query: Type.String({ description: "PromQL query expression" }),
      start: Type.String({
        description: "Start timestamp (RFC3339 or Unix timestamp)",
      }),
      end: Type.String({
        description: "End timestamp (RFC3339 or Unix timestamp)",
      }),
      step: Type.String({
        description: "Query resolution step width (e.g. '15s', '1m', '5m')",
      }),
      timeout: Type.Optional(
        Type.String({ description: "Evaluation timeout (e.g. '30s')" })
      ),
    }),
    async execute(_id, params, signal) {
      const p: Record<string, string | undefined> = {
        query: params.query,
        start: params.start,
        end: params.end,
        step: params.step,
        timeout: params.timeout,
      };
      const result = await promRequest("/query_range", { params: p, signal });
      return { content: [{ type: "text", text: formatResult(result) }] };
    },
  },
];

export const writeTools: ToolDef[] = [];
