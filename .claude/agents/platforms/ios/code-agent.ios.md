# [CODE] — iOS Platform Overlay

> **Platform:** iOS
> **Schema version:** 3.4.0 (inherited from core)
> **Composed with:** `core/code-agent.core.md` — all core rules apply unless explicitly overridden below.
> **The Orchestrator merges this overlay into the core agent definition at spawn time.**

## Language & Framework

- **Language:** Swift 6 with strict concurrency. No exceptions.
- **UI Framework:** SwiftUI only. No UIKit except where Apple requires it (e.g., `UIViewRepresentable`).
- **Architecture:** MVVM with `@Observable` macro. No `ObservableObject`.
- **Persistence:** SwiftData for complex models. UserDefaults only for simple flags and preferences.
- **Shared data:** App Groups for data shared between main app, widget extension, and Live Activities.
- **Minimum target:** iOS 17.4 (required for StoreKit 2.4 win-back offers).
- **Documentation:** DocC comments on all public functions.

## Approved Dependencies

- RevenueCat SDK (payments)
- Mixpanel SDK (analytics)
- No other third-party dependencies.

## Design System

- **Package:** `APOSDesignSystem` (local Swift Package). Import in every view file.
- **Theme:** `@Environment(\.aposTheme)` for all colour, typography, and token access.
- **Components:**
  - Buttons: `AppButton` (primary/secondary/destructive/ghost). No custom button styles.
  - List rows: `ActionRow` unless the layout is genuinely unique.
  - Cards: `Card` organism (elevation-aware).
  - Text: `AppText` or theme font tokens directly.
  - Text fields: `AppTextField` with `FieldValidation`.
  - Data loading: `LoadableView<T>` handles all four `LoadableState` cases.
- **Tokens:**
  - Spacing: `Spacing` enum (IBM Carbon 4pt grid).
  - Radii: `Radius` enum.
  - Colours: semantic tokens from theme only — no raw hex, no `Color.red`.
  - Typography: theme font tokens — no raw `.font(.system(...))`.
- **Icons:** SF Symbols for all iconography. Semantic `Color` assets.

## Accessibility (iOS-Specific)

- `.accessibilityLabel()` on all interactive elements.
- Dynamic Type support from `xSmall` to `AX5`.
- `.accessibilityAction()` for custom gestures.
- 44x44pt minimum touch targets (use `.ensureTouchTarget()` modifier).
- Reduce motion: wrap animations in `withAnimation(.motionSafe)` or `ReduceMotionModifier`.

## Safe Area Rules

When a view needs full-bleed media (camera preview, maps, images), apply `.ignoresSafeArea()` only to the background/media layer. Never apply `.ignoresSafeArea()` to a parent container that also holds interactive controls. Interactive controls must respect safe areas so they remain accessible above the tab bar, navigation bar, and home indicator.

## Common Swift 6 Build Errors

When in Build Error Fix Mode, watch for:
- **Sendability violations:** Ensure types crossing actor boundaries are `Sendable`.
- **Global actor isolation:** `@MainActor` on view models, proper `nonisolated` usage.
- **Concurrency warnings promoted to errors** in strict mode.
- **Missing `async`** on functions that call async code.

## Output Location

Write Swift files to the app's source directory following the established folder structure (typically `Views/`, `ViewModels/`, `Models/`, `Services/`).

## iOS Self-Check (Additive)

In addition to the core self-check:
- [ ] Swift 6 strict concurrency compiles cleanly
- [ ] No third-party dependencies beyond RevenueCat and Mixpanel
- [ ] All views import `APOSDesignSystem`
- [ ] SF Symbols used for all icons
- [ ] Dynamic Type supported (`xSmall` to `AX5`)
- [ ] 44x44pt touch targets on all interactive elements
