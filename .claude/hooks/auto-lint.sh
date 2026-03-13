#!/usr/bin/env bash
# APOS Pipeline — PostToolUse Auto-Lint Hook (async)
# Runs review-lint.sh on Swift files after Write/Edit operations.
# Advisory only — never blocks. Results surface as context on next turn.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || dirname "$(dirname "$(dirname "$0")")")"
LINT_SCRIPT="$REPO_ROOT/tools/review-lint.sh"

# Read hook input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    ti = data.get('tool_input', {})
    print(ti.get('file_path', ''))
except:
    print('')
" 2>/dev/null)

# Skip if no file path or not a Swift file
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

if [[ "$FILE_PATH" != *.swift ]]; then
  exit 0
fi

# Skip test files
if [[ "$FILE_PATH" == *Tests* ]] || [[ "$FILE_PATH" == *Test.swift ]]; then
  exit 0
fi

# Skip if lint script doesn't exist
if [ ! -x "$LINT_SCRIPT" ]; then
  exit 0
fi

# Run lint on the file's directory (review-lint.sh expects a directory)
FILE_DIR=$(dirname "$FILE_PATH")
FILE_NAME=$(basename "$FILE_PATH")

# Run lint and capture output
LINT_OUTPUT=$("$LINT_SCRIPT" "$FILE_DIR" 2>&1 || true)

# Only report if violations were found
if echo "$LINT_OUTPUT" | grep -q "violations:"; then
  # Extract just the violation lines, keep it concise
  VIOLATIONS=$(echo "$LINT_OUTPUT" | grep -A 100 "Rule | Location" | head -20)
  ESCAPED=$(echo "[REVIEW-LINT] Auto-lint after editing $FILE_NAME: $VIOLATIONS" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip()))" 2>/dev/null)
  cat << EOF
{
  "systemMessage": $ESCAPED
}
EOF
fi

exit 0
