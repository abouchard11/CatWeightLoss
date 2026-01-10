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
        self.id = UUID()
        self.name = name
        self.breed = breed
        self.birthDate = birthDate
        self.startWeight = startWeight
        self.targetWeight = targetWeight
        self.weightUnit = weightUnit
        self.dailyActivityMinutes = dailyActivityMinutes
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

        guard recentEntries.count >= 2 else { return .insufficient }

        let weights = recentEntries.map { $0.weight }
        let avgRecent = weights.prefix(2).reduce(0, +) / 2
        let avgOlder = weights.suffix(from: 2).reduce(0, +) / Double(weights.count - 2)

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
}
