# APOS Multi-Track Architecture

> **Status:** Design document — not yet implemented
> **Author:** Architecture review for Builder Program integration
> **Date:** 2026-03-08

## The Problem

APOS is hardcoded to iOS in three ways:

1. **Ideation** — The idea agent scans for "iOS app opportunities." All ideas assume App Store distribution.
2. **Build** — Coding standards, build toolchain, design system, review criteria all assume Swift/SwiftUI/Xcode.
3. **Validation** — Landing pages assume App Store as the end state.

This prevents two valuable idea classes:
- **SaaS/Web apps** that are better served by web distribution (Next.js, Stripe, no App Store review)
- **Technology-push ideas** where the platform is TBD until the capability-problem mapping is complete

## The Three Tracks

APOS operates on three dimensions that are often conflated:

### Dimension 1: Ideation Mode (HOW ideas are generated)

| Mode | Direction | Starting Point | Best For |
|---|---|---|---|
| **Market-Pull** (default) | Problem → Solution | Signal scanning for struggle behaviour | Consumer apps, regulated niches, replacement plays |
| **Technology-Push** | Capability → Problem | Audit unique capabilities, find unlocked problems | AI-native products, API-dependent apps, showcase apps |
| **Clone** | Reference → Differentiation | Existing app gap analysis | Fast-follow, competitive positioning |

These modes are **mutually exclusive per ideation run** but an idea from any mode enters the same downstream pipeline.

### Dimension 2: Platform (WHAT gets built)

| Platform | Language | UI | Build Tool | Distribution | Design System |
|---|---|---|---|---|---|
| **iOS** | Swift 6 | SwiftUI | XcodeGen + xcodebuild | App Store | APOSDesignSystem (Swift Package) |
| **Web** | TypeScript | React/Next.js | npm + Vercel/Netlify | Web URL | shadcn/ui + Tailwind tokens |
| **Platform TBD** | — | — | — | — | — |

Platform is assigned **per-app** at registration (`/add-app`) and stored in `app-state.json`. An idea may start as "Platform TBD" and get assigned during Triage or Build.

### Dimension 3: Evaluation Profile (WHO judges quality)

| Profile | Scoring Criteria | Applied When |
|---|---|---|
| **Standard** (default) | APOS signal strength, JTBD, switching trigger | Normal pipeline operation |
| **Builder Program** | Claude dependency, demo impact, VC narrative | Ideas targeting accelerator/showcase programmes |
| **Custom** | User-defined constraints | Future extensibility |

Profiles are **additive overlays** on standard scoring — they add modifiers and hard gates, never replace the base evaluation.

## Agent Classification

Every agent falls into one of four categories:

### Universal (no changes needed)
These agents are platform-agnostic and mode-agnostic. They work identically regardless of what's being built or how the idea was generated.

| Agent | Why Universal |
|---|---|
| **[TRIAGE]** | Evaluates ideas on market signal, not platform. Receives enriched context from any ideation mode. |
| **[RESEARCH]** | Investigates feasibility — domain research is platform-independent. |
| **[CLONE]** | Gap analysis is about market positioning, not implementation. |
| **[PRD]** | Product requirements are what the user needs, not how it's built. |
| **[REQUIREMENTS]** | Domain rules and regulations are platform-independent. |
| **[VALIDATE]** | Landing pages, channel strategy, conversion tracking — all web-based regardless of final product platform. |
| **[ANALYTICS]** | AARRR funnel analysis is framework-agnostic. |
| **[CONVERT]** | A/B test proposals are about user behaviour, not code. |
| **[PMF-GATE]** | Product-market fit is measured by user behaviour metrics. |
| **[SPRINT-RETRO]** | Feedback synthesis is about user observations, not code. |
| **[PM-REVIEW]** | Advisory — reviews decisions, not code. |
| **[REALITY-CHECK]** | Advisory — frames sessions, not implementations. |
| **[MONO-REVIEW]** | Monetisation advice is platform-aware but not platform-dependent (App Store vs Stripe). Minor adjustment needed. |
| **[FRAMEWORK-REVIEW]** | Reviews external sources against APOS — meta-level. |
| **[SYNC]** | Framework maintenance — propagates changes across artifacts. |
| **[BUILD-QUALITY]** | Aggregates build metrics — reads action logs regardless of platform. |

