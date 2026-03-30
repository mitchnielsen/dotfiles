/**
 * Prometheus HTTP API client with multi-environment support
 */

import { type Environment, ENVIRONMENTS } from "./types.js";

let currentEnvironment: Environment = "dev";

export function setEnvironment(env: Environment): void {
  currentEnvironment = env;
}

export function getEnvironment(): Environment {
  return currentEnvironment;
}

export function getEnvironmentUrl(): string {
  return ENVIRONMENTS[currentEnvironment].url;
}

export function getEnvironmentLabel(): string {
  return ENVIRONMENTS[currentEnvironment].label;
}

export interface RequestOptions {
  params?: Record<string, string | undefined>;
  method?: string;
  body?: URLSearchParams;
  signal?: AbortSignal;
}

export async function promRequest<T = any>(
  path: string,
  options: RequestOptions = {}
): Promise<T> {
  const baseUrl = getEnvironmentUrl();
  const { params, method = "GET", body, signal } = options;

  const url = new URL(`/api/v1${path}`, baseUrl);
  if (params) {
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined) {
        url.searchParams.set(key, value);
      }
    }
  }

  const headers: Record<string, string> = {
    Accept: "application/json",
  };

  const response = await fetch(url.toString(), {
    method,
    headers,
    body: body ? body.toString() : undefined,
    signal,
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(
      `Prometheus API error ${response.status} (${getEnvironmentLabel()}): ${errorBody}`
    );
  }

  return response.json() as Promise<T>;
}

/** Format a Prometheus API response for tool output, truncating if needed */
export function formatResult(data: unknown, env?: Environment): string {
  const e = env ?? currentEnvironment;
  const prefix = `[${ENVIRONMENTS[e].label} — ${ENVIRONMENTS[e].url}]\n\n`;
  const json = JSON.stringify(data, null, 2);
  const full = prefix + json;
  if (full.length > 48000) {
    return full.slice(0, 48000) + "\n\n[Output truncated]";
  }
  return full;
}
