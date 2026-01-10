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
        self.id = UUID()
        self.weight = weight
        self.date = date
        self.notes = notes
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    var formattedWeight: String {
        String(format: "%.2f", weight)
    }
}
