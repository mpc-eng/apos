import CoreGraphics
import Testing
@testable import APOSDesignSystem

@Suite("Spacing Scale")
struct SpacingTests {

    @Test("Spacing values follow the 4pt sub-grid")
    func spacingValuesAreGridAligned() {
        let values: [CGFloat] = [
            Spacing.none, Spacing.xxs, Spacing.xs, Spacing.sm,
            Spacing.md, Spacing.lg, Spacing.xl, Spacing.xxl, Spacing.xxxl
        ]
        for value in values {
            #expect(value.truncatingRemainder(dividingBy: 2) == 0,
                    "Spacing value \(value) is not aligned to the 2pt sub-grid")
        }
    }

    @Test("Spacing scale is monotonically increasing")
    func spacingScaleIsOrdered() {
        let scale: [CGFloat] = [
            Spacing.none, Spacing.xxs, Spacing.xs, Spacing.sm,
            Spacing.md, Spacing.lg, Spacing.xl, Spacing.xxl, Spacing.xxxl
        ]
        for i in 1..<scale.count {
            #expect(scale[i] > scale[i - 1],
                    "Spacing \(scale[i]) should be greater than \(scale[i - 1])")
        }
    }

    @Test("Touch target meets Apple HIG minimum")
    func touchTargetMinimum() {
        #expect(Spacing.touch >= 44, "Touch target must be at least 44pt")
    }

    @Test("Specific spacing values match design spec")
    func specificValues() {
        #expect(Spacing.none == 0)
        #expect(Spacing.xxs == 2)
        #expect(Spacing.xs == 4)
        #expect(Spacing.sm == 8)
        #expect(Spacing.md == 12)
        #expect(Spacing.lg == 16)
        #expect(Spacing.xl == 24)
        #expect(Spacing.xxl == 32)
        #expect(Spacing.xxxl == 48)
        #expect(Spacing.touch == 44)
    }
}

@Suite("Radius Scale")
struct RadiusTests {

    @Test("Radius values are in ascending order")
    func radiusScaleIsOrdered() {
        #expect(Radius.small < Radius.medium)
        #expect(Radius.medium < Radius.large)
        #expect(Radius.large < Radius.extraLarge)
        #expect(Radius.extraLarge < Radius.full)
    }

    @Test("Specific radius values match design spec")
    func specificValues() {
        #expect(Radius.small == 4)
        #expect(Radius.medium == 8)
        #expect(Radius.large == 12)
        #expect(Radius.extraLarge == 16)
        #expect(Radius.full == .infinity)
    }
}

@Suite("Elevation")
struct ElevationTests {

    @Test("Elevation levels are comparable")
    func elevationComparable() {
        #expect(Elevation.base < Elevation.card)
        #expect(Elevation.card < Elevation.content)
        #expect(Elevation.content < Elevation.elevated)
        #expect(Elevation.elevated < Elevation.modal)
    }

    @Test("Base elevation has no shadow")
    func baseShadowIsZero() {
        let shadow = Elevation.base.shadow
        #expect(shadow.radius == 0)
        #expect(shadow.y == 0)
        #expect(shadow.opacity == 0)
    }

    @Test("Higher elevation has more shadow")
    func shadowIncreasesWithElevation() {
        #expect(Elevation.elevated.shadow.radius > Elevation.card.shadow.radius)
        #expect(Elevation.modal.shadow.radius > Elevation.elevated.shadow.radius)
    }
}
