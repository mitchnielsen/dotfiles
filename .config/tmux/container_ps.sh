#!/usr/bin/env bash

# Prints out the number of running
# containers. To be displayed in the
# tmux status bar.

compose_file="$HOME/dotfiles/compose.yml"

total=$(docker ps -q | wc -l)

mcp=0
if [[ -f "$compose_file" ]]; then
  filters=()
  while IFS= read -r name; do
    filters+=(--filter "name=$name")
  done < <(grep 'container_name:' "$compose_file" | awk '{print $2}')
  if [[ ${#filters[@]} -gt 0 ]]; then
    mcp=$(docker ps -q "${filters[@]}" | wc -l)
  fi
fi

count=$((total - mcp))

case $count in
  0) exit 0 ;;
  1) echo "| $count container" ;;
  *) echo "| $count containers" ;;
esac
