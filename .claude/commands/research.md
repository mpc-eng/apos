# /research — Deep Research for Owner-Suggested Ideas

Run the Research Agent to investigate a specific idea in depth before committing it to the pipeline.

## Usage

```
/research "one-sentence idea description"
```

## What This Does

Instead of running `/generate-ideas` (which scans signal sources for ideas you haven't thought of), `/research` takes an idea you already have and investigates it deeply:

1. **Market sizing** — TAM/SAM/SOM with cited sources
2. **Regulatory & structural context** — deadlines, compliance, platform advantages
3. **Competitor deep-dive** — every named competitor, not just top 3
4. **User research synthesis** — 50+ data points from Reddit, Trustpilot, forums
5. **Technical feasibility** — API availability, Apple framework leverage, build estimate
6. **Monetisation benchmarks** — category pricing, WTP evidence, revenue projection

## Execution

Run the Research Agent as a subagent with web research capabilities:

```
Task tool:
  subagent_type: general-purpose
  prompt: |
    Read the agent definition at .claude/agents/research-agent.md and follow it exactly.

    The owner's idea to research:
    "[IDEA DESCRIPTION FROM USER]"

    Read ideas.json to check for duplicates.
    Read state.json to verify no blocking conditions.

    Then execute all 6 research modules using WebSearch and WebFetch extensively.
    Write output to approvals/pending/research-output.json.

    After writing the research output, present the decision card to the owner
    and ask them to choose: COMMIT_TO_TRIAGE, PARK, or KILL.

    If COMMIT_TO_TRIAGE: create the ideas.json entry with status "researched"
    and research_output_ref pointing to the research output.
    If PARK: create the ideas.json entry with status "parked_research".
    If KILL: create the ideas.json entry with kill_reason and status "killed".
```

## After Research

- **COMMIT_TO_TRIAGE** → The idea appears in `ideas.json` with `status: "researched"`. Run `/triage` to evaluate it alongside any other untriaged ideas. The Triage agent reads the research output for richer prosecution/defence context.
- **PARK** → Saved for later. Re-run `/research` when unknowns are resolved.
- **KILL** → Recorded with specific kill reason. No further action needed.

## When NOT to Use

- If you want the pipeline to find ideas for you → use `/generate-ideas`
- If you have a quick signal to drop for later processing → add it to `signals/inbox.md`
- If the idea already exists in `ideas.json` → check with `/status` first
- If a validation cycle is active → complete validation first
