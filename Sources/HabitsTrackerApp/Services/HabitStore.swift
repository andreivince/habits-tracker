import Foundation
import Combine

@MainActor
final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] = []
    @Published private(set) var currentDay: Date = Date().startOfDay

    private let storageKey = "habits"
    private var midnightTimer: Timer?

    init() {
        load()
        scheduleMidnightTimer()
    }

    func create(title: String, cadence: Set<Weekday>, trackingType: HabitTrackingType = .boolean, goalMinutes: Int? = nil) {
        let habit = Habit(title: title, cadence: cadence, trackingType: trackingType, goalMinutes: goalMinutes)
        habits.append(habit)
        save()
    }

    func update(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        save()
    }

    func delete(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        save()
    }

    func toggleCheckIn(for habit: Habit, on date: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].toggleCheckIn(on: date)
        save()
    }

    func addMinutes(_ minutes: Int, for habit: Habit, on date: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].addMinutes(minutes, on: date)
        save()
    }

    func incrementOrResetMinutes(for habit: Habit, on date: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].incrementOrResetMinutes(on: date)
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Habit].self, from: data) else { return }
        habits = decoded
    }

    private func scheduleMidnightTimer() {
        midnightTimer?.invalidate()

        let now = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now.startOfDay)!
        let timeUntilMidnight = tomorrow.timeIntervalSince(now)

        midnightTimer = Timer.scheduledTimer(withTimeInterval: timeUntilMidnight, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateCurrentDay()
            }
        }
    }

    private func updateCurrentDay() {
        currentDay = Date().startOfDay
        scheduleMidnightTimer()
    }

    func refreshIfNeeded() {
        let today = Date().startOfDay
        if currentDay != today {
            updateCurrentDay()
        }
    }

    func resetHistory() {
        let today = Date()
        for index in habits.indices {
            habits[index].checkIns.removeAll()
            habits[index].minutesLog.removeAll()
            habits[index].startDate = today
        }
        save()
    }
}
