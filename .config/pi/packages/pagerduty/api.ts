/**
 * PagerDuty REST API v2 client
 */

const DEFAULT_API_HOST = "https://api.pagerduty.com";

export interface PagerDutyConfig {
  apiKey: string;
  apiHost: string;
}

export function getConfig(): PagerDutyConfig {
  const apiKey = process.env.PAGERDUTY_API_KEY || process.env.PAGERDUTY_USER_API_KEY;
  if (!apiKey) {
    throw new Error(
      "PagerDuty API key not found. Set PAGERDUTY_API_KEY or PAGERDUTY_USER_API_KEY environment variable."
    );
  }
  return {
    apiKey,
    apiHost: process.env.PAGERDUTY_API_HOST || DEFAULT_API_HOST,
  };
}

export interface RequestOptions {
  method?: string;
  params?: Record<string, string | string[] | number | boolean | undefined>;
  body?: unknown;
  signal?: AbortSignal;
}

export async function pdRequest<T = any>(path: string, options: RequestOptions = {}): Promise<T> {
  const config = getConfig();
  const { method = "GET", params, body, signal } = options;

  const url = new URL(path, config.apiHost);
  if (params) {
    for (const [key, value] of Object.entries(params)) {
      if (value === undefined) continue;
      if (Array.isArray(value)) {
        for (const v of value) {
          url.searchParams.append(`${key}[]`, v);
        }
      } else {
        url.searchParams.set(key, String(value));
      }
    }
  }

  const headers: Record<string, string> = {
    Authorization: `Token token=${config.apiKey}`,
    "Content-Type": "application/json",
    Accept: "application/vnd.pagerduty+json;version=2",
  };

  const response = await fetch(url.toString(), {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
    signal,
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(`PagerDuty API error ${response.status}: ${errorBody}`);
  }

  if (response.status === 204) return {} as T;
  return response.json() as Promise<T>;
}

/**
 * Paginate through all results from a PagerDuty API endpoint.
 */
export async function pdPaginate<T = any>(
  path: string,
  resultKey: string,
  options: RequestOptions = {},
  maxResults = 500
): Promise<T[]> {
  const allResults: T[] = [];
  let offset = 0;
  const limit = 100;

  while (allResults.length < maxResults) {
    const params = { ...options.params, offset: String(offset), limit: String(limit) };
    const response = await pdRequest(path, { ...options, params });
    const items = response[resultKey] || [];
    allResults.push(...items);

    if (!response.more || items.length === 0) break;
    offset += limit;
  }

  return allResults.slice(0, maxResults);
}

/** Format a PagerDuty API response for tool output, truncating if needed */
export function formatResult(data: unknown): string {
  const json = JSON.stringify(data, null, 2);
  if (json.length > 48000) {
    return json.slice(0, 48000) + "\n\n[Output truncated]";
  }
  return json;
}
