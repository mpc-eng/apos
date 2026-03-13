import SwiftUI

/// Apple's layering system expressed as discrete elevation levels.
///
/// Each level maps to a background context and optional shadow configuration.
public enum Elevation: Int, Sendable, Comparable {
    /// Base surface — systemBackground
    case base = 0
    /// Card/grouped surface — secondarySystemBackground
    case card = 1
    /// Content on card — text, images, controls
    case content = 2
    /// Sheets, popovers — tertiarySystemBackground
    case elevated = 3
    /// Full-screen covers, alerts
    case modal = 4

    public static func < (lhs: Elevation, rhs: Elevation) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Shadow configuration per level (light mode).
    public var shadow: ShadowToken {
        switch self {
        case .base: ShadowToken(radius: 0, y: 0, opacity: 0)
        case .card: ShadowToken(radius: 2, y: 1, opacity: 0.08)
        case .content: ShadowToken(radius: 0, y: 0, opacity: 0)
        case .elevated: ShadowToken(radius: 8, y: 4, opacity: 0.12)
        case .modal: ShadowToken(radius: 16, y: 8, opacity: 0.16)
        }
    }
}

/// Shadow configuration for an elevation level.
public struct ShadowToken: Sendable {
    /// Blur radius
    public let radius: CGFloat
    /// Vertical offset
    public let y: CGFloat
    /// Opacity (0–1)
    public let opacity: Double
}
