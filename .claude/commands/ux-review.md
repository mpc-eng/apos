Run the UX-REVIEW usability gate.

Read the agent definition at `.claude/agents/ux-review-agent.md` and follow its instructions exactly.

Ask the user for the path to their usability notes file if not provided as an argument: $ARGUMENTS

Review all 6 areas:
1. First Wow Moment — defined, reachable in <60s, no registration wall, positive reactions
2. Hook Model Audit — all 4 phases (Trigger, Action, Variable Reward, Investment)
3. Usability Gate — core loop completion (5/5), D2 return (3+/5), notes specificity
4. JTBD Emotional Layer — emotional completion state defined
5. Category Register — copy tone matches app register
6. Accessibility Gate — VoiceOver, Dynamic Type, WCAG AA contrast (4.5:1)

If review fails, include redesign_brief (min 50 chars).

Write output to `approvals/pending/ux-review-output.json` validated against `agents/schemas/ux-review-output.schema.json`.
