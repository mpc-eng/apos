Run the Triage Agent on the highest-scoring ideas.

Read the agent definition at `.claude/agents/triage-agent.md` and follow its instructions exactly.

Target idea: $ARGUMENTS (if provided, triage that specific idea ID. Otherwise, find ALL highest-scoring untriaged ideas in `ideas.json` and triage them as a batch.)

**IMPORTANT: Always triage as a batch when multiple untriaged ideas exist.** The triage is a competitive ranking, not independent evaluation.

**Adversarial Process — Agent Team:**

Create an agent team for genuine adversarial separation:

1. **Prosecutor teammate**: Reads the idea(s) and writes a kill brief for each. Finds specific reasons it will fail with cited evidence. Has NO access to the defence criteria or four checks.
2. **Defence teammate**: Reads the idea(s) + the prosecutor's kill brief. For each prosecution point: refute with counter-evidence or concede with explanation.
3. **Judge (lead)**: Reads both outputs, runs four sequential checks informed by the debate:
   - Value Hypothesis — is the problem frequent, painful, and poorly solved? Is there a credible return trigger?
   - Market Demand — is there quantifiable, fresh, multi-source evidence? Cite 3+ verbatim user quotes.
   - Competitor Gap — is the gap structural, temporal, or cosmetic? Name the incumbent threat.
   - Unit Economics — can this reach £500 MRR in 12 months solo within a 12-week build?

If agent teams are unavailable, fall back to inline two-pass adversarial (same session).

**Then rank competitively.** Only one idea gets PROMOTE_TO_VALIDATE (or PROMOTE_TO_RAPID_PROTOTYPE if eligible) per batch. Others that pass checks get DEFER.

**Rapid Prototype Path:** If the winning idea meets all eligibility conditions (low complexity + direct_experience proximity + 0 concessions + ranked #1 + WIP available), present a PROMOTE_TO_RAPID_PROTOTYPE decision card alongside the standard recommendation. The owner chooses: approve rapid prototype path (skips 7-day validation, goes to compressed build + usage validation with 5 users) or standard 7-day validation.

Write output to `approvals/pending/triage-output.json`.

Present a decision card to the owner that leads with: the biggest unknown, the most likely failure mode, prosecution survival rate, and confidence level — then the recommendation. Decision cards are decision support, not advocacy.
