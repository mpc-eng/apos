#!/usr/bin/env bash
# APOS Pipeline — Session Start Hook
# 1. Writes a heartbeat (timestamp + session ID) to state.json
# 2. Outputs additionalContext with active app status + next queue action
# Required by ARCH-REVIEW checklist category: session_hook

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || dirname "$(dirname "$(dirname "$0")")")"
STATE_FILE="$REPO_ROOT/state.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID=$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")

# Create state.json if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
  cat > "$STATE_FILE" << 'EOF'
{
  "schema_versions": {},
  "reddit_account": { "age_days": 0, "karma": 0 },
  "system_health": { "manual_file_movements": 0, "schema_failures_this_week": 0 },
  "removal_history": [],
  "consecutive_low_signal_batches": 0,
  "kill_log": [],
  "build_momentum_signal": "moderate"
}
EOF
fi

# Write heartbeat and extract context in a single Python call
CONTEXT=$(python3 -c "
import json, os, glob, time

state_file = '$STATE_FILE'
repo_root = '$REPO_ROOT'
timestamp = '$TIMESTAMP'
session_id = '$SESSION_ID'

# Write heartbeat
with open(state_file, 'r') as f:
    state = json.load(f)

state['last_heartbeat'] = {
    'timestamp': timestamp,
    'session_id': session_id
}

with open(state_file, 'w') as f:
    json.dump(state, f, indent=2)

# Extract context
parts = []

slug = state.get('active_app_slug', '')
if slug:
    # App registry info
    registry = state.get('app_registry', {})
    if isinstance(registry, list):
        app_entry = next((a for a in registry if a.get('slug') == slug), None)
    elif isinstance(registry, dict):
        app_entry = registry.get(slug)
    else:
        app_entry = None

    if app_entry:
        stage = app_entry.get('current_stage', app_entry.get('stage', '?'))
        platform = app_entry.get('platform', 'ios')
        parts.append(f'Active app: {slug} ({stage}/{platform})')
    else:
        parts.append(f'Active app: {slug}')

    # App state
    app_state_path = os.path.join(repo_root, 'apps', slug, 'app-state.json')
    if os.path.isfile(app_state_path):
        with open(app_state_path) as f:
            app_state = json.load(f)
        pipeline = app_state.get('pipeline', {})
        wip = pipeline.get('wip_build', {})
        if wip:
            phase = wip.get('current_phase', '?')
            sprints = wip.get('sprints', [])
            if sprints:
                current_sprint = sprints[-1]
                sprint_name = current_sprint.get('name', f'Sprint {len(sprints)}')
                sprint_status = current_sprint.get('status', '?')
                parts.append(f'Build: Phase {phase}, {sprint_name} ({sprint_status})')
            else:
                parts.append(f'Build: Phase {phase}')

    # Action queue — next action
    queue_path = os.path.join(repo_root, 'apps', slug, 'action-queue.json')
    if os.path.isfile(queue_path):
        with open(queue_path) as f:
            queue = json.load(f)
        actions = queue.get('actions', [])
        failed = [a for a in actions if a.get('status') == 'failed']
        pending = [a for a in actions if a.get('status') == 'pending']
        if failed:
            a = failed[0]
            parts.append(f'FAILED action: {a.get(\"id\", \"?\")} ({a.get(\"agent\", \"?\")})')
        elif pending:
            a = pending[0]
            parts.append(f'Next action: {a.get(\"id\", \"?\")} ({a.get(\"agent\", \"?\")})')
        summary = queue.get('summary', {})
        if summary:
            done = summary.get('completed', 0)
            total = summary.get('total', 0)
            if total > 0:
                parts.append(f'Queue: {done}/{total} complete')

    # Stale approvals (>48h)
    pending_dir = os.path.join(repo_root, 'apps', slug, 'approvals', 'pending')
    if os.path.isdir(pending_dir):
        now = time.time()
        stale = 0
        for fp in glob.glob(os.path.join(pending_dir, '*.json')):
            if now - os.path.getmtime(fp) > 172800:  # 48 hours
                stale += 1
        if stale > 0:
            parts.append(f'{stale} approval(s) stale >48h')

if not parts:
    parts.append('No active app set')

print('. '.join(parts))
" 2>/dev/null || echo "Session heartbeat recorded")

# Output JSON with additionalContext for Claude
cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[APOS] $CONTEXT"
  }
}
EOF
