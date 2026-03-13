import SwiftUI

extension EnvironmentValues {
    /// The active APOS design system theme.
    ///
    /// Inject at the app root via `.environment(\.aposTheme, MyAppTheme())`.
    /// Components read this automatically via `@Environment(\.aposTheme)`.
    @Entry public var aposTheme: any APOSTheme = DefaultTheme()
}

/// Fallback theme using Apple's raw system colours.
///
/// Previews and tests work without any app-specific configuration.
/// Apps override this with their own `APOSTheme` conformance.
public struct DefaultTheme: APOSTheme {

    public init() {}

    // MARK: - Colours

    public var textPrimary: Color { .primary }
    public var textSecondary: Color { .secondary }
    public var textTertiary: Color { .gray }
    public var textOnAccent: Color { .white }

    #if os(iOS)
    public var backgroundPrimary: Color { Color(uiColor: .systemBackground) }
    public var backgroundSecondary: Color { Color(uiColor: .secondarySystemBackground) }
    public var backgroundTertiary: Color { Color(uiColor: .tertiarySystemBackground) }
    public var border: Color { Color(uiColor: .separator) }
    public var fieldBackground: Color { Color(uiColor: .secondarySystemBackground) }
    #else
    public var backgroundPrimary: Color { Color(nsColor: .windowBackgroundColor) }
    public var backgroundSecondary: Color { Color(nsColor: .controlBackgroundColor) }
    public var backgroundTertiary: Color { Color(nsColor: .underPageBackgroundColor) }
    public var border: Color { Color(nsColor: .separatorColor) }
    public var fieldBackground: Color { Color(nsColor: .controlBackgroundColor) }
    #endif

    public var accent: Color { .accentColor }
    public var accentSubtle: Color { Color.accentColor.opacity(0.12) }
    public var positive: Color { .green }
    public var emphasis: Color { .orange }
    public var destructive: Color { .red }

    // MARK: - Typography

    public var displayLarge: Font { .largeTitle.bold() }
    public var displayMedium: Font { .title.weight(.semibold) }
    public var displaySmall: Font { .title3.weight(.semibold) }
    public var headlineMedium: Font { .headline }
    public var bodyLarge: Font { .body }
    public var bodyMedium: Font { .callout }
    public var bodySmall: Font { .subheadline }
    public var labelLarge: Font { .body.weight(.semibold) }
    public var labelMedium: Font { .callout.weight(.medium) }
    public var caption: Font { .caption }
    public var captionEmphasis: Font { .caption.weight(.semibold) }
    public var footnote: Font { .footnote }

    // MARK: - Category Register

    public var categoryRegister: CategoryRegister { .neutralUtility }
}
