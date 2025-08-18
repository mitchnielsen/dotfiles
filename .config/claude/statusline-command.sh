#!/bin/bash

# Claude Code Status Line Script
# Shows current directory and git branch information

# Read JSON input from stdin
input=$(cat)

# Extract paths and model info
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Get git information (skip locks for performance)
cd "$current_dir" 2>/dev/null || cd "/"
git_branch=$(git branch --show-current 2>/dev/null)

# Calculate directory display relative to home
home_dir="$HOME"
if [[ "$current_dir" == "$home_dir" ]]; then
    # At home directory
    rel_dir="~"
elif [[ "$current_dir" == "$home_dir"/* ]]; then
    # Inside home directory, show relative path with ~ prefix
    rel_path="${current_dir#$home_dir/}"
    rel_dir="~/$rel_path"
else
    # Outside home directory, show full path
    rel_dir="$current_dir"
fi

# Build status line
status_line="$rel_dir"

# Add git branch info if available
if [[ -n "$git_branch" ]]; then
    status_line="$status_line ($git_branch)"
fi

# Add model info
status_line="$status_line [$model]"

printf "%s" "$status_line"