import Foundation
import SwiftData

@Model
final class Cat {
    var id: UUID
    var name: String
    var breed: String?
    var birthDate: Date?
    var photoData: Data?
    var targetWeight: Double
    var startWeight: Double
    var weightUnit: WeightUnit
    var dailyCalorieGoal: Double?
    var dailyActivityMinutes: Int
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \WeightEntry.cat)
    var weightEntries: [WeightEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \FeedingSchedule.cat)
    var feedingSchedules: [FeedingSchedule] = []

    @Relationship(deleteRule: .cascade, inverse: \ActivitySession.cat)
    var activitySessions: [ActivitySession] = []

    init(
        name: String,
        breed: String? = nil,
        birthDate: Date? = nil,
        startWeight: Double,
        targetWeight: Double,
        weightUnit: WeightUnit = .lbs,
        dailyActivityMinutes: Int = 15
    ) {
        // Validation: weights must be positive
        assert(startWeight > 0, "Start weight must be positive")
        assert(targetWeight > 0, "Target weight must be positive")
        assert(!name.trimmingCharacters(in: .whitespaces).isEmpty, "Name cannot be empty")

        self.id = UUID()
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.breed = breed?.trimmingCharacters(in: .whitespaces)
        self.birthDate = birthDate
        // Coerce to valid range (safety fallback for release builds)
        self.startWeight = max(0.1, startWeight)
        self.targetWeight = max(0.1, targetWeight)
        self.weightUnit = weightUnit
        self.dailyActivityMinutes = max(0, dailyActivityMinutes)
        self.createdAt = Date()
    }

    // MARK: - Computed Properties

    var currentWeight: Double {
        weightEntries
            .sorted { $0.date > $1.date }
            .first?.weight ?? startWeight
    }

    var weightToLose: Double {
        max(0, currentWeight - targetWeight)
    }

    var progressPercentage: Double {
        let totalToLose = startWeight - targetWeight
        guard totalToLose > 0 else { return 100 }
        let lost = startWeight - currentWeight
        return min(100, max(0, (lost / totalToLose) * 100))
    }

    var weightTrend: WeightTrend {
        let recentEntries = weightEntries
            .sorted { $0.date > $1.date }
            .prefix(5)

        // Need at least 3 entries to calculate trend (compare recent vs older)
        guard recentEntries.count >= 3 else { return .insufficient }

        let weights = recentEntries.map { $0.weight }
        let avgRecent = weights.prefix(2).reduce(0, +) / 2

        // Safe division: only calculate if we have older entries
        let olderWeights = Array(weights.suffix(from: 2))
        guard !olderWeights.isEmpty else { return .insufficient }
        let avgOlder = olderWeights.reduce(0, +) / Double(olderWeights.count)

        let difference = avgRecent - avgOlder
        let threshold = 0.1 // 0.1 kg or lbs threshold

        if difference < -threshold {
            return .decreasing
        } else if difference > threshold {
            return .increasing
        } else {
            return .stable
        }
    }

    var age: String? {
        guard let birthDate = birthDate else { return nil }
        let components = Calendar.current.dateComponents([.year, .month], from: birthDate, to: Date())
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s")"
        } else if let months = components.month {
            return "\(months) month\(months == 1 ? "" : "s")"
        }
        return nil
    }

    var todayActivityMinutes: Int {
        let calendar = Calendar.current
        return activitySessions
            .filter { calendar.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    var activityGoalProgress: Double {
        guard dailyActivityMinutes > 0 else { return 0 }
        return min(1.0, Double(todayActivityMinutes) / Double(dailyActivityMinutes))
    }

    // MARK: - Weight Entry Management

    /// Logs a weight entry, overwriting any existing entry for the same calendar day.
    /// This ensures only one weight entry per day exists.
    /// - Returns: The entry that was created or updated
    @discardableResult
    func logWeight(_ weight: Double, on date: Date = Date(), notes: String? = nil) -> WeightEntry {
        let calendar = Calendar.current

        // Find existing entry for this calendar day
        if let existingEntry = weightEntries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            // Update existing entry
            existingEntry.weight = weight
            existingEntry.date = date
            existingEntry.notes = notes
            return existingEntry
        } else {
            // Create new entry
            let newEntry = WeightEntry(weight: weight, date: date, notes: notes)
            newEntry.cat = self
            weightEntries.append(newEntry)
            return newEntry
        }
    }

    /// Returns the weight entry for a specific date, if one exists
    func weightEntry(for date: Date) -> WeightEntry? {
        let calendar = Calendar.current
        return weightEntries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
