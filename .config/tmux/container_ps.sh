#!/usr/bin/env bash

# Prints out the number of running
# containers. To be displayed in the
# tmux status bar.

total=$(docker ps -q | wc -l)
mcp=$(docker ps -q --filter "name=mcp-grafana" --filter "name=mcp-prometheus" | wc -l)
count=$((total - mcp))

case $count in
  0) exit 0 ;;
  1) echo "| $count container" ;;
  *) echo "| $count containers" ;;
esac
