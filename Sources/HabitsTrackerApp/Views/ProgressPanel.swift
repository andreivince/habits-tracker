import SwiftUI

struct ProgressPanel: View {
    @Environment(\.colorScheme) private var colorScheme
    let snapshot: HabitSnapshot
    @Binding var selectedScope: TimeScope

    private var metrics: [ProgressMetric] {
        [
            ProgressMetric(title: "Current streak", value: "\(snapshot.currentStreak)d", caption: "Days in a row"),
            ProgressMetric(title: "Best run", value: "\(snapshot.bestStreak)d", caption: "Peak streak"),
            ProgressMetric(title: "Completion", value: snapshot.completionRate.formatted(.percent.precision(.fractionLength(0))), caption: "This window"),
            ProgressMetric(title: "Entries", value: "\(snapshot.entries.count)", caption: "Points plotted")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This \(selectedScope.title.lowercased())")
                        .font(.headline)
                        .foregroundStyle(AdaptiveColor.metricCardText(colorScheme).opacity(0.9))
                    Text(snapshot.caption)
                        .font(.subheadline)
                        .foregroundStyle(AdaptiveColor.metricCardText(colorScheme).opacity(0.65))
                }
                Spacer()
                ScopePicker(selection: $selectedScope)
                    .frame(width: 260)
            }

            LineGraphView(entries: snapshot.entries, accent: .softMint)
                .frame(height: 220)
                .padding(.top, 4)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(metrics) { metric in
                    ProgressMetricCard(metric: metric)
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(AdaptiveColor.progressPanelBackground(colorScheme))
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.4), radius: 30, x: 0, y: 30)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .stroke(AdaptiveColor.scopePickerBorder(colorScheme), lineWidth: 1)
        )
    }
}
