Register a new app in the APOS pipeline.

Arguments: $ARGUMENTS (app name, e.g. "MyNewApp")

**Steps:**

1. Ask the user for the **full path to the project** (e.g. `~/Dev/my-app`). This is required — do not assume or default.

2. Ask the user for:
   - **Platform** — `ios` or `web`. Determines which coding standards, build toolchain, design system, and agent overlays are used. See `agents/config/multi-track-architecture.md` for details.
   - **App name** (use $ARGUMENTS if provided, otherwise derive from folder name)
   - **Slug** (lowercase, hyphenated version of the name, e.g. "my-new-app")
   - **Description** (one-sentence summary)
   - **Starting stage** (idea_pool / triage / validate / build / convert)
   - **App category** — used for category-specific retention benchmarks in Analytics and PMF Gate. Valid values: `social_messaging`, `news_media`, `health_fitness`, `finance`, `travel`, `food_drink`, `entertainment`, `education`, `productivity`, `utilities`
   - **Evaluation profile** (optional) — `standard` (default) or `builder_program`. Sets additional scoring criteria for ideas targeting a specific programme.

3. Create the app directory structure:
   ```
   apps/<slug>/
     specs/
     approvals/pending/
     docs/
     app-state.json
   ```

4. **Auto-import from project repo** — scan the provided path for existing assets to bring into the pipeline:
   - **Specs:** Look for `docs/specs/`, `specs/`, or any directory containing numbered markdown specs (e.g. `001-*.md`). Copy them into `apps/<slug>/specs/`.
   - **PRD:** Look for `PRD*.md`, `PRD_*.md`, or `docs/PRD*.md`. Copy into `apps/<slug>/docs/`.
   - **Architecture docs:** Look for `ARCHITECTURE.md`, `docs/ARCHITECTURE.md`. Copy into `apps/<slug>/docs/`.
   - **Design docs:** Look for `DESIGN_BRIEF.md`, `DESIGN_PROPOSAL.md`, `TONE_AND_LANGUAGE.md`, `ONBOARDING.md`, `DESIGN_STANDARDS.md` in root or `docs/`. Copy into `apps/<slug>/docs/`.
   - **CLAUDE.md:** Read the project's `CLAUDE.md` to extract metadata for `app-state.json`.
   - **Platform-specific auto-import:**
     - **If iOS:** Look for `project.yml` / `.xcodeproj` to extract bundle ID, deployment target, team ID, extensions, capabilities. Extract Swift version from `CLAUDE.md` or `Package.swift`.
     - **If Web:** Look for `package.json` to extract name, dependencies, scripts. Look for `next.config.*`, `tsconfig.json`, `.env.example`, `vercel.json` / `netlify.toml` for deployment config. Extract Node version from `.nvmrc` or `package.json > engines`.
   - Present a summary of what was found and imported.

5. **Platform readiness check** — if platform is `web`, read `agents/config/platform-readiness.json` and check overlay status for each platform-dependent agent. If any overlays are missing, warn:
   ```
   Web platform selected. Current overlay status:
     [CODE] core + web overlay exist
     [TEST] web overlay missing (Phase B item B1)
     [REVIEW] web overlay missing (Phase B item B2)
     ...
   Web apps can proceed through idea/triage/validate stages.
   Build stage will be blocked until Phase B items are complete.
   Register anyway? (y/n)
   ```
   If all overlays are ready (or platform is `ios`), skip this step.

6. Write `apps/<slug>/app-state.json` with:
   - App metadata populated from auto-import where possible:
     - **Common:** name, slug, description, repo_path, platform, app_category, evaluation_profile
     - **iOS-specific:** bundle_id, deployment_target, swift_version
     - **Web-specific:** node_version, framework (e.g. "next.js"), deploy_target (e.g. "vercel")
   - Pipeline state (current_stage, wip_build if in build stage)
   - Registered timestamp

7. Add the app to `app_registry` in `state.json` (include `platform` field).

8. Ask: "Switch to **<app name>** now?" If yes, run the same symlink swap as `/switch`.

Present confirmation: "Registered **<app name>** at stage: <stage>. Run `/switch <slug>` to make it active."
