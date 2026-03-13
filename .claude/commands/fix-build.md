Diagnose and fix build errors for the active app.

Read the active app slug from `state.json`, then:

1. Navigate to `apps/<slug>/`
2. Run `xcodegen generate` to ensure the `.xcodeproj` is up to date with all source files
3. Use XcodeBuildMCP to attempt a build: `mcp__XcodeBuildMCP__build_sim_name_proj` with the app's scheme name and project path
4. If the build succeeds: report success and list any warnings
5. If the build fails:
   a. Read the error output carefully — note file, line, and error message for each
   b. Identify which Swift files have errors
   c. Fix each error while preserving AC satisfaction (do not remove functionality to fix a build)
   d. Run `xcodegen generate` again after adding/removing files
   e. Rebuild to verify progress
   f. Repeat until build succeeds or 5 attempts exhausted
6. After a successful build, optionally run tests: `mcp__XcodeBuildMCP__test_sim_name_proj`

Common Swift 6 strict concurrency issues to watch for:
- Sendability violations: types crossing actor boundaries must be `Sendable`
- Global actor isolation: `@MainActor` on view models, proper `nonisolated` usage
- Concurrency warnings promoted to errors in strict mode
- Missing `async` on functions that call async code

This command is for manual intervention when the automated build loop in `/build` fails after 3 attempts. It runs interactively so you can make judgement calls about fixes.

Arguments: $ARGUMENTS (optional: specific error to focus on)
