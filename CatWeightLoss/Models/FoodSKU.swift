import Foundation
import SwiftData

@Model
final class FoodSKU {
    var id: UUID
    var skuId: String
    var displayName: String
    var caloriesPerGram: Double
    var servingSizeGrams: Double
    var bagSizeGrams: Double  // For reorder prediction (e.g., 3500g for 7.7lb bag)
    var productImageData: Data?
    var createdAt: Date

    var brand: BrandConfiguration?

    init(
        skuId: String,
        displayName: String,
        caloriesPerGram: Double,
        servingSizeGrams: Double = 35.0,
        bagSizeGrams: Double = 3500.0,  // Default: ~7.7 lb bag
        productImageData: Data? = nil
    ) {
        self.id = UUID()
        self.skuId = skuId
        self.displayName = displayName
        self.caloriesPerGram = caloriesPerGram
        self.servingSizeGrams = servingSizeGrams
        self.bagSizeGrams = bagSizeGrams
        self.productImageData = productImageData
        self.createdAt = Date()
    }

    // MARK: - Computed Properties

    /// Calories in one standard serving
    var caloriesPerServing: Double {
        caloriesPerGram * servingSizeGrams
    }

    /// Grams needed for a given calorie target
    func gramsForCalories(_ calories: Double) -> Double {
        guard caloriesPerGram > 0 else { return 0 }
        return calories / caloriesPerGram
    }

    /// Number of servings for a given calorie target
    func servingsForCalories(_ calories: Double) -> Double {
        guard caloriesPerServing > 0 else { return 0 }
        return calories / caloriesPerServing
    }

    /// Formatted serving description
    var formattedServing: String {
        String(format: "%.0fg (%.0f kcal)", servingSizeGrams, caloriesPerServing)
    }
}
