import SwiftUI

/// Design system spacing scale (IBM Carbon-derived, 4pt sub-grid).
///
/// All padding and spacing values in APOS apps must reference these constants.
/// No raw `CGFloat` literals for spacing are permitted in feature code.
public enum Spacing {
    /// 0pt — No spacing
    public static let none: CGFloat = 0
    /// 2pt — Hairline (icon-to-label in compact elements)
    public static let xxs: CGFloat = 2
    /// 4pt — Tight (caption to parent, icon padding)
    public static let xs: CGFloat = 4
    /// 8pt — Default inner padding (between related items)
    public static let sm: CGFloat = 8
    /// 12pt — Medium (between loosely related items in a group)
    public static let md: CGFloat = 12
    /// 16pt — Standard (screen edges, card padding) — Apple's default margin
    public static let lg: CGFloat = 16
    /// 24pt — Section gaps (between distinct sections)
    public static let xl: CGFloat = 24
    /// 32pt — Large section gaps (major divisions)
    public static let xxl: CGFloat = 32
    /// 48pt — Page-level divisions
    public static let xxxl: CGFloat = 48

    /// 44pt — Minimum touch target (Apple HIG non-negotiable)
    public static let touch: CGFloat = 44
}
