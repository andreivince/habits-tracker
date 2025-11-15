import SwiftUI

struct HomeTabBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selection: HomeTab

    var body: some View {
        HStack(spacing: 12) {
            ForEach(HomeTab.allCases) { tab in
                Button {
                    selection = tab
                } label: {
                    Text(tab.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selection == tab ? AdaptiveColor.tabBarSelectedText(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(selection == tab ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.cardBackground(colorScheme))
                                .shadow(color: selection == tab ? AdaptiveColor.cardShadow(colorScheme).opacity(0.15) : .clear, radius: 18, x: 0, y: 10)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
