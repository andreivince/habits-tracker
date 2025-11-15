import SwiftUI

struct AppBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark ? [.midnight, .indigoNight] : [.canvas, .parchment],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            Circle()
                .fill(Color.softMint.opacity(colorScheme == .dark ? 0.15 : 0.3))
                .blur(radius: 180)
                .frame(width: 520, height: 520)
                .offset(x: -320, y: -200)
            Circle()
                .fill(Color.peach.opacity(colorScheme == .dark ? 0.1 : 0.25))
                .blur(radius: 180)
                .frame(width: 480, height: 480)
                .offset(x: 260, y: 220)
        }
    }
}

extension Color {
    static let midnight = Color(red: 11 / 255, green: 13 / 255, blue: 26 / 255)
    static let indigoNight = Color(red: 24 / 255, green: 28 / 255, blue: 52 / 255)
    static let electricBlue = Color(red: 106 / 255, green: 133 / 255, blue: 255 / 255)
    static let peach = Color(red: 255 / 255, green: 153 / 255, blue: 123 / 255)
    static let softMint = Color(red: 150 / 255, green: 255 / 255, blue: 221 / 255)
    static let canvas = Color(red: 248 / 255, green: 246 / 255, blue: 242 / 255)
    static let parchment = Color(red: 232 / 255, green: 228 / 255, blue: 221 / 255)
    static let graphiteDark = Color(red: 26 / 255, green: 28 / 255, blue: 32 / 255)
    static let graphiteLight = Color(red: 240 / 255, green: 242 / 255, blue: 245 / 255)
}

struct AdaptiveColor {
    static func graphite(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .graphiteLight : .graphiteDark
    }

    static func cardBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 32 / 255, green: 35 / 255, blue: 42 / 255) : .white
    }

    static func cardShadow(_ colorScheme: ColorScheme) -> Color {
        .black
    }

    static func progressPanelBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 32 / 255, green: 35 / 255, blue: 42 / 255) : .graphiteDark
    }

    static func metricCardBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 42 / 255, green: 45 / 255, blue: 52 / 255) : Color.graphiteDark.opacity(0.55)
    }

    static func metricCardText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .graphiteLight : .white
    }

    static func scopePickerSelected(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 50 / 255, green: 53 / 255, blue: 60 / 255) : .white
    }

    static func scopePickerSelectedText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .graphiteLight : .graphiteDark
    }

    static func scopePickerBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.1)
    }

    static func scopePickerBorder(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.2)
    }

    static func tabBarSelected(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 50 / 255, green: 53 / 255, blue: 60 / 255) : .graphiteDark
    }

    static func tabBarSelectedText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .graphiteLight : .canvas
    }

    static func habitRowBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(red: 28 / 255, green: 30 / 255, blue: 35 / 255) : .canvas
    }

    static func habitRowButton(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.graphiteLight.opacity(0.08) : Color.graphiteDark.opacity(0.08)
    }

    static func textFieldBackground(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.graphiteLight.opacity(0.04) : Color.graphiteDark.opacity(0.04)
    }
}
