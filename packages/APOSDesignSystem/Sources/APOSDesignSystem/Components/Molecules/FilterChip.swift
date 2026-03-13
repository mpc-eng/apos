import SwiftUI

/// Selectable tag for filter and multi-select patterns.
///
/// ```swift
/// FilterChip("Jab", isSelected: $jabSelected)
/// FilterChip("All time", isSelected: .constant(true))
/// ```
public struct FilterChip: View {
    @Environment(\.aposTheme) private var theme

    private let label: String
    @Binding private var isSelected: Bool

    /// Creates a selectable filter chip.
    public init(_ label: String, isSelected: Binding<Bool>) {
        self.label = label
        self._isSelected = isSelected
    }

    public var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(label)
                .font(theme.labelMedium)
                .foregroundStyle(isSelected ? theme.textOnAccent : theme.textPrimary)
                .padding(.horizontal, Spacing.md)
                .frame(minHeight: 32)
                .background(isSelected ? theme.accent : .clear)
                .clipShape(Capsule())
                .overlay {
                    if !isSelected {
                        Capsule().strokeBorder(theme.border, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack(spacing: Spacing.sm) {
        FilterChip("All", isSelected: .constant(true))
        FilterChip("Jab", isSelected: .constant(false))
        FilterChip("Cross", isSelected: .constant(false))
        FilterChip("Hook", isSelected: .constant(true))
    }
    .padding(Spacing.lg)
}
