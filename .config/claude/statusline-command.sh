#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Format numbers with K/M suffixes
format_number() {
    local num=$1
    if [ -z "$num" ] || [ "$num" -eq 0 ] 2>/dev/null; then
        echo "0"
    elif [ "$num" -ge 1000000 ] 2>/dev/null; then
        awk "BEGIN {printf \"%.2fM\", $num/1000000}"
    elif [ "$num" -ge 1000 ] 2>/dev/null; then
        awk "BEGIN {printf \"%.1fK\", $num/1000}"
    else
        echo "$num"
    fi
}

# Extract values using jq
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
# Replace home directory with ~
CURRENT_DIR="${CURRENT_DIR/#$HOME/~}"
MODEL=$(echo "$input" | jq -r '.model.display_name')
REMAINING_PERCENT=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100')
USED_PERCENT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Create a bar chart for context remaining (battery drains as context is used)
BLOCKS=$((REMAINING_PERCENT / 10))
BAR=""
for ((i=0; i<10; i++)); do
    if [ $i -lt $BLOCKS ]; then
        BAR="${BAR}█"
    else
        BAR="${BAR}░"
    fi
done

# Color the battery bar based on remaining context
if [ "$REMAINING_PERCENT" -lt 12 ]; then
    BAR="\033[38;5;196m${BAR}\033[0m"  # Red
elif [ "$REMAINING_PERCENT" -lt 25 ]; then
    BAR="\033[38;5;226m${BAR}\033[0m"  # Yellow
else
    BAR="\033[38;5;114m${BAR}\033[0m"  # Green
fi

# Calculate transcript tokens from character count
TRANSCRIPT_PATH=$(echo "$input" | jq -r '.transcript_path')
if [ -f "$TRANSCRIPT_PATH" ]; then
    CHAR_COUNT=$(wc -c < "$TRANSCRIPT_PATH")
    TRANSCRIPT_TOKENS=$((CHAR_COUNT / 4))
else
    TRANSCRIPT_TOKENS=0
fi
TRANSCRIPT_TOKENS_FORMATTED=$(format_number $TRANSCRIPT_TOKENS)

# Format and output the statusline
printf "  🤖 %s 🔋 %b 📝 %s  " \
    "$MODEL" "$BAR" "$TRANSCRIPT_TOKENS_FORMATTED"
