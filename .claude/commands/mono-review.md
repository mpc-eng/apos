Run the MONO-REVIEW monetisation advisory.

Read the agent definition at `.claude/agents/mono-review-agent.md` and follow its instructions exactly.

Context: $ARGUMENTS (default: paywall_spec. Use "monday" for monday_analytics context)

Check for all 11 monetisation flag types. If context is monday_analytics, produce enriched_diagnosis with aarrr_pattern, intervention_type, do_not_test, and enriched_diagnosis_source.

Write output to `approvals/pending/mono-review-output.json` validated against `agents/schemas/mono-review-output.schema.json`.
