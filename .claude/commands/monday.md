Run the full Monday morning chain using an agent team for parallel execution.

**Create an agent team with this structure:**

**Teammate "analyst" (starts immediately):**
- Read `.claude/agents/analytics-agent.md` and follow its instructions exactly
- Run AARRR funnel analysis on last week's data
- Write output to `approvals/pending/analytics-output.json`
- No dependencies — starts immediately

**Teammate "framing" (starts immediately, parallel with analyst):**
- Read `.claude/agents/reality-check-agent.md` and follow its instructions exactly
- Run in `monday_session` context
- Produce `build_momentum_signal`, `system_health`, `kill_log_pattern`, and `session_framing_note`
- Write output to `approvals/pending/reality-check-output.json`
- No dependencies — runs in parallel with analyst

**Lead task: Monetisation Review (after analyst completes):**
- Wait for the analyst teammate to complete
- Read `.claude/agents/mono-review-agent.md` and follow its instructions exactly
- Run in `monday_analytics` context using the analytics output
- Enrich the analytics diagnosis with `aarrr_pattern`, `intervention_type`, and `do_not_test`
- Write output to `approvals/pending/mono-review-output.json`

**Lead task: Conversion Proposal (after monetisation review completes):**
- Read `.claude/agents/conversion-agent.md` and follow its instructions exactly
- Using the enriched diagnosis from ANALYTICS + MONO-REVIEW, propose a single A/B test for the week
- Write output to `approvals/pending/conversion-output.json`

**After all tasks complete, present a consolidated Monday briefing:**
- Session framing note (from REALITY-CHECK)
- Key metric changes (from ANALYTICS)
- Monetisation flags (from MONO-REVIEW, if any)
- This week's recommended A/B test (from CONVERT)
- Any alerts or flags

**Fallback:** If agent teams are unavailable, run all four steps sequentially in this order: ANALYTICS → MONO-REVIEW → REALITY-CHECK → CONVERT. This matches the original behavior.
