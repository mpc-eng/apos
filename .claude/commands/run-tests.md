Run all tests for the active app and report results.

Read the active app slug from `state.json`, then:

1. Navigate to `apps/<slug>/`
2. Run `xcodegen generate` to ensure the `.xcodeproj` includes all source and test files
3. Use XcodeBuildMCP to run tests: `mcp__XcodeBuildMCP__test_sim_name_proj` with the app's scheme name and project path
4. Report:
   - Total tests run, passed, failed
   - For each failure: test name, file, line, assertion details
   - Suggestions for fixing any failures
5. If tests cannot compile, run `/fix-build` first

Arguments: $ARGUMENTS (optional: specific test target or test file to focus on)
