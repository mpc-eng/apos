# APOS — Autonomous App Portfolio Operating System

A fully agentic pipeline for identifying, validating, building, and monetising software products. 32 AI agents across 5 stages, operated by a single decision-maker via slash commands in [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Pipeline

```
/generate-ideas → /triage → /validate → /build → /convert
```

| Stage | What Happens |
|-------|-------------|
| **Idea Pool** | Scan 8 signal sources, frame JTBD, score ideas 1–5 |
| **Triage** | Adversarial two-pass: kill brief → four checks. One winner per batch |
| **Validate** | Landing page with pricing signal, 7-day conversion tracking |
| **Build** | Orchestrated spec → code → test → review sprints with retros |
| **Convert** | Weekly AARRR funnel analysis, single A/B test per week |

Three ideation modes: **Market-Pull** (signal scanning), **Technology-Push** (domain expertise + Claude-fit), **Clone** (gap analysis against existing apps).

Two platforms: **iOS** (Swift 6 / SwiftUI) and **Web** (TypeScript / React / Next.js).

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (VS Code extension or CLI)
- For iOS: Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- For Web: Node.js 20+ and npm

## Quick Start

```bash
git clone https://github.com/mpc-eng/apos.git
cd apos
```

Open in VS Code with Claude Code, then:

```
/add-app              # Register your first app
/generate-ideas       # Scan for opportunities
/triage               # Evaluate top candidates
/validate             # Start 7-day demand validation
/build                # Build with orchestrated agents
```

## Agent Architecture

| Category | Count | Role |
|----------|-------|------|
| **Pipeline** | 18 | Drive workflow forward (IDEA, TRIAGE, VALIDATE, ORCHESTRATOR, SPEC, CODE, TEST, REVIEW, etc.) |
| **Gate** | 3 | Block pipeline on failure (ARCH-REVIEW, IOS-REVIEW, UX-REVIEW) |
| **Advisory** | 6 | Enrich without blocking (MONO-REVIEW, DIST-REVIEW, REALITY-CHECK, PM-REVIEW, FRAMEWORK-REVIEW, BUILD-QUALITY) |
| **Utility** | 3 | Framework maintenance (SYNC, DIAGNOSE, SPINE-CHECK) |

## Key Directories

```
.claude/agents/       # Agent definitions (core + platform overlays)
.claude/commands/     # Slash commands
.claude/hooks/        # Lifecycle hooks (session start, schema validation, auto-lint)
agents/schemas/       # JSON Schema validation for agent outputs
agents/config/        # Pipeline config, channel rules, evaluation profiles
agents/templates/     # Decision cards, amendment specs, requirements templates
packages/             # APOSDesignSystem (Swift Package, iOS)
tools/                # Sprint board dashboard, review lint
apps/                 # Per-app directories (specs, docs, state)
```

## Documentation

See [USER_GUIDE.md](USER_GUIDE.md) for comprehensive documentation covering all commands, agents, and workflow details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. All contributions require a [DCO sign-off](DCO).

## License

[Apache License 2.0](LICENSE)
