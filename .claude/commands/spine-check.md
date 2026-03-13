# /spine-check — Product Spine Alignment Gate

Verify that product artifacts align with the Product Spine — the single source of truth for what the product IS.

## Usage

```
/spine-check                              — Audit all artifacts against spine
/spine-check "add DiD section to methodology" — Pre-change gate on a proposed change
/spine-check create                       — Create a spine for the active app (interview mode)
```

## What This Does

Reads `apps/<slug>/docs/PRODUCT_SPINE.md` and checks product artifacts for:

1. **Promise priority alignment** — P1/P2 content gets ≥60% of space; P3/P4 doesn't dominate
2. **Value chain mapping** — every section maps to a step in the product's value chain
3. **Terminology compliance** — only canonical terms from the spine's registry
4. **Cross-artifact consistency** — figures, thresholds, tier definitions match across docs
5. **Surveillance language** — no framing of Claude evaluating people vs analysing systems
6. **Artifact role compliance** — each doc contains what it should and excludes what it shouldn't

## Execution

Read the agent definition at `.claude/agents/spine-check-agent.md` and follow its instructions exactly.

### Mode Detection

- **No arguments** → Mode B (full alignment audit of all artifacts)
- **Arguments describing a change** → Mode A (pre-change gate — evaluate before writing)
- **`create` argument** → Spine creation (interview CDO, generate spine from answers)

Arguments: $ARGUMENTS

### Steps

1. Read `state.json` to determine active app
2. Read `apps/<slug>/app-state.json` for current build phase
3. Check if `apps/<slug>/docs/PRODUCT_SPINE.md` exists
   - If no spine and not in create mode: offer to create one, then stop
   - If no spine and in create mode: run spine creation interview
   - If spine exists: proceed with Mode A or B
4. Read the spine and all product docs in `apps/<slug>/docs/`
5. Execute the relevant mode's checks
6. Deliver verdict with specific findings and recommendations

## When to Run

- **Before editing any product doc** — propose the change first, get alignment verdict
- **After a batch of artifact changes** — audit to catch drift
- **After a product pivot** — spine was updated, check everything against it
- **During Foundation (Phase 1)** — after all foundation docs are written, before build starts
- **After sprint retro** — before amendment specs enter the pipeline
- **Periodically** — quick coherence check during long build phases

## When NOT to Run

- Changing the spine itself (spine changes are ratified directly by CDO)
- Changes to framework files (agent definitions, schemas, config) — use `/sync`
- No product docs exist yet (create the spine first, then write docs against it)

## Verdicts

| Verdict | Meaning | What to do |
|---|---|---|
| **ALIGNED** | Change/artifacts match the spine | Proceed |
| **DRIFT — FIXABLE** | Valid change but needs adjustment | Apply fixes, then proceed |
| **DRIFT — SPINE UPDATE REQUIRED** | Change implies a shift in product direction | Update and ratify the spine first |
| **REJECT** | Change contradicts the product's core promises | Don't implement (CDO can override) |
