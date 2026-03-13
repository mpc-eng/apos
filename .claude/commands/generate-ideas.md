Run the Idea Agent to generate new iOS app concepts.

Read the agent definition at `.claude/agents/idea-agent.md` and follow its instructions exactly.

Scan signal sources (App Store reviews, Reddit threads, Google Trends, regulatory changes, competitor gaps, Twitter/X complaint threads, Trustpilot churned-user reviews, Product Hunt/Indie Hackers failed launches) for iOS app opportunities. Score each idea 1-5. Ideas scoring 4-5 should be expanded with detail; ideas scoring 1-3 should be noted briefly.

Read existing `ideas.json` to avoid duplicates. Append new ideas with status "new" and today's date.

After generating, run a quick REALITY-CHECK filter: read `state.json` for `consecutive_low_signal_batches` and update accordingly. If all ideas score below 3, increment the counter.

Present the top ideas to the owner for review.

After presenting ideas, batch-ask the CDO about their owner proximity to each problem space: "For each idea, how close are you to this problem? Answer 'direct' / 'adjacent' / 'outsider' for each, or skip any you're unsure about." Record `owner_proximity` and apply score modifiers per the idea-agent.md definition.
