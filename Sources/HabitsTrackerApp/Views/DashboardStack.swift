import SwiftUI

struct DashboardStack: View {
    let snapshot: HabitSnapshot
    @Binding var selectedScope: TimeScope

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            TodayTasksView()
            ProgressPanel(snapshot: snapshot, selectedScope: $selectedScope)
        }
    }
}
