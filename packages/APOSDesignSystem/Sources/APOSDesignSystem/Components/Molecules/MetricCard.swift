import SwiftUI

/// Trend direction for metric display.
public enum MetricTrend: Sendable {
    case up
    case down
    case flat

    var systemName: String {
        switch self {
        case .up: "arrow.up.right"
        case .down: "arrow.down.right"
        case .flat: "arrow.right"
        }
    }
}

/// Semantic colour for metric values, resolved from theme.
public enum SemanticColor: Sendable {
    case positive
    case emphasis
    case destructive
    case accent
    case primary

    func color(from theme: any APOSTheme) -> Color {
        switch self {
        case .positive: theme.positive
        case .emphasis: theme.emphasis
        case .destructive: theme.destructive
        case .accent: theme.accent
        case .primary: theme.textPrimary
        }
    }
}

/// Value display with label and optional trend indicator.
///
/// ```swift
/// MetricCard(label: "Guard", value: "85", trend: .up, tint: .positive)
/// MetricCard(label: "Sessions", value: "12")
/// ```
public struct MetricCard: View {
    @Environment(\.aposTheme) private var theme

    private let label: String
    private let value: String
    private let trend: MetricTrend?
    private let tint: SemanticColor?

    /// Creates a metric display card.
    public init(
        label: String,
        value: String,
        trend: MetricTrend? = nil,
        tint: SemanticColor? = nil
    ) {
        self.label = label
        self.value = value
        self.trend = trend
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            AppText(label, style: .caption, color: theme.textSecondary)
            HStack(spacing: Spacing.xs) {
                AppText(value, style: .displaySmall, color: valueColor)
                if let trend {
                    Image(systemName: trend.systemName)
                        .font(theme.caption)
                        .foregroundStyle(trendColor(for: trend))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(theme.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Radius.large))
    }

    private var valueColor: Color {
        tint?.color(from: theme) ?? theme.textPrimary
    }

    private func trendColor(for trend: MetricTrend) -> Color {
        switch trend {
        case .up: theme.positive
        case .down: theme.destructive
        case .flat: theme.textSecondary
        }
    }
}

#Preview {
    LazyVGrid(columns: [.init(), .init()], spacing: Spacing.sm) {
        MetricCard(label: "Guard", value: "85", trend: .up, tint: .positive)
        MetricCard(label: "Stance", value: "62", trend: .down, tint: .emphasis)
        MetricCard(label: "Sessions", value: "12")
        MetricCard(label: "Streak", value: "3 days", trend: .flat)
    }
    .padding(Spacing.lg)
}
