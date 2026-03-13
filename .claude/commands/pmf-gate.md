Run the PMF-GATE product-market fit gate.

Read the agent definition at `.claude/agents/pmf-gate-agent.md` and follow its instructions exactly.

This gate runs between Build Phase 2 (Core Loop) and Phase 3 (Monetisation). It requires at least 20 TestFlight users with 7+ days of usage data.

Ask the user to provide:
1. Sean Ellis survey results (or help them draft the survey to send)
2. D7 retention data from TestFlight analytics or Mixpanel
3. Core loop completion counts per user
4. NPS survey results (or help them draft the survey to send)

Run all 4 checks:
1. Ellis 40% Test — >= 40% "very disappointed" from >= 10 respondents
2. Retention — D7 meets category-specific threshold from app-state.json
3. Core Loop Engagement — >= 50% of users completed core loop 3+ times in 7 days
4. NPS Baseline — positive NPS (> 0)

If gate fails, include remediation_brief (min 100 chars) with specific changes needed.

Write output to `approvals/pending/pmf-gate-output.json`.
