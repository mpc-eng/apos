#!/usr/bin/env bash
# APOS Pipeline — Schema Validation Hook (TaskCompleted)
#
# Validates agent output JSON against its corresponding schema.
# Fires on every TaskCompleted event. Exits 0 if no agent output was produced
# or no matching schema exists. Exits 2 to block completion on validation failure.
#
# Schema mapping: approvals/pending/<name>.json -> agents/schemas/<name>.schema.json

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PENDING_DIR="$REPO_ROOT/approvals/pending"
SCHEMA_DIR="$REPO_ROOT/agents/schemas"

# Consume stdin (TaskCompleted hook input) — not used but must be read
cat > /dev/null

# Find JSON files in approvals/pending/ modified in the last 2 minutes
RECENT_FILES=$(find "$PENDING_DIR" -name "*.json" -mmin -2 2>/dev/null || true)

if [ -z "$RECENT_FILES" ]; then
  exit 0
fi

for FILE in $RECENT_FILES; do
  BASENAME=$(basename "$FILE" .json)
  SCHEMA_FILE="$SCHEMA_DIR/${BASENAME}.schema.json"

  if [ ! -f "$SCHEMA_FILE" ]; then
    continue
  fi

  RESULT=$(python3 -c "
import json, sys

output_file = '$FILE'
schema_file = '$SCHEMA_FILE'

try:
    from jsonschema import validate, ValidationError
    with open(output_file) as f:
        data = json.load(f)
    with open(schema_file) as f:
        schema = json.load(f)
    validate(instance=data, schema=schema)
    print('VALID')
except ImportError:
    # jsonschema not installed — fall back to basic JSON parse check
    with open(output_file) as f:
        json.load(f)
    print('VALID_NO_SCHEMA_CHECK')
except ValidationError as e:
    print('INVALID: ' + e.message[:200])
except json.JSONDecodeError as e:
    print('INVALID_JSON: ' + str(e)[:200])
except Exception as e:
    print('ERROR: ' + str(e)[:200])
" 2>&1)

  if [[ "$RESULT" == INVALID* ]]; then
    echo "[HOOK] Schema validation failed for ${BASENAME}: ${RESULT}" >&2
    exit 2
  fi
done

exit 0
