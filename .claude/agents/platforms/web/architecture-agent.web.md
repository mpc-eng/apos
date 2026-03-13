# [ARCHITECTURE] — Web Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0
> **Composed with:** `architecture-agent.md` — all base rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the base agent definition at spawn time.**

## Stack

- **Framework:** Next.js 15+ with App Router. Server Components by default — Client Components only where interactivity requires it.
- **Language:** TypeScript strict mode. No `any`. Explicit return types on all exported functions.
- **Styling:** Tailwind CSS v3+ with shadcn/ui component library. No inline `style` props.
- **Database:** PostgreSQL via Prisma (complex models) or Drizzle ORM. No raw SQL except in migrations.
- **Auth:** NextAuth.js v5 (Auth.js) or Clerk.
- **Payments:** Stripe (not StoreKit).
- **Analytics:** Plausible or Mixpanel.
- **State:** Zustand for global client state. React Hook Form + Zod for forms. No Redux.
- **Deployment:** Vercel. Environment variables in `.env.local` (never committed).

## ARCHITECTURE.md Structure (Web Override)

Replace the iOS-specific sections with these web equivalents:

```markdown
# Architecture: <App Name>

## 1. Overview
<High-level architecture: Next.js App Router, PostgreSQL, Vercel>
<Server/Client Component boundary decisions>

## 2. Data Model
<Prisma schema entities with relationships>
<Zod validation schemas for API boundaries>

## 3. Service Layer
<Server Actions for mutations>
<API Route Handlers for external webhooks (Stripe, GitHub)>
<Data access layer (DAL) — server-only functions wrapping Prisma>

## 4. Persistence Strategy
- PostgreSQL via Prisma: <what goes here and why>
- Vercel KV (Redis): <for session caching, rate limiting — if applicable>
- Vercel Blob: <for file storage — if applicable>

## 5. Navigation Architecture
<App Router layout hierarchy (layout.tsx nesting)>
<Route groups and parallel routes>
<Loading and error boundaries per route segment>

## 6. Authentication & Authorisation
<Session strategy (JWT vs database sessions)>
<Middleware for route protection>
<Role/permission model if applicable>

## 7. External Integrations
<API clients (GitHub, Stripe, etc.)>
<Webhook handler routes>
<Rate limiting strategy>

## 8. Caching Strategy
<Next.js cache() calls on data fetches>
<revalidatePath / revalidateTag usage>
<Static vs dynamic rendering decisions>

## 9. Network Layer
<Fetch wrappers, retry logic, error handling>
<Edge vs Node.js runtime decisions>

## 10. Error Handling
<Error boundary components>
<Server Action error types>
<User-facing error presentation patterns>
```

## Technical Constraints (Web)

- Next.js App Router only — no Pages Router patterns.
- Server Components are the default — `"use client"` directive only when required (event handlers, browser APIs, hooks).
- All database access via Prisma DAL (server-only) — never query the database in Client Components.
- Environment variables prefixed `NEXT_PUBLIC_` only for values safe to expose to the browser.
- No `any` in TypeScript. Strict null checks on.
- shadcn/ui components only — no custom component library alongside it.
- Approved dependencies: shadcn/ui, Prisma/Drizzle, NextAuth/Clerk, Stripe, Plausible/Mixpanel, Zustand, RHF + Zod. No others without explicit approval.

## Self-Check (Web Override)

Before completing, verify:
1. Data model uses Prisma schema with proper relations and indexes
2. Server/Client Component boundary is clearly defined — no "use client" on data-fetching components
3. All mutations use Server Actions (not client-side fetch to API routes)
4. Authentication middleware protects all authenticated routes
5. Caching strategy documented per route segment
6. No TypeScript `any` types in the architecture
7. External webhook routes documented with security (signature verification)
