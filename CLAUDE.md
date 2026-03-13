# APOS Development Pipeline

## Project Overview

APOS is the Autonomous App Portfolio Operating System — a fully agentic pipeline for identifying, validating, building, and monetising software products. It operates across five stages: **Idea Pool → Triage → Validate → Build → Convert**. Designed for a solo PM operating as Chief Decision Officer whose only required inputs are binary approve/reject decisions.

## Multi-Track Architecture

APOS operates on three independent dimensions. Full architecture: `agents/config/multi-track-architecture.md`.

### Platforms (what gets built)
| Platform | Stack | Distribution | Design System |
|---|---|---|---|
| **iOS** | Swift 6 / SwiftUI / XcodeGen | App Store | APOSDesignSystem (Swift Package) |
| **Web** | TypeScript / React / Next.js | Web URL | shadcn/ui + Tailwind tokens |

Platform is set per-app at registration. Agent definitions use a core + platform overlay pattern: `core/agent.core.md` + `platforms/{platform}/agent.{platform}.md`.

### Ideation Modes (how ideas are generated)
| Mode | Direction | Command |
|---|---|---|
| **Market-Pull** (default) | Problem → Solution. Scan signals for struggle behaviour | `/generate-ideas` |
| **Technology-Push** | Domain Pain → Claude-Fit. Start from domain expertise, validate Claude enables a product that couldn't exist before | `/builder-ideate` |
| **Clone** | Reference → Differentiation. Gap analysis against existing app | `/clone` |

All modes output to `ideas.json` and enter the same downstream pipeline.

### Evaluation Profiles (who judges quality)
| Profile | Extra Criteria | Config |
|---|---|---|
| **Standard** (default) | APOS signal strength, JTBD, switching trigger | Built into agent definitions |
| **Builder Program** | Claude runtime dependency, displacement test (HG-5), structural vs. replicable capabilities, demo impact, VC narrative | `agents/config/builder-program-profile.json` |

Profiles are additive overlays — they add modifiers and hard gates on top of standard scoring.

## Schema Version

All agents and schemas use **schema_version: "3.4.0"** (JSON Schema draft-07).

## Pipeline Stages

| Stage | What Happens | Owner Input |
|---|---|---|
| **Idea Pool** | Scan signal sources, frame user value (JTBD), score ideas with owner proximity and trend coupling modifiers, surface top candidates | Review expanded ideas, rate proximity to problem, collapse/ignore low-score |
| **Research** *(optional)* | Deep feasibility research on an owner-suggested idea: market sizing, competitor deep-dive, user research synthesis, technical feasibility, monetisation benchmarks. Alternative on-ramp to Triage | Review decision card → COMMIT_TO_TRIAGE / PARK / KILL |
| **Clone** *(optional)* | Takes an existing app or concept, analyses gaps across 7 dimensions (incl. value-chain coupling), generates 3-5 differentiated angles as complete idea entries. Alternative on-ramp alongside Research | Select which angles to commit to ideas.json |
| **Triage** | Adversarial two-pass evaluation: prosecution (kill brief) then defence (four checks). Batch-ranked competitively — only one idea promoted per batch. If eligible: PROMOTE_TO_RAPID_PROTOTYPE (low complexity + direct experience + 0 concessions). Researched ideas enter with enriched context | Review decision card (leads with uncertainty, not advocacy). If rapid prototype offered: approve or choose standard validation |
| **Rapid Prototype** *(conditional)* | If triage recommends PROMOTE_TO_RAPID_PROTOTYPE: skip landing page, compressed build (Foundation + 1 sprint). MVP is the validation artifact. Usage Validation (5 users, 3 days) replaces email-signup validation | Approve rapid prototype path, recruit 5 test users, review usage validation results |
| **Validate** | Pre-flight check, landing page with pricing signal, multi-channel traffic strategy, 7-day signal collection with conversion rate as primary metric. OR: Usage Validation after rapid prototype (5 users, 3-day observation) | Approve community post + outreach list, review Day 7 decision card |
| **Design** *(optional)* | Visual design iteration using Refero (precedent research), Stitch (screen generation), Figma (refinement). Critical-path screens only: onboarding, core loop, empty states, paywall. Max 3 iteration rounds → design freeze | Approve/iterate screens each round, approve design freeze |
| **Build** | Orchestrator coordinates spec → Stitch validation (if mockups) → code → compile → test → run tests → review → UX walkthrough cycle. Approved design screens feed into spec + code context | Review spec before code, approve/reject at each gate |
| **Convert** | Weekly analytics, A/B test proposals, win-back tracking | Approve/reject single A/B test per week |

## Context Routing

CLAUDE.md is routing and overview — enforcement rules live in the agent definitions. When looking for details on a specific topic:

