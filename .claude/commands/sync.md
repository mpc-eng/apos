Propagate framework changes across all APOS artifacts.

Read the agent definition at `.claude/agents/sync-agent.md` and follow its instructions exactly.

After any framework change (new agents, updated rules, schema bumps, renamed commands, changed thresholds), this command:

1. **Detects** what changed via git diff
2. **Classifies** changes into sync groups (agents, commands, schemas, rules, state, config, app structure)
3. **Auto-counts** agents, commands, schemas, signal sources — flags stale references
4. **Builds a sync plan** showing every file and line that needs updating
5. **Requests approval** before applying any changes
6. **Applies** auto changes and prompts for manual items
7. **Verifies** all counts match after applying

Run this after making framework changes to keep CLAUDE.md, USER_GUIDE.md, agent definitions, schemas, and all cross-references consistent.
