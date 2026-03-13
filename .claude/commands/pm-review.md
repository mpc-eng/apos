Run the PM-REVIEW staff product manager advisory.

Read the agent definition at `.claude/agents/pm-review-agent.md` and follow its instructions exactly.

Questions/concerns: $ARGUMENTS

If no arguments provided, ask the CDO to provide their questions or concerns about the current pipeline stage.

Steps:
1. Read `state.json` to determine active app and pipeline stage
2. Read the active app's `app-state.json` for current phase/sprint context
3. Read relevant artifacts for the detected stage (specs, PRD, docs, etc.)
4. Review each CDO question through the staff PM framework (Question Assessment, Coverage Analysis, Technical Feasibility, Recommendation)
5. Deliver inline markdown output — no JSON file (this is conversational advisory)
