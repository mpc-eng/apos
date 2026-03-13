# /framework-review — Critical Review of External Sources Against APOS

Evaluate whether an external source (article, repo, talk, paper) contains ideas that should be adopted into the APOS framework.

## Usage

```
/framework-review <url>
/framework-review <url> "focus on their approach to X"
```

## What This Does

Takes a URL, fetches the content, and produces a staff-engineer-grade critical review against the APOS framework:

1. **Source comprehension** — What is this, who made it, what does it claim?
2. **Problem overlap** — Does APOS have the problem this source solves?
3. **Architecture compatibility** — Would adoption break APOS conventions?
4. **Concept extraction** — Even if the whole is rejected, are individual ideas useful?
5. **Anti-pattern detection** — Complexity theatre, dependency creep, cargo culting?
6. **Implementation recommendation** — Specific scope, files, effort, and risks

## Execution

Run the Framework Review Agent inline:

```
Read the agent definition at .claude/agents/framework-review-agent.md and follow it exactly.

The URL to review:
"[URL FROM USER]"

[Optional focus area from user, if provided]

Use WebFetch to retrieve the source content. If it's a GitHub repo, also fetch
the README and key source files.

Read CLAUDE.md and relevant agent definitions to ground the review against the
current framework state.

Produce the full structured review as inline markdown.
```

## After the Review

Based on the verdict:

- **ADOPT** — CDO approves → create a proposal in `proposals/` (see `proposals/dependency-graph-queue.md` for format) → implement via `/sync` after changes are made
- **PARTIALLY ADOPT** — CDO selects which concepts to adopt → create a scoped proposal → implement
- **DEFER** — Note the trigger condition. Revisit when the trigger fires.
- **REJECT** — No further action. The review serves as a record of evaluation.

## When NOT to Use

- Evaluating an app idea → use `/research`
- Evaluating a competitor app → use `/clone`
- Reviewing internal APOS artifacts → use `/pm-review`
- Quick question about the framework → just ask directly

## Examples

```
/framework-review https://github.com/someone/cool-agent-framework
/framework-review https://blog.example.com/agentic-pipelines-2026 "focus on their error recovery approach"
/framework-review https://arxiv.org/abs/2026.12345 "relevant to our triage adversarial pattern?"
```
