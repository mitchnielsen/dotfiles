#!/usr/bin/env bash

# Check if an MCP server exists, and if not, add it
add_mcp_if_not_exists() {
  local server_name="$1"
  shift

  if claude mcp get "$server_name" --scope=user &>/dev/null; then
    echo "MCP server '$server_name' already exists, skipping..."
    return 0
  fi

  claude mcp "$@"
}

GRAFANA_TOKEN=$(cat "$HOME/secret/grafana-service-account-token.txt")

add_mcp_if_not_exists grafana add-json grafana --scope=user "{\"command\": \"/opt/homebrew/bin/docker\", \"args\": [\"run\", \"--rm\", \"-i\", \"-e\", \"GRAFANA_URL=https://grafana.private.prefect.cloud/\", \"-e\", \"GRAFANA_SERVICE_ACCOUNT_TOKEN=${GRAFANA_TOKEN}\", \"mcp/grafana\", \"-t\", \"stdio\"]}"

add_mcp_if_not_exists prefect-docs add prefect-docs --transport=http --scope=user https://docs.prefect.io/mcp

# add_mcp_if_not_exists linear add linear --scope=user --transport=sse https://mcp.linear.app/sse
# https://github.com/anthropics/claude-code/issues/9127#issuecomment-3419682335
add_mcp_if_not_exists linear-server add linear --scope user --transport stdio -- npx mcp-remote@0.1.13 https://mcp.linear.app/sse

add_mcp_if_not_exists mcp-router add mcp-router --scope user --transport stdio -- npx -y @mcp_router/cli@latest connect
