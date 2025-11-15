import SwiftUI

struct ProgressMetricCard: View {
    let metric: ProgressMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title.uppercased())
                .font(.caption2.weight(.medium))
                .foregroundStyle(Color.white.opacity(0.7))
            Text(metric.value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
            Text(metric.caption)
                .font(.caption)
                .foregroundStyle(Color.white.opacity(0.65))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.graphite.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

struct ProgressMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let caption: String
}
