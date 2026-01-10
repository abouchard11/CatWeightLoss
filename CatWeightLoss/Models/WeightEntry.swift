import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var weight: Double
    var date: Date
    var notes: String?
    var cat: Cat?

    init(weight: Double, date: Date = Date(), notes: String? = nil) {
        // Validation: weight must be positive
        assert(weight > 0, "Weight must be positive")

        self.id = UUID()
        // Coerce to valid range (safety fallback for release builds)
        self.weight = max(0.1, weight)
        self.date = date
        self.notes = notes?.trimmingCharacters(in: .whitespaces)
    }

    var formattedDate: String {
        DateFormatting.formatDate(date)
    }

    var formattedWeight: String {
        String(format: "%.2f", weight)
    }
}
