import SwiftUI

/// Themed toggle with label and optional description.
///
/// ```swift
/// AppToggle("Enable notifications", isOn: $notificationsEnabled)
/// AppToggle("Dark mode", isOn: $darkMode, description: "Uses system appearance when off")
/// ```
public struct AppToggle: View {
    @Environment(\.aposTheme) private var theme

    private let label: LocalizedStringKey
    @Binding private var isOn: Bool
    private let description: LocalizedStringKey?

    /// Creates a themed toggle.
    public init(_ label: LocalizedStringKey, isOn: Binding<Bool>, description: LocalizedStringKey? = nil) {
        self.label = label
        self._isOn = isOn
        self.description = description
    }

    /// Creates a themed toggle with plain strings.
    public init(_ label: String, isOn: Binding<Bool>, description: String? = nil) {
        self.label = LocalizedStringKey(label)
        self._isOn = isOn
        self.description = description.map { LocalizedStringKey($0) }
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(label)
                    .font(theme.bodyLarge)
                    .foregroundStyle(theme.textPrimary)
                if let description {
                    Text(description)
                        .font(theme.caption)
                        .foregroundStyle(theme.textSecondary)
                }
            }
        }
        .tint(theme.accent)
        .frame(minHeight: Spacing.touch)
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        AppToggle("Notifications", isOn: .constant(true))
        AppToggle("Dark mode", isOn: .constant(false), description: "Uses system appearance when off")
    }
    .padding(Spacing.lg)
}
