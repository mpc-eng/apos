import SwiftUI

/// Convenience property wrapper for spacing that scales with Dynamic Type.
///
/// Use when a spacing value must grow proportionally with text size
/// (e.g., padding around a text-heavy card).
///
/// ```swift
/// @ScaledSpacing(baseValue: Spacing.lg) var cardPadding
/// ```
@propertyWrapper
public struct ScaledSpacing: DynamicProperty {
    @ScaledMetric private var value: CGFloat

    public var wrappedValue: CGFloat { value }

    /// Creates a scaled spacing value.
    /// - Parameter baseValue: The spacing value at the default text size.
    public init(baseValue: CGFloat) {
        _value = ScaledMetric(wrappedValue: baseValue)
    }
}
