Show the Mission Control dashboard for the active app's build execution.

Read `state.json` to get the `active_app_slug`. Then read `apps/<slug>/action-queue.json` and `apps/<slug>/action-log.json` for that app.

If `action-queue.json` does not exist for the active app, say: "No action queue for [app name]. The queue is created when `/build` runs." and stop.

Present the dashboard in this exact order:

**1. Queue Status Bar**
If the queue has a `summary` block, use it directly. Otherwise, count completed vs total actions in the queue. Show a visual progress bar and phase/sprint context.
Format: `[=====>---] 12/18 actions complete (Sprint 2, Phase 2) | 3 ready, 0 blocked`

**2. Blocked/Failed Actions** (skip if none)
List any action with status `failed` or `blocked`. For each, show:
- Action name (human-readable, e.g., "Compile check for 001-core-loop")
- Agent responsible
- Error category and message (from the `error` field)
- Retry count vs max (e.g., "3/3 retries exhausted")
- **Transitive impact:** If `summary.critical_blocker` matches this action, show: "Blocking: N downstream actions" (from `summary.critical_blocker_downstream_count`). Otherwise, count downstream `blocks` dependents from `dependencies` edges.
- Suggested next step (e.g., "Run /fix-build" or "Review ARCHITECTURE.md")

**3. Critical Path** (skip if no failed actions)
If `summary.critical_blocker` is not null, walk `dependencies` edges of type `blocks` from the critical blocker to show the longest blocked chain. Format:
```
CRITICAL PATH: act_013 (compile_check) → act_014 → act_015 → act_016 → act_023 → act_024
  Longest blocked chain: N actions deep
  Impact: [human-readable summary, e.g., "Sprint deploy and retro both blocked"]
```

**4. Current Action**
The single action with status `in_progress`. Show action name, agent, spec_id if applicable, parallel_group if set, and how long it's been running (compare `started_at` to now).
If multiple actions are `in_progress` (parallel execution), show all of them with their parallel_group.
If no action is `in_progress`, show: "No action running — pipeline idle."

**5. Next Up**
All `pending` actions that are ready to execute. If `summary.ready` exists, use it for the count. Otherwise, check `depends_on` / `dependencies` with type `blocks` as before.

Group by `parallel_group` if applicable. Format:
```
READY (N actions can execute now):
  ▸ Generate spec for 001-core-loop (SPEC) — parallel_group: sprint_1_specs
  ▸ Generate spec for 002-onboarding (SPEC) — parallel_group: sprint_1_specs
```

If no actions are ready, show why (e.g., "Blocked by: [failed action ID and name]" or "Waiting on owner approval for [action]").

**6. Owner Decisions Pending** (skip if none)
Actions with `owner_approval_required: true` and status `pending`. Show action name and what's being waited on (e.g., "Spec 001-core-loop ready for review before code generation"). Flag resubmissions: if `resubmit_of` is set, show "(resubmission of act_NNN)".

**7. Override Audit** (skip if none)
Any actions with a non-null `override` field. Show: action name, override type, reason, date.

**8. Session Stats**
From the action log, calculate for today's entries:
- Total actions completed today
- Average duration (from `duration_ms` in completed events)
- Error rate (retry + failed events / total events)
- Most common error category (if any errors occurred)
- Parallel executions today (count of `parallel_group_started` events)

If the log has no entries for today, show: "No activity logged today."

**Rules:**
- This is a read-only dashboard — never modify the queue or log files
- Keep the entire output under 30 lines
- No raw JSON in output — human-readable summary only
- Use the action's `spec_id` and `sprint_number` to make action names contextual (e.g., "Generate code for 001-core-loop" not just "generate_code")
- If the queue has a `summary` block, prefer reading counts from it rather than recomputing
- Show `parallel_group` context when displaying actions in Ready and Current sections
