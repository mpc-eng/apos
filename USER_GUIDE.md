 # APOS Pipeline — User Guide

## What Is This?

APOS is your automated co-pilot for building software products (iOS apps or web/SaaS). It takes you from "I have no idea what to build" all the way to "my app is live and optimising conversions" — with expert checks at every step.

APOS supports **two platforms** (iOS and Web), **three ideation modes** (market-pull, technology-push, clone), and **evaluation profiles** (standard, builder program) that layer additional scoring criteria. See `agents/config/multi-track-architecture.md` for details.

The system has five stages:

```
IDEA POOL → (optional: RESEARCH / CLONE) → TRIAGE → VALIDATE → BUILD → CONVERT
```

You talk to it through **Claude Code** in VS Code. Type `/` to see all available commands.

---

## Prerequisites

One-time setup:
- **Xcode** with iOS simulator (e.g., iPhone 16)
- **XcodeGen**: `brew install xcodegen` — generates `.xcodeproj` from `project.yml`
- **Node.js**: required for XcodeBuildMCP (runs via `npx` automatically)
- **Xcode 26.3+** (optional): enables Apple's native `xcrun mcpbridge` for documentation search, SwiftUI preview rendering, and Swift REPL

## Getting Started

1. Open VS Code
2. Open the `apos-pipeline` folder (File → Open Folder → `~/apos-pipeline`)
3. Open the Claude Code panel
4. Type `/generate-ideas` to start

That's it. The pipeline guides you from there.

---

## Your Role: Chief Decision Officer

You don't do research, write first drafts, or monitor dashboards. The agents do that. Your job is to make decisions:

- **Approve or reject** ideas at each gate
- **Review specs** before code is written
- **Approve channel-specific posts** (Reddit, Twitter/X, Indie Hackers, etc.) before they go live
- **Set up Formspree** for your first validation (one-time, 2 minutes)
- **Approve A/B tests** each week

**Time commitment:**
- 5-10 minutes each morning
- 30 minutes on Monday (weekly review)
- 60-90 minutes during active build sessions (reviewing specs and code)

---

## The Five Stages

### Stage 1: Idea Pool — "What should I build?"

```
/generate-ideas
```

The Idea Agent scans 8 signal sources for iOS app opportunities: App Store reviews, Reddit threads, Google Trends, GOV.UK/regulatory changes, competitor review mining, **Twitter/X complaint threads**, **Trustpilot churned-user reviews**, and **Product Hunt/Indie Hackers failed launches**. It prioritises **struggle behaviour** over stated demand — elaborate workarounds, repeated failure chains, and non-consumption are stronger signals than "I wish there was an app."

Twitter/X captures complaints in real-time moments of frustration. Trustpilot catches users who've already churned from competitors (a different population from App Store reviews, which skew toward current users). Product Hunt/Indie Hackers post-mortems reveal validated demand where the product was wrong — the gap still exists.

For each idea, it frames the **user value** — what job the user is hiring the app to do, what they do today without it, and what would trigger them to switch. Each idea gets a score from 1-5. Ideas scoring 4-5 are highlighted; lower scores are collapsed. A **session frequency gate** is applied first — ideas where the core job completes in one or a few sessions are capped at score 1-2 regardless of signal strength, since they can't support a subscription model.

You can also drop raw signals into `signals/inbox.md` at any time — a Reddit thread, an App Store review, a tweet. The Idea Agent will pick them up on its next run, evaluate them, and either score them or discard them.

An idea can't score above 3 unless it has a clear job-to-be-done and a concrete switching trigger. An idea can't score above 2 if the core job is lifecycle-event frequency, or above 1 if it's one-and-done — no matter how strong the external signal.

Each idea also captures three context signals: **session frequency** (whether the core job recurs daily/weekly — required to justify subscription pricing; this is a hard gate, not a bonus), **owner proximity** (how close you are to the problem — `direct_experience`, `adjacent_domain`, or `outsider`), and **trend coupling** (whether the idea rides a rising trend). The Idea Agent will ask you about your proximity after presenting generated ideas. Direct experience adds a small scoring bonus (+0.5), and ideas riding fresh trends (<90 days) can also get a boost. Owner proximity and trend coupling are not hard gates — outsider ideas with strong signals still proceed.

