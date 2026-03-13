Start the Build phase using the Orchestrator Agent.

Read the agent definition at `.claude/agents/orchestrator-agent.md` and follow its instructions exactly.

The Orchestrator coordinates all build subagents. It never writes code itself. It uses the Task tool to spawn each build subagent ([SPEC], [CODE], [TEST], [REVIEW]) as an independent subagent with its own context window. This prevents context pollution between stages. See the Subagent Execution Model section in the orchestrator definition for details.

If this is a new build (no existing ARCHITECTURE.md), start with Phase 1 Foundation:
1. Spawn [PRD] subagent → writes `docs/PRD.md`
2. Spawn [ARCHITECTURE] + [DESIGN] subagents in parallel → write foundation docs
3. Present foundation docs for owner review

If foundation exists, continue with the build sequence:
1. Spawn [SPEC] subagent → writes spec with numbered ACs → owner reviews
2. Spawn [CODE] subagent → writes code to satisfy ACs
3. Compile check → `xcodegen generate` + `mcp__XcodeBuildMCP__build_sim_name_proj` → if fails, re-spawn [CODE] with errors (max 3 retries)
4. Spawn [TEST] subagent → writes XCTests mapping 1:1 to ACs
5. Test execution → `xcodegen generate` + `mcp__XcodeBuildMCP__test_sim_name_proj` → if fails, re-spawn [TEST] with failures (max 3 retries)
6. Spawn [REVIEW] subagent → validates mapping + HIG compliance (code compiles, tests pass)
7. If review fails, repeat from step 2 with review feedback

Prerequisites: XcodeGen (`brew install xcodegen`), Node.js (for XcodeBuildMCP via npx), iOS simulator available.
If compilation or tests fail after 3 retries, use `/fix-build` or `/run-tests` for manual intervention.

If `app-state.json` shows `validation_path: "rapid_prototype"`, the build is a compressed rapid prototype:
- Phase 1 Foundation runs normally (PRD, ARCHITECTURE, DESIGN, REQUIREMENTS, project config, design system)
- Tier 1.5 Checkpoint is SKIPPED (no landing page exists)
- Phase 2 is compressed to a single sprint of 1-2 core loop specs
- After the compressed sprint deploys to TestFlight, the Orchestrator surfaces a prompt to run `/validate` for Usage Validation (5 real users, 3 days)

If no validation record exists for the target app, the Orchestrator will prompt for manual override confirmation before proceeding. Manual overrides are recorded in app-state.json.

Arguments: $ARGUMENTS (optional: specific feature to build or phase to start)
