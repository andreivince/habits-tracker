import Foundation

struct HabitDayBuilder {
    static func buildLast4Weeks(from habits: [Habit]) -> [HabitDay] {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let daysCount = 28

        return (0..<daysCount).map { offset in
            let date = today.addingDays(-daysCount + offset + 1)
            let weekday = calendar.component(.weekday, from: date)
            let label = dayLabel(for: weekday)
            let level = calculateLevel(for: date, habits: habits)
            let highlight = calendar.isDate(date, inSameDayAs: today)

            return HabitDay(label: label, level: level, highlight: highlight)
        }
    }

    private static func calculateLevel(for date: Date, habits: [Habit]) -> Int {
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

        let percentage = Double(totalChecked) / Double(totalActive)
        if percentage >= 1.0 { return 3 }
        if percentage >= 0.66 { return 2 }
        if percentage >= 0.33 { return 1 }
        return 0
    }

    private static func dayLabel(for weekday: Int) -> String {
        switch weekday {
        case 1: return "Su"
        case 2: return "Mo"
        case 3: return "Tu"
        case 4: return "We"
        case 5: return "Th"
        case 6: return "Fr"
        case 7: return "Sa"
        default: return ""
        }
    }
}
