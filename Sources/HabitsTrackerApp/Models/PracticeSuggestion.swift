import Foundation

struct PracticeSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

extension PracticeSuggestion {
    static let samples: [PracticeSuggestion] = [
        PracticeSuggestion(title: "Gratitude", subtitle: "2 min reset", icon: "hands.sparkles"),
        PracticeSuggestion(title: "Deep breath", subtitle: "4 cycles", icon: "wind"),
        PracticeSuggestion(title: "Stretch", subtitle: "3 poses", icon: "figure.cooldown"),
        PracticeSuggestion(title: "Focus", subtitle: "10 min sprint", icon: "bolt.fill"),
        PracticeSuggestion(title: "Sleep prep", subtitle: "Wind down", icon: "moon.stars.fill"),
        PracticeSuggestion(title: "Journal", subtitle: "5 prompts", icon: "pencil"),
        PracticeSuggestion(title: "Hydrate", subtitle: "Glass of water", icon: "drop.fill"),
        PracticeSuggestion(title: "Walk", subtitle: "Steps burst", icon: "figure.walk"),
    ]
}
