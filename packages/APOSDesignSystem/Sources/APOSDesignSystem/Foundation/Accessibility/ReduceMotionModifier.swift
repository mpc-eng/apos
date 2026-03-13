import SwiftUI

/// View modifier that respects the user's reduce-motion preference.
///
/// Usage: `.motionSafe(default: .spring(), reduced: .easeInOut(duration: 0.25))`
public struct MotionSafeModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let defaultAnimation: Animation
    let reducedAnimation: Animation

    public func body(content: Content) -> some View {
        content.animation(
            reduceMotion ? reducedAnimation : defaultAnimation,
            value: reduceMotion
        )
    }
}

extension View {
    /// Applies an animation that automatically downgrades when reduce-motion is enabled.
    ///
    /// - Parameters:
    ///   - defaultAnimation: The full animation to use normally.
    ///   - reduced: The simpler animation for reduce-motion users. Defaults to a gentle fade.
    public func motionSafe(
        default defaultAnimation: Animation = Motion.springDefault,
        reduced: Animation = Motion.reducedMotionFade
    ) -> some View {
        modifier(MotionSafeModifier(
            defaultAnimation: defaultAnimation,
            reducedAnimation: reduced
        ))
    }
}
