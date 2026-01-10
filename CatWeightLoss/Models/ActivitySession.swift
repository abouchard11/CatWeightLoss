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
        // Validation: duration must be positive
        assert(durationMinutes > 0, "Duration must be positive")

        self.id = UUID()
        self.date = date
        // Coerce to valid range (safety fallback for release builds)
        self.durationMinutes = max(1, durationMinutes)
        self.activityType = activityType
        self.intensityLevel = min(5, max(1, intensityLevel))
        self.notes = notes?.trimmingCharacters(in: .whitespaces)
    }

    var estimatedCaloriesBurned: Double {
        let baseCalories = activityType.caloriesPerMinute * Double(durationMinutes)
        let intensityMultiplier = 0.8 + (Double(intensityLevel) * 0.1) // 0.9 to 1.3
        return baseCalories * intensityMultiplier
    }

    var formattedDate: String {
        DateFormatting.formatDateTime(date)
    }

    var formattedDuration: String {
        DurationFormatting.format(minutes: durationMinutes)
    }
}
