#!/bin/bash

# <xbar.title>Docker Containers</xbar.title>
# <xbar.author>mitch</xbar.author>
# <xbar.desc>Count of running docker containers (excluding containers defined in ~/dotfiles/compose.yml)</xbar.desc>

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

compose_file="$HOME/dotfiles/compose.yml"

total=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')

mcp=0
if [ -f "$compose_file" ]; then
  filters=""
  for name in $(grep 'container_name:' "$compose_file" | awk '{print $2}'); do
    filters="$filters --filter name=$name"
  done
  if [ -n "$filters" ]; then
    mcp=$(eval docker ps -q "$filters" 2>/dev/null | wc -l | tr -d ' ')
  fi
fi

count=$((total - mcp))

if [ "$count" -eq 0 ]; then
  color="#2e8b57"
else
  color="#1e6fd9"
fi

echo ":shippingbox: $count | sfcolor=$color"
echo "---"
echo "Running containers: $total"
echo "Compose-managed (excluded): $mcp"
echo "---"
echo "Refresh | refresh=true"
