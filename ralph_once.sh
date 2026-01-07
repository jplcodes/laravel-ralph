#!/bin/bash

# Ralph Wiggum Technique - Single Iteration (Human-in-the-Loop)
# Runs Claude Code once, then validates with composer test
# https://ghuntley.com/ralph/

# Config
PROMPT_FILE="PROMPT.md"
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"

if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: $PROMPT_FILE not found"
    exit 1
fi

if [ ! -f "$PRD_FILE" ]; then
    echo "Error: $PRD_FILE not found"
    exit 1
fi

# Initialize progress.txt if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
    echo "# Ralph Progress Log" > "$PROGRESS_FILE"
    echo "Started: $(date)" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
fi

# Count untested features
untested=$(grep -c '"tested": false' "$PRD_FILE" 2>/dev/null || echo "0")

echo "Running single iteration"
echo "PRD: $PRD_FILE ($untested features remaining)"
echo "Progress: $PROGRESS_FILE"
echo "---"

# Log iteration start
echo "---" >> "$PROGRESS_FILE"
echo "## $(date)" >> "$PROGRESS_FILE"

# Run Claude Code with the prompt
cat "$PROMPT_FILE" | claude

echo ""
echo "--- Running validation: composer test ---"

if composer test; then
    echo ""
    echo "--- Tests passed ---"

    untested_after=$(grep -c '"tested": false' "$PRD_FILE" 2>/dev/null || echo "0")
    if [ "$untested_after" -eq 0 ]; then
        echo "=== ALL FEATURES COMPLETE ==="
    else
        echo "$untested_after feature(s) remaining in PRD"
        echo "Run again: ./ralph_once.sh"
    fi
else
    echo ""
    echo "--- Tests failed ---"
    echo "Review the output, then run again: ./ralph_once.sh"
fi
