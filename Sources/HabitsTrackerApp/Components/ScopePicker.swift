import SwiftUI

struct ScopePicker: View {
    @Binding var selection: TimeScope

    var body: some View {
        HStack(spacing: 4) {
            ForEach(TimeScope.allCases) { scope in
                Button {
                    selection = scope
                } label: {
                    Text(scope.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selection == scope ? Color.graphite : Color.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if selection == scope {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(Color.white.opacity(0.1), in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: selection)
    }
}
