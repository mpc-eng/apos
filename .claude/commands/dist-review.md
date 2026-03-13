Run the DIST-REVIEW distribution advisory.

Read the agent definition at `.claude/agents/dist-review-agent.md` and follow its instructions exactly.

Target subreddit: $ARGUMENTS (ask the user if not provided)

Read channel and subreddit floor requirements from `agents/config/channel-rules.json`.
Read reddit_account and removal_history from `state.json`.

Assess all 4 areas:
1. Subreddit Assessment — classify target subreddit
2. Account Readiness — check against subreddit-specific floors
3. Post Structure Flags — identify weaknesses, provide rewrites
4. Validation Target — adjust signal target for channel

Select recommended_channel from 9-value enum. Include channel_rationale if not reddit_primary.

Write output to `approvals/pending/dist-review-output.json` validated against `agents/schemas/dist-review-output.schema.json`.
