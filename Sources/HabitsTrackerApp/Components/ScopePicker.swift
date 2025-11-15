import SwiftUI

struct ScopePicker: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selection: TimeScope

    var body: some View {
        HStack(spacing: 4) {
            ForEach(TimeScope.allCases) { scope in
                Button {
                    selection = scope
                } label: {
                    Text(scope.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selection == scope ? AdaptiveColor.scopePickerSelectedText(colorScheme) : AdaptiveColor.metricCardText(colorScheme).opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if selection == scope {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(AdaptiveColor.scopePickerSelected(colorScheme))
                                        .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.2), radius: 8, x: 0, y: 6)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(AdaptiveColor.scopePickerBackground(colorScheme), in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .stroke(AdaptiveColor.scopePickerBorder(colorScheme), lineWidth: 1)
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: selection)
    }
}