### Platform-Dependent (need core + overlay split)
These agents have platform-specific rules. The pattern already exists for [CODE] — extend it to the others.

| Agent | What Varies | Core (shared) | iOS Overlay | Web Overlay |
|---|---|---|---|---|
| **[CODE]** | Language, framework, design system, build errors | ✅ exists | ✅ exists | ✅ exists |
| **[TEST]** | Test framework (XCTest vs Vitest/Jest), test patterns | Test-per-AC contract, amendment mode, UX test checklist | XCTest, `@Test`, `#expect`, iOS simulators | Vitest/Jest, React Testing Library, Playwright for E2E |
| **[REVIEW]** | HIG vs WCAG, platform-specific smells, lint rules | AC→code→test mapping, UX smell detection, sprint integration | HIG compliance, SF Symbols, Dynamic Type, review-lint.sh | WCAG compliance, semantic HTML, responsive, Lighthouse |
| **[SPEC]** | Screen state patterns, platform capabilities | AC numbering, wow moment tree, UX assumptions | iOS screen states, HealthKit/StoreKit/Vision references | Responsive breakpoints, SSR considerations, web APIs |
| **[DESIGN]** | Design system, component library, platform patterns | DESIGN_BRIEF structure, TONE_AND_LANGUAGE | APOSDesignSystem, SF Symbols, iOS HIG | shadcn/ui, Lucide icons, responsive patterns |
| **[ARCHITECTURE]** | Data model, services, persistence, deployment | Architecture document structure | SwiftData, App Groups, Xcode project | Prisma/Drizzle, Next.js API routes, Vercel/Railway |
| **[ORCHESTRATOR]** | Build toolchain, compile check, test execution | Action queue, sprint structure, context bundles, gate enforcement | xcodebuild, XcodeGen, TestFlight | npm build, Vitest, Vercel deploy |
| **[DESIGN-ITERATE]** | Stitch/Figma output format, component mapping | Iteration workflow, screen map, design freeze | SwiftUI component mapping | React component mapping |
| **[ASO]** | Distribution channel | — | App Store Optimisation (full agent) | SEO + Product Hunt + landing page (new overlay) |
| **[DIAGNOSE]** | Runtime error patterns | Diagnostic protocol | Swift concurrency, audio, Xcode console | Browser console, Next.js errors, Vercel logs |

### Ideation-Mode-Dependent (need mode parameter)
| Agent | What Changes |
|---|---|
| **[IDEA]** | Signal sources, value framing, scoring. Market-pull scans struggle behaviour. Technology-push audits capabilities. |

### Gate Agents — Require Platform Variants
| Agent | iOS | Web |
|---|---|---|
| **[IOS-REVIEW]** | Privacy manifest, entitlements, AC testability | N/A — replaced by [WEB-REVIEW] |
| **[ARCH-REVIEW]** | MCP config, iOS schemas, cost controls | Web infra: Vercel config, DB security, API rate limits |
| **[UX-REVIEW]** | iOS-specific (VoiceOver, Dynamic Type) + universal | Web-specific (keyboard nav, screen readers) + universal |
| **[DIST-REVIEW]** | App Store channels, ASO | SEO, Product Hunt, social, web directories |

## State Model Changes

### `state.json` (global)

```json
{
  "default_platform": "ios",
  "default_ideation_mode": "market_pull",
  "default_evaluation_profile": "standard",
  "evaluation_profiles": ["standard", "builder_program"],
  "platforms_available": ["ios", "web"]
}
```

### `app-state.json` (per-app) — new fields

