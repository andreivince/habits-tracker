import SwiftUI

@main
struct HabitsTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var habitStore = HabitStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 720, minHeight: 600)
                .environmentObject(habitStore)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
