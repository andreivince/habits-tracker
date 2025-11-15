import SwiftUI

struct GraphFooter: View {
    let entries: [HabitEntry]
    let completion: Double

    private var average: Double {
        guard !entries.isEmpty else { return .zero }
        let total = entries.reduce(0) { $0 + $1.value }
        return total / Double(entries.count)
    }

    private var mutedColor: Color { Color.white.opacity(0.65) }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(entries.first?.label ?? "—")
                    .font(.caption)
                    .foregroundStyle(mutedColor)
                Text("Kickoff")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text("\(average, format: .number.precision(.fractionLength(1)))x")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                Text("Daily avg")
                    .font(.caption)
                    .foregroundStyle(mutedColor)
                Text(completion.formatted(.percent.precision(.fractionLength(0))))
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.12), in: Capsule())
                    .foregroundStyle(.white)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(entries.last?.label ?? "—")
                    .font(.caption)
                    .foregroundStyle(mutedColor)
                Text("Momentum")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }
        }
        .padding(.top, 8)
    }
}
