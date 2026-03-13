#!/usr/bin/env bash
# APOS Pipeline — SubagentStart Context Injection Hook
# Injects standard APOS context (active app, platform, schema version, key paths)
# into every subagent automatically, reducing orchestrator bundle construction burden.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || dirname "$(dirname "$(dirname "$0")")")"
STATE_FILE="$REPO_ROOT/state.json"

# Read hook input from stdin (contains agent_type etc.)
INPUT=$(cat)

# Extract context from state.json
CONTEXT=$(python3 -c "
import json, os

state_file = '$REPO_ROOT/state.json'
if not os.path.isfile(state_file):
    print('')
    exit(0)

with open(state_file) as f:
    state = json.load(f)

slug = state.get('active_app_slug', '')
if not slug:
    print('')
    exit(0)

registry = state.get('app_registry', {})
if isinstance(registry, list):
    app_entry = next((a for a in registry if a.get('slug') == slug), None)
elif isinstance(registry, dict):
    app_entry = registry.get(slug)
else:
    app_entry = None

platform = 'ios'
stage = '?'
if app_entry:
    platform = app_entry.get('platform', 'ios')
    stage = app_entry.get('current_stage', app_entry.get('stage', '?'))

lines = []
lines.append(f'[APOS Context] App: {slug} | Platform: {platform} | Stage: {stage} | Schema: 3.4.0')
lines.append(f'Key paths: specs/ docs/ approvals/pending/ (symlinks to apps/{slug}/)')
lines.append('All agent outputs are JSON validated against agents/schemas/')
print(' | '.join(lines))
" 2>/dev/null || echo "")

# Only output JSON if we have context
if [ -n "$CONTEXT" ]; then
  # Escape for JSON
  ESCAPED=$(echo "$CONTEXT" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip()))" 2>/dev/null)
  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SubagentStart",
    "additionalContext": $ESCAPED
  }
}
EOF
else
  exit 0
fi
