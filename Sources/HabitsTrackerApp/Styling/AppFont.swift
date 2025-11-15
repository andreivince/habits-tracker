import SwiftUI

struct UseSerifFontKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var useSerifFont: Bool {
        get { self[UseSerifFontKey.self] }
        set { self[UseSerifFontKey.self] = newValue }
    }
}

extension Font {
    private static func serifFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Try Lyon-Text first, fall back to Georgia (widely available on macOS)
        let fontName: String
        switch weight {
        case .semibold, .bold:
            fontName = "Georgia-Bold"
        case .medium:
            fontName = "Georgia-Bold"
        default:
            fontName = "Georgia"
        }
        return .custom(fontName, size: size)
    }

    static func appTitle(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 28, weight: .semibold) : .title.weight(.semibold)
    }

    static func appTitle2(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 22, weight: .semibold) : .title2.weight(.semibold)
    }

    static func appTitle3(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 20, weight: .semibold) : .title3.weight(.semibold)
    }

    static func appHeadline(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 17, weight: .medium) : .headline
    }

    static func appBody(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 17) : .body
    }

    static func appSubheadline(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 15) : .subheadline
    }

    static func appCaption(useSerif: Bool) -> Font {
        useSerif ? serifFont(size: 12) : .caption
    }
}

struct AdaptiveFontModifier: ViewModifier {
    @Environment(\.useSerifFont) private var useSerifFont
    let style: FontStyle

    enum FontStyle {
        case title, title2, title3, headline, body, subheadline, caption
    }

    func body(content: Content) -> some View {
        switch style {
        case .title:
            content.font(.appTitle(useSerif: useSerifFont))
        case .title2:
            content.font(.appTitle2(useSerif: useSerifFont))
        case .title3:
            content.font(.appTitle3(useSerif: useSerifFont))
        case .headline:
            content.font(.appHeadline(useSerif: useSerifFont))
        case .body:
            content.font(.appBody(useSerif: useSerifFont))
        case .subheadline:
            content.font(.appSubheadline(useSerif: useSerifFont))
        case .caption:
            content.font(.appCaption(useSerif: useSerifFont))
        }
    }
}

extension View {
    func adaptiveFont(_ style: AdaptiveFontModifier.FontStyle) -> some View {
        modifier(AdaptiveFontModifier(style: style))
    }
}
