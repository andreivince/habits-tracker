import SwiftUI

struct ThemeToggleButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isDarkMode: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isDarkMode.toggle()
            }
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                .padding(10)
                .background(AdaptiveColor.cardBackground(colorScheme), in: Circle())
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
