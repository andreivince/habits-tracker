import SwiftUI

struct GreetingSection: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                .kerning(0.2)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.75))
        }
    }
}
