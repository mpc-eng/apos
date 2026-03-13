Run the Build Quality Evaluator to surface pipeline health metrics.

Read the agent definition at `.claude/agents/build-quality-agent.md` and follow its instructions exactly.

This command reads `build_progress` from all registered apps and computes:
- First-pass success rates (compile, test, review)
- Retry distributions and hotspots
- Error category frequency (from action logs)
- Context bundle efficiency
- Test coverage trends
- Sprint velocity
- Amendment rates

No input required — the agent reads all data from existing `app-state.json` and `action-log.json` files.
