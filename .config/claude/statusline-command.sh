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

# Extract input and output token counts
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
INPUT_FORMATTED=$(format_number $INPUT_TOKENS)
OUTPUT_FORMATTED=$(format_number $OUTPUT_TOKENS)

# Format and output the statusline
printf "  %s 🔋 %b ⬇ %s ⬆ %s  " \
    "$MODEL" "$BAR" "$INPUT_FORMATTED" "$OUTPUT_FORMATTED"