```json
{
  "app": {
    "platform": "ios | web | tbd",
    "ideation_mode": "market_pull | technology_push | clone",
    "evaluation_profile": "standard | builder_program | null"
  }
}
```

### `ideas.json` — new fields per idea

```json
{
  "platform": "ios | web | tbd",
  "ideation_mode": "market_pull | technology_push | clone",
  "evaluation_profile": "standard | builder_program | null"
}
```

## Command Changes

### Modified Commands

| Command | Change |
|---|---|
| `/add-app` | Ask for platform (ios/web/tbd) during registration |
| `/generate-ideas` | Accept optional `--mode` flag (market_pull/technology_push). Default: market_pull |
| `/builder-ideate` | Already technology-push. Add `--profile builder_program` implicitly |
| `/build` | Orchestrator reads `app.platform` and composes correct overlays |
| `/fix-build` | Reads platform to select correct error patterns |
| `/run-tests` | Reads platform to select correct test runner |
| `/diagnose` | Reads platform to select correct error categories |

### New Commands

| Command | Purpose |
|---|---|
| `/switch-platform <platform>` | Change an app's platform (only allowed before Build Phase 2) |

## Orchestrator Composition

The Orchestrator already spawns subagents with context bundles. The change is in HOW it composes those bundles:

```
Current:  agent_definition.md → subagent
Proposed: core/agent.core.md + platforms/{platform}/agent.{platform}.md → subagent
```

For agents that don't have a core/overlay split yet, the existing monolithic definition IS the iOS overlay. Migration path:

1. Extract platform-agnostic rules into `core/agent.core.md`
2. Leave iOS-specific rules in `platforms/ios/agent.ios.md`
3. Create `platforms/web/agent.web.md` for web-specific rules
4. Orchestrator merges core + platform overlay before spawning

## Idea Agent Mode Switch

The idea agent needs the most significant change. Rather than one monolithic agent, it becomes mode-aware:

### Market-Pull Mode (current default)
- Scan 8 signal sources for struggle behaviour
- Frame JTBD, workaround, switching trigger
- Score on signal strength
- Platform field defaults to `ios` unless the idea is clearly web-native

### Technology-Push Mode (new)
- Phase 1: Capability audit (extended thinking, no search)
- Phase 2: Capability → problem mapping (agentic research)
- Phase 3: Signal validation (standard APOS rigour)
- Phase 4: Showcase narrative test
- Platform field defaults to `tbd` — assigned based on best delivery vehicle
- Evaluation profile automatically set to whatever profile triggered the mode

### Clone Mode (existing)
- Gap analysis against reference app/idea
- Platform inherits from reference app's platform, or `tbd` if cross-platform differentiation

## Implementation Phases

Each phase has a **trigger condition** checked by the Orchestrator and `/add-app`. When the trigger fires and required items are incomplete, the pipeline blocks with an actionable message.

### Phase A: Minimum viable multi-track
**Trigger:** Already implemented (2026-03-08).
**Status:** COMPLETE

| # | Item | Status |
|---|---|---|
| A1 | `platform` field in `state.json`, `app-state.json`, `ideas.json` | DONE |
| A2 | `/add-app` asks for platform | DONE |
| A3 | Core + overlay composition for [CODE] | DONE (3 files exist) |
| A4 | Technology-push ideation mode (`/builder-ideate`) | DONE |
| A5 | Builder Program evaluation profile | DONE |
| A6 | Core/overlay split for [TEST] and [REVIEW] | TODO |

### Phase B: Full platform parity
**Trigger:** A `web` platform app reaches `build` stage (`app-state.json > pipeline.current_stage == "build"` AND `app.platform == "web"`).
**Blocking message:** `[ORCHESTRATOR] Blocked: App "<name>" is platform "web" but Phase B (web platform parity) is incomplete. Run the items below before /build can proceed.`

