import SwiftUI

/// Context-agnostic raw palette values.
///
/// These are **internal** to the package — app code never imports them directly.
/// They exist only to be referenced by semantic tokens in `DefaultTheme`.
enum ReferenceColor {
    // MARK: - Neutral palette (Apple system grays)

    static let neutral0 = Color.black
    static let neutral10 = Color(red: 0.11, green: 0.11, blue: 0.12)   // ~#1C1C1E (dark background)
    static let neutral20 = Color(red: 0.17, green: 0.17, blue: 0.18)   // ~#2C2C2E (dark secondary)
    static let neutral30 = Color(red: 0.23, green: 0.23, blue: 0.24)   // ~#3A3A3C (dark tertiary)
    static let neutral92 = Color(red: 0.90, green: 0.90, blue: 0.92)   // ~#E5E5EA (separator light)
    static let neutral95 = Color(red: 0.95, green: 0.95, blue: 0.97)   // ~#F2F2F7 (grouped bg light)
    static let neutral100 = Color.white

    // MARK: - Blue palette (system accent)

    static let blue50 = Color(red: 0.0, green: 0.48, blue: 1.0)       // ~#007AFF (systemBlue light)
    static let blue60 = Color(red: 0.04, green: 0.52, blue: 1.0)      // ~#0A84FF (systemBlue dark)

    // MARK: - Semantic palette

    static let green50 = Color(red: 0.20, green: 0.78, blue: 0.35)    // ~#34C759 (systemGreen)
    static let red50 = Color(red: 1.0, green: 0.23, blue: 0.19)       // ~#FF3B30 (systemRed)
    static let amber50 = Color(red: 1.0, green: 0.58, blue: 0.0)      // ~#FF9500 (systemOrange)
}
