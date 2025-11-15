import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var habitStore: HabitStore
    @State private var selectedScope: TimeScope = .weekly
    @State private var selectedTab: HomeTab = .dashboard
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("userName") private var userName = "Andrei Vince"
    @AppStorage("useSerifFont") private var useSerifFont = false
    @State private var showingSettings = false

    private var snapshot: HabitSnapshot {
        HabitSnapshotBuilder.build(from: habitStore.habits, scope: selectedScope)
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
                            ManageHabitsSection()
                        }
                    }
                }
                .padding(.vertical, 44)
                .padding(.horizontal, 48)
                .frame(maxWidth: 940)
                .frame(maxWidth: .infinity)
            }

            VStack {
                HStack {
                    Spacer()
                    ThemeToggleButton(isDarkMode: $isDarkMode, showingSettings: $showingSettings)
                        .padding(.top, 48)
                        .padding(.trailing, 48)
                }
                Spacer()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.useSerifFont, useSerifFont)
        .sheet(isPresented: $showingSettings) {
            SettingsSheet(userName: $userName, useSerifFont: $useSerifFont)
                .environment(\.useSerifFont, useSerifFont)
        }
    }
}
