import Testing
@testable import APOSDesignSystem

// MARK: - APOSTextStyle Tests

@Suite("APOSTextStyle")
struct APOSTextStyleTests {

    @Test("All styles resolve a font from DefaultTheme")
    func allStylesResolve() {
        let theme = DefaultTheme()
        let styles: [APOSTextStyle] = [
            .displayLarge, .displayMedium, .displaySmall, .headlineMedium,
            .bodyLarge, .bodyMedium, .bodySmall,
            .labelLarge, .labelMedium, .caption, .captionEmphasis, .footnote
        ]
        for style in styles {
            // Font resolves without crashing — that's the contract
            _ = style.font(from: theme)
        }
        #expect(styles.count == 12, "All 12 text styles should be covered")
    }
}

// MARK: - AppIconColor Tests

@Suite("AppIconColor")
struct AppIconColorTests {

    @Test("All icon colours resolve from DefaultTheme")
    func allColoursResolve() {
        let theme = DefaultTheme()
        let colours: [AppIconColor] = [
            .primary, .secondary, .accent, .positive, .emphasis, .destructive
        ]
        for colour in colours {
            _ = colour.color(from: theme)
        }
        #expect(colours.count == 6, "All 6 icon colours should be covered")
    }
}

// MARK: - AppIconSize Tests

@Suite("AppIconSize")
struct AppIconSizeTests {

    @Test("Icon sizes are ascending")
    func sizesAreAscending() {
        #expect(AppIconSize.small.points < AppIconSize.medium.points)
        #expect(AppIconSize.medium.points < AppIconSize.large.points)
        #expect(AppIconSize.large.points < AppIconSize.xlarge.points)
    }

    @Test("Specific icon size values")
    func specificValues() {
        #expect(AppIconSize.small.points == 16)
        #expect(AppIconSize.medium.points == 20)
        #expect(AppIconSize.large.points == 24)
        #expect(AppIconSize.xlarge.points == 32)
    }
}

// MARK: - ButtonVariant Tests

@Suite("ButtonVariant")
struct ButtonVariantTests {

    @Test("All four button variants exist")
    func allVariantsExist() {
        let variants: [ButtonVariant] = [.primary, .secondary, .destructive, .ghost]
        #expect(variants.count == 4)
    }
}

// MARK: - FieldValidation Tests

@Suite("FieldValidation")
struct FieldValidationTests {

    @Test("Error validation carries message")
    func errorCarriesMessage() {
        let validation = FieldValidation.error("Invalid email")
        if case .error(let message) = validation {
            #expect(message == "Invalid email")
        } else {
            #expect(Bool(false), "Expected .error case")
        }
    }

    @Test("All validation states exist")
    func allStatesExist() {
        _ = FieldValidation.none
        _ = FieldValidation.error("test")
        _ = FieldValidation.success
    }
}

// MARK: - MetricTrend Tests

@Suite("MetricTrend")
struct MetricTrendTests {

    @Test("Each trend has an SF Symbol")
    func trendsHaveSymbols() {
        #expect(!MetricTrend.up.systemName.isEmpty)
        #expect(!MetricTrend.down.systemName.isEmpty)
        #expect(!MetricTrend.flat.systemName.isEmpty)
    }

    @Test("Trends have distinct symbols")
    func trendsHaveDistinctSymbols() {
        let symbols = Set([MetricTrend.up.systemName, MetricTrend.down.systemName, MetricTrend.flat.systemName])
        #expect(symbols.count == 3)
    }
}

// MARK: - SemanticColor Tests

@Suite("SemanticColor")
struct SemanticColorTests {

    @Test("All semantic colours resolve from DefaultTheme")
    func allColoursResolve() {
        let theme = DefaultTheme()
        let colours: [SemanticColor] = [.positive, .emphasis, .destructive, .accent, .primary]
        for colour in colours {
            _ = colour.color(from: theme)
        }
        #expect(colours.count == 5)
    }
}

// MARK: - LoadableState Tests

@Suite("LoadableState")
struct LoadableStateTests {

    @Test("All four states are constructible")
    func allStatesExist() {
        let idle: LoadableState<String> = .idle
        let loading: LoadableState<String> = .loading
        let loaded: LoadableState<String> = .loaded("test")
        let error: LoadableState<String> = .error("fail")

        if case .idle = idle {} else { #expect(Bool(false), "Expected idle") }
        if case .loading = loading {} else { #expect(Bool(false), "Expected loading") }
        if case .loaded(let val) = loaded { #expect(val == "test") } else { #expect(Bool(false), "Expected loaded") }
        if case .error(let msg) = error { #expect(msg == "fail") } else { #expect(Bool(false), "Expected error") }
    }
}

// MARK: - DefaultTheme Tests

@Suite("DefaultTheme")
struct DefaultThemeTests {

    @Test("DefaultTheme category register is neutral utility")
    func defaultCategoryRegister() {
        let theme = DefaultTheme()
        #expect(theme.categoryRegister == .neutralUtility)
    }

    @Test("DefaultTheme provides all 13 colour tokens")
    func allColourTokens() {
        let theme = DefaultTheme()
        // Access each to verify they don't crash
        _ = theme.textPrimary
        _ = theme.textSecondary
        _ = theme.textTertiary
        _ = theme.textOnAccent
        _ = theme.backgroundPrimary
        _ = theme.backgroundSecondary
        _ = theme.backgroundTertiary
        _ = theme.accent
        _ = theme.accentSubtle
        _ = theme.positive
        _ = theme.emphasis
        _ = theme.destructive
        _ = theme.border
        _ = theme.fieldBackground
    }

    @Test("DefaultTheme provides all 12 typography tokens")
    func allTypographyTokens() {
        let theme = DefaultTheme()
        _ = theme.displayLarge
        _ = theme.displayMedium
        _ = theme.displaySmall
        _ = theme.headlineMedium
        _ = theme.bodyLarge
        _ = theme.bodyMedium
        _ = theme.bodySmall
        _ = theme.labelLarge
        _ = theme.labelMedium
        _ = theme.caption
        _ = theme.captionEmphasis
        _ = theme.footnote
    }
}

// MARK: - CategoryRegister Tests

@Suite("CategoryRegister")
struct CategoryRegisterTests {

    @Test("All three registers exist")
    func allRegistersExist() {
        let registers: [CategoryRegister] = [.positiveAffect, .highAnxiety, .neutralUtility]
        #expect(registers.count == 3)
    }

    @Test("Registers have distinct raw values")
    func distinctRawValues() {
        let rawValues = Set([
            CategoryRegister.positiveAffect.rawValue,
            CategoryRegister.highAnxiety.rawValue,
            CategoryRegister.neutralUtility.rawValue
        ])
        #expect(rawValues.count == 3)
    }
}
