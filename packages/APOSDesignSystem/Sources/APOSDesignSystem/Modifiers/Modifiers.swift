import SwiftUI

// MARK: - Card Style Modifier

/// Applies card-level visual treatment (background, radius, shadow) without the Card container.
///
/// Use when you need card styling on an existing view without wrapping in `Card`.
/// ```swift
/// MyCustomView().cardStyle()
/// ```
public struct CardStyleModifier: ViewModifier {
    @Environment(\.aposTheme) private var theme
    let elevation: Elevation

    public func body(content: Content) -> some View {
        content
            .background(theme.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.large))
            .shadow(
                color: .black.opacity(elevation.shadow.opacity),
                radius: elevation.shadow.radius,
                y: elevation.shadow.y
            )
    }
}

extension View {
    /// Applies card visual treatment (background, radius, shadow).
    public func cardStyle(elevation: Elevation = .card) -> some View {
        modifier(CardStyleModifier(elevation: elevation))
    }
}

// MARK: - Touch Target Modifier

/// Ensures a view meets the 44x44pt minimum touch target.
///
/// ```swift
/// smallIcon.ensureTouchTarget()
/// ```
public struct TouchTargetModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(
                minWidth: AccessibilityConstants.minimumTouchTarget,
                minHeight: AccessibilityConstants.minimumTouchTarget
            )
            .contentShape(Rectangle())
    }
}

extension View {
    /// Ensures the view meets the 44x44pt minimum touch target size.
    public func ensureTouchTarget() -> some View {
        modifier(TouchTargetModifier())
    }
}

// MARK: - Button Styles

/// ButtonStyle for primary actions — filled accent background.
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.aposTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.labelLarge)
            .foregroundStyle(theme.textOnAccent)
            .frame(minHeight: Spacing.touch)
            .padding(.horizontal, Spacing.lg)
            .background(theme.accent)
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

/// ButtonStyle for secondary actions — bordered with accent colour.
public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.aposTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.labelLarge)
            .foregroundStyle(theme.accent)
            .frame(minHeight: Spacing.touch)
            .padding(.horizontal, Spacing.lg)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.medium)
                    .strokeBorder(theme.accent, lineWidth: 1.5)
            }
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

/// ButtonStyle for destructive actions — filled destructive background.
public struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.aposTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.labelLarge)
            .foregroundStyle(theme.textOnAccent)
            .frame(minHeight: Spacing.touch)
            .padding(.horizontal, Spacing.lg)
            .background(theme.destructive)
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Glassmorphism Card Style Modifier

/// Applies frosted glass card treatment — translucent background with backdrop blur.
///
/// Use for premium dashboard cards where depth without clutter is needed.
/// ```swift
/// MyScoreCard().glassCardStyle()
/// ```
public struct GlassCardStyleModifier: ViewModifier {
    @Environment(\.aposTheme) private var theme
    let cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(theme.backgroundSecondary.opacity(0.3))
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(theme.border.opacity(0.3), lineWidth: 0.5)
            )
    }
}

extension View {
    /// Applies frosted glass card treatment (translucent + backdrop blur).
    public func glassCardStyle(cornerRadius: CGFloat = Radius.large) -> some View {
        modifier(GlassCardStyleModifier(cornerRadius: cornerRadius))
    }
}

// Note: ReduceMotionModifier is already implemented in Foundation/Accessibility/
