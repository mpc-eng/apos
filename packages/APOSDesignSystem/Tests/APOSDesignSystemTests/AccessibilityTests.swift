import Testing
@testable import APOSDesignSystem

@Suite("Accessibility Constants")
struct AccessibilityTests {

    @Test("Touch target minimum is 44pt")
    func touchTargetMinimum() {
        #expect(AccessibilityConstants.minimumTouchTarget == 44)
    }

    @Test("WCAG AA contrast ratio for normal text is 4.5:1")
    func normalTextContrastRatio() {
        #expect(AccessibilityConstants.contrastRatioNormalText == 4.5)
    }

    @Test("WCAG AA contrast ratio for large text is 3:1")
    func largeTextContrastRatio() {
        #expect(AccessibilityConstants.contrastRatioLargeText == 3.0)
    }
}
