import Foundation
import UniformTypeIdentifiers

@MainActor
final class HabitExportService {
    static func generateCSV(habits: [Habit]) -> String {
        guard !habits.isEmpty else {
            return "No habits to export"
        }

        // Determine date range
        let today = Date().startOfDay
        let earliestDate = habits.map { $0.startDate.startOfDay }.min() ?? today

        // Generate all dates from earliest to today
        var dates: [Date] = []
        var currentDate = earliestDate
        while currentDate <= today {
            dates.append(currentDate)
            currentDate = currentDate.addingDays(1)
        }

        // Build CSV header
        var csv = "Date"
        for habit in habits {
            csv += ",\(escapeCSV(habit.title))"
        }
        csv += "\n"

        // Build CSV rows
        for date in dates {
            csv += date.dateString

            for habit in habits {
                csv += ","

                if !habit.isActiveDay(date) {
                    csv += "REST DAY"
                } else {
                    let completionValue = habit.completionValue(on: date)
                    let percentage = Int(completionValue * 100)
                    csv += "\(percentage)%"
                }
            }

            csv += "\n"
        }

        return csv
    }

    static func exportToFile(habits: [Habit]) -> URL? {
        let csv = generateCSV(habits: habits)

        // Create filename with timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        let filename = "habits_export_\(timestamp).csv"

        // Get temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(filename)

        // Write to file
        do {
            try csv.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error writing CSV file: \(error)")
            return nil
        }
    }

    private static func escapeCSV(_ field: String) -> String {
        if field.contains(",") || field.contains("\"") || field.contains("\n") {
            let escaped = field.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escaped)\""
        }
        return field
    }
}
