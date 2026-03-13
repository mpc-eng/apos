Run the REALITY-CHECK session framing advisory.

Read the agent definition at `.claude/agents/reality-check-agent.md` and follow its instructions exactly.

Context: $ARGUMENTS (default: daily. Use "monday" for monday_session context)

Daily tasks:
- Read ideas.json and state.json
- Filter low-signal ideas (write suppressed_ids)
- Check disappointment loop detection
- Check cognitive_load_flag
- Write morning_framing (3 sentences, momentum-first)

If monday context, also produce:
- build_momentum_signal, system_health, kill_log_pattern, session_framing_note

Update state.json with consecutive_low_signal_batches and build_momentum_signal.

Write output to `approvals/pending/reality-check-output.json` validated against `agents/schemas/reality-check-output.schema.json`.
