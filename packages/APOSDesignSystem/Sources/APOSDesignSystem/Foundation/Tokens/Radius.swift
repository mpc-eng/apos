import SwiftUI

/// Design system corner radius scale.
///
/// All `cornerRadius` and `RoundedRectangle(cornerRadius:)` values must reference
/// these constants. No raw `CGFloat` literals for radii are permitted.
public enum Radius {
    /// 4pt — Subtle rounding (tags, badges)
    public static let small: CGFloat = 4
    /// 8pt — Default rounding (buttons, text fields)
    public static let medium: CGFloat = 8
    /// 12pt — Card rounding
    public static let large: CGFloat = 12
    /// 16pt — Sheet-style rounding (used sparingly)
    public static let extraLarge: CGFloat = 16
    /// Capsule / pill shape
    public static let full: CGFloat = .infinity
}
