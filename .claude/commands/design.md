Start the Design Iteration stage for the active app.

Read the agent definition at `.claude/agents/design-iterate-agent.md` and follow its instructions exactly.

This stage sits between Validate and Build. It uses Refero (precedent research), Stitch (screen generation), and optionally Figma (pixel-level refinement) to iterate on the visual design before any code is written.

## What happens

1. **Reference research** — Refero screens/flows in the app's category
2. **Screen generation** — Stitch mockups for critical-path screens (onboarding, core loop, empty states, paywall)
3. **CDO review** — present screens for approve/iterate/remove decisions
4. **Iteration** — up to 3 rounds of feedback and revision
5. **Design freeze** — approved screens recorded, SCREEN_MAP.md written, app moves to `design_frozen`

## Prerequisites

- Active app must have `docs/PRD.md`, `docs/DESIGN_BRIEF.md`, and `docs/ONBOARDING.md`
- These are produced during Build Foundation (Phase 1). If they don't exist, run `/build` first — it will complete Foundation, then you can run `/design` before proceeding to Phase 2.

## After design freeze

Run `/build` to continue. The Orchestrator will detect `design_frozen` status and proceed to Phase 2 (Core Loop) with approved screens in the spec and code context bundles.
