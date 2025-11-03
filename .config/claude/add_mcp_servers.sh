#!/usr/bin/env bash

GRAFANA_TOKEN=$(cat "$HOME/secret/grafana-service-account-token.txt")

claude mcp add-json grafana --scope=user "{\"command\": \"/opt/homebrew/bin/docker\", \"args\": [\"run\", \"--rm\", \"-i\", \"-e\", \"GRAFANA_URL=https://grafana.private.prefect.cloud/\", \"-e\", \"GRAFANA_SERVICE_ACCOUNT_TOKEN=${GRAFANA_TOKEN}\", \"mcp/grafana\", \"-t\", \"stdio\"]}" || true

claude mcp add linear --scope=user --transport=sse https://mcp.linear.app/sse || true

claude mcp add prefect-docs --scope=user https://docs.prefect.io/mcp || true

# https://github.com/anthropics/claude-code/issues/9127#issuecomment-3419682335
claude mcp add linear-server --scope user --transport stdio -- npx mcp-remote@0.1.13 https://mcp.linear.app/sse || true
