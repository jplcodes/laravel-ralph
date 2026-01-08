#!/bin/bash

# Ralph Wiggum Technique - Laravel Template
# A persistent loop that runs Claude Code until all PRD features are tested
# https://ghuntley.com/ralph/

set -e

# Config
PROMPT_FILE="PROMPT.md"
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"
MAX_ITERATIONS=50

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--max-iterations)
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: ./ralph.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -n, --max-iterations NUM  Maximum iterations (default: 50)"
            echo "  -h, --help                Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./ralph.sh           # Run with defaults (50 iterations)"
            echo "  ./ralph.sh -n 100    # Run up to 100 iterations"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

iteration=0

if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: $PROMPT_FILE not found"
    echo "Use --help for usage information"
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

# Function to check if all features are tested
all_features_tested() {
    # Count features where tested is false
    untested=$(grep -c '"tested": false' "$PRD_FILE" 2>/dev/null || echo "0")
    [ "$untested" -eq 0 ]
}

echo "Starting Ralph loop with $PROMPT_FILE (max $MAX_ITERATIONS iterations)"
echo "PRD: $PRD_FILE"
echo "Progress: $PROGRESS_FILE"
echo "Stop condition: composer test passes AND all PRD features tested"
echo "---"

while [ $iteration -lt $MAX_ITERATIONS ]; do
    iteration=$((iteration + 1))
    echo ""
    echo "=== Iteration $iteration of $MAX_ITERATIONS ==="
    echo ""

    # Log iteration start to progress file
    echo "---" >> "$PROGRESS_FILE"
    echo "## Iteration $iteration - $(date)" >> "$PROGRESS_FILE"

    # Run Claude Code with the prompt
    echo "--- Running Claude Code ---"
    claude -p "$(cat "$PROMPT_FILE")"
    echo "--- Claude Code completed ---"

    echo ""
    echo "--- Running validation: composer test ---"

    # Check if tests pass
    if composer test; then
        echo ""
        echo "--- Tests passed, checking PRD completion ---"

        if all_features_tested; then
            echo "" >> "$PROGRESS_FILE"
            echo "=== COMPLETED: All features tested on iteration $iteration ===" >> "$PROGRESS_FILE"
            echo ""
            echo "=== SUCCESS: All tests passed and all PRD features tested on iteration $iteration ==="
            exit 0
        else
            echo "--- Some PRD features still untested, continuing ---"
        fi
    else
        echo ""
        echo "--- Tests failed, continuing to next iteration ---"
    fi
done

echo "" >> "$PROGRESS_FILE"
echo "=== STOPPED: Reached max iterations ($MAX_ITERATIONS) ===" >> "$PROGRESS_FILE"
echo ""
echo "=== STOPPED: Reached max iterations ($MAX_ITERATIONS) ==="
exit 1
