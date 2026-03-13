import SwiftUI

/// Horizontal icon + text pair with theme-aware styling.
///
/// ```swift
/// IconLabel("clock", "2m 15s")
/// IconLabel("flame.fill", "12 punches", color: .emphasis)
/// ```
public struct IconLabel: View {
    @Environment(\.aposTheme) private var theme

    private let systemName: String
    private let text: String
    private let color: AppIconColor
    private let style: APOSTextStyle

    /// Creates a horizontal icon + text pair.
    public init(
        _ systemName: String,
        _ text: String,
        color: AppIconColor = .secondary,
        style: APOSTextStyle = .bodyMedium
    ) {
        self.systemName = systemName
        self.text = text
        self.color = color
        self.style = style
    }

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            AppIcon(systemName, color: color, size: .small)
            AppText(text, style: style, color: color.color(from: theme))
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.md) {
        IconLabel("clock", "2m 15s")
        IconLabel("flame.fill", "12 punches", color: .emphasis)
        IconLabel("checkmark.circle.fill", "Complete", color: .positive)
    }
    .padding(Spacing.lg)
}
