import SwiftUI

struct QuickPracticeSection: View {
    let practices: [PracticeSuggestion]
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Singles")
                .font(.headline)
                .foregroundStyle(Color.graphite)
            Text("Quick practices you can trigger anytime")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(practices) { practice in
                    PracticeChip(practice: practice)
                }
            }
        }
    }
}

private struct PracticeChip: View {
    let practice: PracticeSuggestion

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: practice.icon)
                .font(.title3)
                .frame(width: 42, height: 42)
                .background(Color.canvas)
                .foregroundStyle(Color.graphite)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(practice.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.graphite)
                Text(practice.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 6)
        )
    }
}
