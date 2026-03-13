import SwiftUI

/// List row with icon, label, optional trailing content, and disclosure indicator.
///
/// ```swift
/// ActionRow(icon: "figure.boxing", title: "Round 3", subtitle: "2m 15s") {
///     navigateToDetail()
/// }
/// ActionRow(icon: "gear", title: "Notifications") {
///     AppToggle("", isOn: $enabled)
/// }
/// ```
public struct ActionRow<Trailing: View>: View {
    @Environment(\.aposTheme) private var theme

    private let icon: String?
    private let title: String
    private let subtitle: String?
    private let action: (() -> Void)?
    private let trailing: Trailing

    /// Creates an action row with trailing content.
    public init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = nil
        self.trailing = trailing()
    }

    public var body: some View {
        let content = HStack(spacing: Spacing.md) {
            if let icon {
                AppIcon(icon, color: .accent, size: .medium)
            }
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                AppText(title, style: .bodyLarge)
                if let subtitle {
                    AppText(subtitle, style: .bodySmall, color: theme.textSecondary)
                }
            }
            Spacer()
            trailing
            if action != nil {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.textTertiary)
            }
        }
        .frame(minHeight: Spacing.touch)
        .contentShape(Rectangle())

        if let action {
            Button(action: action) {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
}

extension ActionRow where Trailing == EmptyView {
    /// Creates an action row with a tap action and disclosure chevron.
    public init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.trailing = EmptyView()
    }

    /// Creates a static action row with no trailing content or action.
    public init(
        icon: String? = nil,
        title: String,
        subtitle: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = nil
        self.trailing = EmptyView()
    }
}

#Preview {
    VStack(spacing: 0) {
        ActionRow(icon: "figure.boxing", title: "Round 3", subtitle: "2m 15s", action: {
            // navigate
        })
        AppDivider()
        ActionRow(icon: "gear", title: "Notifications") {
            Toggle("", isOn: .constant(true)).tint(.accentColor)
        }
        AppDivider()
        ActionRow(icon: "clock", title: "Session History", subtitle: "12 sessions", action: {
            // navigate
        })
    }
    .padding(.horizontal, Spacing.lg)
}
