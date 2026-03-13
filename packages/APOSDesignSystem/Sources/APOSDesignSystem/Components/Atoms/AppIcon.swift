import SwiftUI

/// Semantic colour for icon tinting, resolved from the active theme.
public enum AppIconColor: Sendable {
    case primary
    case secondary
    case accent
    case positive
    case emphasis
    case destructive

    /// Resolves the colour from the active theme.
    func color(from theme: any APOSTheme) -> Color {
        switch self {
        case .primary: theme.textPrimary
        case .secondary: theme.textSecondary
        case .accent: theme.accent
        case .positive: theme.positive
        case .emphasis: theme.emphasis
        case .destructive: theme.destructive
        }
    }
}

/// Icon size presets.
public enum AppIconSize: Sendable {
    case small
    case medium
    case large
    case xlarge

    var points: CGFloat {
        switch self {
        case .small: 16
        case .medium: 20
        case .large: 24
        case .xlarge: 32
        }
    }
}

/// SF Symbol wrapper with theme-aware tinting and standard sizes.
///
/// ```swift
/// AppIcon("checkmark.circle.fill", color: .positive, size: .medium)
/// ```
public struct AppIcon: View {
    @Environment(\.aposTheme) private var theme

    private let systemName: String
    private let color: AppIconColor
    private let size: AppIconSize

    /// Creates a themed SF Symbol icon.
    public init(_ systemName: String, color: AppIconColor = .primary, size: AppIconSize = .medium) {
        self.systemName = systemName
        self.color = color
        self.size = size
    }

    public var body: some View {
        Image(systemName: systemName)
            .symbolRenderingMode(.hierarchical)
            .font(.system(size: size.points))
            .foregroundStyle(color.color(from: theme))
            .frame(width: size.points, height: size.points)
    }
}

#Preview {
    HStack(spacing: Spacing.lg) {
        AppIcon("checkmark.circle.fill", color: .positive, size: .small)
        AppIcon("flame.fill", color: .emphasis, size: .medium)
        AppIcon("trash", color: .destructive, size: .large)
        AppIcon("star.fill", color: .accent, size: .xlarge)
    }
    .padding(Spacing.lg)
}
