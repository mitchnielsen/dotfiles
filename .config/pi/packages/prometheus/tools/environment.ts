import { Type } from "@sinclair/typebox";
import { StringEnum } from "@mariozechner/pi-ai";
import {
  setEnvironment,
  getEnvironment,
  getEnvironmentLabel,
  getEnvironmentUrl,
} from "../api.js";
import { type Environment, ENVIRONMENTS } from "../types.js";
import type { ToolDef } from "../types.js";

export const readTools: ToolDef[] = [
  {
    name: "prom_set_environment",
    label: "Prometheus: Set Environment",
    description:
      "Switch the Prometheus environment for subsequent queries. All prom_* tools operate against the currently selected environment. Defaults to dev.",
    parameters: Type.Object({
      environment: StringEnum(["dev", "stg", "prd"] as const, {
        description:
          "Target environment: dev (Development), stg (Staging), prd (Production)",
      }),
    }),
    async execute(_id, params) {
      const env = params.environment as Environment;
      setEnvironment(env);
      const config = ENVIRONMENTS[env];
      return {
        content: [
          {
            type: "text",
            text: `Switched to ${config.label} environment (${config.url}).\nAll subsequent Prometheus queries will target this environment.`,
          },
        ],
      };
    },
  },

  {
    name: "prom_get_environment",
    label: "Prometheus: Get Environment",
    description:
      "Show the currently selected Prometheus environment and URL.",
    parameters: Type.Object({}),
    async execute() {
      return {
        content: [
          {
            type: "text",
            text: `Current environment: ${getEnvironment()} (${getEnvironmentLabel()})\nURL: ${getEnvironmentUrl()}`,
          },
        ],
      };
    },
  },
];

export const writeTools: ToolDef[] = [];
