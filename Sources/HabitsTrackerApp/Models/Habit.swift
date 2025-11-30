import Foundation

enum HabitTrackingType: String, Codable, Hashable {
    case boolean
    case minutes
}

struct Habit: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var cadence: Set<Weekday>
    var startDate: Date
    var checkIns: Set<String>
    var trackingType: HabitTrackingType
    var minutesLog: [String: Int]
    var goalMinutes: Int?

    init(
        id: UUID = UUID(),
        title: String,
        cadence: Set<Weekday>,
        startDate: Date = Date(),
        checkIns: Set<String> = [],
        trackingType: HabitTrackingType = .boolean,
        minutesLog: [String: Int] = [:],
        goalMinutes: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.cadence = cadence
        self.startDate = startDate
        self.checkIns = checkIns
        self.trackingType = trackingType
        self.minutesLog = minutesLog
        self.goalMinutes = goalMinutes
    }

    func isCheckedIn(on date: Date) -> Bool {
        if trackingType == .minutes {
            return (minutesLog[date.dateString] ?? 0) > 0
        }
        return checkIns.contains(date.dateString)
    }

    func minutes(on date: Date) -> Int {
        minutesLog[date.dateString] ?? 0
    }

    func completionValue(on date: Date) -> Double {
        if trackingType == .minutes, let goal = goalMinutes, goal > 0 {
            let current = Double(minutes(on: date))
            return min(current / Double(goal), 1.0)
        }
        return isCheckedIn(on: date) ? 1.0 : 0.0
    }

    func isActiveDay(_ date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdayEnum = Weekday.from(weekday)
        return cadence.contains(weekdayEnum)
    }

    mutating func toggleCheckIn(on date: Date) {
        let dateString = date.dateString
        if checkIns.contains(dateString) {
            checkIns.remove(dateString)
        } else {
            checkIns.insert(dateString)
        }
    }

    mutating func addMinutes(_ minutes: Int, on date: Date) {
        let dateString = date.dateString
        let current = minutesLog[dateString] ?? 0
        minutesLog[dateString] = current + minutes
    }

    mutating func incrementOrResetMinutes(on date: Date) {
        let dateString = date.dateString
        let current = minutesLog[dateString] ?? 0

        if let goal = goalMinutes, current >= goal {
            minutesLog[dateString] = 0
        } else {
            minutesLog[dateString] = current + 5
        }
    }

    mutating func reset() {
        checkIns.removeAll()
        minutesLog.removeAll()
        startDate = Date()
    }

    func historyEntries() -> [HabitEntry] {
        var entries: [HabitEntry] = []
        var date = Date().startOfDay
        let start = startDate.startOfDay
        
        // Safety cap to prevent infinite loops if startDate is corrupted or way in past
        let maxDays = 365 * 5 
        var daysChecked = 0
        
        while date >= start && daysChecked < maxDays {
            if isActiveDay(date) {
                let value = completionValue(on: date)
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d"
                let label = formatter.string(from: date)
                entries.append(HabitEntry(label: label, value: value, date: date))
            }
            date = date.addingDays(-1)
            daysChecked += 1
        }
        
        return entries.reversed()
    }
}

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    static func from(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
