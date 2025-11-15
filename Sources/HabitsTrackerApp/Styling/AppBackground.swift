import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.canvas, .parchment], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Circle()
                .fill(Color.softMint.opacity(0.3))
                .blur(radius: 180)
                .frame(width: 520, height: 520)
                .offset(x: -320, y: -200)
            Circle()
                .fill(Color.peach.opacity(0.25))
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
    static let cardSurface = Color.white.opacity(0.07)
    static let canvas = Color(red: 248 / 255, green: 246 / 255, blue: 242 / 255)
    static let parchment = Color(red: 232 / 255, green: 228 / 255, blue: 221 / 255)
    static let graphite = Color(red: 26 / 255, green: 28 / 255, blue: 32 / 255)
}
