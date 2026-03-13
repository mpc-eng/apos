Run the Conversion Agent to propose a single A/B test for the week.

Read the agent definition at `.claude/agents/conversion-agent.md` and follow its instructions exactly.

Read the analytics diagnosis from `approvals/pending/analytics-output.json`.
Read MONO-REVIEW enriched diagnosis from `approvals/pending/mono-review-output.json` if available.
Respect the `do_not_test` list.

Propose exactly ONE A/B test following all 7 non-negotiable rules:
1. One variable only
2. Sample size calculated
3. Sufficient traffic check
4. No paying-user tests without approval
5. Behavioural principle cited
6. Onboarding tests need 7-day minimum
7. Kill criterion specified

Write output to `approvals/pending/conversion-output.json`.

Present a clear decision card for the owner to approve or reject.
