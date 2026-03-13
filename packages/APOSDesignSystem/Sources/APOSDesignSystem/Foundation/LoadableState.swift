/// Generic loading state for any data-fetching view.
///
/// Every screen that loads data uses this enum to handle all four states.
/// Pair with `LoadableView` (organism) for declarative state rendering.
public enum LoadableState<Value: Sendable>: Sendable {
    /// Initial state — no load attempted
    case idle
    /// Data is being fetched
    case loading
    /// Data loaded successfully
    case loaded(Value)
    /// Load failed with a user-facing message
    case error(String)
}
