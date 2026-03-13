import SwiftUI

/// Empty state with heading, message, and call-to-action button.
///
/// ```swift
/// EmptyAction(
///     icon: "figure.boxing",
///     title: "No sessions yet",
///     message: "Record your first round to see your technique score.",
///     actionLabel: "Start Training"
/// ) { startRecording() }
/// ```
public struct EmptyAction: View {
    @Environment(\.aposTheme) private var theme

    private let icon: String
    private let title: String
    private let message: String
    private let actionLabel: String
    private let action: () -> Void

    /// Creates an empty state view with a CTA.
    public init(
        icon: String,
        title: String,
        message: String,
        actionLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
                    .font(theme.headlineMedium)
                    .foregroundStyle(theme.textPrimary)
            } icon: {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(theme.textSecondary)
            }
        } description: {
            Text(message)
                .font(theme.bodyMedium)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
        } actions: {
            AppButton(actionLabel, variant: .primary, action: action)
        }
    }
}

#Preview {
    EmptyAction(
        icon: "figure.boxing",
        title: "No sessions yet",
        message: "Record your first round to see your technique score.",
        actionLabel: "Start Training"
    ) {}
}