**Your job:** Look at the top ideas. Each high-scoring idea includes a **demand narrative** (a short story of a real person's struggle) and an **improvement hypothesis** (a testable before/after claim). Ask yourself:
1. Does the **demand narrative** feel true? Can you picture this person? Would they recognise themselves in this story?
2. Is the **improvement hypothesis** credible? Is the claimed improvement (e.g., "15 minutes → 60 seconds") genuinely achievable, or is it aspirational?
3. Is the **switching trigger** concrete? A deadline, a shutdown, a life event — not just "they're frustrated sometimes"?

Move your favourites to triage.

### Optional: Deep Research — "I have a specific idea"

```
/research "BTL company tax app for UK landlords"
```

If you already have an idea in mind, `/research` investigates it deeply before it enters the pipeline. Instead of the Idea Agent's wide-and-shallow signal scan, the Research Agent goes narrow-and-deep on one concept:

- **Market sizing** — TAM/SAM/SOM with cited sources
- **Regulatory & structural context** — deadlines, compliance, platform advantages
- **Competitor deep-dive** — every named competitor, not just the top 3
- **User research synthesis** — 50+ data points from Reddit, Trustpilot, forums, App Store reviews
- **Technical feasibility** — API availability, Apple framework leverage, solo-buildability
- **Monetisation benchmarks** — category pricing, willingness-to-pay evidence, revenue projection
- **Value Chain Stress Test** *(mandatory)* — decomposes the value proposition into 3-7 delivery steps, checks whether required inputs (data, APIs, partnerships) actually exist, identifies the bottleneck step, and rates overall deliverability. This catches ideas where demand is strong but the core feature depends on data that doesn't exist publicly.

The agent runs as a background subagent with heavy web research. When it finishes, you get a decision card with three options:

- **COMMIT_TO_TRIAGE** — Research supports viability. The idea enters `ideas.json` with status `researched` and goes to triage with the full research context (the prosecution and defence both get 50+ data points instead of 3-5).
- **PARK** — Research is inconclusive. Saved for later.
- **KILL** — Research found a fatal flaw. Recorded and done.

This replaces the pattern of manually promoting ideas with ad-hoc research. The research output becomes part of the audit trail and enriches the triage debate.

**Your job:** Describe your idea in 1-3 sentences. Review the decision card when it arrives. Choose COMMIT, PARK, or KILL.

### Optional: Clone & Differentiate — "What if I twisted this?"

```
/clone "Headspace but for parents"
/clone idea-20260224-004
```

If you see an app you like but think it misses something — a user segment, a pricing model, a UK-specific angle — `/clone` investigates the reference deeply and generates 3-5 differentiated concepts.

The Clone Agent analyses the reference across seven dimensions:
- **Audience niche** — who does the reference exclude?
- **Feature gap** — what's missing that users actually request?
- **Pricing gap** — is the pricing model wrong for a segment?
- **UX/accessibility gap** — where is the execution poor?
- **Regulatory/market gap** — UK-specific opportunities?
- **Platform gap** — web-only or Android-first → iOS opportunity?
- **Value-chain coupling gap** — where does the reference force users through friction (data entry, configuration, mandatory tutorials) bundled with the actual value? An app that delivers the value without the friction has a natural switching trigger.

You can also point it at a killed or parked idea from your own `ideas.json` — maybe the concept was right but the angle was wrong. The agent maps what failed, finds new angles, and generates fresh ideas that avoid the original failure mode.

Each angle is a complete idea entry with JTBD, demand narrative, and improvement hypothesis. You select which angles to commit, and they enter `ideas.json` ready for `/triage`.

**Your job:** Describe the reference app or provide an idea ID. Review the decision card showing ranked angles. Select which angles to commit to the pipeline.

### Stage 2: Triage — "Is this worth pursuing?"

```
/triage
```

Triage is adversarial and competitive. It's designed to kill ideas cheaply before you spend 7 days and real reputation validating them in public.

**How it works:**

1. **Prosecution first (separate agent).** A Prosecutor teammate writes a "kill brief" — a 3-paragraph argument for why this idea will fail. It looks for failed predecessors, weak switching triggers, stale signals, adequate workarounds, and missing return triggers. The prosecutor runs in its own context window with no knowledge of the defence criteria — it can't pull punches.

2. **Defence (separate agent).** A Defence teammate reads the kill brief and must address every prosecution point — either refuting with evidence or conceding. If 2+ points are conceded, the idea cannot be promoted. The defence also runs in its own context window.

3. **Judge with four checks.** The lead reads both outputs and runs four checks informed by the adversarial debate:
   - **Value hypothesis** — Is the problem frequent, painful, and poorly solved? Will users come back after day one?
   - **Market demand** — Is there fresh, multi-source evidence? At least 3 verbatim user quotes required.
   - **Competitor gap** — Is the gap structural (competitor *can't* close it), temporal (competitor *hasn't yet*), or cosmetic (easy to copy)?
   - **Unit economics** — Can this reach £500 MRR in 12 months within a 12-week solo build?

3. **Competitive ranking.** When multiple ideas are triaged together (which is the default), they're ranked against each other. Only one idea gets promoted per batch. Others that pass all checks get DEFER — viable but not the best use of your next 12 weeks.

**Your decision card looks different now.** It leads with:
- The biggest unknown (what we haven't tested)
- The most likely failure mode
- How many prosecution points were refuted vs conceded
- Confidence level (high / medium / low)
- Then the recommendation

**Your job:** You see PROMOTE / DEFER / KILL / PIVOT. You can override the ranking — if a deferred idea is the one you want to build, that's your call. But the triage tells you what you're betting on.

**Rapid Prototype Path.** If the winning idea meets all four conditions — low complexity, you have direct experience with the problem, zero prosecution concessions, and ranked first — triage may offer `PROMOTE_TO_RAPID_PROTOTYPE` instead of standard validation. This skips the 7-day landing page test and goes directly to a compressed build. The working MVP becomes the validation artifact: you test it with 5 real users for 3 days instead of collecting emails from 200+ visitors. You must approve this path, and you can always choose standard validation instead. Only 1 rapid prototype can be in progress at a time.

### Stage 3: Validate — "Will people actually pay?"

```
/validate
```

Validation is not binary — confidence escalates through four tiers that gate further investment. The primary metric is **conversion rate** (signups / page views), not absolute signup count. Category-specific benchmarks set the bar (e.g., finance apps need 10% conversion, social apps need 5%).

**Before Day 1: Pre-flight Check**
The agent auto-invokes DIST-REVIEW to determine your multi-channel strategy based on your app's vertical (e.g., finance ideas get r/UKPersonalFinance + r/FIREUK, not builder subs like r/SideProject). It then verifies everything is ready: Reddit account meets subreddit requirements (if Reddit selected), landing page hosting configured, **Formspree email collection** configured, triage output verified. If anything is blocked, it stops and tells you what to fix — no wasted effort.

**One-time setup (first validation only):** Create a free Formspree account at formspree.io and provide the form endpoint URL. This is your email collection backend — the free tier supports 50 submissions/month, exactly matching Tier 1 targets.

**Tier 1: Hypothesis Validation (7 days, pre-build)**
- Day 1: Landing page with Formspree form + Plausible analytics + UTM attribution, **channel-specific content for minimum 2 channels** (Reddit, Twitter/X, Indie Hackers, Facebook groups — selected by DIST-REVIEW based on your app's vertical), direct outreach list (10-20 people from triage signals). You approve each channel's post AND outreach before they go live.
- Days 1-7: Conversion rate, signups, would-pay breakdown, and negative signals tracked daily. Per-channel attribution via UTM parameters.
- Day 3+: If signal is exceptionally strong (12%+ conversion, 30+ signups, 5+ would-pay), you get an early-promote option.
- Day 5+: If signal is clearly dead (200+ views, <2% conversion), you get an early-kill option.
- Day 7: Decision card with conversion rate vs category benchmark, velocity trend, negative signal summary, and recommendation.
- **Gate:** Conversion rate meets category threshold AND signups >= 30 → unlocks Build Phase 1
- **Four outcomes:** PROMOTE_TO_BUILD / KILL / PIVOT_AND_REVALIDATE (max 2 pivots per idea) / INSUFFICIENT_TRAFFIC (< 200 page views = distribution failure, not demand failure)

**Tier 1.5: Demand Confirmation (passive, during Build Phase 1)**
- Landing page stays live while Foundation docs are written. The Orchestrator checks cumulative signups before starting Phase 2.
- **Gate:** 150 cumulative signups AND organic growth > 0 → unlocks Build Phase 2
- If failed: you decide whether to continue, boost distribution, or kill.

**Tier 2: Product Validation (post-MVP, pre-monetisation)**
- **Gate:** 300 waitlist signups + 30 TestFlight beta testers actively using the app
- **Proves:** People will actually use the product, not just express interest
- Measured during Build Phase 2 TestFlight period → unlocks PMF Gate and Build Phase 3

**Tier 3: Launch Validation (pre-public launch)**
- **Gate:** 500 waitlist signups + PMF Gate passed (40% Ellis test confirmed)
- **Proves:** Demand is sufficient for launch investment and users love the product
- Measured during Build Phase 3 TestFlight expansion → unlocks Build Phase 4 and paid acquisition

**Usage Validation (after Rapid Prototype)**
If the app entered via the rapid prototype path (skipping the 7-day landing page), validation happens *after* the compressed build deploys to TestFlight. You recruit 5 real users from your network, they use the app for 3 days, and the validate agent measures two things: core loop completion rate (target ≥60%) and day-3 retention (target ≥40%). If it passes, the app continues to full Phase 2 sprints. If it fails, you choose: kill the idea (code is preserved) or fall back to standard 7-day landing page validation. One re-test is allowed before fallback becomes mandatory.

**Your job:** Approve each channel-specific post (Reddit, Twitter/X, Indie Hackers, etc.) and the outreach list before they go live. Review the Day 7 decision card. Track tier progression as the app moves through build. For rapid prototypes, recruit your 5 test users and review the usage validation decision card after the 3-day observation period.

### Stage 4: Build — "Let's make it"

```
/build
```

The Orchestrator coordinates a team of specialist agents, spawning each as an independent subagent with its own context window via the Task tool:

| Agent | Job |
|---|---|
| Architecture Agent | Designs the technical foundation |
| PRD Agent | Writes the product requirements |
| Design Agent | Defines visual language and interactions |
| Spec Agent | Writes testable feature specs |
| Code Agent | Writes Swift code; diagnose-before-fix protocol for perf/bug fixes |
| Test Agent | Writes XCTests |
| Review Agent | Validates everything before merge |

**Automated compilation and testing:** After the Code Agent writes Swift files, the Orchestrator generates the Xcode project (via XcodeGen) and builds it (via XcodeBuildMCP). If compilation fails, the Code Agent is re-spawned with the errors to fix (up to 3 retries). After the Test Agent writes XCTests, the Orchestrator runs the tests. If tests fail, the Test Agent is re-spawned with the failures (up to 3 retries). The Review Agent only sees code that compiles and tests that pass.

If the automated loop can't resolve issues after 3 attempts, you'll be notified and can use `/fix-build` or `/run-tests` to diagnose interactively. For runtime console errors (crashes, concurrency warnings, audio issues), use `/diagnose` with the pasted console output. Once everything compiles and tests pass, open the `.xcodeproj` in Xcode and deploy to your device.

**Review lint pre-pass:** After tests pass and before the Review Agent runs, the Orchestrator runs a mechanical lint script (`tools/review-lint.sh`) that catches pattern-matchable violations — hardcoded colours, raw spacing values, missing design system imports. Lint results are passed to the Review Agent so it can skip re-checking covered categories and focus on semantic judgment (AC satisfaction, component reuse decisions, navigation patterns). This makes reviews faster and more reliable.

**Context budget:** Each subagent receives a pruned context bundle sized for its task (CODE: ~40KB, TEST: ~30KB, REVIEW: ~35KB, SPEC: ~50KB). The Orchestrator strips non-essential sections from CLAUDE.md and limits existing code files to import-relevant modules, preventing context overflow where tail-end rules get silently dropped.

**Persona-driven build:** The build is grounded in the PRD's Persona Priority Map. P0 personas (highest volume × activation feasibility × revenue potential) determine the feature hierarchy — if a feature is a P0 persona's Day 1 activation blocker, it ships in Phase 2, not later. The Spec Agent derives a Wow Moment Decision Tree with separate paths for each P0 persona, and the UX Review agent gates on persona-wow alignment before the build can proceed.

**Reference-informed design:** The Design, Spec, and Conversion agents use Refero MCP (a searchable database of real iOS app screens and user flows) to ground UX decisions in real-world precedent. The Design Agent researches onboarding flow structure, category register tone, and empty state patterns before writing foundation documents. The Spec Agent researches wow path patterns and screen states. The Conversion Agent researches layout patterns before proposing design/position A/B tests. All Refero research has graceful fallback — agents proceed without it if the MCP is unavailable.

**The build runs in five phases (with validation checkpoints between them):**

1. **Foundation** (Weeks 1-2) — PRD first, then Architecture + Design + Requirements in parallel. After you review the requirements research, a **Requirements Review** runs in plan mode — a cross-document consistency check (REQUIREMENTS vs REGULATORY completeness, PRD vs REQUIREMENTS alignment, ARCHITECTURE coverage, internal consistency). Issues are fixed before project config and design system setup.
2. **Tier 1.5 Checkpoint** — Before Phase 2 starts, the Orchestrator checks that cumulative signups have reached 150 and organic growth is still happening. If not, you decide: continue, boost distribution, or kill.
3. **Core Loop** (Weeks 3-6) — Sprint-based development. Specs are grouped into sprints (1-3 per sprint), deployed to TestFlight, and iterated based on user feedback. Wow Moment must be reachable in <60 seconds for all P0 personas, with persona-specific paths derived from the Wow Moment Decision Tree.
4. **PMF Gate** — After Phase 2, run `/pmf-gate` with 7+ days of TestFlight data. Four checks: Sean Ellis 40% test (survey users "How would you feel if you could no longer use this product?" — need ≥40% "very disappointed"), category-adjusted D7 retention, core loop engagement (50%+ users with 3+ completions), and NPS baseline. **Hard gate — must pass before monetisation investment.**
5. **Monetisation** (Weeks 7-10) — Paywall, subscriptions, pricing
6. **Polish & Launch** (Weeks 11-14) — ASO with launch sequencing (soft launch in small markets → editorial pitch → coordinated big-market release), App Preview, Custom Product Pages, TestFlight beta

**Sprint-based iteration in Phase 2:**

Phase 2 uses sprints to enable mid-build course correction based on real user feedback:

1. **Sprint Planning** — The Orchestrator groups 1-3 specs (plus any approved amendments) into a sprint. You approve the sprint composition.
2. **Building** — Standard SPEC → Stitch Screen Validation (if mockups exist) → CODE → compile → TEST → run tests → REVIEW → UX Walkthrough cycle for each spec. If you generated Stitch mockups, the Orchestrator cross-references them against the spec's ACs before code begins — flagging missing variables, redundant screens, and flow gaps. After REVIEW passes, the Orchestrator runs a **Simulated UX Walkthrough** — it steps through each P0 persona's first-time experience screen by screen, checking for 9 usability failure patterns (dead ends, silent failures, cognitive overload, invisible features, etc.). This is advisory — it surfaces findings for you to review alongside the deploy decision, but never blocks.
3. **Deploy** — You deploy to TestFlight. The sprint status moves to "deployed".
4. **Feedback** (3-5 days) — Collect TestFlight user feedback. Structured or free-form.
5. **Retro** — Run `/sprint-retro`. The Sprint Retro Agent rates each feature's health, proposes amendments for underperforming features, suggests backlog changes, and composes the next sprint. You approve or reject each proposal.
6. **Next Sprint** — Approved amendments join the next sprint alongside new specs. The cycle repeats.

**Amendments** are lightweight, scoped changes to shipped features (max 3 AC changes each). Every modified or added AC includes a **Rationale** field tracing the specific user feedback that triggered the change — this prevents over-engineering by giving the Code Agent the "why" alongside the "what." The amendment cap uses convergence tracking: if amendments keep addressing the same root cause (divergent), the feature is flagged for redesign after 2 attempts; if each amendment fixes a different issue (convergent), up to 3 are allowed. They go through the full build pipeline (SPEC → CODE → TEST → REVIEW) with regression testing to ensure existing behaviour isn't broken. The Test Agent also produces a **UX Test Checklist** per feature — structured observation prompts the owner fills in during the TestFlight feedback period to ground the Sprint Retro in specific user behaviours.

**Your job:** Review specs before code is written. Approve foundation docs. Approve requirements review findings (fix contradictions, decide on flagged items). Approve sprint composition. Collect TestFlight feedback. Review sprint retro decisions. Provide survey results and TestFlight data for the PMF Gate. The agents handle everything else.

### Stage 5: Convert — "How do we grow?"

```
/analytics
/convert
```

Weekly cycle:
- Analytics Agent diagnoses your funnel (where are users dropping off?). At 30/60/90 day milestones, it prompts you to record outcome data (retention, revenue, verdict) back to `ideas.json` — building a portfolio-level track record
- Conversion Agent proposes one A/B test per week. It checks `experiments.json` for past experiments across all your apps, so insights from one app inform the next. After you report test results, they're recorded as transferable learnings

**Your job:** Review the weekly diagnosis. Approve or reject the proposed test. Report results when tests conclude.

---

## All Slash Commands

### Daily Pipeline

| Command | What It Does |
|---|---|
| `/generate-ideas` | Scan for new app opportunities (market-pull mode) |
| `/builder-ideate` | Capability-first idea generation (technology-push mode) |
| `/research "idea"` | Deep feasibility research on a specific idea you have |
| `/clone "reference"` | Generate differentiated ideas from an existing app or concept |
| `/triage` | Adversarial triage: kill brief → 4 checks → competitive ranking |
| `/triage idea-20260224-001` | Triage a specific idea |
| `/validate` | Start 7-day demand validation |
| `/build` | Start or continue the build phase |
| `/fix-build` | Diagnose and fix build compilation errors |
| `/diagnose` | Diagnose and fix runtime console errors (concurrency, audio, memory, threading) |
| `/run-tests` | Run all tests and report results |
| `/sprint-retro` | Run sprint retrospective after beta feedback |
| `/pmf-gate` | Product-market fit gate (run after Phase 2 with beta data) |
| `/status` | See current pipeline state at a glance |
| `/daily` | Morning briefing: next action, stale approvals, alerts |
| `/mission-control` | Build execution dashboard: action queue progress, errors, audit trail |
| `/sprint-board` | Visual dashboard: pipeline funnel, sprint board, lineage graph, compare view (opens in browser) |
| `/design` | Visual design iteration: Refero research, Stitch mockups, CDO review, design freeze |

### Weekly / Monday

| Command | What It Does |
|---|---|
| `/monday` | Full Monday chain: analytics + reality check in parallel, then monetisation review, then test proposal |
| `/analytics` | Weekly funnel analysis (AARRR) |
| `/convert` | Propose this week's A/B test |

### Review Agents

| Command | What It Does |
|---|---|
| `/arch-review` | Check project infrastructure is set up correctly |
| `/ios-review` | Review specs for testability and App Store compliance |
| `/ux-review notes.md` | Check usability test results |
| `/mono-review` | Check monetisation for common mistakes |
| `/mono-review monday` | Monday monetisation diagnosis |
| `/dist-review r/SubredditName` | Plan where to post for validation |
| `/pm-review <questions>` | Staff PM review of your questions or decision-framing |
| `/reality-check` | Daily focus and motivation check |
| `/reality-check monday` | Weekly momentum and health review |

### App Management

| Command | What It Does |
|---|---|
| `/switch` | Show which app is active and list all registered apps |
| `/add-app` | Register a new app in the pipeline |

### Framework Maintenance

| Command | What It Does |
|---|---|
| `/sync` | After framework changes, propagate updates across all artifacts (CLAUDE.md, USER_GUIDE.md, agent definitions, schemas, counts) |
| `/framework-review <url>` | Critical review of external source against APOS framework (sceptical by default) |
| `/build-quality` | Build pipeline health metrics: first-pass rates, retry distributions, error trends across all apps |
| `/spine-check` | Product spine alignment gate: check proposed changes or audit all artifacts against the Product Spine |

---

## A Typical Week

### Monday Morning (30 min)
```
/monday
```
Get your weekly briefing: what happened last week, where things stand, and what to focus on this week.

### Daily (5-10 min)
```
/daily                 ← what needs your attention right now
/generate-ideas        ← if in Idea Pool stage
/reality-check         ← get your daily focus
```

### During Active Build (60-90 min sessions)
```
/build                 ← Orchestrator resumes from last checkpoint automatically
```
If a previous session crashed mid-build, the Orchestrator detects interrupted actions in the queue and resumes from that point — no manual "where did I leave off?" needed. Review specs when presented. The agents write the code and tests.

---

## Where Things Live

| What | Where |
|---|---|
| Per-app directories | `apps/<slug>/` (specs, docs, approvals, app-state per app) |
| Your feature specs | `specs/` (symlink → active app's specs) |
| Build docs | `docs/` (symlink → active app's docs — PRD.md, ARCHITECTURE.md, etc.) |
| Agent results | `approvals/pending/` (symlink → active app's approvals) |
| Global pipeline state | `state.json` |
| Per-app state | `apps/<slug>/app-state.json` |
| Ideas | `ideas.json` |
| Schema migrations | `schema-migrations/` (global) |
| Validation pages | `validate/<idea-slug>/` |
| Usability template | `USABILITY_NOTES.template.md` |
| Channel config | `agents/config/channel-rules.json` |
| Per-app learnings | `apps/<slug>/learnings.json` |
| Signal inbox | `signals/inbox.md` |
| XcodeGen template | `agents/templates/project.yml.template` |
| Per-app Xcode config | `apps/<slug>/project.yml` |
| Amendment spec template | `agents/templates/amendment-spec.md` |
| Per-app action queue | `apps/<slug>/action-queue.json` |
| Per-app action log | `apps/<slug>/action-log.json` |
| Agent definitions | `.claude/agents/` (32 agents) |
| Slash commands | `.claude/commands/` (33 commands) |
| Agent Teams config | `.claude/settings.json` |
| MCP server config (XcodeBuildMCP, Figma) | `.claude/mcp.json` |
| MCP server config — user scope (Stitch, Refero) | `~/.claude.json` via `claude mcp add` |
| Lifecycle hooks | `.claude/hooks/` (session-start, schema validation, subagent context, auto-lint) |
| Hooks config | `.claude/settings.json` (hooks section) |
| Platform-agnostic agent cores | `.claude/agents/core/` |
| Platform overlays (iOS, Web) | `.claude/agents/platforms/{ios,web}/` |
| CI workflows | `.github/workflows/` (schema validation, agent linting, JSON parsing, symlink validation) |
| Multi-track architecture | `agents/config/multi-track-architecture.md` |
| Platform readiness tracker | `agents/config/platform-readiness.json` |
| Builder Program profile | `agents/config/builder-program-profile.json` |
| Experiment registry | `experiments.json` (global, cross-app A/B test history) |

---

## Continuous Integration

GitHub Actions runs three checks on every push to `main`:

1. **Schema validation** — all `agents/schemas/*.schema.json` are valid draft-07, and agent outputs in `apps/*/approvals/pending/` validate against their schemas
2. **Agent linting** — every agent definition has the required `## Prerequisites` and `## When NOT to Run` sections
3. **JSON parsing** — all pipeline JSON files (`state.json`, `ideas.json`, app configs, action queues) parse without errors

No Xcode builds run in CI — compilation and testing stay local via XcodeBuildMCP. CI catches framework drift and broken schemas only.

---

## The 31 Agents

### Pipeline Agents (drive the workflow)
| Agent | Badge | Job |
|---|---|---|
| Idea Agent | `[IDEA]` | Scans 8 signal sources (incl. Twitter/X, Trustpilot, PH/IH), frames user value (JTBD), scores ideas, applies session frequency gate (daily_habit/weekly_ritual/monthly_event/lifecycle_event/one_and_done), assesses platform (ios/web/tbd) |
| Research Agent | `[RESEARCH]` | Deep feasibility research on owner-suggested ideas: market sizing, competitors, user research (50+ data points), technical feasibility, monetisation benchmarks, mandatory Value Chain Stress Test (deliverability assessment). Conditional Module 7 (Data & Training Infrastructure) for ML/scoring-dependent ideas |
| Clone Agent | `[CLONE]` | Takes reference app/idea, generates 3-5 differentiated angles via 7-dimension gap analysis (audience, feature, pricing, UX, regulatory, platform, value-chain coupling) |
| Triage Agent | `[TRIAGE]` | Adversarial two-pass triage: kill brief → 4 checks (incl. revenue scalability + LTV:CAC) → competitive batch ranking. Researched ideas enter with enriched context. References outcome data from launched apps in the same category |
| Validate Agent | `[VALIDATE]` | Auto-invokes DIST-REVIEW, Formspree + Plausible landing page, multi-channel content (min 2), 4-tier validation |
| Design Iterate | `[DESIGN-ITERATE]` | Visual design iteration: Refero precedent research, Stitch screen generation, Figma refinement. Max 3 rounds → design freeze. Approved screens feed into spec + code |
| Orchestrator | `[ORCHESTRATOR]` | Coordinates build, enforces PMF Gate, runs UX Walkthrough after REVIEW, never writes code |
| PMF Gate | `[PMF-GATE]` | Ellis 40% test, category-adjusted retention, core loop engagement, NPS baseline. Remediation briefs cite cross-app experiment insights |
| Requirements Agent | `[REQUIREMENTS]` | Domain rules, regulatory constraints, accounting standards, calculation rules with validation source classification (tiered by app category) |
| Spec Agent | `[SPEC]` | Writes testable feature specs with Wow Moment Decision Tree (per-P0 persona paths), Walkthrough Scenarios, Refero-informed screen states. Consults cross-app learnings before writing |
| Code Agent | `[CODE]` | Writes code (Swift for iOS, TypeScript for Web) via core + platform overlay; spec-over-mockup rule; diagnose-before-fix protocol |
| Test Agent | `[TEST]` | Writes tests per AC (XCTest for iOS, Vitest for Web) |
| Review Agent | `[REVIEW]` | Validates code + tests + platform compliance (HIG for iOS, WCAG for Web), detects 9 UX smells, sprint integration check |
| Design Agent | `[DESIGN]` | Visual language, multi-persona onboarding paths, tone, Refero reference research |
| PRD Agent | `[PRD]` | Product requirements from JTBD with Persona Priority Map and Feature-Persona Traceability Matrix |
| Architecture Agent | `[ARCHITECTURE]` | Data model, services, persistence |
| ASO Agent | `[ASO]` | App Store listing + launch sequencing (soft launch → editorial → big market). Conditional pre-order strategy for social/competitive apps |
| Analytics Agent | `[ANALYTICS]` | Weekly AARRR funnel with category benchmarks, LTV/CAC, K-factor, cohort trends. Prompts for experiment results and outcome tracking at milestones |
| Sprint Retro | `[SPRINT-RETRO]` | Post-sprint feedback analysis, feature health, amendment proposals with convergence tracking, walkthrough calibration |
| Conversion Agent | `[CONVERT]` | Weekly A/B test proposal, Refero-grounded design/position variants. Reads/writes `experiments.json` for cross-app experiment history |

### Review Agents — Gatekeepers (must pass)
| Agent | Badge | Job |
|---|---|---|
| Systems Architect | `[ARCH-REVIEW]` | Infrastructure validation |
| iOS Engineer | `[IOS-REVIEW]` | Privacy, entitlements, testability |
| UX Researcher | `[UX-REVIEW]` | Persona-Wow Alignment gate, Hook Model, accessibility, retention |

### Review Agents — Advisors (helpful input)
| Agent | Badge | Job |
|---|---|---|
| Monetisation Analyst | `[MONO-REVIEW]` | Pricing, paywall, subscription flags |
| Distribution Specialist | `[DIST-REVIEW]` | Vertical-aware channel selection (user vs builder audiences), content format research, auto-invoked by VALIDATE |
| Staff PM Reviewer | `[PM-REVIEW]` | Reviews CDO questions and concerns through a staff PM lens, recommends specific actions |
| Framework Reviewer | `[FRAMEWORK-REVIEW]` | Staff engineer critical review of external sources (articles, repos, talks, papers) against APOS — problem overlap, architecture compatibility, extractable concepts, anti-patterns |
| Reality Check | `[REALITY-CHECK]` | Motivation, momentum, focus |

### Utility Agents (framework maintenance)
| Agent | Badge | Job |
|---|---|---|
| Sync Agent | `[SYNC]` | Detects framework changes, auto-counts agents/commands/schemas, propagates updates across all artifacts with plan-then-apply approval |
| Diagnose Agent | `[DIAGNOSE]` | Staff iOS engineer: classifies runtime console errors (12 categories), traces to structural root cause, applies targeted fixes |
| Build Quality Evaluator | `[BUILD-QUALITY]` | Aggregates build metrics across all apps: first-pass success rates, retry distributions, error category trends |
| Spine Check Agent | `[SPINE-CHECK]` | Product spine alignment gate: enforces coherence between artifacts and the Product Spine (promise priority, value chain, terminology, cross-references). Pre-change gate or full audit mode |

---

## How Agents Handle Missing Data

Every agent checks its prerequisites before doing any work. If something is missing — wrong pipeline state or a required file doesn't exist — the agent stops immediately and tells you exactly what to fix.

### What this looks like in practice

If you run `/build` when no validated idea exists, the Orchestrator will ask if you want to manually override:

```
[ORCHESTRATOR] No validation record found for [app name].
This idea has not completed the 7-day validation cycle.
Do you want to manually override and promote this idea directly to Build?
```

If you confirm, the build proceeds and the override is recorded in `app-state.json`. If you decline, you'll see:

```
[ORCHESTRATOR] Blocked: no validated idea found for active app.
Next step: run /validate and complete the 7-day validation cycle first.
```

If you run `/convert` without running analytics first:

```
[CONVERT] Blocked: no analytics output found for this week.
Required: approvals/pending/analytics-output.json from a run this week.
Next step: run /analytics first.
```

### The fail-fast principle

A blocked agent:
1. States which specific condition is not met
2. States what file or data is missing
3. States the corrective next step

This prevents wasted agent runs and keeps the pipeline state clean. If an agent is blocked, fix the stated condition, then re-run the command.

---

## Understanding Decision Cards

When an agent needs you to make a binary approve/reject decision, it produces a **decision card**. Every card follows the same structure, regardless of which agent produced it:

1. **Biggest unknown** — the single most important thing that hasn't been tested (leads because uncertainty is what you most need to know)
2. **What kills this** — the most likely specific failure mode
3. **Confidence level** — high / medium / low with a one-sentence rationale
4. **Recommendation** — a clear directive (PROMOTE / KILL / DEFER / etc.) with reasoning

After the standard parts, each agent adds its own details:
- **Research** adds market sizing summary, competitor landscape classification, unknowns list
- **Clone** adds reference summary, gap distribution (structural vs temporal vs cosmetic), top angle highlight, failed clone warnings
- **Triage** adds prosecution survival summary and competitive ranking
- **Validate** adds conversion rate, signups, velocity trend, negative signals
- **PMF Gate** adds check-by-check results and remediation brief if failed
- **Convert** adds the test variable, behavioural principle, sample size, and kill criterion

The format deliberately leads with doubt, not advocacy. You get the most important uncertainty first, then the reasoning.

---

## FAQ

**Q: What's the difference between `/daily`, `/status`, `/mission-control`, and `/monday`?**
`/daily` is a 30-second morning briefing — it tells you the single next action you should take and flags anything stale. `/status` is a full dashboard showing pipeline state across all apps. `/mission-control` shows the build execution queue — what's running, what failed (with error categories), what's next, and an audit trail of overrides. Use it during active builds to see exactly where the Orchestrator is. `/monday` runs 4 agents — analytics and reality check in parallel, then monetisation review and conversion proposal — and takes 30 minutes. Start your day with `/daily`; use `/status` when you need the full picture; use `/mission-control` when you're mid-build; run `/monday` once a week.

**Q: What are session learnings?**
After key decisions (validation Day 7, A/B test approval/rejection), agents prompt you to capture operational learnings — things like "question-format Reddit titles converted 3x better" or "r/UKPersonalFinance removes posts under 50 karma". These are stored in `apps/<slug>/learnings.json` and referenced by future agent runs so the pipeline gets smarter over time. You can always decline.

**Q: How do I add a signal I spotted outside the pipeline?**
Drop it in `signals/inbox.md` using the format in the file. Next time you run `/generate-ideas`, the Idea Agent evaluates it alongside its normal 8-source scan. Processed signals are moved to `signals/processed.md` for audit trail.

**Q: Where do I start if I'm brand new?**
Type `/generate-ideas`. The Idea Agent scans 8 sources (App Store reviews, Reddit, Google Trends, regulatory changes, competitor reviews, Twitter/X, Trustpilot, and Product Hunt/Indie Hackers) and the pipeline takes it from there.

**Q: What if I already have an app idea?**
Run `/research "your idea in one sentence"`. The Research Agent investigates it deeply — market sizing, competitor analysis, user research, technical feasibility, monetisation benchmarks, and (for ML/scoring-dependent ideas) data & training infrastructure — then presents a decision card. If the research supports it, approve COMMIT_TO_TRIAGE and run `/triage`. You can also add ideas manually to `ideas.json` with a score of 5 and run `/triage` directly if you want to skip research.

**Q: What's the difference between /research and /clone?**
`/research` takes a raw idea and investigates whether it's viable — market sizing, competitors, user demand, technical feasibility. It goes deep on one concept. `/clone` takes an existing app or concept and finds where it's weak — different audience, missing features, wrong pricing, UK-specific angles. It goes wide across 3-5 differentiated opportunities. Use `/research` when you have your own concept. Use `/clone` when you see someone else's app and think "this could be better for [X]." You can also `/clone` a killed or parked idea from your own pipeline to find a better angle.

**Q: How does the build phase know what to code?**
It follows the Acceptance Criteria Contract: every spec has numbered, testable criteria. The Code Agent writes code for each one. The Test Agent writes a test for each one. The Review Agent won't pass until every AC maps to both code and a test.

**Q: What's the Monday chain?**
A weekly review that runs 4 agents: Analytics and Reality Check run as parallel teammates, then Monetisation Review and Conversion proposal run sequentially. Run it with `/monday`.

**Q: Can I work on multiple apps at the same time?**
Yes, including multiple apps in Build simultaneously. Each app gets its own directory under `apps/<slug>/` with separate specs, build state, and agent outputs. Use `/switch <slug>` to change which app all commands target. Use `/add-app` to register a new app.

**Q: What's the PMF Gate?**
A hard gate between Build Phase 2 (Core Loop) and Phase 3 (Monetisation). It uses the Sean Ellis "very disappointed" test — you survey TestFlight users and need ≥40% saying they'd be very disappointed without your app. It also checks category-adjusted retention (a finance app has different benchmarks than a social app), core loop engagement, and NPS. Run it with `/pmf-gate` after 7+ days of TestFlight data. You can't start building paywalls until it passes.

**Q: What are the validation tiers?**
Confidence escalates through four tiers. Tier 1 (conversion rate meets category benchmark, 30+ signups) proves the hypothesis resonates. Tier 1.5 (150 cumulative signups with organic growth, checked passively during Foundation) proves interest extends beyond the initial post. Tier 2 (300 waitlist + 30 TestFlight users) proves people will actually use it. Tier 3 (500 waitlist + PMF confirmed) proves demand is sufficient for launch. Each tier unlocks the next build phase, preventing you from over-investing in an idea that hasn't earned it.

**Q: What channels does validation use?**
The validate agent auto-invokes DIST-REVIEW to select channels based on your app's vertical. A finance app gets r/UKPersonalFinance and r/FIREUK (actual users), not r/SideProject (builders). Minimum 2 channels are required — typically a Reddit post plus one of: Twitter/X thread, Indie Hackers post, or Facebook group post. Each channel gets tailored content and its own UTM parameter (`?ref=reddit-ukpf`, `?ref=twitter`, etc.) so you can see which channels drive signups. If total page views stay below 200, the result is INSUFFICIENT_TRAFFIC (try different channels) — not KILL.

**Q: What do I need to set up for my first validation?**
Two things, both one-time: (1) Create a free Formspree account at formspree.io for email collection. (2) Optionally set up Plausible analytics for page view tracking. The agent will prompt you during pre-flight if these aren't configured.

**Q: What is the rapid prototype path?**
When triage recommends `PROMOTE_TO_RAPID_PROTOTYPE`, you skip the 7-day landing page and go directly into a compressed build (Foundation + 1 sprint of 1-2 core specs). This only happens when all four conditions are met: low complexity, you have direct experience with the problem, zero prosecution concessions, and ranked first in the batch. After the build deploys to TestFlight, you recruit 5 users for a 3-day usage test instead of collecting emails. You can always decline and use standard validation instead. Only 1 rapid prototype can be in flight at a time.

**Q: What are owner proximity and trend coupling scores?**
After generating ideas, the Idea Agent asks how close you are to each problem (`direct_experience`, `adjacent_domain`, or `outsider`) and checks whether each idea rides a rising trend. Direct experience adds +0.5 to the idea's score (capped at 5) because every successful solo app story involves someone solving their own problem. Riding a confirmed trend (with evidence from the last 90 days) adds another +0.5 because organic distribution reduces your customer acquisition cost. These are tiebreakers and signal boosters — they never hard-gate an idea. An outsider idea with score 5 signals still proceeds normally.

**Q: Can I skip stages?**
Yes. If you already have a validated idea, jump straight to `/build`. If you want to skip validation entirely, `/build` will prompt you to confirm a manual override — the override is recorded in `app-state.json` for audit. The pipeline is flexible — use what's relevant.

**Q: What if an agent fails or gives bad output?**
Check `approvals/pending/` for the output file. It will explain what failed. Fix the issue and re-run the command.

**Q: Do I need an API key?**
No. Everything runs locally through your Claude Code subscription in VS Code.

**Q: What coding standards does the build use?**
Swift 6, SwiftUI only, MVVM with @Observable, iOS 17.4+, SwiftData, full accessibility, no third-party deps except RevenueCat and Mixpanel. See `CLAUDE.md` for the complete list.

**Q: How much of my time does this need?**
5-10 minutes daily, 30 minutes on Monday, and 60-90 minute sessions during active builds. Your role is reviewing and deciding, not doing the work.

**Q: What is a decision card?**
A structured format for approve/reject decisions. Every card — whether from triage, validation, PMF gate, or conversion — follows the same structure: biggest unknown first, then what kills this, then confidence level, then recommendation. Agent-specific details appear after the standard parts. See the "Understanding Decision Cards" section above.

**Q: Why does an agent sometimes refuse to run?**
Agents check prerequisites before producing output. If a prerequisite is missing — wrong pipeline state or a required file doesn't exist — the agent stops immediately and tells you what to fix. For `/build`, you'll get a manual override prompt instead of a hard block if validation hasn't been completed. This is intentional: a partial run on bad state is worse than no run. See "How Agents Handle Missing Data" above.

**Q: What are sprints and amendments?**
Phase 2 (Core Loop) uses sprints to iterate based on TestFlight feedback. After deploying a sprint and collecting 3-5 days of feedback, run `/sprint-retro` to assess feature health. Features rated `needs_amendment` get a lightweight amendment spec (max 3 AC changes) that goes through the full build pipeline with regression testing. Features rated `needs_redesign` get flagged for a full spec rewrite. The amendment cap uses convergence tracking — if amendments keep fixing the same problem (divergent), redesign is triggered after 2; if each fixes a different issue (convergent), up to 3 are allowed.

**Q: An agent told me it's blocked. What do I do?**
Read the blocked message. It says exactly which condition failed and what to do next. Common examples: "Run `/validate` first" means no validated idea exists. "Phase 2 not complete" means the build hasn't reached the gate yet. "No spec files found" means [SPEC] hasn't run. Follow the stated next step, then re-run the command.
