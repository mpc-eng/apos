import SwiftUI

/// Visual variant for AppButton.
public enum ButtonVariant: Sendable {
    /// Filled background with accent colour
    case primary
    /// Bordered with accent colour
    case secondary
    /// Filled background with destructive colour
    case destructive
    /// Text-only with accent colour
    case ghost
}

/// Width behaviour for AppButton.
public enum ButtonWidth: Sendable {
    /// Expands to fill available width
    case full
    /// Hugs content with horizontal padding
    case hug
}

/// Themed button with four visual variants and enforced 44pt touch target.
///
/// ```swift
/// AppButton("Start Training", variant: .primary) { startSession() }
/// AppButton("Delete", variant: .destructive, icon: "trash") { confirmDelete() }
/// AppButton("Cancel", variant: .ghost) { dismiss() }
/// ```
public struct AppButton: View {
    @Environment(\.aposTheme) private var theme

    private let label: LocalizedStringKey
    private let variant: ButtonVariant
    private let icon: String?
    private let width: ButtonWidth
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: () -> Void

    /// Creates a themed button.
    public init(
        _ label: LocalizedStringKey,
        variant: ButtonVariant = .primary,
        icon: String? = nil,
        width: ButtonWidth = .hug,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.variant = variant
        self.icon = icon
        self.width = width
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    /// Creates a themed button with a plain string label.
    public init(
        _ label: String,
        variant: ButtonVariant = .primary,
        icon: String? = nil,
        width: ButtonWidth = .hug,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = LocalizedStringKey(label)
        self.variant = variant
        self.icon = icon
        self.width = width
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                } else {
                    if let icon {
                        Image(systemName: icon)
                    }
                    Text(label)
                }
            }
            .font(theme.labelLarge)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: width == .full ? .infinity : nil)
            .frame(minHeight: Spacing.touch)
            .padding(.horizontal, Spacing.lg)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .overlay {
                if variant == .secondary {
                    RoundedRectangle(cornerRadius: Radius.medium)
                        .strokeBorder(theme.accent, lineWidth: 1.5)
                }
            }
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: theme.textOnAccent
        case .secondary: theme.accent
        case .destructive: theme.textOnAccent
        case .ghost: theme.accent
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary: theme.accent
        case .secondary: .clear
        case .destructive: theme.destructive
        case .ghost: .clear
        }
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        AppButton("Primary", variant: .primary, width: .full) {}
        AppButton("Secondary", variant: .secondary, icon: "plus") {}
        AppButton("Destructive", variant: .destructive, icon: "trash") {}
        AppButton("Ghost", variant: .ghost) {}
        AppButton("Loading", variant: .primary, isLoading: true) {}
        AppButton("Disabled", variant: .primary, isDisabled: true) {}
    }
    .padding(Spacing.lg)
}