| # | Item | Required Files | Status |
|---|---|---|---|
| B1 | Core/overlay split: [TEST] agent | `core/test-agent.core.md` + `platforms/web/test-agent.web.md` | TODO |
| B2 | Core/overlay split: [REVIEW] agent | `core/review-agent.core.md` + `platforms/web/review-agent.web.md` | TODO |
| B3 | Core/overlay split: [SPEC] agent | `core/spec-agent.core.md` + `platforms/web/spec-agent.web.md` | TODO |
| B4 | Core/overlay split: [DESIGN] agent | `core/design-agent.core.md` + `platforms/web/design-agent.web.md` | TODO |
| B5 | Core/overlay split: [ARCHITECTURE] agent | `core/architecture-agent.core.md` + `platforms/web/architecture-agent.web.md` | TODO |
| B6 | Core/overlay split: [ORCHESTRATOR] agent | `core/orchestrator-agent.core.md` + `platforms/web/orchestrator-agent.web.md` | TODO |
| B7 | Core/overlay split: [DIAGNOSE] agent | `core/diagnose-agent.core.md` + `platforms/web/diagnose-agent.web.md` | TODO |
| B8 | Web gate agent: [WEB-REVIEW] | `.claude/agents/web-review-agent.md` | TODO |
| B9 | Web build toolchain in Orchestrator | npm build, Vitest, Vercel/Netlify deploy | TODO |
| B10 | Web Foundation template | Next.js project scaffold, shadcn/ui init, Tailwind config | TODO |

### Phase C: Profile system
**Trigger:** A second evaluation profile is registered in `state.json > evaluation_profiles` beyond `standard` and `builder_program`.
**Blocking message:** `[TRIAGE] Info: Custom evaluation profile "<name>" detected but profile registry not yet implemented. Using standard scoring only.`

| # | Item | Status |
|---|---|---|
| C1 | Profile registry schema in `agents/schemas/` | TODO |
| C2 | Profile-aware scoring overlay in Triage | TODO |
| C3 | Profile metadata in ideas.json output | TODO |

## Orchestrator Phase Check

The Orchestrator MUST check platform readiness before starting a build. Add this to the Orchestrator's Prerequisites section:

```
## Platform Readiness Check

Before starting any build phase, verify the app's platform has required agent overlays:

1. Read `app-state.json > app.platform`
2. For each platform-dependent agent in the build sequence (CODE, TEST, REVIEW, SPEC, DESIGN, ARCHITECTURE):
   a. Check if `core/{agent}.core.md` exists
   b. Check if `platforms/{platform}/{agent}.{platform}.md` exists
   c. If core exists but platform overlay is missing → BLOCK with Phase B message
   d. If neither exists → fall back to monolithic agent definition (backwards compatible for iOS)
3. Log which composition mode was used in the action log

This check is a NO-OP for iOS apps (monolithic definitions work as-is).
It only blocks for web apps where overlays are missing.
```

## `/add-app` Phase Awareness

When registering a `web` platform app, `/add-app` should warn:

```
⚠️ Web platform selected. Current overlay status:
  [CODE] ✅ core + web overlay exist
  [TEST] ❌ web overlay missing (Phase B item B1)
  [REVIEW] ❌ web overlay missing (Phase B item B2)
  ...
Web apps can proceed through idea/triage/validate stages.
Build stage will be blocked until Phase B items are complete.
Register anyway? (y/n)
```

## Migration

Existing apps are unaffected:
- `platform` defaults to `"ios"` if absent
- `ideation_mode` defaults to `"market_pull"` if absent
- `evaluation_profile` defaults to `"standard"` if absent
- Monolithic agent definitions continue to work — they ARE the iOS overlay
- Core/overlay composition is opt-in per agent (the Orchestrator checks for core file existence)

## Non-Goals

- **Mobile web / PWA** — not a separate platform. Use `web` platform.
- **Android** — out of scope. Solo operator, one mobile platform.
- **Desktop (macOS/Windows)** — out of scope for now. Mac Catalyst could be an iOS overlay extension later.
- **Multi-platform apps** — one app = one platform. If you want iOS + web, register two apps.
