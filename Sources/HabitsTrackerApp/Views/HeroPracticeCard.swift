import SwiftUI

struct HeroPracticeCard: View {
    var body: some View {
        HStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Driving home", systemImage: "figure.outdoor.cycle")
                    .font(.headline)
                    .foregroundStyle(Color.graphite)
                Text("Activity • 12 min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Design your check-in ritual. Tap once to log, twice to reflect.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                } label: {
                    Text("Begin now")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.graphite, in: Capsule())
                        .foregroundStyle(Color.canvas)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Color.graphite.opacity(0.08), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.white)
                    )
                    .frame(width: 220, height: 180)
                    .overlay(
                        Image(systemName: "figure.run.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.graphite.opacity(0.25))
                            .padding(30)
                    )
                Circle()
                    .fill(Color.graphite)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.canvas)
                    )
                    .offset(x: 6, y: 6)
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 25, x: 0, y: 14)
        )
    }
}
