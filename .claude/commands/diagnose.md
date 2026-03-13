Diagnose and fix runtime console errors for the active app as a staff iOS engineer.

This command handles **runtime errors** (console warnings, crashes, assertion failures, continuation misuse) — NOT compilation errors (use `/fix-build` for those).

Read the active app slug from `state.json`, then follow the [DIAGNOSE] agent definition at `.claude/agents/diagnose-agent.md` exactly.

## Flow

1. Parse the provided console error lines from `$ARGUMENTS`
2. Classify each error into one of the 12 categories defined in the agent (swift_concurrency, audio_engine, audio_session, audio_buffer, speech_synthesis, capture_session, main_thread, memory, storekit, permissions, core_data, layout)
3. For each error: search the codebase for the relevant API usage, read the full source file, check related services
4. Identify the structural root cause (not the symptom)
5. Apply targeted fixes — preserve AC satisfaction, follow CLAUDE.md standards, minimise diff
6. Verify fixes compile (via XcodeBuildMCP if available)
7. Output the per-error diagnostic and summary table per the agent definition

If the app does not compile, stop and direct the owner to `/fix-build` first.

Arguments: $ARGUMENTS (required: paste the console error lines to diagnose)
