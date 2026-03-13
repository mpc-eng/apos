import SwiftUI

/// The theme protocol that every APOS app must implement.
///
/// Each app provides a concrete conformance with its brand colours, while
/// the component library reads these tokens via `@Environment(\.aposTheme)`.
/// Typography tokens map to Apple's semantic text styles — no hardcoded sizes.
public protocol APOSTheme: Sendable {

    // MARK: - Colour Tokens (semantic)

    /// Primary content (labels, headings)
    var textPrimary: Color { get }
    /// Secondary content (captions, metadata)
    var textSecondary: Color { get }
    /// Placeholder, disabled (large text only)
    var textTertiary: Color { get }
    /// Text on accent-coloured backgrounds
    var textOnAccent: Color { get }

    /// Main surface
    var backgroundPrimary: Color { get }
    /// Cards, grouped sections
    var backgroundSecondary: Color { get }
    /// Elevated surfaces (sheets)
    var backgroundTertiary: Color { get }

    /// Interactive elements (buttons, links)
    var accent: Color { get }
    /// Accent backgrounds (selected states)
    var accentSubtle: Color { get }
    /// Success states (used sparingly)
    var positive: Color { get }
    /// Attention without alarm (amber)
    var emphasis: Color { get }
    /// Delete actions ONLY
    var destructive: Color { get }

    /// Dividers, card borders
    var border: Color { get }
    /// Text field backgrounds
    var fieldBackground: Color { get }

    // MARK: - Typography Tokens

    /// → .largeTitle, bold
    var displayLarge: Font { get }
    /// → .title, semibold
    var displayMedium: Font { get }
    /// → .title3, semibold
    var displaySmall: Font { get }
    /// → .headline, semibold
    var headlineMedium: Font { get }
    /// → .body, regular
    var bodyLarge: Font { get }
    /// → .callout, regular
    var bodyMedium: Font { get }
    /// → .subheadline, regular
    var bodySmall: Font { get }
    /// → .body, semibold (buttons)
    var labelLarge: Font { get }
    /// → .callout, medium (secondary buttons)
    var labelMedium: Font { get }
    /// → .caption, regular
    var caption: Font { get }
    /// → .caption, semibold
    var captionEmphasis: Font { get }
    /// → .footnote, regular
    var footnote: Font { get }

    // MARK: - Category Register

    /// The emotional register of the app's category.
    var categoryRegister: CategoryRegister { get }
}

/// The emotional register that governs tone, copy, and interaction feedback.
public enum CategoryRegister: String, Sendable {
    /// Joy, delight — warm, encouraging copy
    case positiveAffect
    /// Health, finance — precise, reassuring copy
    case highAnxiety
    /// Productivity — clear, functional copy
    case neutralUtility
}
