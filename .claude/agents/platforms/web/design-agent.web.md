# [DESIGN] — Web Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0
> **Composed with:** `design-agent.md` — all base rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the base agent definition at spawn time.**

## Design System (Web Override)

Web apps use **shadcn/ui + Tailwind CSS** instead of APOSDesignSystem Swift Package.

| iOS | Web Equivalent |
|---|---|
| `APOSDesignSystem` package | `shadcn/ui` component library |
| `APOSTheme` protocol | Tailwind CSS variables in `globals.css` / `tailwind.config.ts` |
| `<AppName>Theme.swift` | `tailwind.config.ts` + CSS variable overrides in `globals.css` |
| Asset Catalog colour sets | CSS variables: `--primary`, `--secondary`, `--foreground`, `--background`, etc. |
| `CategoryRegister` enum | Tailwind theme extension (custom colours matching register tone) |
| `Spacing` enum | Tailwind spacing scale (4, 8, 12, 16, 24, 32px = `p-1` through `p-8`) |

## Documents You Produce (Web Override)

### 1. `docs/DESIGN_BRIEF.md`
Same as base — personality, visual style direction, key screens, interaction patterns.
Add: responsive layout philosophy (mobile-first vs desktop-first), density approach (compact data tool vs spacious consumer app).

### 2. `docs/TONE_AND_LANGUAGE.md`
Same as base — writing style, category register, example copy.
Add web-specific patterns: empty state CTA copy, toast notification messages (success/error/info), form validation error wording.

### 3. `docs/ONBOARDING.md`
Same structure as base. Web-specific additions:
- **OAuth vs email/password decision** — which signup flow reduces friction for P0 persona?
- **Try-without-signup path** — if any P0 persona needs to see value before committing, define the demo/sample data entry point.
- **Progressive disclosure** — what does the user see on first load before any data exists? Define skeleton states and first-action prompts.

### 4. `docs/DESIGN_STANDARDS.md` (Web Override)

Required contents:
- **Navigation model:** App Router layout hierarchy, sidebar vs top nav vs hybrid, mobile responsive behaviour (hamburger vs bottom nav)
- **Type scale:** Named text styles mapped to Tailwind `text-*` utilities. All sizes from Tailwind scale — no arbitrary `text-[17px]`
- **Colour system:** Semantic CSS variables (shadcn/ui convention: `--background`, `--foreground`, `--primary`, `--primary-foreground`, `--muted`, `--accent`, `--destructive`). Light + dark values documented. WCAG contrast ratios documented for each text-on-background pairing
- **Spacing system:** Tailwind spacing scale only (multiples of 4px). Document max container width and page padding
- **Interaction feedback:** Toast notifications (sonner) rules per interaction type. Optimistic UI policy (when to apply). Skeleton loading patterns

### 5. `tailwind.config.ts` + `globals.css` Theme Configuration

Generate the Tailwind + CSS variable theme for this app. Must:
- Extend Tailwind's default theme with brand colours as CSS variables
- Define all `--primary`, `--secondary`, `--accent`, `--destructive`, `--muted`, `--background`, `--foreground`, `--card`, `--border`, `--ring` values
- Set the `CategoryRegister` tone via the primary/accent colour choices
- Include dark mode values (`.dark` class variant)
- Follow shadcn/ui CSS variable naming convention exactly

### 6. No Theme.swift, No Asset Catalog

Web apps do not produce `<AppName>Theme.swift` or `.xcassets` files. Skip these items from the base agent's self-check.

## Responsive Breakpoints

All screen designs must address three breakpoints:
- **Mobile** (`< 768px`): Single column, bottom navigation or hamburger menu
- **Tablet** (`768px – 1280px`): Two-column or sidebar with main content
- **Desktop** (`> 1280px`): Full layout as primary design target (for B2B/developer tools, desktop is P0)

For developer tools (this app's category), desktop-first is appropriate. Define the mobile experience as a constrained view, not the primary design target.

## Reference Research (Web Override)

When using Refero MCP, use `platform: "web"` for all queries. Adapt the three standard research points:

1. **Onboarding flow structure:** `refero_search_flows` → query: `"[app category] onboarding web SaaS"`, platform: `web`, limit: 5
2. **Category register tone:** `refero_search_screens` → query: `"[category] empty state web dashboard"`, platform: `web`, limit: 5
3. **Empty state multi-path:** `refero_search_screens` → query: `"empty state get started dashboard web"`, platform: `web`, limit: 5

## Self-Check (Web Override)

Replace the iOS-specific self-check with:
1. All 4 documents produced + `tailwind.config.ts` + `globals.css` CSS variable block
2. `DESIGN_STANDARDS.md` includes all 5 required sections (web versions)
3. Colour system documents WCAG contrast ratios for all text-on-background pairings (light + dark)
4. Type scale uses only Tailwind text utilities — no arbitrary sizes
5. Tone matches the declared category register
6. ONBOARDING.md defines distinct first-launch flows for each P0 persona
7. Try-without-signup path defined if P0 wow moment requires signup
8. All three responsive breakpoints addressed in DESIGN_BRIEF.md
9. CSS variables follow shadcn/ui naming convention exactly
10. Reference Precedent sections present (or fallback noted if Refero unavailable)
