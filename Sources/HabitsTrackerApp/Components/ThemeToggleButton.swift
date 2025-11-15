import SwiftUI

struct ThemeToggleButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isDarkMode: Bool
    @Binding var showingSettings: Bool

    @State private var isHovering = false
    @State private var isExpanded = false
    @State private var hoverTimer: Timer?

    private let expandDelay: TimeInterval = 2.0

    var body: some View {
        ZStack {
            morphingBackground

            HStack(spacing: 16) {
                if isExpanded {
                    settingsButton
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.3, anchor: .trailing).combined(with: .opacity),
                            removal: .scale(scale: 0.3, anchor: .trailing).combined(with: .opacity)
                        ))
                }

                themeButton
            }
            .padding(.horizontal, 8)
        }
        .onHover { hovering in
            isHovering = hovering

            if hovering {
                hoverTimer?.invalidate()
                hoverTimer = Timer.scheduledTimer(withTimeInterval: expandDelay, repeats: false) { [self] _ in
                    Task { @MainActor in
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
                            isExpanded = true
                        }
                    }
                }
            } else {
                hoverTimer?.invalidate()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0)) {
                    isExpanded = false
                }
            }
        }
    }

    private var morphingBackground: some View {
        RoundedRectangle(cornerRadius: isExpanded ? 28 : 22, style: .continuous)
            .fill(AdaptiveColor.cardBackground(colorScheme))
            .shadow(
                color: AdaptiveColor.cardShadow(colorScheme).opacity(isExpanded ? 0.15 : 0.08),
                radius: isExpanded ? 20 : 8,
                x: 0,
                y: isExpanded ? 10 : 4
            )
            .overlay(
                RoundedRectangle(cornerRadius: isExpanded ? 28 : 22, style: .continuous)
                    .stroke(AdaptiveColor.tabBarSelected(colorScheme).opacity(isExpanded ? 0.3 : 0), lineWidth: 1.5)
            )
            .frame(width: isExpanded ? 120 : 44, height: 44)
            .animation(.spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0), value: isExpanded)
    }

    private var themeButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                isDarkMode.toggle()
            }
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(isExpanded ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.graphite(colorScheme))
                .scaleEffect(isExpanded ? 1.05 : 1.0)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    private var settingsButton: some View {
        Button {
            showingSettings = true
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0)) {
                isExpanded = false
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.8))
                .rotationEffect(.degrees(isExpanded ? 360 : 0))
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: isExpanded)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }
}
