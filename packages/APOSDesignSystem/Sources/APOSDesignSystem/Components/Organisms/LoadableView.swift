import SwiftUI

/// Generic wrapper for `LoadableState<T>` that renders all four states.
///
/// ```swift
/// LoadableView(state: viewModel.sessions) { sessions in
///     ForEach(sessions) { session in
///         ActionRow(...)
///     }
/// } empty: {
///     EmptyAction(icon: "clock", title: "No sessions", ...)
/// }
/// ```
public struct LoadableView<Value: Sendable, Content: View, Empty: View>: View {
    @Environment(\.aposTheme) private var theme

    private let state: LoadableState<Value>
    private let content: (Value) -> Content
    private let empty: Empty
    private let onRetry: (() -> Void)?

    /// Creates a loadable view with custom content and empty views.
    public init(
        state: LoadableState<Value>,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content,
        @ViewBuilder empty: () -> Empty
    ) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
        self.empty = empty()
    }

    public var body: some View {
        switch state {
        case .idle, .loading:
            loadingView
        case .loaded(let value):
            content(value)
        case .error(let message):
            errorView(message: message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .tint(theme.accent)
            AppText("Loading...", style: .bodySmall, color: theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label {
                Text("Something went wrong")
                    .font(theme.headlineMedium)
                    .foregroundStyle(theme.textPrimary)
            } icon: {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.destructive)
            }
        } description: {
            Text(message)
                .font(theme.bodyMedium)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
        } actions: {
            if let onRetry {
                AppButton("Try Again", variant: .secondary, action: onRetry)
            }
        }
    }
}

extension LoadableView where Empty == EmptyView {
    /// Creates a loadable view without a custom empty state.
    public init(
        state: LoadableState<Value>,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
        self.empty = EmptyView()
    }
}

#Preview("Loading") {
    LoadableView(state: LoadableState<String>.loading) { value in
        Text(value)
    }
}

#Preview("Error") {
    LoadableView(state: LoadableState<String>.error("Network unavailable"), onRetry: {}) { value in
        Text(value)
    }
}

#Preview("Loaded") {
    LoadableView(state: LoadableState<String>.loaded("Hello, World!")) { value in
        AppText(value, style: .displayLarge)
    }
}