| Topic | Read |
|---|---|
| Multi-track architecture, platform/mode/profile dimensions | `agents/config/multi-track-architecture.md` |
| Platform readiness check, phase triggers, overlay status | `agents/config/platform-readiness.json` |
| Builder Program evaluation profile, hard gates, Claude capability targets | `agents/config/builder-program-profile.json` |
| Technology-push ideation (problem-first with Claude-fit validation) | `.claude/commands/builder-ideate.md` |
| Platform-specific coding rules, web/iOS adapter layer | `.claude/agents/core/*`, `.claude/agents/platforms/*/` |
| Idea scoring, JTBD framing, signal sources, owner proximity, trend coupling, decoupling type, session frequency gate | `.claude/agents/idea-agent.md` |
| Deep research, feasibility, market sizing, data strategy, value chain stress test | `.claude/agents/research-agent.md` |
| Clone analysis, differentiation angles | `.claude/agents/clone-agent.md` |
| Triage kill brief, four checks, batch ranking, rapid prototype eligibility | `.claude/agents/triage-agent.md` |
| Validation pre-flight, landing page, Day 7 decision, Usage Validation | `.claude/agents/validate-agent.md` |
| Build phases, gate enforcement, manual overrides, rapid prototype build entry | `.claude/agents/orchestrator-agent.md` |
| Build compilation, XcodeGen, XcodeBuildMCP, Xcode MCP | `.claude/agents/orchestrator-agent.md` (Compile Check, Test Execution sections), `.claude/mcp.json` |
| Build quality evals, first-pass rates, retry trends | `.claude/agents/build-quality-agent.md` |
| Review lint pre-pass, mechanical HIG checks | `tools/review-lint.sh`, `.claude/agents/orchestrator-agent.md` (Review Lint Pre-Pass section) |
| Context budget, subagent context pruning | `.claude/agents/orchestrator-agent.md` (Context Budget section) |
| Amendment rationale, feedback-to-code traceability | `agents/templates/amendment-spec.md`, `.claude/agents/code-agent.md` (Amendment Mode) |
| Design iteration, screen generation, Refero/Stitch/Figma workflow, design freeze | `.claude/agents/design-iterate-agent.md` |
| Stitch screen validation, mockup-to-spec review | `.claude/agents/orchestrator-agent.md` (Stitch Screen Validation section), `.claude/agents/code-agent.md` (Rule 10) |
| PMF gate criteria | `.claude/agents/pmf-gate-agent.md` |
| Swift/accessibility enforcement | `.claude/agents/code-agent.md`, `.claude/agents/review-agent.md` |
| Performance/bug fix diagnosis protocol | `.claude/agents/code-agent.md` (Performance & Bug Fix Mode section) |
| A/B test rules | `.claude/agents/conversion-agent.md` |
| Channel selection, account readiness, content format research | `.claude/agents/dist-review-agent.md` + `agents/config/channel-rules.json` |
| App Store pre-order strategy (social/competitive apps) | `.claude/agents/aso-agent.md` (Pre-Order Strategy section) |
| Domain rules, regulatory constraints, calculation rules, validation source | `.claude/agents/requirements-agent.md`, `docs/REQUIREMENTS.md`, `docs/REGULATORY.md` |
| Value chain feasibility, delivery step decomposition, input availability, bottleneck identification | `.claude/agents/research-agent.md` (Module 8: Value Chain Stress Test), `.claude/agents/validate-agent.md` (Pre-flight Check 7), `.claude/agents/orchestrator-agent.md` (Requirements Review — value chain deliverability) |
| Requirements review (cross-document consistency gate), calibration strategy | `.claude/agents/orchestrator-agent.md` (Phase 1 Step 3: Requirements Review) |
| Regulatory traceability in specs | `.claude/agents/spec-agent.md` (Regulatory Traceability Tags section) |
| Regulatory test fixtures | `.claude/agents/test-agent.md` (Regulatory Calculation Tests section) |
| Regulatory coverage check | `.claude/agents/review-agent.md` (Regulatory Coverage Check section) |
| Persona priority, wow moment decision tree | `.claude/agents/prd-agent.md` (Persona Priority Map), `.claude/agents/spec-agent.md` (Wow Moment Decision Tree) |
| Persona-wow alignment gate | `.claude/agents/ux-review-agent.md` (Section 7) |
| Decision card format | `agents/templates/decision-card.md` |
| Operational learnings | `apps/<slug>/learnings.json` |
| Ad-hoc signal capture | `signals/inbox.md` |
| Execution model (subagents, teams) | `.claude/settings.json`, `orchestrator-agent.md` |
| MCP server config (XcodeBuildMCP, Xcode native, Figma) | `.claude/mcp.json` |
| MCP server config — user scope (Stitch, Refero) | `~/.claude.json` via `claude mcp add` |
| Lifecycle hooks (schema validation, context injection, auto-lint) | `.claude/settings.json` (hooks config), `.claude/hooks/` |
| Sprint retros, amendment specs, sprint structure | `.claude/agents/sprint-retro-agent.md`, `.claude/agents/orchestrator-agent.md` (Phase 2 Sprint Structure) |
| Design system tokens, components, theme protocol | `packages/APOSDesignSystem/` |
| UX assumptions, pre-code validation | `.claude/agents/spec-agent.md` (UX Assumptions section) |
| UX test checklists, manual QA | `.claude/agents/test-agent.md` (UX Test Checklist section) |
| UX smells, code-level UX patterns | `.claude/agents/review-agent.md` (UX Smell Detection section) |
| Simulated UX walkthrough, persona-driven pre-deploy usability | `.claude/agents/orchestrator-agent.md` (Simulated UX Walkthrough section), `.claude/agents/spec-agent.md` (Walkthrough Scenarios) |
| Sprint integration, cross-feature | `.claude/agents/review-agent.md` (Sprint Integration Check section) |
| UX checkpoint after Sprint 1 | `.claude/agents/orchestrator-agent.md` (UX Checkpoint section) |
| Amendment convergence tracking | `.claude/agents/sprint-retro-agent.md` (Amendment Proposals section) |
| Mission Control, action queue, action log | `.claude/commands/mission-control.md`, `apps/<slug>/action-queue.json`, `apps/<slug>/action-log.json` |
| Dependency graph scheduling, parallel dispatch, cascade blocking, resubmission | `.claude/agents/orchestrator-agent.md` (Readiness Algorithm, Cascade Block Propagation, Parallel Dispatch, Resubmission Flow sections) |
| Build session resume, crash recovery, blocker-first ordering | `.claude/agents/orchestrator-agent.md` (Session Resume Detection, Queue Lifecycle) |
| CDO question review, staff PM advisory | `.claude/agents/pm-review-agent.md` |
| Runtime error diagnosis (concurrency, audio, memory, threading) | `.claude/agents/diagnose-agent.md` |
| UI/UX reference research, screen/flow precedent (Refero MCP) | `.claude/mcp.json`, DESIGN/SPEC/CONVERT agent definitions (Reference Research sections) |
| External source critical review, framework improvement evaluation | `.claude/agents/framework-review-agent.md` |
| Lineage graph, dependency visualization, artifact traceability | `tools/sprint-board/lineage.html`, `tools/sprint-board/server.js` (computeLineage) |
| Research/triage enrichment on ideas, compare view, early-stage dashboard | `tools/sprint-board/server.js` (enrichIdeasWithResearchAndTriage), `tools/sprint-board/index.html` |
| Cross-app experiment history, A/B test results, transferable insights | `experiments.json`, `.claude/agents/conversion-agent.md` (Experiment Registry section) |
| Idea outcome tracking, post-launch retrospectives | `ideas.json` (outcome field), `.claude/agents/analytics-agent.md` (Outcome Tracking section) |
| Cross-app learning consultation in specs | `.claude/agents/spec-agent.md` (Cross-App Learning Consultation section) |
| Product spine, artifact coherence, change protocol, terminology registry | `apps/<slug>/docs/PRODUCT_SPINE.md`, `.claude/agents/spine-check-agent.md` |

