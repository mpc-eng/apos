import SwiftUI

/// Label + text field + validation message, vertically stacked.
///
/// ```swift
/// LabeledTextField("Email address", text: $email, validation: .error("Required"))
/// ```
public struct LabeledTextField: View {
    @Environment(\.aposTheme) private var theme

    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let validation: FieldValidation
    private let icon: String?
    private let characterLimit: Int?

    /// Creates a labeled text field.
    public init(
        _ label: String,
        placeholder: String? = nil,
        text: Binding<String>,
        validation: FieldValidation = .none,
        icon: String? = nil,
        characterLimit: Int? = nil
    ) {
        self.label = label
        self.placeholder = placeholder ?? label
        self._text = text
        self.validation = validation
        self.icon = icon
        self.characterLimit = characterLimit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            AppText(label, style: .caption, color: theme.textSecondary)
            AppTextField(
                placeholder,
                text: $text,
                validation: validation,
                icon: icon,
                characterLimit: characterLimit
            )
        }
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        LabeledTextField("Email", text: .constant("john@example.com"), icon: "envelope")
        LabeledTextField("Password", text: .constant(""), validation: .error("Required"))
        LabeledTextField("Bio", text: .constant("Hello"), characterLimit: 100)
    }
    .padding(Spacing.lg)
}
