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

# Docker-based servers (requires: docker compose up -d from ~/dotfiles)
add_mcp_if_not_exists grafana add grafana --transport sse --scope user http://localhost:8100/sse
add_mcp_if_not_exists prometheus add prometheus --transport http --scope user http://localhost:8101/mcp
add_mcp_if_not_exists prefect-docs add prefect-docs --transport=http --scope=user https://docs.prefect.io/mcp
add_mcp_if_not_exists linear add linear --scope=user --transport=http https://mcp.linear.app/mcp
