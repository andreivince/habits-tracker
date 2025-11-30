import Foundation

enum TimeScope: String, CaseIterable, Identifiable {
    case weekly, monthly, yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .weekly: return "7 days"
        case .monthly: return "30 days"
        case .yearly: return "12 months"
        }
    }

    var tagline: String {
        switch self {
        case .weekly: return "Focused micro sprint"
        case .monthly: return "Momentum builder"
        case .yearly: return "Legacy streak"
        }
    }
}

struct HabitSnapshot {
    let scope: TimeScope
    let entries: [HabitEntry]
    let caption: String
    let currentStreak: Int
    let bestStreak: Int
    let completionRate: Double

    static func snapshot(for scope: TimeScope) -> HabitSnapshot {
        samples[scope] ?? samples[.weekly]!
    }

    private static let samples: [TimeScope: HabitSnapshot] = [
        .weekly: HabitSnapshot(
            scope: .weekly,
            entries: HabitEntry.weekly,
            caption: "You closed out \(HabitEntry.weekly.filter { $0.value >= 1 }.count) / 7 sessions.",
            currentStreak: 6,
            bestStreak: 21,
            completionRate: 0.86
        ),
        .monthly: HabitSnapshot(
            scope: .monthly,
            entries: HabitEntry.monthly,
            caption: "Momentum naps peaked twice — keep the cadence steady.",
            currentStreak: 14,
            bestStreak: 32,
            completionRate: 0.72
        ),
        .yearly: HabitSnapshot(
            scope: .yearly,
            entries: HabitEntry.yearly,
            caption: "Two plateaus broken this year. Next up: 90-day run.",
            currentStreak: 48,
            bestStreak: 79,
            completionRate: 0.64
        )
    ]
}

struct HabitEntry: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double
    let date: Date?
    
    init(label: String, value: Double, date: Date? = nil) {
        self.label = label
        self.value = value
        self.date = date
    }
}

extension HabitEntry {
    static let weekly: [HabitEntry] = [
        HabitEntry(label: "Mon", value: 1.0),
        HabitEntry(label: "Tue", value: 0.6),
        HabitEntry(label: "Wed", value: 1.2),
        HabitEntry(label: "Thu", value: 0.9),
        HabitEntry(label: "Fri", value: 1.4),
        HabitEntry(label: "Sat", value: 1.0),
        HabitEntry(label: "Sun", value: 1.3)
    ]

    static let monthly: [HabitEntry] = [
        HabitEntry(label: "Week 1", value: 0.9),
        HabitEntry(label: "Week 2", value: 1.1),
        HabitEntry(label: "Week 3", value: 0.7),
        HabitEntry(label: "Week 4", value: 1.2)
    ]

    static let yearly: [HabitEntry] = [
        HabitEntry(label: "Jan", value: 0.8),
        HabitEntry(label: "Feb", value: 1.1),
        HabitEntry(label: "Mar", value: 0.95),
        HabitEntry(label: "Apr", value: 1.2),
        HabitEntry(label: "May", value: 1.05),
        HabitEntry(label: "Jun", value: 0.9),
        HabitEntry(label: "Jul", value: 1.3),
        HabitEntry(label: "Aug", value: 1.25),
        HabitEntry(label: "Sep", value: 0.85),
        HabitEntry(label: "Oct", value: 1.4),
        HabitEntry(label: "Nov", value: 1.1),
        HabitEntry(label: "Dec", value: 1.32)
    ]
}

struct HabitDay: Identifiable {
    let id = UUID()
    let label: String
    let level: Int
    let highlight: Bool
}

extension HabitDay {
    static let lastFourWeeks: [HabitDay] = [
        HabitDay(label: "Su", level: 0, highlight: false),
        HabitDay(label: "Mo", level: 1, highlight: false),
        HabitDay(label: "Tu", level: 2, highlight: false),
        HabitDay(label: "We", level: 3, highlight: true),
        HabitDay(label: "Th", level: 1, highlight: false),
        HabitDay(label: "Fr", level: 2, highlight: false),
        HabitDay(label: "Sa", level: 0, highlight: false),
        HabitDay(label: "Su", level: 1, highlight: false),
        HabitDay(label: "Mo", level: 3, highlight: true),
        HabitDay(label: "Tu", level: 2, highlight: false),
        HabitDay(label: "We", level: 1, highlight: false),
        HabitDay(label: "Th", level: 0, highlight: false),
        HabitDay(label: "Fr", level: 3, highlight: true),
        HabitDay(label: "Sa", level: 2, highlight: false),
        HabitDay(label: "Su", level: 1, highlight: false),
        HabitDay(label: "Mo", level: 0, highlight: false),
        HabitDay(label: "Tu", level: 1, highlight: false),
        HabitDay(label: "We", level: 2, highlight: false),
        HabitDay(label: "Th", level: 2, highlight: false),
        HabitDay(label: "Fr", level: 3, highlight: true),
        HabitDay(label: "Sa", level: 1, highlight: false),
        HabitDay(label: "Su", level: 0, highlight: false),
        HabitDay(label: "Mo", level: 2, highlight: false),
        HabitDay(label: "Tu", level: 3, highlight: true),
        HabitDay(label: "We", level: 2, highlight: false),
        HabitDay(label: "Th", level: 1, highlight: false),
        HabitDay(label: "Fr", level: 0, highlight: false),
        HabitDay(label: "Sa", level: 3, highlight: true)
    ]
}

struct HabitPlan: Identifiable {
    let id = UUID()
    let title: String
    let cadence: String
    let progress: Double
}

extension HabitPlan {
    static let samples: [HabitPlan] = [
        HabitPlan(title: "Deep work focus", cadence: "Weekdays • 2 sessions", progress: 0.78),
        HabitPlan(title: "Morning run", cadence: "4x per week", progress: 0.62),
        HabitPlan(title: "Digital sunset", cadence: "Nightly • 30 min", progress: 0.88),
        HabitPlan(title: "Mindfulness journal", cadence: "Daily • 5 prompts", progress: 0.55)
    ]
}
