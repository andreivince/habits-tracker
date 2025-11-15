import Foundation

struct Habit: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var cadence: Set<Weekday>
    let startDate: Date
    var checkIns: Set<String>

    init(id: UUID = UUID(), title: String, cadence: Set<Weekday>, startDate: Date = Date(), checkIns: Set<String> = []) {
        self.id = id
        self.title = title
        self.cadence = cadence
        self.startDate = startDate
        self.checkIns = checkIns
    }

    func isCheckedIn(on date: Date) -> Bool {
        checkIns.contains(date.dateString)
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

