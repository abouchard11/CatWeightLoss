import Foundation
import SwiftData

@Model
final class FeedingSchedule {
    var id: UUID
    var mealName: String
    var mealTime: Date
    var portionGrams: Double
    var foodType: FoodType
    var caloriesPerPortion: Double
    var isEnabled: Bool
    var notificationEnabled: Bool
    var cat: Cat?

    init(
        mealName: String = "Meal",
        mealTime: Date,
        portionGrams: Double,
        foodType: FoodType = .dry,
        caloriesPerPortion: Double? = nil,
        isEnabled: Bool = true,
        notificationEnabled: Bool = true
    ) {
        self.id = UUID()
        self.mealName = mealName
        self.mealTime = mealTime
        self.portionGrams = portionGrams
        self.foodType = foodType
        self.caloriesPerPortion = caloriesPerPortion ?? (portionGrams * foodType.averageCaloriesPerGram)
        self.isEnabled = isEnabled
        self.notificationEnabled = notificationEnabled
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: mealTime)
    }

    var timeComponents: DateComponents {
        Calendar.current.dateComponents([.hour, .minute], from: mealTime)
    }
}
