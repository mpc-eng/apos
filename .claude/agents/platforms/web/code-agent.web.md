# [CODE] — Web/SaaS Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0 (inherited from core)
> **Composed with:** `core/code-agent.core.md` — all core rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the core agent definition at spawn time.**

## Language & Framework

- **Language:** TypeScript (strict mode). No `any` types except at external API boundaries.
- **UI Framework:** React 19+ with Server Components where appropriate.
- **Meta-framework:** Next.js 15+ (App Router). Pages Router only if migrating legacy code.
- **Styling:** Tailwind CSS 4+. No inline styles. No CSS modules unless integrating a third-party component.
- **Architecture:** Server Components by default. Client Components (`"use client"`) only when state, effects, or browser APIs are needed.
- **Persistence:** PostgreSQL via Prisma or Drizzle ORM. No raw SQL in application code.
- **Auth:** NextAuth.js or Clerk. No custom auth implementations.
- **Minimum target:** Modern evergreen browsers (Chrome, Firefox, Safari, Edge — last 2 versions).
- **Documentation:** JSDoc or TSDoc comments on all exported functions and types.

## Approved Dependencies

- **UI components:** shadcn/ui (Radix primitives + Tailwind). Install components as needed — they are copied into `components/ui/`, not a package dependency.
- **Icons:** Lucide React (`lucide-react`).
- **Payments:** Stripe SDK (`@stripe/stripe-js`, `stripe` server-side).
- **Analytics:** Plausible (script tag) or Mixpanel SDK.
- **Forms:** React Hook Form + Zod for validation.
- **State:** Zustand for client-side global state (only when React state/context is insufficient).
- **Data fetching:** Server Components + `fetch` for server-side. TanStack Query for client-side caching only when needed.
- Avoid adding dependencies beyond this list. If a dependency is needed, justify it in a code comment.

## Design System

- **Component library:** shadcn/ui components in `components/ui/`. These are the atoms.
- **App components:** Composed components in `components/` (not in `ui/`).
- **Theme:** CSS custom properties in `globals.css` or `tailwind.config.ts`. All colours reference CSS variables — no raw hex in component code.
- **Tokens:**
  - Spacing: Tailwind spacing scale (`p-4`, `gap-6`, etc.). Use consistent increments.
  - Radii: Tailwind `rounded-*` classes mapped to design tokens.
  - Colours: `text-foreground`, `bg-background`, `bg-primary`, etc. — semantic tokens only.
  - Typography: Tailwind `text-*` classes. Define custom font sizes in `tailwind.config.ts` if needed.
- **Dark mode:** Support via `class` strategy (`dark:` prefix). All colour tokens must have dark mode variants.

## Accessibility (Web-Specific)

- Semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<article>`, etc.) — no `<div>` with `onClick`.
- `aria-label` on all interactive elements that lack visible text.
- `aria-describedby` for form field error messages.
- Keyboard navigation: all interactive elements focusable and operable via keyboard.
- Focus indicators: visible `:focus-visible` styles. Never `outline: none` without a replacement.
- Skip links for main content.
- `role` attributes only when semantic HTML is insufficient.
- Reduced motion: `prefers-reduced-motion` media query. Wrap animations in `motion-safe:`.
- Minimum 44x44px click/tap targets on touch devices.

## Responsive Design

- Mobile-first: base styles are mobile, scale up with `sm:`, `md:`, `lg:`, `xl:`.
- Fluid typography where appropriate (`clamp()` or Tailwind `text-*` with responsive modifiers).
- No horizontal scrolling on any viewport width.
- Test at 320px (smallest supported), 768px (tablet), 1024px (desktop), 1440px (large desktop).

## Common Build Errors

When in Build Error Fix Mode, watch for:
- **Type errors:** TypeScript strict mode catches nullable access, missing properties, and type mismatches.
- **Server/client boundary:** `"use client"` missing on components that use hooks, or server-only code leaking into client bundles.
- **Import errors:** Named vs default exports, missing barrel files.
- **Hydration mismatches:** Server-rendered HTML differs from client — usually caused by browser-only APIs (`window`, `localStorage`) used during SSR.
- **Environment variables:** `NEXT_PUBLIC_*` prefix required for client-side env vars. Server-only vars must not be referenced in client components.

## Output Location

Write files following Next.js App Router conventions:
- Routes: `app/` directory (page.tsx, layout.tsx, loading.tsx, error.tsx)
- Server actions: `app/` or `lib/actions/`
- Components: `components/` (app-level), `components/ui/` (shadcn primitives)
- Database: `lib/db/` (schema, queries, migrations)
- Types: `types/` or co-located with features
- Utilities: `lib/` or `utils/`
- API routes: `app/api/` (only when webhooks or external integrations require it — prefer Server Actions)

## Web Self-Check (Additive)

In addition to the core self-check:
- [ ] TypeScript strict mode compiles cleanly (`tsc --noEmit`)
- [ ] No `any` types except at external API boundaries
- [ ] All interactive elements use semantic HTML (`<button>`, `<a>`, `<input>`, etc.)
- [ ] Keyboard navigation works for all interactive flows
- [ ] Dark mode supported (all colour tokens have `dark:` variants)
- [ ] Responsive at 320px, 768px, 1024px, 1440px
- [ ] No raw hex colours — all via CSS custom properties / Tailwind tokens
- [ ] Server Components used by default; `"use client"` only where necessary
- [ ] `prefers-reduced-motion` respected on all animations
