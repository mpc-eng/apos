import SwiftUI

/// Semantic text style mapping to APOSTheme typography tokens.
public enum APOSTextStyle: Sendable {
    case displayLarge
    case displayMedium
    case displaySmall
    case headlineMedium
    case bodyLarge
    case bodyMedium
    case bodySmall
    case labelLarge
    case labelMedium
    case caption
    case captionEmphasis
    case footnote

    /// Resolves the font from the active theme.
    func font(from theme: any APOSTheme) -> Font {
        switch self {
        case .displayLarge: theme.displayLarge
        case .displayMedium: theme.displayMedium
        case .displaySmall: theme.displaySmall
        case .headlineMedium: theme.headlineMedium
        case .bodyLarge: theme.bodyLarge
        case .bodyMedium: theme.bodyMedium
        case .bodySmall: theme.bodySmall
        case .labelLarge: theme.labelLarge
        case .labelMedium: theme.labelMedium
        case .caption: theme.caption
        case .captionEmphasis: theme.captionEmphasis
        case .footnote: theme.footnote
        }
    }
}

/// Themed text component that resolves font from the active APOSTheme.
///
/// ```swift
/// AppText("Round Score", style: .headlineMedium)
/// AppText("85", style: .displayLarge, color: theme.positive)
/// ```
public struct AppText: View {
    @Environment(\.aposTheme) private var theme

    private let text: LocalizedStringKey
    private let style: APOSTextStyle
    private let color: Color?

    /// Creates themed text with a `LocalizedStringKey`.
    public init(_ text: LocalizedStringKey, style: APOSTextStyle, color: Color? = nil) {
        self.text = text
        self.style = style
        self.color = color
    }

    /// Creates themed text with a plain `String`.
    public init(_ text: String, style: APOSTextStyle, color: Color? = nil) {
        self.text = LocalizedStringKey(text)
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(style.font(from: theme))
            .foregroundStyle(color ?? theme.textPrimary)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.sm) {
        AppText("Display Large", style: .displayLarge)
        AppText("Display Medium", style: .displayMedium)
        AppText("Headline", style: .headlineMedium)
        AppText("Body Large", style: .bodyLarge)
        AppText("Body Medium", style: .bodyMedium)
        AppText("Caption", style: .caption)
    }
    .padding(Spacing.lg)
}