## Agent Architecture

### Pipeline Agents (drive the workflow forward)
- **[IDEA]** — Scans 8 signal sources for struggle behaviour (App Store reviews, Reddit, Google Trends, GOV.UK/regulatory, competitor reviews, Twitter/X, Trustpilot, Product Hunt/Indie Hackers), frames user value (JTBD, workaround, switching trigger), assesses owner proximity and trend coupling, applies session frequency gate (caps score_raw for low-engagement ideas that can't support subscription pricing), scores ideas 1-5 with modifiers, writes to `ideas.json`
- **[RESEARCH]** — Deep feasibility research for owner-suggested ideas. Seven core modules: market sizing (TAM/SAM/SOM), regulatory context, competitor deep-dive, user research synthesis (50+ data points), technical feasibility, monetisation benchmarks, and mandatory Module 8 (Value Chain Stress Test — decomposes value prop into delivery steps, assesses input availability, identifies bottleneck step, rates overall deliverability). Conditional Module 7 (Data & Training Infrastructure) for ideas depending on ML/scoring accuracy — researches existing datasets, pre-trained models, validation benchmarks, and architecture implications. Runs as subagent. Output enriches Triage context. Alternative on-ramp — bypasses signal scanning when the owner has a specific concept.
- **[CLONE]** — Takes an external app or `ideas.json` reference and generates 3-5 ranked differentiation angles via seven-dimension gap analysis (audience, feature, pricing, UX, regulatory, platform, value-chain coupling). Each angle is a complete idea entry. Runs as subagent. Output enriches Triage context. Alternative on-ramp alongside [RESEARCH].
- **[TRIAGE]** — Two-pass adversarial triage: kill brief (prosecution) → four checks with defence against each prosecution point. Includes revenue scalability and LTV:CAC trajectory assessment (trend-adjusted CAC for riding_trend ideas). Competitive batch ranking — only one PROMOTE per batch. If eligible: PROMOTE_TO_RAPID_PROTOTYPE (low complexity + direct experience + 0 concessions). Requires external evidence for promotion.
- **[VALIDATE]** — Auto-invokes DIST-REVIEW for channel strategy, runs pre-flight check (account readiness, hosting, Formspree email backend), deploys landing page with Formspree form + Plausible analytics + UTM attribution, generates channel-specific content for minimum 2 channels (Reddit, Twitter/X, Indie Hackers, Facebook groups), monitors conversion rate with daily snapshots and velocity tracking, tracks negative signals. Four-tier validation: Tier 1 (conversion rate meets category benchmark, 30+ signups), Tier 1.5 (150 cumulative signups with organic growth during Foundation), Tier 2 (300 waitlist + 30 TestFlight), Tier 3 (500 waitlist + PMF confirmed)
- **[DESIGN-ITERATE]** — Visual design iteration between Validate and Build. Uses Refero (precedent research), Stitch (screen generation), and Figma (pixel refinement) to iterate on critical-path screens. Max 3 rounds → design freeze. Approved screens feed into spec and code context bundles.
- **[ORCHESTRATOR]** — Coordinates build subagents, constructs context bundles, never writes code. Runs compile check (xcodebuild) after [CODE] and test execution (xcodebuild test) after [TEST]. Enforces PMF Gate between Phase 2 and Phase 3.
- **[PMF-GATE]** — Hard gate between Build Phase 2 and Phase 3. Four checks: Sean Ellis 40% test, category-adjusted D7 retention, core loop engagement, NPS baseline. Prevents monetisation investment before product-market fit is confirmed.
- **[REQUIREMENTS]** — Researches domain rules, regulatory constraints, accounting standards, and user workflows. Tiered by app category: Tier A (finance, health) gets full regulatory research with authoritative citations and calculation worked examples; Tier B (social, gaming, education) gets platform rules; Tier C (productivity, utilities) gets lightweight workflow mapping. Outputs `docs/REQUIREMENTS.md` and `docs/REGULATORY.md`. Runs in parallel with [ARCHITECTURE] and [DESIGN] during Foundation.
- **[SPEC]** — Writes feature specs with numbered, testable acceptance criteria. Regulatory ACs tagged with `[REG-XXX]` tracing to the Regulatory Constraint Register. Every core spec includes a Wow Moment Decision Tree mapping each P0 persona's Day 1 state to a distinct wow path (reachable <60s, no registration wall). Alternate wow paths required when 2 P0 personas exist.
- **[CODE]** — Writes code to satisfy acceptance criteria. Platform-specific rules via core + overlay composition (`core/code-agent.core.md` + `platforms/{platform}/code-agent.{platform}.md`). Includes diagnose-before-fix protocol for performance and bug fixes
- **[TEST]** — Writes tests mapping 1:1 to acceptance criteria. Platform-specific: XCTest (iOS), Vitest/Jest (Web)
- **[REVIEW]** — Validates AC→code→test mapping, checks platform-specific compliance (HIG for iOS, WCAG for Web)
- **[DESIGN]** — Writes DESIGN_BRIEF.md, TONE_AND_LANGUAGE.md, ONBOARDING.md
- **[PRD]** — Writes PRD from validation data, structured around JTBD. Includes Persona Priority Map (3-5 personas, P0/P1/P2 ranking) and Feature-Persona Traceability Matrix (features mapped to persona needs, phase placement derived from persona priority)
- **[ARCHITECTURE]** — Writes ARCHITECTURE.md: data model, services, persistence
- **[ASO]** — App Store Optimisation: title, subtitle, keywords, screenshots, preview video spec. Includes launch sequencing (soft launch → editorial pitch → coordinated big-market release). Conditional pre-order strategy for social/competitive apps (leaderboard seeding, simultaneous launch-day downloads).
- **[ANALYTICS]** — Weekly AARRR funnel diagnosis with category-specific retention benchmarks, LTV/CAC ratios, virality K-factor decomposition, and cohort trend analysis
- **[CONVERT]** — Proposes single A/B test per week based on diagnosis
- **[SPRINT-RETRO]** — After each Phase 2 sprint deploys to TestFlight and 3-5 days of feedback accumulates, synthesises user feedback into feature health assessments, amendment proposals (scoped AC changes, max 3 ACs), and backlog adjustments. Soft gate — blocks next sprint unless owner overrides.

### Review Agents — Gate (block pipeline on failure)
- **[ARCH-REVIEW]** — Validates infrastructure (MCP config, schemas, cost controls, session hooks)
- **[IOS-REVIEW]** — Checks privacy manifest, entitlements, AC testability
- **[UX-REVIEW]** — Audits First Wow Moment (<60s TTFV), Hook Model (all 4 phases), core loop completion, D2 retention, JTBD emotional layer, category register, accessibility (VoiceOver, Dynamic Type, WCAG AA), and persona-wow alignment (P0 personas served, migration paths, empty state multi-path)

### Review Agents — Advisory (enrich, never block)
- **[MONO-REVIEW]** — Flags monetisation issues (11 flag types)
- **[DIST-REVIEW]** — Vertical-aware channel selection (user vs builder audiences), account readiness per channel, post structure. Auto-invoked by VALIDATE during pre-flight. Recommends primary + secondary channels from `channel-rules.json` vertical-to-channel mapping.
- **[REALITY-CHECK]** — Detects disappointment loops, frames sessions momentum-first
- **[PM-REVIEW]** — Staff PM review of CDO questions at any pipeline stage. Assesses question quality, coverage gaps, technical feasibility, and recommends specific actions. Runs inline.
- **[FRAMEWORK-REVIEW]** — Staff engineer critical review of external sources (articles, repos, talks, papers) against the APOS framework. Evaluates problem overlap, architecture compatibility, extractable concepts, and anti-patterns. Sceptical by default — changes must earn their place. Runs inline.

### Utility Agents (framework maintenance)
- **[SYNC]** — Detects framework changes via git diff, classifies into sync groups, auto-counts agents/commands/schemas, builds a sync plan, applies approved changes across CLAUDE.md, USER_GUIDE.md, agent definitions, and schemas. Plan-then-apply workflow — never modifies files without owner approval.
- **[DIAGNOSE]** — Staff iOS engineer for runtime console errors. Classifies 12 error categories (swift_concurrency, audio_engine, audio_session, audio_buffer, speech_synthesis, capture_session, main_thread, memory, storekit, permissions, core_data, layout), traces to structural root cause, applies targeted fixes. Distinct from `/fix-build` which handles compilation errors.
- **[BUILD-QUALITY]** — Aggregates build metrics across all apps: first-pass success rates, retry distributions, error category trends. Surfaces regressions and actionable insights. Inline report, no JSON output.
- **[SPINE-CHECK]** — Product spine alignment gate. Enforces coherence between an app's product artifacts and its Product Spine (`apps/<slug>/docs/PRODUCT_SPINE.md`). Two modes: pre-change gate (evaluate proposed changes before writing) and alignment audit (check all artifacts against spine). Blocks changes that contradict promise priority, introduce banned terminology, or break cross-artifact consistency. Can create spines for apps that don't have one.

## Multi-App Support

APOS supports multiple apps at different pipeline stages. Each app gets its own directory under `apps/<slug>/` with isolated specs, docs, and agent outputs.

```
apps/
  pausemate/
    app-state.json          # App-specific pipeline state
    learnings.json          # Operational learnings captured after key decisions
    specs/                  # App-specific feature specs
    docs/                   # App-specific build docs (PRD, ARCHITECTURE, DESIGN_BRIEF, etc.)
    approvals/pending/      # App-specific agent outputs
  another-app/
    ...
```

- `state.json` tracks the `active_app_slug` and `app_registry`
- `specs/`, `docs/`, and `approvals/pending/` at the project root are **symlinks** to the active app's directories
- All agent definitions read from `specs/`, `docs/`, and `approvals/pending/` — the symlinks make this work transparently
- `/switch <slug>` changes the active app (re-points the symlinks)
- `/add-app` registers a new app
- `schema-migrations/` is global (not per-app) and stays at the project root

## Key Paths
- Agent definitions: `.claude/agents/`
- Slash commands: `.claude/commands/`
- Agent output schemas: `agents/schemas/`
- Per-app directories: `apps/<slug>/`
- Agent outputs: `approvals/pending/` (symlink → active app)
- Feature specs: `specs/` (symlink → active app)
- Build docs: `docs/` (symlink → active app — PRD.md, ARCHITECTURE.md, DESIGN_BRIEF.md, REQUIREMENTS.md, REGULATORY.md, etc.)
- Global pipeline state: `state.json`
- Per-app state: `apps/<slug>/app-state.json`
- Idea outputs: `ideas.json`
- Schema migrations: `schema-migrations/` (global)
- Channel config: `agents/config/channel-rules.json`
- Per-app learnings: `apps/<slug>/learnings.json`
- Signal inbox: `signals/inbox.md`
- XcodeGen template: `agents/templates/project.yml.template`
- Per-app Xcode config: `apps/<slug>/project.yml`
- Sprint feedback: `apps/<slug>/sprint-feedback.md`
- Amendment spec template: `agents/templates/amendment-spec.md`
- Requirements template: `agents/templates/requirements.md.template`
- Regulatory template: `agents/templates/regulatory.md.template`
- Design system package: `packages/APOSDesignSystem/`
- Per-app theme: `apps/<slug>/<AppName>/Theme/<AppName>Theme.swift`
- Per-app action queue: `apps/<slug>/action-queue.json`
- Per-app action log: `apps/<slug>/action-log.json`
- Per-app product spine: `apps/<slug>/docs/PRODUCT_SPINE.md`
- Sprint board: `tools/sprint-board/`
- Review lint script: `tools/review-lint.sh`
- Per-app approved designs: `apps/<slug>/design/`
- Platform-agnostic agent cores: `.claude/agents/core/`
- Platform overlays (iOS, Web): `.claude/agents/platforms/{ios,web}/`
- Multi-track architecture: `agents/config/multi-track-architecture.md`
- Evaluation profiles: `agents/config/builder-program-profile.json`
- Pipeline config: `agents/config/pipeline-config.json`
- Experiment registry: `experiments.json` (global, cross-app)
- Lifecycle hooks: `.claude/hooks/` (session-start, schema validation, subagent context, auto-lint)
- CI workflows: `.github/workflows/`

## Running the Pipeline

All agents run locally via slash commands in Claude Code (VS Code):

```
/generate-ideas          — Daily idea generation (market-pull mode)
/builder-ideate          — Problem-first idea generation with Claude-fit validation (technology-push mode)
/research                — Deep research on an owner-suggested idea
/clone                   — Clone & differentiate from an existing app or idea
/triage                  — Triage top ideas
/validate                — Start 7-day validation
/design                  — Visual design iteration (Refero + Stitch + Figma)
/build                   — Start build phase (Orchestrator)
/pmf-gate                — Product-market fit gate (between Phase 2 and Phase 3)
/analytics               — Weekly funnel analysis
/convert                 — Propose A/B test
/sprint-retro             — Sprint retrospective after TestFlight deploy
/fix-build               — Diagnose and fix build errors
/diagnose                — Diagnose and fix runtime console errors
/run-tests               — Run tests and report results
/status                  — View current pipeline state
/daily                   — Morning briefing (next action + stale approvals)
/mission-control         — Build execution dashboard (action queue + audit log)
/build-quality           — Pipeline health metrics (first-pass rates, retries, error trends)
/sprint-board            — Visual dashboard: pipeline funnel, sprint board, lineage graph, compare view
/monday                  — Full Monday morning chain
```

Review agents:
```
/arch-review             — Infrastructure gate
/ios-review              — Spec gate
/ux-review <notes.md>    — Usability gate
/mono-review [monday]    — Monetisation advisory
/dist-review <subreddit> — Distribution advisory
/pm-review <questions>    — Staff PM review of CDO questions
/reality-check [monday]  — Session framing
```

App management:
```
/switch <slug>           — Switch active app context
/add-app                 — Register a new app
```

Framework maintenance:
```
/sync                    — Propagate framework changes across all artifacts
/framework-review <url>  — Critical review of external source against APOS
/build-quality           — Build pipeline health metrics across all apps
/spine-check             — Product spine alignment gate (pre-change or audit)
```

## Pipeline Order

1. `/generate-ideas` → ideas scored and written to `ideas.json`
1b. *(optional)* `/research "idea"` → deep feasibility research → decision card → COMMIT_TO_TRIAGE / PARK / KILL
1c. *(optional)* `/clone "reference"` → seven-dimension gap analysis → 3-5 differentiated angles → selected angles written to `ideas.json`
2. `/triage` → batch adversarial triage: kill brief → four checks → competitive ranking → one winner promoted. If eligible: PROMOTE_TO_RAPID_PROTOTYPE (compressed build, skips validation). Otherwise: PROMOTE_TO_VALIDATE (standard 7-day)
3a. *(standard path)* Owner approves → `/validate` → auto-invokes DIST-REVIEW for channel strategy → landing page (Formspree + Plausible) + multi-channel content (min 2 channels)
3b. *(rapid prototype path)* Owner approves → `/build` → compressed Foundation + 1 sprint → TestFlight → `/validate` (Usage Validation: 5 users, 3 days)
4. Day 7 decision (or usage validation result) → `/build` → Orchestrator runs Phase 1 (Foundation)
4b. *(optional)* `/design` → visual design iteration (Refero research → Stitch mockups → CDO review → iterate → design freeze)
5. `/build` continues → Orchestrator runs Phase 2-4 (approved designs feed into specs + code)
6. Weekly → `/analytics` + `/convert` → continuous optimisation

## Non-Negotiable Coding Standards

### Platform-Specific Standards

Full coding standards are defined in platform overlays. See `.claude/agents/platforms/{platform}/` for details.

| Standard | iOS | Web |
|---|---|---|
| **Language** | Swift 6 strict concurrency | TypeScript strict mode |
| **UI** | SwiftUI only (no UIKit) | React 19+ / Next.js 15+ (Server Components default) |
| **Architecture** | MVVM with `@Observable` | Server Components + Client Components |
| **Persistence** | SwiftData / UserDefaults | PostgreSQL via Prisma/Drizzle |
| **Design System** | `APOSDesignSystem` Swift Package | shadcn/ui + Tailwind tokens |
| **Dependencies** | RevenueCat + Mixpanel only | shadcn/ui, Stripe, Plausible/Mixpanel, Zustand, RHF+Zod |
| **Build** | XcodeGen + xcodebuild | npm + tsc + Next.js build |
| **Tests** | XCTest (xcodebuild test) | Vitest/Jest + Playwright |
| **Min target** | iOS 17.4 | Evergreen browsers (last 2 versions) |
| **Payments** | StoreKit 2 | Stripe |

### Accessibility (Universal)

44pt/44px touch/click targets, WCAG AA contrast (4.5:1 body, 3:1 large text), reduce motion compliance, semantic colour tokens only. Platform-specific: Dynamic Type + VoiceOver (iOS), keyboard navigation + semantic HTML + screen readers (Web). Full enforcement in [CODE] and [REVIEW] agent definitions.

### Acceptance Criteria Contract
Every spec must include numbered, testable acceptance criteria. This is the formal contract:
- The **Code Agent** writes code to satisfy each criterion
- The **Test Agent** writes one test per criterion (XCTest on iOS, Vitest on Web)
- The **Review Agent** cannot return `review_passed: true` unless every AC maps to a code line AND a passing test

### Build Phases
1. **Foundation** (Weeks 1-2): PRD.md, then ARCHITECTURE.md + DESIGN_BRIEF.md + REQUIREMENTS.md + REGULATORY.md in parallel, TONE_AND_LANGUAGE.md. Owner reviews requirements research. Then **Requirements Review** (plan mode staff-engineer cross-document review — checks REQUIREMENTS↔REGULATORY completeness, PRD↔REQUIREMENTS alignment, ARCHITECTURE coverage, internal consistency). Project config, Design System Setup (app Theme file + Asset Catalog + package compilation check). The shared component library (`packages/APOSDesignSystem/`) provides 15 implemented components (atoms, molecules, organisms) — apps only need a Theme file and Asset Catalog.
2. **Tier 1.5 Checkpoint** (between Phase 1 and Phase 2): Orchestrator verifies 150 cumulative signups and organic growth before starting Core Loop. Passive check — landing page stays live during Foundation.
3. **Core Loop + Platform** (Weeks 3-6): Built in sprints (1-3 specs per sprint, independent specs in parallel pipelines). Each sprint: build → deploy to TestFlight → 3-5 day feedback period → Sprint Retro → owner approves amendments/backlog changes. Amendment specs are scoped AC changes (max 3 ACs) that run through the full build pipeline. Amendment cap uses convergence tracking: divergent amendments (same root cause recurring) trigger redesign after 2; convergent amendments (different root causes) allow up to 3. All code verified to compile, all tests verified to pass (automated by Orchestrator). First Wow Moment reachable <60s. Apple Intelligence App Intents. Live Activities if time-bounded.
4. **PMF Gate** (after Phase 2): Sean Ellis 40% test, category-adjusted D7 retention, core loop engagement, NPS baseline. Hard gate — must pass before monetisation.
5. **Monetisation** (Weeks 7-10): Paywall after first core loop completion. Free tier = value revelation. Three tiers: Free/Monthly/Annual. StoreKit 2.
6. **Polish & Launch** (Weeks 11-14): ASO with launch sequencing (soft launch → editorial pitch → coordinated big-market release), App Preview Video, Custom Product Pages, TestFlight beta.

Phase entry conditions and gate criteria are enforced by [ORCHESTRATOR] and [PMF-GATE] agents. The owner can manually promote ideas to Build with a confirmation check (recorded as manual override). See `.claude/agents/orchestrator-agent.md` and `.claude/agents/pmf-gate-agent.md`.

### A/B Test Rules

Enforced by the [CONVERT] agent. Full rules (7 non-negotiable items) in `.claude/agents/conversion-agent.md`.

## Verification-First Rule
Never present a capability, CLI flag, API feature, or external tool as existing without verifying it via tool use (run the command, read the docs, fetch the URL). If verification isn't possible, explicitly mark the claim as unverified. This applies to all agents, especially research and advisory outputs.

## Conventions
- All agent outputs are JSON, validated against their schema in `agents/schemas/`
- Gate agents set `review_passed: true/false` — false blocks pipeline progression
- Advisory agents always set `review_passed: true` (they enrich, never block)
- `state.json` is the shared source of truth for pipeline state
- All timestamps use ISO 8601 format
- Multiple apps may be in Build concurrently — each app's build state is tracked independently
- The owner can manually promote an idea to Build without completed validation (recorded as manual override in app-state.json)
- Every agent output includes a `self_check` block
- Agent identity badges (e.g., `[IDEA]`, `[TRIAGE]`) prefix all log lines
- Every agent definition must include `## Prerequisites` and `## When NOT to Run` sections — agents fail fast when inputs are missing
- Agents producing owner-facing decisions must follow the Decision Card template in `agents/templates/decision-card.md`
- Domain-specific enforcement rules live in the enforcing agent's definition — CLAUDE.md is routing and overview, not the enforcement point
- Pipeline agents prompt for session learnings after significant decisions (validation Day 7, A/B test approval) — stored in `apps/<slug>/learnings.json`
- Cloned ideas enter `ideas.json` with `status: "cloned"`, `score: 4`, and `clone_output_ref` pointing to the clone analysis. Triage receives the clone output as enriched context (same pattern as researched ideas)
- The Idea Agent checks `signals/inbox.md` for manually-added signals before scanning fresh sources
- Phase 2 is structured as sprints with retrospectives after each TestFlight deploy
- Amendment specs scope changes to <=3 ACs; amendment cap uses convergence tracking (divergent = redesign after 2, convergent = up to 3)
- Sprint Retro is a soft gate — blocks next sprint unless owner explicitly overrides
- Feature health from sprint retros feeds into the Analytics agent post-launch
- The Orchestrator manages `apps/<slug>/action-queue.json` during builds — agents do not read or write the queue directly. On session start, the Orchestrator detects interrupted (`in_progress`) actions and resumes from the last checkpoint. Queue actions are selected blocker-first (most downstream impact executes first)
- Action queue uses typed dependency edges (`blocks`, `supersedes`, `relates_to`) for graph-aware scheduling. `depends_on` (flat array) is deprecated but retained for backwards compatibility
- Specs within a sprint that target independent modules execute in parallel pipelines (max 2 concurrent subagents). Sprint deploy is the join point
- When an action fails, the orchestrator cascades `blocked` status to all transitively downstream actions via `blocks` edges
- Owner rejection of a spec creates a resubmission action (preserving audit trail) rather than a dead-end `skipped` status
- The action queue includes a computed `summary` block written on every queue mutation — read by Mission Control and /daily without recomputing
- `owner_proximity` and `trend_coupling` are additive scoring signals on ideas, not hard gates — outsider ideas with strong signals still proceed
- Rapid prototype path (`PROMOTE_TO_RAPID_PROTOTYPE`) is a structured alternative to manual override — tracked separately with its own lifecycle in `app-state.json` (`validation_path: "rapid_prototype"`)
- Maximum 1 rapid prototype in flight at a time (`state.json > active_rapid_prototypes`)
- Review lint (`tools/review-lint.sh`) runs between test execution and REVIEW, catching mechanical HIG violations (hardcoded colours, raw spacing, missing imports). Lint results are passed to REVIEW so it can skip re-checking covered categories and focus on semantic judgment
- Simulated UX Walkthrough runs after REVIEW passes, before sprint deploy. Orchestrator simulates each P0 persona's first-time flow, checking 9 usability failure patterns (W1-W9). Advisory only — findings surfaced to CDO alongside deploy decision. Walkthrough findings recorded in action log for sprint retro calibration
- Subagent context bundles have size budgets (CODE: 40KB target, TEST: 30KB, REVIEW: 35KB, SPEC: 50KB). The orchestrator prunes CLAUDE.md to coding-standards-only and limits existing code files to import-relevant modules when bundles exceed targets
- Amendment specs include a `Rationale` field on every modified/added AC — traces the specific user feedback to the code change, preventing over-engineering
- Action log events include `input_tokens`, `output_tokens`, and `context_bundle_files` for subagent calls — read by `/build-quality` for efficiency trends
- `experiments.json` is a global cross-app registry of A/B tests. The CONVERT agent writes proposals and records results. TRIAGE, SPEC, and PMF-GATE agents read it for transferable insights. The ANALYTICS agent prompts for result recording at weekly checkpoints
- Ideas that reach build/launch can have an optional `outcome` field in `ideas.json` tracking launch date, PMF gate result, actual retention, revenue milestones, and honest retrospective. The ANALYTICS agent prompts for outcome data at 30/60/90 day post-launch milestones
- The SPEC agent consults `apps/*/learnings.json` and `experiments.json` across all apps before writing specs — cross-app learnings prevent repeating known mistakes
- Apps with a `docs/PRODUCT_SPINE.md` use it as the anchor for all product artifacts. The spine defines the problem, promise priority, value chain, artifact roles, change protocol, and terminology registry. `/spine-check` enforces alignment — run it before editing product docs and after Foundation phase completes. Changes to artifacts must be proposed against the spine first (which promise? which value chain step?) and applied to all affected artifacts in one pass

## Execution Model

The pipeline uses three execution patterns for agent delegation:

- **Subagents (Task tool):** Build subagents ([SPEC], [CODE], [TEST], [REVIEW]), Foundation agents ([PRD], [ARCHITECTURE], [DESIGN], [REQUIREMENTS]), the [RESEARCH] agent, and the [CLONE] agent run as independent subagents via the Task tool, each with its own context window. The [ORCHESTRATOR] spawns and coordinates build/foundation agents. Research runs standalone via `/research`. Clone runs standalone via `/clone`.
- **Agent Teams:** The Monday chain (`/monday`) runs ANALYTICS + REALITY-CHECK as parallel teammates, then MONO-REVIEW and CONVERT sequentially. Triage (`/triage`) uses a three-role agent team (Prosecutor, Defence, Judge) for genuine adversarial separation.
- **Inline execution:** All other agents (idea generation, validation, review agents) run inline in the current session.

- **Lifecycle Hooks:** Four hooks in `.claude/settings.json` automate cross-cutting concerns: `SessionStart` (injects active app context), `TaskCompleted` (schema validation of agent output), `SubagentStart` (injects APOS context into every subagent), `PostToolUse` on Write/Edit (async auto-lint on Swift files). Hook scripts live in `.claude/hooks/`.

Agent Teams require `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in `.claude/settings.json`. All subagent/team-based agents include fallback instructions for inline execution if these features are unavailable.
