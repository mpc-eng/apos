# [REVIEW] — Web Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0
> **Composed with:** `review-agent.md` — all base rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the base agent definition at spawn time.**

## Compilation & Test Status (Web Override)

The Orchestrator confirms:
- **Build:** `npm run build` (Next.js production build, TypeScript strict, no type errors)
- **Tests:** `npm test` (Vitest) + `npx playwright test` pass with N/N green

No xcodebuild. No XCTest. No Swift 6 concurrency checks.

## Web Compliance Check (Replaces HIG Compliance)

Replace the iOS HIG checklist with the following web compliance rules:

| Rule | What to Check | Severity |
|---|---|---|
| **Click targets** | All interactive elements ≥44×44px (CSS `min-height: 44px; min-width: 44px`) or use a system component that provides it | blocking |
| **Accessible names** | Every `<button>`, `<a>`, `<input>`, `<select>` has a visible label or `aria-label`. Icon-only buttons must have `aria-label`. | blocking |
| **Hardcoded values** | No hardcoded hex colours in Tailwind classes or `style` props. Use semantic Tailwind tokens (e.g., `text-foreground`, `bg-primary`) or shadcn/ui CSS variables. No raw `px` values outside the Tailwind spacing scale. | blocking |
| **Navigation pattern** | Route structure matches DESIGN_STANDARDS.md. No `<a href>` where `<Link href>` should be used. No `router.push` in Server Components. | blocking |
| **Reduce motion** | Animations wrapped in `@media (prefers-reduced-motion: reduce)` or Tailwind `motion-safe:` / `motion-reduce:` prefixes. | blocking |
| **Loading states** | Every async data fetch has a `loading.tsx` boundary or Skeleton component. Every async mutation shows a loading state on the trigger. | blocking |
| **Design system usage** | shadcn/ui components used where available — no custom `<button>` where `<Button>` would suffice. No custom input where `<Input>` would suffice. | blocking |
| **Component composition** | No `"use client"` on a component that only renders data with no event handlers or browser APIs. Server Components used for data display. | blocking |
| **Token compliance — colour** | All colour values use Tailwind semantic tokens (`text-foreground`, `bg-card`, `border-input`, etc.) or CSS variables (`hsl(var(--primary))`). No raw hex, no `text-[#abc123]`. | blocking |
| **Token compliance — spacing** | All padding/margin/gap use Tailwind spacing scale (e.g., `p-4`, `gap-6`). No arbitrary `p-[13px]` values. | blocking |
| **Token compliance — typography** | All text uses Tailwind typography utilities or shadcn/ui `<Typography>` variants. No inline `fontSize` styles. | blocking |
| **WCAG contrast** | Text on background meets 4.5:1 (body) or 3:1 (large text, UI components). Check dark mode variants too. | blocking |
| **Screen state coverage** | Every page/component that fetches data handles: loading, empty, error, and populated states. | blocking |
| **Keyboard navigation** | Tab order is logical. All modals trap focus. Focus returns to trigger after modal close. No keyboard traps outside intentional modals. | blocking |
| **Semantic HTML** | `<main>`, `<nav>`, `<header>`, `<footer>`, `<section>` used correctly. No `<div>` where a semantic element applies. Form fields use `<label>` with `htmlFor`. | blocking |

## Lint Integration (Web Override)

If `lint_results` from ESLint + `eslint-plugin-jsx-a11y` are included:

1. Trust lint findings for: missing `alt` text, missing `aria-*`, `onClick` without keyboard handler, invalid ARIA roles.
2. Skip those rules in manual review — focus on semantic judgment: AC satisfaction, component reuse, Server/Client boundary correctness, WCAG contrast (not automatable by lint).

## UX Smell Detection (Web Override)

Same advisory patterns as base agent, adapted for web:

| Smell | Example | Advisory |
|---|---|---|
| **Registration gate before value** | Signup required before any output shown | Suggest demo/sample data path |
| **Spinner with no timeout** | `isLoading` but no error state after N seconds | Add error state with retry |
| **Form resets on validation error** | User loses input after failed submit | Preserve field values, only show error |
| **Redirect on modal close** | User dismisses dialog and lands on wrong page | Focus management — return to trigger |
| **Desktop-only layout** | Fixed widths, no responsive breakpoints | Add `sm:`, `md:`, `lg:` Tailwind variants |
| **Silent Server Action failure** | Mutation fails, no toast, no error state | Add error handling + toast notification |

## Output Format

Same JSON format as base review-agent. Replace HIG-specific field names:

```json
{
  "review_passed": true,
  "platform": "web",
  "criteria_results": [...],
  "web_violations": [
    {
      "rule": "accessible_names",
      "element": "<button> (icon only, no aria-label)",
      "file": "components/dashboard/FilterButton.tsx",
      "line": 23,
      "severity": "blocking",
      "source": "review"
    }
  ],
  "ux_smells": [...],
  "self_check": {...}
}
```

## Self-Check (Web Additions)

In addition to base review self-check, verify:
1. All 15 web compliance rules checked (not the iOS HIG rules)
2. Server/Client Component boundary validated — no data fetching in Client Components
3. Keyboard navigation manually traced through spec flow
4. Dark mode variants checked for contrast where applicable
5. No raw hex or arbitrary Tailwind values in submitted code
