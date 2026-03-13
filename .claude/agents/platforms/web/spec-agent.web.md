# [SPEC] — Web Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0
> **Composed with:** `spec-agent.md` — all base rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the base agent definition at spawn time.**

## AC Language (Web Override)

ACs must use web-idiomatic language, not iOS patterns:

| Instead of | Use |
|---|---|
| "User taps X" | "User clicks X" |
| "Sheet appears" | "Modal/dialog opens" |
| "NavigationLink pushes" | "Route navigates to /path" |
| "SwiftUI view" | "React component / page" |
| "XCTest" | "Vitest unit test / Playwright E2E test" |

## Component References (Web)

When ACs reference UI components, use shadcn/ui component names:

- Buttons: `Button` (variant: default/secondary/destructive/ghost/outline)
- Forms: `Form` with `FormField`, `Input`, `Select`, `Checkbox`, `Switch`
- Layout: `Card`, `Separator`, `Sheet` (slide-over), `Dialog` (modal), `Drawer`
- Feedback: `Toast` (sonner), `Alert`, `Badge`, `Progress`, `Skeleton`
- Navigation: `NavigationMenu`, `Tabs`, `Breadcrumb`, `Sidebar`
- Data: `Table`, `DataTable` (with TanStack Table), `Command` (for search/command palettes)

## Accessibility ACs (Web — Required for Every Spec)

Every spec must include at minimum:

- **Keyboard navigation AC:** All interactive elements reachable and operable via keyboard (Tab, Enter, Escape, Arrow keys per ARIA patterns).
- **Screen reader AC:** Page regions have correct ARIA landmarks (`main`, `nav`, `aside`). Interactive elements have accessible names.
- **Focus management AC:** After modal opens, focus moves to it. After modal closes, focus returns to trigger element.
- **WCAG contrast AC:** All text meets WCAG AA contrast (4.5:1 body text, 3:1 large text / UI components).

## Server/Client Component Notation

In the spec's Screen States and Architecture Notes sections, annotate components:

```
[SERVER] DashboardPage — fetches data at request time, no interactivity
[CLIENT] FilterPanel — requires useState for filter state
[SERVER ACTION] submitReport() — mutation, runs on server
```

## Wow Moment Decision Tree (Web Override)

Replace iOS-specific patterns with web equivalents:

- Time-to-first-value target: **<90 seconds** from landing to first meaningful output (web has no install gate but has signup friction).
- Registration wall rule: If the wow moment requires signup, the spec must include a **"Try without signing up"** path (demo mode, sample data, or OAuth one-click) as a P0 AC.
- First load performance AC: Core content visible within **2.5s LCP** on a median connection.

## Reference Research (Web Override)

When using Refero MCP, set `platform: "web"` (not `"ios"`) for all queries. If the app category has no web precedent in Refero, use `platform: "ios"` with a note that the patterns are being adapted.

## Self-Check (Web Additions)

In addition to base spec self-check, verify:
1. All ACs use web-idiomatic language (no "tap", no iOS component names)
2. At least one keyboard navigation AC per interactive feature
3. Server/Client Component boundaries annotated in Screen States
4. WCAG contrast AC present
5. Registration wall addressed — try-without-signup path defined if signup required for wow moment
6. LCP performance AC present for pages that are entry points
