# Decision Card Template

> Used by agents that produce owner-facing decisions: [TRIAGE], [VALIDATE], [PMF-GATE], [CONVERT], [SPRINT-RETRO]

## Purpose

A decision card is structured decision support, not advocacy. The owner is making a binary approve/reject call. The card must give them the information they need to make that decision — including the information that argues against acting.

## Required Structure (5 parts, in this order)

### 1. Biggest Unknown

The single most important thing that has not been tested or confirmed. One sentence. This leads because uncertainty, not confidence, is what the owner most needs to know.

Format: "The biggest unknown is [X] — we have not tested whether [condition]."

### 2. What Kills This

The most likely specific failure mode. Not a general risk category — a concrete scenario. One sentence.

Format: "This fails if [specific condition], because [mechanism]."

### 3. Confidence Level

State the confidence level with a one-sentence rationale. Do not use qualifiers like "quite confident" or "fairly low" — use the three-tier enum.

- `high` — all checks passed, no concessions or unresolved blockers, evidence grounded in external sources
- `medium` — all checks passed with 1 concession or 1 unresolved minor issue, or evidence is synthesised rather than externally grounded
- `low` — borderline checks, 2+ concessions, or data is insufficient or stale

Format: "Confidence: [high/medium/low]. [One sentence rationale]."

### 4. Recommendation

One paragraph. State the recommendation first, then the supporting reasoning. The recommendation must be actionable — "approve" or "reject", not "consider" or "explore".

Format: "[PROMOTE/KILL/DEFER/etc.]. [Reasoning paragraph, 3–5 sentences]."

### 5. Agent-Specific Additions

Each agent appends its own required fields after the 4 standard parts. These are defined in the agent's own definition:

- **[TRIAGE]** adds: prosecution survival summary ("N of M prosecution points refuted"), ranked position in batch
- **[VALIDATE]** adds: quantitative summary (conversion rate, signups, would-pay), velocity trend, negative signal summary, pivot/traffic details if applicable
- **[PMF-GATE]** adds: check-by-check results table, remediation brief if failed
- **[CONVERT]** adds: test variable, behavioural principle citation, sample size calculation, kill criterion
- **[SPRINT-RETRO]** adds: sprint summary (specs delivered, feedback period, users), feature health table with per-feature evidence, amendment proposals with AC-level detail, backlog changes, next sprint preview

## Anti-Patterns

- Do not lead with the recommendation — the biggest unknown comes first
- Do not use advocacy language ("this is a great opportunity", "we're excited about", "strong signal")
- Do not omit the confidence level or leave it unqualified
- Do not state confidence as "high" without meeting all the criteria above
- Do not describe the recommendation as optional or exploratory — it must be a clear directive
