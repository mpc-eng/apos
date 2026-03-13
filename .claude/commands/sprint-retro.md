Run the Sprint Retro Agent after a sprint deploys to TestFlight and feedback is collected.

Read the agent definition at `.claude/agents/sprint-retro-agent.md` and follow its instructions exactly.

Target sprint: $ARGUMENTS (if provided, retro that specific sprint number. Otherwise, find the sprint with `status: "retro"` in `app-state.json`)

## Before running:

1. Check `apps/<slug>/app-state.json` for a sprint with `status: "retro"`.
2. Verify at least 3 days have elapsed since the sprint's `deploy_date`.
3. Check for `apps/<slug>/sprint-feedback.md` — if it does not exist, prompt the owner to create it using the template from the agent definition.

## Process:

1. Read the sprint's deployed specs from `app-state.json`
2. Read the full spec files for each feature in the sprint
3. Read `apps/<slug>/sprint-feedback.md` for structured feedback
4. Read `apps/<slug>/learnings.json` for historical context
5. Assess each feature's health
6. Propose amendments for features rated `needs_amendment`
7. Propose backlog adjustments
8. Compose the next sprint
9. Capture learnings
10. Present decision card to owner

## Owner decisions:

The owner approves or rejects:
- Each amendment proposal individually
- Backlog reorder/defer/add/promote proposals
- The next sprint composition

Approved amendments become amendment specs queued into the next sprint.
Rejected amendments are recorded as "owner_rejected" in the retro output.

After the owner decides, prompt for additional learnings:
> "Any learnings to capture from this sprint? e.g., 'Users need visual feedback during escalation transitions'"

Write output to `approvals/pending/sprint-retro-output.json`, validated against `agents/schemas/sprint-retro-output.schema.json`.

Update `app-state.json`:
- Set current sprint `status: "complete"`
- Set current sprint `retro_date` to now
- Apply approved backlog adjustments
- Queue approved amendments into the next sprint
- Create the next sprint entry with `status: "planning"`
