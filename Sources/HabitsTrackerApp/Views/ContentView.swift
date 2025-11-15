import SwiftUI

struct ContentView: View {
    @State private var selectedScope: TimeScope = .weekly
    @State private var selectedTab: HomeTab = .dashboard

    private let userName = "Andrei Vince"

    private var snapshot: HabitSnapshot {
        HabitSnapshot.snapshot(for: selectedScope)
    }

    private var greetingTitle: String {
        HomeTab.greeting(for: Date())
    }

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    GreetingSection(title: "\(greetingTitle), \(userName)", subtitle: "Micro actions compound. Track the ritual and the streak rewards you.")
                    HomeTabBar(selection: $selectedTab)
                    Group {
                        switch selectedTab {
                        case .dashboard:
                            DashboardStack(snapshot: snapshot, selectedScope: $selectedScope)
                        case .manage:
                            ManageHabitsSection(habits: HabitPlan.samples)
                        }
                    }
                }
                .padding(.vertical, 44)
                .padding(.horizontal, 48)
                .frame(maxWidth: 940)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
