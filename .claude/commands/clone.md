# /clone — Clone & Differentiate from Existing App or Idea

Generate 3-5 differentiated iOS app ideas by analysing an existing app or concept.

## Usage

```
# From an external app or concept:
/clone "Headspace but for parents"
/clone "Monzo's budgeting features for freelancers"

# From an existing ideas.json entry:
/clone idea-20260224-004
/clone idea-20260224-008    # works on killed/parked ideas too
```

## What This Does

Instead of scanning for new signal (`/generate-ideas`) or researching a single concept (`/research`), `/clone` starts from an existing reference point and finds where it's weak:

1. **Reference Analysis** — Deep dive into the reference app or idea (features, reviews, pricing, trajectory)
2. **Gap Analysis** — Six dimensions: audience niche, feature gap, pricing gap, UX/accessibility gap, regulatory/market gap, platform gap
3. **Audience Fragmentation** — Who is underserved by the reference? 3-5 segments with struggle evidence
4. **Competitive Landscape** — Who has already tried to differentiate? What worked, what failed?
5. **Differentiation Strategy** — 3-5 ranked angles, each as a complete idea entry with JTBD, demand narrative, and improvement hypothesis

## Execution

Run the Clone Agent as a subagent with web research capabilities:

```
Task tool:
  subagent_type: general-purpose
  prompt: |
    Read the agent definition at .claude/agents/clone-agent.md and follow it exactly.

    The owner's clone reference:
    "[CLONE INPUT FROM USER]"

    Read ideas.json to check for duplicates and (if an ideas.json ID was provided)
    to read the referenced idea entry.
    Read state.json to verify no blocking conditions.

    Then execute all 5 analysis modules using WebSearch and WebFetch extensively.
    Write output to approvals/pending/clone-output.json.

    After writing the clone output, present the decision card to the owner showing
    the ranked differentiation angles. Ask the owner to select which angles to
    commit to ideas.json:
    - "Approve all" → write all angles to ideas.json with status "cloned"
    - "Approve #1, #3" → write selected angles only
    - "Reject all" → no ideas.json entries created

    For each approved angle: create the ideas.json entry from the idea_entry
    object in the clone output, with status "cloned" and clone_output_ref
    pointing to the clone output file.
```

## After Cloning

- Approved angles appear in `ideas.json` with `status: "cloned"` and `score: 4`.
- Run `/triage` to evaluate them alongside any other untriaged ideas.
- The Triage agent reads the clone output for richer prosecution/defence context (same pattern as researched ideas).
- Rejected angles are not written to `ideas.json` but remain in the clone output for future reference.

## When NOT to Use

- If you want the pipeline to find ideas from scratch → use `/generate-ideas`
- If you want to deeply research a single concept you already have → use `/research`
- If the app/concept has no established reference point to analyse → use `/research`
- If a validation cycle is active → complete validation first
