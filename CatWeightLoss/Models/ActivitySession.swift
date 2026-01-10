import Foundation
import SwiftData

@Model
final class ActivitySession {
    var id: UUID
    var date: Date
    var durationMinutes: Int
    var activityType: ActivityType
    var intensityLevel: Int // 1-5
    var notes: String?
    var cat: Cat?

    init(
        date: Date = Date(),
        durationMinutes: Int,
        activityType: ActivityType,
        intensityLevel: Int = 3,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.durationMinutes = durationMinutes
        self.activityType = activityType
        self.intensityLevel = min(5, max(1, intensityLevel))
        self.notes = notes
    }

    var estimatedCaloriesBurned: Double {
        let baseCalories = activityType.caloriesPerMinute * Double(durationMinutes)
        let intensityMultiplier = 0.8 + (Double(intensityLevel) * 0.1) // 0.9 to 1.3
        return baseCalories * intensityMultiplier
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        if durationMinutes >= 60 {
            let hours = durationMinutes / 60
            let mins = durationMinutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
        return "\(durationMinutes) min"
    }
}
