import SwiftUI

/// Accessibility constants enforced across all APOS components.
public enum AccessibilityConstants {
    /// Minimum touch target size (Apple HIG).
    public static let minimumTouchTarget: CGFloat = 44

    /// WCAG AA minimum contrast ratio for normal text.
    public static let contrastRatioNormalText: Double = 4.5

    /// WCAG AA minimum contrast ratio for large text (18pt+ or 14pt+ bold).
    public static let contrastRatioLargeText: Double = 3.0
}
