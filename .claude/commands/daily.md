Show the daily morning briefing — what needs your attention right now.

Read `state.json`, the active app's `app-state.json` (at `apps/<active_app_slug>/app-state.json`), and scan `approvals/pending/` for files.

Present a focused briefing in this exact order:

**1. Next Action (lead with this)**
Determine the single most important thing the owner should do right now. If `apps/<slug>/action-queue.json` exists for any app, also check:
- Any action with status `failed` → "MTD Landlord build blocked: [action] failed after [N] retries ([error_category]). Run /fix-build or /mission-control."
- Any action with `owner_approval_required: true` and status `pending` → "Review pending: [spec_id] spec ready for approval"
- These queue-based blockers take priority over general status checks.

Examples:
- "Resolve preflight blockers for UK Net Worth Tracker validation (Day 3/7)"
- "Review ios-review-output.json — pending 52 hours"
- "Run `/monday` — last Monday chain was 8 days ago"
- "Approve community post for validation — clock is ticking"
- "Build blocked: compile_check for 001-core-loop failed (swift6_concurrency). Run /mission-control."
- "No blockers — continue PauseMate build (Phase 2, spec 001)"

**2. Active Apps (one line each)**
For each app in the registry, show: `<name> — <stage> <detail>`
- Validate: show day counter and signup count (e.g., "Day 3/7 — 12 signups, preflight BLOCKED")
- Build: show phase, sprint number, and sprint status. If `action-queue.json` exists, enrich with queue progress (e.g., "Phase 2 — Sprint 1 (building, 8/14 actions, compiling 001-core-loop)" instead of just "Phase 2 — Sprint 1 (building)")
- Other stages: show current status

**3. Stale Approvals**
List any JSON files in `approvals/pending/` that are older than 48 hours. Show filename and age. If none are stale, skip this section entirely.

To check file age, compare the `timestamp` field inside each JSON file against today's date (available from the system). If the file has no `timestamp` field, use the file's modification time.

**4. Alerts**
Only show if something is wrong:
- Validation running with preflight failures
- Build momentum signal is "weak" or "stalled"
- Schema failures this week > 0
- Manual file movements > 0
- `/monday` not run in >7 days (check `last_monday_chain` in state.json)
- `/analytics` not run in >7 days (check `last_analytics_run` in state.json)
- Learnings file exists with unreviewed entries (check `apps/<slug>/learnings.json` for entries with `reviewed: false`)
- Sprint deployed > 5 days ago with no retro run (check sprint `deploy_date` vs today, and `status` still "deployed")
- Sprint retro output pending owner decisions (check `approvals/pending/sprint-retro-output.json`)

If no alerts, skip this section entirely.

**Rules:**
- Keep the entire briefing under 15 lines
- No agent outputs, no JSON, no schemas — this is a human-readable summary
- Lead with the next action, not a status dump
- If there's genuinely nothing to do, say so: "Pipeline clear. No pending actions."
