import SwiftUI

struct StreakMatrixView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore
    let days: [HabitDay]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    private var todayHabits: [Habit] {
        habitStore.habits.filter { $0.isActiveDay(habitStore.currentDay) }
    }

    private var allCheckedIn: Bool {
        todayHabits.allSatisfy { $0.isCheckedIn(on: habitStore.currentDay) }
    }

    private func toggleTodayCheckIns() {
        for habit in todayHabits {
            if allCheckedIn {
                if habit.isCheckedIn(on: habitStore.currentDay) {
                    habitStore.toggleCheckIn(for: habit, on: habitStore.currentDay)
                }
            } else {
                if !habit.isCheckedIn(on: habitStore.currentDay) {
                    habitStore.toggleCheckIn(for: habit, on: habitStore.currentDay)
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY's Tasks")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                    Text("Last 4 weeks of check-ins")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    toggleTodayCheckIns()
                } label: {
                    Image(systemName: allCheckedIn ? "checkmark.circle.fill" : "circle")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(allCheckedIn ? .green : AdaptiveColor.graphite(colorScheme))
                        .padding(10)
                        .background(AdaptiveColor.cardBackground(colorScheme), in: Circle())
                        .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.08), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .disabled(todayHabits.isEmpty)
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
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(AdaptiveColor.cardBackground(colorScheme))
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.1), radius: 20, x: 0, y: 16)
        )
    }
}

private extension HabitDay {
    var tint: Color {
        switch level {
        case 3: return Color.graphiteDark
        case 2: return Color.graphiteDark.opacity(0.7)
        case 1: return Color.graphiteDark.opacity(0.3)
        default: return Color.graphiteDark.opacity(0.1)
        }
    }

    var labelColor: Color {
        highlight ? .white : Color.graphiteDark.opacity(0.6)
    }
}
