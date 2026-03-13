import SwiftUI

/// Card container with elevation, corner radius, and theme background.
///
/// ```swift
/// Card {
///     MetricCard(label: "Guard", value: "85")
/// }
///
/// Card(elevation: .elevated) {
///     // sheet-level content
/// }
/// ```
public struct Card<Content: View>: View {
    @Environment(\.aposTheme) private var theme

    private let elevation: Elevation
    private let content: Content

    /// Creates a card container.
    public init(
        elevation: Elevation = .card,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.content = content()
    }

    public var body: some View {
        content
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Radius.large))
            .shadow(
                color: .black.opacity(elevation.shadow.opacity),
                radius: elevation.shadow.radius,
                y: elevation.shadow.y
            )
    }

    private var backgroundColor: Color {
        switch elevation {
        case .base: theme.backgroundPrimary
        case .card, .content: theme.backgroundSecondary
        case .elevated, .modal: theme.backgroundTertiary
        }
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        Card {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                AppText("Card Title", style: .headlineMedium)
                AppText("Card body text goes here", style: .bodyMedium)
            }
        }
        Card(elevation: .elevated) {
            AppText("Elevated Card", style: .bodyLarge)
        }
    }
    .padding(Spacing.lg)
}
