import SwiftUI

struct TodayTasksView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore
    @State private var dayOffset: Int = 0
    
    private var selectedDate: Date {
        habitStore.currentDay.addingDays(dayOffset)
    }
    
    private var isToday: Bool {
        dayOffset == 0
    }

    private var selectedDayHabits: [Habit] {
        habitStore.habits.filter { $0.isActiveDay(selectedDate) && selectedDate >= $0.startDate.startOfDay }
    }
    
    private var dailyCompletionPercent: Int {
        guard !selectedDayHabits.isEmpty else { return 0 }
        let total = selectedDayHabits.reduce(0.0) { $0 + $1.completionValue(on: selectedDate) }
        return Int((total / Double(selectedDayHabits.count)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 12) {
                        Text(isToday ? "Today" : (dayOffset == -1 ? "Yesterday" : formattedDate))
                            .adaptiveFont(.title3)
                            .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                        
                        HStack(spacing: 4) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    dayOffset -= 1
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            
                            if !isToday {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        dayOffset = min(dayOffset + 1, 0)
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    Text(dateSubtitle)
                        .adaptiveFont(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if !selectedDayHabits.isEmpty {
                    Text("\(dailyCompletionPercent)%")
                        .font(.title2.weight(.bold).monospacedDigit())
                        .foregroundStyle(dailyCompletionPercent >= 100 ? .green : AdaptiveColor.graphite(colorScheme))
                }
            }

            if selectedDayHabits.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary.opacity(0.3))
                    Text("No habits scheduled for \(isToday ? "today" : "this day")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(isToday ? "Enjoy your rest day!" : "Nothing to track here")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(selectedDayHabits) { habit in
                        TodayHabitRow(habit: habit, date: selectedDate)
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

    private var dateSubtitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: selectedDate)
    }
}

private struct TodayHabitRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore
    let habit: Habit
    let date: Date

    private var isCheckedIn: Bool {
        habit.isCheckedIn(on: date)
    }

    private var currentMinutes: Int {
        habit.minutes(on: date)
    }

    var body: some View {
        Button {
            if habit.trackingType == .minutes {
                habitStore.incrementOrResetMinutes(for: habit, on: date)
            } else {
                habitStore.toggleCheckIn(for: habit, on: date)
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
