import SwiftUI

struct HabitFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    let onSave: (String, Set<Weekday>) -> Void

    @State private var title = ""
    @State private var selectedDays: Set<Weekday> = []
    @FocusState private var isTitleFocused: Bool

    private var isValid: Bool {
        !title.isEmpty && !selectedDays.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("New habit")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
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
            .padding(24)

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Habit name")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                        TextField("Morning meditation", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .focused($isTitleFocused)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Days of the week")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AdaptiveColor.graphite(colorScheme))

                        HStack(spacing: 10) {
                            ForEach(Weekday.allCases) { day in
                                DayButton(
                                    day: day,
                                    isSelected: selectedDays.contains(day)
                                ) {
                                    if selectedDays.contains(day) {
                                        selectedDays.remove(day)
                                    } else {
                                        selectedDays.insert(day)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }

            VStack(spacing: 12) {
                Button {
                    onSave(title, selectedDays)
                    dismiss()
                } label: {
                    Text("Create habit")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AdaptiveColor.tabBarSelected(colorScheme), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .foregroundStyle(AdaptiveColor.tabBarSelectedText(colorScheme))
                }
                .buttonStyle(.plain)
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.4)

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
        .background(AdaptiveColor.cardBackground(colorScheme))
        .frame(width: 500, height: 450)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleFocused = true
            }
        }
    }
}

private struct DayButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let day: Weekday
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(day.short)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(isSelected ? AdaptiveColor.tabBarSelectedText(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.textFieldBackground(colorScheme))
            )
        }
        .buttonStyle(.plain)
    }
}

