import Foundation

@MainActor
final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] = []

    private let storageKey = "habits"

    init() {
        load()
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
}
