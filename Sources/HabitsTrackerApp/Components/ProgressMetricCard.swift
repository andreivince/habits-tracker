import SwiftUI

struct ProgressMetricCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let metric: ProgressMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title.uppercased())
                .font(.caption2.weight(.medium))
                .foregroundStyle(AdaptiveColor.metricCardText(colorScheme).opacity(0.7))
            Text(metric.value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AdaptiveColor.metricCardText(colorScheme))
            Text(metric.caption)
                .font(.caption)
                .foregroundStyle(AdaptiveColor.metricCardText(colorScheme).opacity(0.65))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AdaptiveColor.metricCardBackground(colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(AdaptiveColor.scopePickerBorder(colorScheme), lineWidth: 1)
        )
    }
}

struct ProgressMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let caption: String
}
