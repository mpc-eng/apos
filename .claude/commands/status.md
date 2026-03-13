Show the current APOS pipeline status.

Read `state.json` and `ideas.json` and present a clear summary:

1. **Pipeline Stage** — What stage is the current app in? (Idea/Triage/Validate/Build/Convert)
2. **Ideas** — How many ideas total? How many scored 4-5? Any pending triage?
3. **Active Validation** — Is there a validation running? What day? Signup count?
4. **Build Status** — What phase? What sprint? What sprint status (planning/building/deployed/retro)? What spec? Any pending reviews?
5. **Pending Approvals** — List any files in `approvals/pending/` awaiting owner review
6. **Stale Approvals** — Check each JSON file in `approvals/pending/`. Read the `timestamp` field inside each file. If any approval is older than 48 hours, flag it with the filename and age (e.g., "ios-review-output.json — 3 days old"). If none are stale, show "None".
7. **System Health** — Schema failures? Manual file movements? Momentum signal?
8. **Alerts** — Disappointment loop? Cognitive overload? Stalled momentum?

Format this as a clear, scannable dashboard — not a wall of text.
