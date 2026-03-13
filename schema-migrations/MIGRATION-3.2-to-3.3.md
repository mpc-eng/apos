# Schema Migration Guide: v3.2 → v3.3.0

## Overview

This migration introduces the six specialist review agents (3 gate, 3 advisory), expands `state.json` with new tracking fields, and adds conditional schema logic for Monday chain agents.

## New Fields in `state.json`

| Field | Type | Purpose |
|---|---|---|
| `removal_history` | `array` | Tracks post removals for DIST-REVIEW. Each entry: `{ subreddit, removal_reason, date }` |
| `consecutive_low_signal_batches` | `integer` | Tracks consecutive low-quality idea batches for REALITY-CHECK disappointment loop detection |
| `kill_log` | `array` | Records killed ideas for pattern analysis. Each entry: `{ idea_slug, kill_reason, date }` |
| `build_momentum_signal` | `string` | Values: `strong` / `moderate` / `stalled`. Written by REALITY-CHECK, used as fallback on timeout |
| `last_heartbeat` | `object` | Written by session-start hook: `{ timestamp, session_id }` |

## New Schema Files (6 total)

All schemas are JSON Schema draft-07 with `schema_version: "3.3.0"`:

| Schema | Agent | Gate Type |
|---|---|---|
| `arch-review-output.schema.json` | ARCH-REVIEW | hard_gate |
| `ios-review-output.schema.json` | IOS-REVIEW | hard_gate |
| `ux-review-output.schema.json` | UX-REVIEW | hard_gate |
| `mono-review-output.schema.json` | MONO-REVIEW | advisory |
| `dist-review-output.schema.json` | DIST-REVIEW | advisory |
| `reality-check-output.schema.json` | REALITY-CHECK | advisory |

## Enum Additions

### MONO-REVIEW `aarrr_pattern` (6 values)
`acquisition` | `activation` | `retention` | `revenue` | `referral` | `not_diagnosed`

### MONO-REVIEW `intervention_type` (6 values)
`onboarding_optimization` | `feature_education` | `engagement_loop` | `pricing_adjustment` | `referral_incentive` | `no_intervention`

### MONO-REVIEW `flag_type` (11 values)
`pricing_tier_mismatch` | `win_back_logic_absent` | `endowment_copy_generic` | `aarrr_pattern_mismatch` | `churn_intervention_wrong` | `win_back_eligible_rate_low` | `trial_length_miscalibrated` | `annual_monthly_ratio_unhealthy` | `paywall_timing_too_early` | `paywall_timing_too_late` | `geographic_pricing_absent`

### DIST-REVIEW `recommended_channel` (9 values)
`reddit_primary` | `reddit_secondary` | `facebook_group` | `reddit_plus_facebook` | `product_hunt` | `indie_hackers` | `hacker_news` | `discord_community` | `defer_30_days`

### DIST-REVIEW `classification` (3 values)
`high_conversion` | `low_conversion` | `high_risk_removal`

### REALITY-CHECK `build_momentum_signal` (3 values)
`strong` | `moderate` | `stalled`

### REALITY-CHECK `health_status` (3 values)
`healthy` | `degraded` | `unhealthy`

### UX-REVIEW `category_register` (3 values)
`positive_affect` | `high_anxiety` | `neutral_utility`

### UX-REVIEW `d2_collection_method` (3 values)
`testflight_analytics` | `manual_check_in` | `session_log`

## Conditional (if/then) Logic in Schemas

### MONO-REVIEW
- **Condition:** When `context` is `"monday_analytics"`
- **Effect:** `enriched_diagnosis` object becomes required (contains `aarrr_pattern`, `intervention_type`, `do_not_test`, `enriched_diagnosis_source`)

### REALITY-CHECK
- **Condition:** When `context` is `"monday_session"`
- **Effect:** `monday_session` object becomes required (contains `build_momentum_signal`, `system_health`, `kill_log_pattern`, `session_framing_note`)

### UX-REVIEW
- **Condition:** When `review_passed` is `false`
- **Effect:** `redesign_brief` string becomes required (minLength: 50)

### DIST-REVIEW
- **Condition:** When `recommended_channel` is NOT `"reddit_primary"`
- **Effect:** `channel_rationale` string becomes required

## Breaking Changes

- `schema_version` must be `"3.3.0"` in all agent outputs (previously "3.2.x")
- `state.json` requires new fields — run the initialisation template from Section 4.5 of the PRD
- All agent outputs now include a `self_check` block (was not present in v3.2)

## Migration Steps

1. Update `state.json` with new fields (use the template in the PRD Section 4.5)
2. Deploy all 6 schema files to `agents/schemas/`
3. Deploy all 6 agent definition files to `.claude/agents/`
4. Deploy all 7 workflow files to `.github/workflows/`
5. Run ARCH-REVIEW to verify infrastructure: `gh workflow run arch-review.yml`
6. Verify `schema_version_match` passes for all 6 agents
