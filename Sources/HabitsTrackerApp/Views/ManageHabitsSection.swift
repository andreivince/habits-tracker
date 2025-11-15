import SwiftUI

struct ManageHabitsSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore

    @State private var showingForm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Manage habits")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                    Text("Tune cadence, pause rituals, and archive what no longer serves.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    showingForm = true
                } label: {
                    Label("New habit", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(AdaptiveColor.tabBarSelected(colorScheme), in: Capsule())
                        .foregroundStyle(AdaptiveColor.tabBarSelectedText(colorScheme))
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 16) {
                ForEach(habitStore.habits) { habit in
                    HabitRow(habit: habit, onDelete: {
                        habitStore.delete(habit)
                    })
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(AdaptiveColor.cardBackground(colorScheme))
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.08), radius: 28, x: 0, y: 18)
        )
        .sheet(isPresented: $showingForm) {
            HabitFormSheet(onSave: { title, selectedDays in
                habitStore.create(title: title, cadence: selectedDays)
            })
        }
    }
}

private struct HabitRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let habit: Habit
    let onDelete: () -> Void

    private var cadenceText: String {
        let days = habit.cadence.sorted(by: { $0.calendarWeekday < $1.calendarWeekday })
        return days.map { $0.short }.joined(separator: ", ")
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                Text(cadenceText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.title3)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.6))
                    .padding(10)
                    .background(AdaptiveColor.habitRowButton(colorScheme), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AdaptiveColor.habitRowBackground(colorScheme))
        )
    }
}
