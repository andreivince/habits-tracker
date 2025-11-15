import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Binding var userName: String
    @Binding var useSerifFont: Bool

    @State private var editedName: String
    @FocusState private var isNameFocused: Bool

    init(userName: Binding<String>, useSerifFont: Binding<Bool>) {
        self._userName = userName
        self._useSerifFont = useSerifFont
        self._editedName = State(initialValue: userName.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    nameSection
                    fontSection
                }
                .padding(28)
            }

            footer
        }
        .background(AdaptiveColor.cardBackground(colorScheme))
        .frame(width: 480, height: 420)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isNameFocused = true
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                Text("Customize your experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(28)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.subheadline)
                    .foregroundStyle(AdaptiveColor.tabBarSelected(colorScheme))
                Text("Display name")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
            }

            TextField("Your name", text: $editedName)
                .textFieldStyle(.plain)
                .font(.body)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AdaptiveColor.textFieldBackground(colorScheme))
                )
                .focused($isNameFocused)
        }
    }

    private var fontSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "textformat")
                    .font(.subheadline)
                    .foregroundStyle(AdaptiveColor.tabBarSelected(colorScheme))
                Text("Font style")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
            }

            HStack(spacing: 12) {
                FontOptionButton(
                    title: "Default",
                    fontName: "System",
                    isSelected: !useSerifFont
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                        useSerifFont = false
                    }
                }

                FontOptionButton(
                    title: "Serif",
                    fontName: "Georgia",
                    isSelected: useSerifFont
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                        useSerifFont = true
                    }
                }
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 12) {
            Button {
                userName = editedName
                dismiss()
            } label: {
                Text("Save changes")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AdaptiveColor.tabBarSelected(colorScheme), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .foregroundStyle(AdaptiveColor.tabBarSelectedText(colorScheme))
            }
            .buttonStyle(.plain)
            .disabled(editedName.isEmpty)
            .opacity(editedName.isEmpty ? 0.4 : 1.0)

            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.body)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(AdaptiveColor.cardBackground(colorScheme))
    }
}

private struct FontOptionButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let fontName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text("Aa")
                    .font(fontName == "System" ? .title.weight(.semibold) : .custom("Georgia-Bold", size: 28))
                    .foregroundStyle(isSelected ? AdaptiveColor.tabBarSelectedText(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.7))

                VStack(spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(isSelected ? AdaptiveColor.tabBarSelectedText(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.8))
                    Text(fontName)
                        .font(.caption2)
                        .foregroundStyle(isSelected ? AdaptiveColor.tabBarSelectedText(colorScheme).opacity(0.7) : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.textFieldBackground(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isSelected ? AdaptiveColor.tabBarSelected(colorScheme).opacity(0.3) : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
