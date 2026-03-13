import SwiftUI

/// Section title with optional trailing action.
///
/// ```swift
/// SectionHeader("Recent Sessions")
/// SectionHeader("Drills", actionLabel: "See All") { showAll() }
/// ```
public struct SectionHeader: View {
    @Environment(\.aposTheme) private var theme

    private let title: String
    private let actionLabel: String?
    private let action: (() -> Void)?

    /// Creates a section header.
    public init(_ title: String) {
        self.title = title
        self.actionLabel = nil
        self.action = nil
    }

    /// Creates a section header with a trailing action.
    public init(_ title: String, actionLabel: String, action: @escaping () -> Void) {
        self.title = title
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        HStack {
            AppText(title, style: .headlineMedium)
            Spacer()
            if let actionLabel, let action {
                Button(action: action) {
                    Text(actionLabel)
                        .font(theme.labelMedium)
                        .foregroundStyle(theme.accent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, Spacing.xs)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.lg) {
        SectionHeader("Recent Sessions")
        SectionHeader("Technique Drills", actionLabel: "See All") {}
    }
    .padding(Spacing.lg)
}
