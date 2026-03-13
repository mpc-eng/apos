# [TEST] — Web Platform Overlay

> **Platform:** Web
> **Schema version:** 3.4.0
> **Composed with:** `test-agent.md` — all base rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the base agent definition at spawn time.**

## Test Stack (Web)

| Layer | Tool | When to Use |
|---|---|---|
| Unit / integration | Vitest + React Testing Library | Component logic, Server Actions, utility functions, data transformations |
| E2E / user flows | Playwright | Critical user journeys, auth flows, payment flows, multi-step forms |
| Accessibility | axe-core via `@axe-core/playwright` or `vitest-axe` | Automated WCAG AA checks on each route |
| API routes | Vitest with `fetch` mock or `msw` | Route handler logic, webhook validation |

No XCTest. No XCTestExpectation. No Swift.

## Test Naming Convention (Web Override)

```
testAC001_descriptiveName  →  same convention, different implementation
```

```typescript
// Vitest unit test
describe('FeatureName', () => {
  it('testAC001_submitShowsLoadingState', async () => {
    // Arrange
    render(<FeatureForm />)

    // Act
    await userEvent.click(screen.getByRole('button', { name: /submit/i }))

    // Assert
    expect(screen.getByRole('progressbar')).toBeInTheDocument()
  })
})
```

```typescript
// Playwright E2E test
test('testAC005_reportGeneratesAfterConnect', async ({ page }) => {
  await page.goto('/dashboard')
  await page.getByRole('button', { name: 'Connect GitHub' }).click()
  await expect(page.getByTestId('signal-report')).toBeVisible({ timeout: 10_000 })
})
```

## AC-to-Test Mapping Rules (Web)

1. **Unit test first.** Default to Vitest + RTL. Only reach for Playwright when the AC describes a multi-page flow, real browser behaviour (clipboard, file upload, OAuth redirect), or time-sensitive interaction.
2. **One test per AC.** Same rule as iOS — testAC001 maps to AC-001.
3. **Prefer `getByRole` over `getByTestId`.** Accessible queries validate accessibility while testing behaviour. Use `getByTestId` only when no semantic role exists.
4. **Async handling.** Use `await userEvent.*` for RTL (never `fireEvent`). Use `await expect(locator).toBeVisible()` for Playwright.
5. **Server Actions.** Test Server Actions by importing and calling them directly in Vitest. Mock the Prisma client with `vi.mock('@/lib/db')`.
6. **API route handlers.** Test with `new Request(...)` + the handler function directly — no running server needed.

## UX Test Checklist (Web Override)

Same five categories as base agent, adapted for web:

| Category | Web-Specific Observations |
|---|---|
| **Discoverability** | Can the user find the feature without a tooltip? Does the nav label communicate what's inside? |
| **Learnability** | Does the empty state explain the feature, not just its absence? Is the first action obvious? |
| **Error recovery** | Do form validation errors name the field and explain the fix? Does a failed Server Action show a toast? |
| **Emotional response** | Does the first generated output feel credible and worth returning for? |
| **Accessibility** | Tab through the feature without a mouse — is every action reachable? Test with VoiceOver/NVDA. |

## Accessibility Test (Required per Spec)

Every test file must include at least one axe accessibility scan for each primary route the spec introduces:

```typescript
import { checkA11y } from 'axe-playwright' // or vitest-axe equivalent

test('testAC_axe_dashboardPage_noViolations', async ({ page }) => {
  await page.goto('/dashboard')
  await checkA11y(page, undefined, {
    detailedReport: true,
    detailedReportOptions: { html: true }
  })
})
```

## Test Failure Fix Mode (Web Override)

When spawned with test failure output:

1. **Vitest failures:** Read the assertion diff. If RTL query fails, check if the DOM changed (component renamed, role changed) — fix the query, not the component.
2. **Playwright failures:** Check selector stability. Prefer role-based selectors. If timeout, increase `{ timeout: 15_000 }` before diagnosing flakiness.
3. **axe failures:** Read the violation rule (e.g., `color-contrast`, `button-name`, `landmark-one-main`). Fix the component, not the test — axe violations are real accessibility bugs.
4. **Never mock Prisma in a way that returns data inconsistent with the Prisma schema** — type mismatches will cause false positives.

## Self-Check (Web Additions)

In addition to base test self-check, verify:
1. No XCTest, Swift, or iOS-specific imports
2. Every AC has either a Vitest or Playwright test (correct tool chosen per AC type)
3. At least one axe accessibility scan per new route
4. Server Actions tested via direct import, not via UI click chain
5. `getByRole` used as first choice for all interactive element queries
