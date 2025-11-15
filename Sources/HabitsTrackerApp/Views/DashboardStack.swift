import SwiftUI

struct DashboardStack: View {
    @EnvironmentObject private var habitStore: HabitStore
    let snapshot: HabitSnapshot
    @Binding var selectedScope: TimeScope

    private var habitDays: [HabitDay] {
        HabitDayBuilder.buildLast4Weeks(from: habitStore.habits)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            StreakMatrixView(days: habitDays)
            ProgressPanel(snapshot: snapshot, selectedScope: $selectedScope)
        }
    }
}
