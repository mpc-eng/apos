import SwiftUI

/// Validation state for text fields.
public enum FieldValidation: Sendable {
    /// No validation state
    case none
    /// Field has an error with a message
    case error(String)
    /// Field value is valid
    case success
}

/// Themed text input with validation state.
///
/// ```swift
/// AppTextField("Email", text: $email, validation: .error("Invalid email"))
/// ```
public struct AppTextField: View {
    @Environment(\.aposTheme) private var theme

    private let placeholder: LocalizedStringKey
    @Binding private var text: String
    private let validation: FieldValidation
    private let icon: String?
    private let characterLimit: Int?

    /// Creates a themed text field.
    public init(
        _ placeholder: LocalizedStringKey,
        text: Binding<String>,
        validation: FieldValidation = .none,
        icon: String? = nil,
        characterLimit: Int? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.validation = validation
        self.icon = icon
        self.characterLimit = characterLimit
    }

    /// Creates a themed text field with a plain string placeholder.
    public init(
        _ placeholder: String,
        text: Binding<String>,
        validation: FieldValidation = .none,
        icon: String? = nil,
        characterLimit: Int? = nil
    ) {
        self.placeholder = LocalizedStringKey(placeholder)
        self._text = text
        self.validation = validation
        self.icon = icon
        self.characterLimit = characterLimit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(theme.textSecondary)
                        .font(.system(size: AppIconSize.medium.points))
                }
                TextField(placeholder, text: $text)
                    .font(theme.bodyLarge)
                    .foregroundStyle(theme.textPrimary)
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(theme.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.md)
            .frame(minHeight: Spacing.touch)
            .background(theme.fieldBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.medium)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            }

            if let characterLimit {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(characterLimit)")
                        .font(theme.caption)
                        .foregroundStyle(
                            text.count > characterLimit ? theme.destructive : theme.textTertiary
                        )
                }
            }

            if case .error(let message) = validation {
                Text(message)
                    .font(theme.caption)
                    .foregroundStyle(theme.destructive)
            }
        }
    }

    private var borderColor: Color {
        switch validation {
        case .none: theme.border
        case .error: theme.destructive
        case .success: theme.positive
        }
    }

    private var borderWidth: CGFloat {
        switch validation {
        case .none: 0.5
        case .error, .success: 1.5
        }
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        AppTextField("Email address", text: .constant(""), icon: "envelope")
        AppTextField("Name", text: .constant("John"), validation: .success)
        AppTextField("Password", text: .constant("short"), validation: .error("Too short"))
        AppTextField("Bio", text: .constant("Hello world"), characterLimit: 20)
    }
    .padding(Spacing.lg)
}
