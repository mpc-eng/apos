import SwiftUI

/// Themed divider using the border token.
///
/// ```swift
/// AppDivider()
/// ```
public struct AppDivider: View {
    @Environment(\.aposTheme) private var theme

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(theme.border)
            .frame(height: 0.5)
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        Text("Above")
        AppDivider()
        Text("Below")
    }
    .padding(Spacing.lg)
}
