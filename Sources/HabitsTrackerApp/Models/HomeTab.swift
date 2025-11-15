import Foundation

enum HomeTab: String, CaseIterable, Identifiable {
    case dashboard
    case manage

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: return "Overview"
        case .manage: return "Manage"
        }
    }

    static func greeting(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
}
