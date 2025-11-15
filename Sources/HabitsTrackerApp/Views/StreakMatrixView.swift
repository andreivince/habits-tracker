import SwiftUI

struct StreakMatrixView: View {
    let days: [HabitDay]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dashboard")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.graphite)
                    Text("Last 4 weeks of check-ins")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "plus")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.graphite)
                    .padding(10)
                    .background(Color.white, in: Circle())
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days) { day in
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(day.tint)
                        .frame(height: 44)
                        .overlay(
                            Text(day.label)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(day.labelColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
                        )
                }
            }
            Divider()
            MoodStripView(progress: days.moodScore)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 16)
        )
    }
}

private struct MoodStripView: View {
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Mood score")
                    .font(.headline)
                    .foregroundStyle(Color.graphite)
                Spacer()
                Text(progress.formatted(.percent.precision(.fractionLength(0))))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.graphite)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.graphite.opacity(0.08))
                    Capsule()
                        .fill(Color.graphite)
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 10)
        }
    }
}

private extension HabitDay {
    var tint: Color {
        switch level {
        case 3: return Color.graphite
        case 2: return Color.graphite.opacity(0.7)
        case 1: return Color.graphite.opacity(0.3)
        default: return Color.graphite.opacity(0.1)
        }
    }

    var labelColor: Color {
        highlight ? .white : Color.graphite.opacity(0.6)
    }
}

private extension Array where Element == HabitDay {
    var moodScore: Double {
        guard !isEmpty else { return 0 }
        let total = reduce(0) { $0 + Double($1.level) }
        return min(max(total / (Double(count) * 3), 0), 1)
    }
}
