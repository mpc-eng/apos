import SwiftUI

/// Design system motion tokens.
///
/// All animations should use these durations and spring configurations.
/// Always pair with `.motionSafe()` modifier for reduce-motion compliance.
public enum Motion {
    /// 0.15s — Micro feedback (opacity, scale changes)
    public static let durationFast: Double = 0.15
    /// 0.25s — Standard transitions (fade, slide)
    public static let durationNormal: Double = 0.25
    /// 0.35s — Emphasised transitions (sheet present)
    public static let durationSlow: Double = 0.35

    /// Standard spring for interactive elements.
    public static let springDefault: Animation = .spring(
        response: 0.3, dampingFraction: 0.8
    )
    /// Reduce-motion safe fade.
    public static let reducedMotionFade: Animation = .easeInOut(
        duration: durationNormal
    )
}
