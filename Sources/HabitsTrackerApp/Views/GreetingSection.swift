import SwiftUI

struct GreetingSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.useSerifFont) private var useSerifFont
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(useSerifFont ? .custom("Georgia-Bold", size: 36) : .system(size: 36, weight: .semibold, design: .rounded))
                .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                .kerning(useSerifFont ? -0.3 : 0.2)
            Text(subtitle)
                .adaptiveFont(.subheadline)
                .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.75))
        }
    }
}
