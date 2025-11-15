import SwiftUI

struct ManageHabitsSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var habitStore: HabitStore

    @State private var showingForm = false
    @State private var habitToEdit: Habit?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Manage habits")
                        .adaptiveFont(.title3)
                        .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                    Text("Tune cadence, pause rituals, and archive what no longer serves.")
                        .adaptiveFont(.subheadline)
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
                    HabitRow(
                        habit: habit,
                        onEdit: {
                            habitToEdit = habit
                            showingForm = true
                        },
                        onDelete: {
                            habitStore.delete(habit)
                        }
                    )
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(AdaptiveColor.cardBackground(colorScheme))
                .shadow(color: AdaptiveColor.cardShadow(colorScheme).opacity(0.08), radius: 28, x: 0, y: 18)
        )
        .sheet(isPresented: $showingForm, onDismiss: {
            habitToEdit = nil
        }) {
            HabitFormSheet(habitToEdit: habitToEdit, onSave: { habit in
                if habitToEdit != nil {
                    habitStore.update(habit)
                } else {
                    habitStore.create(
                        title: habit.title,
                        cadence: habit.cadence,
                        trackingType: habit.trackingType,
                        goalMinutes: habit.goalMinutes
                    )
                }
                habitToEdit = nil
            })
        }
    }
}

private struct HabitRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let habit: Habit
    let onEdit: () -> Void
    let onDelete: () -> Void

    private var cadenceText: String {
        let days = habit.cadence.sorted(by: { $0.calendarWeekday < $1.calendarWeekday })
        return days.map { $0.short }.joined(separator: ", ")
    }

    private var trackingTypeText: String {
        if habit.trackingType == .minutes {
            if let goal = habit.goalMinutes {
                return "\(goal) min"
            }
            return "Minutes"
        }
        return "Check-in"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(habit.title)
                    .adaptiveFont(.headline)
                    .foregroundStyle(AdaptiveColor.graphite(colorScheme))
                HStack(spacing: 8) {
                    Text(cadenceText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.5))
                    HStack(spacing: 4) {
                        Image(systemName: habit.trackingType == .minutes ? "clock" : "checkmark.circle")
                            .font(.caption2)
                        Text(trackingTypeText)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
            HStack(spacing: 8) {
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.title3)
                        .foregroundStyle(AdaptiveColor.graphite(colorScheme).opacity(0.6))
                        .padding(10)
                        .background(AdaptiveColor.habitRowButton(colorScheme), in: Circle())
                }
                .buttonStyle(.plain)

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
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AdaptiveColor.habitRowBackground(colorScheme))
        )
    }
}
