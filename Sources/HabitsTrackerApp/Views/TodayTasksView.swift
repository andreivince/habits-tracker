import SwiftUI

struct TodayTasksView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore

    private var todayHabits: [Habit] {
        let today = Date().startOfDay
        return habitStore.habits.filter { $0.isActiveDay(today) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today")
                    .adaptiveFont(.title3)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                Text(todayDate)
                    .adaptiveFont(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if todayHabits.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary.opacity(0.3))
                    Text("No habits scheduled for today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Enjoy your rest day!")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(todayHabits) { habit in
                        TodayHabitRow(habit: habit)
                    }
                }
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(AdaptiveColor.cardBackground(colorScheme))
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.1), radius: 20, x: 0, y: 16)
        )
    }

    private var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

private struct TodayHabitRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore
    let habit: Habit

    private var isCheckedIn: Bool {
        habit.isCheckedIn(on: Date().startOfDay)
    }

    private var currentMinutes: Int {
        habit.minutes(on: Date().startOfDay)
    }

    var body: some View {
        Button {
            if habit.trackingType == .minutes {
                habitStore.incrementOrResetMinutes(for: habit, on: Date().startOfDay)
            } else {
                habitStore.toggleCheckIn(for: habit, on: Date().startOfDay)
            }
        } label: {
            HStack(spacing: 16) {
                if habit.trackingType == .minutes {
                    Image(systemName: currentMinutes > 0 ? "clock.fill" : "clock")
                        .font(.title2)
                        .foregroundStyle(currentMinutes > 0 ? .green : AdaptiveColor.graphite(colorScheme).opacity(0.3))
                } else {
                    Image(systemName: isCheckedIn ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isCheckedIn ? .green : AdaptiveColor.graphite(colorScheme).opacity(0.3))
                }

                Text(habit.title)
                    .adaptiveFont(.body)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                    .strikethrough(isCheckedIn && habit.trackingType == .boolean, color: AdaptiveColor.graphite(colorScheme).opacity(0.5))

                Spacer()

                if habit.trackingType == .minutes {
                    if let goal = habit.goalMinutes, goal > 0 {
                        HStack(spacing: 8) {
                            Text("\(currentMinutes)/\(goal) min")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(currentMinutes >= goal ? .green : AdaptiveColor.graphite(colorScheme).opacity(0.7))

                            if currentMinutes < goal {
                                Text("\(Int((Double(currentMinutes) / Double(goal)) * 100))%")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(currentMinutes >= goal ? Color.green.opacity(0.15) : AdaptiveColor.habitRowBackground(colorScheme))
                        )
                    } else if currentMinutes > 0 {
                        Text("\(currentMinutes) min")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.green.opacity(0.15))
                            )
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isCheckedIn || currentMinutes > 0 ? Color.green.opacity(0.05) : AdaptiveColor.habitRowBackground(colorScheme))
            )
        }
        .buttonStyle(.plain)
    }
}
