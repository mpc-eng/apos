Run the Validate Agent to start a 7-day demand validation cycle.

Read the agent definition at `.claude/agents/validate-agent.md` and follow its instructions exactly.

Target idea: $ARGUMENTS (if provided, validate that specific idea ID. Otherwise, use the most recently promoted idea from triage)

## Day 1 tasks (in order):

0. **Auto-invoke DIST-REVIEW.** Read the app's category from `app-state.json`, run DIST-REVIEW to determine channel strategy using vertical-to-channel mapping from `agents/config/channel-rules.json`. Write output to `approvals/pending/dist-review-output.json`. Prefer `user` audience subreddits over `builder` audience subreddits for consumer app validation.

1. **Run pre-flight check.** Verify: triage output exists with PROMOTE_TO_VALIDATE, DIST-REVIEW channel recommendation available, Reddit account meets subreddit requirements (if Reddit selected), landing page hosting configured, Formspree email collection backend configured. If ANY check fails, present blockers to owner and STOP. Do not generate artifacts for a validation that cannot distribute.

2. Generate a landing page at `validate/<idea-slug>/index.html` with the fixed 6-section structure (including post-signup pricing signal, Formspree form action, UTM parameter capture via `?ref=` parameter, and Plausible analytics snippet)

3. **Generate channel-specific content** — minimum 2 channels based on DIST-REVIEW output. Write each to:
   - `validate/<idea-slug>/community-post-reddit.md` (if Reddit channel selected)
   - `validate/<idea-slug>/twitter-thread.md` (if Twitter/X channel selected)
   - `validate/<idea-slug>/ih-post.md` (if Indie Hackers channel selected)
   - `validate/<idea-slug>/facebook-post.md` (if Facebook channel selected)

4. Generate a direct outreach list at `validate/<idea-slug>/outreach.md` using verbatim quotes from triage to identify 10-20 users to contact

5. Update `state.json` with `active_validation` tracking (including preflight, formspree_endpoint, traffic_channels with per-channel attribution, daily_snapshots, negative_signals, velocity)

Present ALL channel-specific content drafts AND the outreach list to the owner for approval before posting.

## Subsequent runs (Days 2-7):

Update daily snapshots: page views, signups, conversion rate, would-pay breakdown, negative signals, per-channel attribution.

- **Day 3+:** If early-promote criteria met (conversion >= 12%, signups >= 30, would_pay >= 5), surface early-promote card.
- **Day 5+:** If early-kill criteria met (page_views >= 200, conversion < 2%), surface early-kill card.

## Day 7:

Produce a decision card with one of four outcomes:
- `PROMOTE_TO_BUILD` — conversion rate meets category threshold, signups >= 30
- `KILL` — conversion below category kill threshold, or net sentiment ratio < 0.3
- `PIVOT_AND_REVALIDATE` — between thresholds with positive qualitative (max 2 pivots per idea)
- `INSUFFICIENT_TRAFFIC` — page views < 200 (distribution failure, not demand failure)

The primary metric is **signup conversion rate** (signups / page views) compared to category-specific benchmarks, not absolute signup count.

Write output to `approvals/pending/validate-output.json`, validated against `agents/schemas/validate-output.schema.json`.
