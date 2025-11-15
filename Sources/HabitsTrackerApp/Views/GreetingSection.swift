import SwiftUI

struct GreetingSection: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.graphite)
                .kerning(0.2)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.graphite.opacity(0.75))
        }
    }
}
