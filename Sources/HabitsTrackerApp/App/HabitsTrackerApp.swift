import SwiftUI

@main
struct HabitsTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 720, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
