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
                        },
                        onReset: {
                            var updatedHabit = habit
                            updatedHabit.reset()
                            habitStore.update(updatedHabit)
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
    @State private var isExpanded = false
    @State private var showingResetAlert = false
    
    let habit: Habit
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onReset: () -> Void

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
        VStack(spacing: 0) {
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
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chart.xyaxis.line")
                            .font(.title3)
                            .foregroundStyle(isExpanded ? AdaptiveColor.tabBarSelected(colorScheme) : AdaptiveColor.graphite(colorScheme).opacity(0.6))
                            .padding(10)
                            .background(AdaptiveColor.habitRowButton(colorScheme), in: Circle())
                    }
                    .buttonStyle(.plain)

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

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Consistency")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button {
                            showingResetAlert = true
                        } label: {
                            Text("Reset history")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.red.opacity(0.8))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)

                    LineGraphView(
                        entries: habit.historyEntries(),
                        accent: AdaptiveColor.tabBarSelected(colorScheme)
                    )
                    .frame(height: 100)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .transition(.opacity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AdaptiveColor.habitRowBackground(colorScheme))
        )
        .alert("Reset Habit History?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                withAnimation {
                    onReset()
                    // Keep expanded to show the empty graph? Or collapse?
                    // Let's keep it expanded so user sees the effect (graph clears).
                }
            }
        } message: {
            Text("This will permanently delete all check-ins and minutes for this habit, and restart tracking from today.")
        }
    }
}
