import Foundation

struct HabitSnapshotBuilder {
    static func build(from habits: [Habit], scope: TimeScope) -> HabitSnapshot {
        let entries = buildEntries(from: habits, scope: scope)
        let streaks = calculateStreaks(from: habits)
        let completion = calculateCompletion(from: habits, scope: scope)

        return HabitSnapshot(
            scope: scope,
            entries: entries,
            caption: buildCaption(habits: habits, scope: scope),
            currentStreak: streaks.current,
            bestStreak: streaks.best,
            completionRate: completion
        )
    }

    private static func buildEntries(from habits: [Habit], scope: TimeScope) -> [HabitEntry] {
        let today = Date().startOfDay
        let daysCount: Int

        switch scope {
        case .weekly: daysCount = 7
        case .monthly: daysCount = 30
        case .yearly: return buildYearlyEntries(from: habits)
        }

        return (0..<daysCount).map { offset in
            let date = today.addingDays(-daysCount + offset + 1)
            let value = calculateDayValue(for: date, habits: habits)
            let label = formatLabel(for: date, scope: scope)
            return HabitEntry(label: label, value: value)
        }
    }

    private static func buildYearlyEntries(from habits: [Habit]) -> [HabitEntry] {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)

        return (1...12).map { month in
            var components = DateComponents()
            components.year = currentYear
            components.month = month
            components.day = 1

            guard let monthStart = calendar.date(from: components),
                  let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
                return HabitEntry(label: monthLabel(month), value: 0)
            }

            let value = calculateMonthValue(start: monthStart, end: monthEnd, habits: habits)
            return HabitEntry(label: monthLabel(month), value: value)
        }
    }

    private static func calculateDayValue(for date: Date, habits: [Habit]) -> Double {
        var totalChecked = 0
        var totalActive = 0

        for habit in habits where date >= habit.startDate.startOfDay {
            guard habit.isActiveDay(date) else { continue }
            totalActive += 1
            if habit.isCheckedIn(on: date) {
                totalChecked += 1
            }
        }

        guard totalActive > 0 else { return 0 }
        return Double(totalChecked) / Double(totalActive)
    }

    private static func calculateMonthValue(start: Date, end: Date, habits: [Habit]) -> Double {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0

        var totalValue = 0.0
        for dayOffset in 0...days {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: start) else { continue }
            totalValue += calculateDayValue(for: date, habits: habits)
        }

        return days > 0 ? totalValue / Double(days + 1) : 0
    }

    private static func calculateStreaks(from habits: [Habit]) -> (current: Int, best: Int) {
        let today = Date().startOfDay
        var currentStreak = 0
        var bestStreak = 0
        var tempStreak = 0

        for dayOffset in (0..<365).reversed() {
            let date = today.addingDays(-dayOffset)
            var dayComplete = false

            for habit in habits where date >= habit.startDate.startOfDay {
                guard habit.isActiveDay(date) else { continue }
                if habit.isCheckedIn(on: date) {
                    dayComplete = true
                    break
                }
            }

            if dayComplete {
                tempStreak += 1
                bestStreak = max(bestStreak, tempStreak)
                if dayOffset == 0 { currentStreak = tempStreak }
            } else {
                if dayOffset == 0 { currentStreak = 0 }
                tempStreak = 0
            }
        }

        return (currentStreak, bestStreak)
    }

    private static func calculateCompletion(from habits: [Habit], scope: TimeScope) -> Double {
        let today = Date().startOfDay
        let daysCount = scope == .weekly ? 7 : (scope == .monthly ? 30 : 365)

        var totalChecked = 0
        var totalActive = 0

        for dayOffset in 0..<daysCount {
            let date = today.addingDays(-daysCount + dayOffset + 1)
            for habit in habits where date >= habit.startDate.startOfDay {
                guard habit.isActiveDay(date) else { continue }
                totalActive += 1
                if habit.isCheckedIn(on: date) {
                    totalChecked += 1
                }
            }
        }

        guard totalActive > 0 else { return 0 }
        return Double(totalChecked) / Double(totalActive)
    }

    private static func buildCaption(habits: [Habit], scope: TimeScope) -> String {
        guard !habits.isEmpty else { return "No habits tracked yet" }
        let completion = calculateCompletion(from: habits, scope: scope)
        return "You're at \(Int(completion * 100))% completion this \(scope.title.lowercased())"
    }

    private static func formatLabel(for date: Date, scope: TimeScope) -> String {
        let formatter = DateFormatter()
        switch scope {
        case .weekly:
            formatter.dateFormat = "EEE"
            return String(formatter.string(from: date).prefix(3))
        case .monthly:
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        case .yearly:
            formatter.dateFormat = "MMM"
            return formatter.string(from: date)
        }
    }

    private static func monthLabel(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        var components = DateComponents()
        components.month = month
        guard let date = Calendar.current.date(from: components) else { return "" }
        return formatter.string(from: date)
    }
}
