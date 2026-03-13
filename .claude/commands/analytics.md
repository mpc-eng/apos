Run the Analytics Interpreter for weekly AARRR funnel analysis.

Read the agent definition at `.claude/agents/analytics-agent.md` and follow its instructions exactly.

Analyse the prior week across all 5 AARRR stages:
- Acquisition (installs, trend)
- Activation (core loop completion rate)
- Retention (D1, D7, D30)
- Revenue (free-to-paid, trial-to-paid, churn)
- Referral (organic install %)

Identify the single most important bottleneck (first underperforming stage, not worst).

Include win-back offer tracking (StoreKit 2.4).

Write output to `approvals/pending/analytics-output.json`.

Present the diagnosis clearly: what's the bottleneck, what's the evidence, how severe is it.
