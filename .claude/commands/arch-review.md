Run the ARCH-REVIEW infrastructure gate.

Read the agent definition at `.claude/agents/arch-review-agent.md` and follow its instructions exactly.

Check all 8 categories against the current repo state:
1. mcp_server
2. prompt_caching
3. batch_api
4. model_pinning
5. schema_validation
6. session_hook
7. cost_management
8. schema_version_match

Write output to `approvals/pending/arch-review-output.json` validated against `agents/schemas/arch-review-output.schema.json`.
