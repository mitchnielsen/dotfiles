import type { TObject } from "@sinclair/typebox";

export type Environment = "dev" | "stg" | "prd";

export interface EnvironmentConfig {
  url: string;
  label: string;
}

export const ENVIRONMENTS: Record<Environment, EnvironmentConfig> = {
  dev: {
    url: "https://prometheus.private.prefect.dev",
    label: "Development",
  },
  stg: {
    url: "https://prometheus.private.stg.prefect.dev",
    label: "Staging",
  },
  prd: {
    url: "https://prometheus.private.prefect.cloud",
    label: "Production",
  },
};

export interface ToolDef {
  name: string;
  label: string;
  description: string;
  parameters: TObject;
  execute: (
    toolCallId: string,
    params: any,
    signal?: AbortSignal,
    onUpdate?: any,
    ctx?: any
  ) => Promise<{ content: Array<{ type: string; text: string }> }>;
}
