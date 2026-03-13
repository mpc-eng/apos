Switch the active app context.

Target app: $ARGUMENTS

**Steps:**

1. Read `state.json` and find the app matching the provided slug in `app_registry`.
2. If no slug is provided, list all registered apps and show which one is currently active. Stop here.
3. If the slug is not found in `app_registry`, tell the user and list available apps. Stop here.
4. Update `active_app_slug` in `state.json` to the new slug.
5. Remove the existing `specs`, `approvals/pending`, and `docs` symlinks (if they are symlinks).
6. Create new symlinks:
   - `specs` → `apps/<slug>/specs`
   - `approvals/pending` → `../apps/<slug>/approvals/pending`
   - `docs` → `apps/<slug>/docs`
7. Read `apps/<slug>/app-state.json` and display:
   - App name and current pipeline stage
   - Repo path
   - Number of specs
   - Current build phase (if in build stage)

**Important:** The symlinks allow all agent definitions to work without changes — they always read from `specs/`, `approvals/pending/`, and `docs/`, which point to the active app's directories.

**Note:** `docs/schema-migrations/` is global (not per-app). It stays in its own directory and is NOT part of the symlink. Keep it at the project root if needed.

Present confirmation: "Switched to **<app name>** (<stage>)"
