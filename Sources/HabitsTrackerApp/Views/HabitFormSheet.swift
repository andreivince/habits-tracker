import SwiftUI

struct HabitFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    let habitToEdit: Habit?
    let onSave: (Habit) -> Void

    @State private var title: String
    @State private var selectedDays: Set<Weekday>
    @State private var trackingType: HabitTrackingType
    @State private var goalMinutes: String
    @FocusState private var isTitleFocused: Bool

    init(habitToEdit: Habit? = nil, onSave: @escaping (Habit) -> Void) {
        self.habitToEdit = habitToEdit
        self.onSave = onSave

        if let habit = habitToEdit {
            _title = State(initialValue: habit.title)
            _selectedDays = State(initialValue: habit.cadence)
            _trackingType = State(initialValue: habit.trackingType)
            _goalMinutes = State(initialValue: habit.goalMinutes.map { String($0) } ?? "")
        } else {
            _title = State(initialValue: "")
            _selectedDays = State(initialValue: [])
            _trackingType = State(initialValue: .boolean)
            _goalMinutes = State(initialValue: "")
        }
    }

    private var isValid: Bool {
        let titleValid = !title.isEmpty
        let daysValid = !selectedDays.isEmpty
        let minutesValid = trackingType == .boolean || (!goalMinutes.isEmpty && Int(goalMinutes) != nil && Int(goalMinutes)! > 0)
        return titleValid && daysValid && minutesValid
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(habitToEdit == nil ? "New habit" : "Edit habit")
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
                        Text("Tracking type")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AdaptiveColor.graphite(colorScheme))

                        HStack(spacing: 12) {
                            TrackingTypeButton(
                                title: "Check-in",
                                icon: "checkmark.circle",
                                isSelected: trackingType == .boolean
                            ) {
                                trackingType = .boolean
                            }

                            TrackingTypeButton(
                                title: "Minutes",
                                icon: "clock",
                                isSelected: trackingType == .minutes
                            ) {
                                trackingType = .minutes
                            }
                        }
                    }

                    if trackingType == .minutes {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Goal (minutes)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                            TextField("30", text: $goalMinutes)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                        }
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
                    let goalMinutesValue = trackingType == .minutes ? Int(goalMinutes) : nil
                    let habit: Habit
                    if let existingHabit = habitToEdit {
                        habit = Habit(
                            id: existingHabit.id,
                            title: title,
                            cadence: selectedDays,
                            startDate: existingHabit.startDate,
                            checkIns: existingHabit.checkIns,
                            trackingType: trackingType,
                            minutesLog: existingHabit.minutesLog,
                            goalMinutes: goalMinutesValue
                        )
                    } else {
                        habit = Habit(
                            title: title,
                            cadence: selectedDays,
                            trackingType: trackingType,
                            goalMinutes: goalMinutesValue
                        )
                    }
                    onSave(habit)
                    dismiss()
                } label: {
                    Text(habitToEdit == nil ? "Create habit" : "Save changes")
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
        .frame(width: 500, height: 600)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleFocused = true
            }
        }
    }
}

private struct TrackingTypeButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.body)
                Text(title)
                    .font(.body.weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(isSelected ? AdaptiveColor.tabBarSelectedText(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.6))
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.textFieldBackground(colorScheme))
            )
        }
        .buttonStyle(.plain)
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

