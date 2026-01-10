import Foundation

struct PortionCalculator {

    /// Calculate Resting Energy Requirement (RER) for a cat
    /// Formula: RER = 70 × (body weight in kg)^0.75
    static func restingEnergyRequirement(weightKg: Double) -> Double {
        return 70 * pow(weightKg, 0.75)
    }

    /// Calculate Maintenance Energy Requirement (MER)
    /// For indoor cats: MER = RER × 1.2
    /// For active cats: MER = RER × 1.4
    static func maintenanceEnergyRequirement(weightKg: Double, isActive: Bool = false) -> Double {
        let rer = restingEnergyRequirement(weightKg: weightKg)
        let factor = isActive ? 1.4 : 1.2
        return rer * factor
    }

    /// Calculate daily calories for gradual progress
    /// Uses standard 15% reduction from maintenance
    static func weightLossCalories(
        currentWeightKg: Double,
        targetWeightKg: Double,
        aggressiveness: WeightLossAggressiveness = .moderate
    ) -> DailyCalorieRecommendation {
        let mer = maintenanceEnergyRequirement(weightKg: currentWeightKg)

        // Fixed 15% reduction - no user choice to avoid liability
        let reductionFactor = 0.85

        let targetCalories = mer * reductionFactor

        // Minimum calories (never go below RER)
        let rer = restingEnergyRequirement(weightKg: currentWeightKg)
        let safeCalories = max(targetCalories, rer)

        return DailyCalorieRecommendation(
            calories: safeCalories,
            mer: mer,
            rer: rer,
            reductionPercentage: (1 - reductionFactor) * 100
        )
    }

    /// Validate target weight is within safe bounds
    /// Max 30% total loss, target must be less than current
    static func validateTargetWeight(current: Double, target: Double) -> Bool {
        let maxLoss = current * 0.30
        return target >= (current - maxLoss) && target < current && target > 0
    }

    /// Calculate portion sizes for a given daily calorie goal
    static func portionSizes(
        dailyCalories: Double,
        mealsPerDay: Int,
        foodType: FoodType
    ) -> PortionRecommendation {
        let caloriesPerMeal = dailyCalories / Double(mealsPerDay)
        let gramsPerMeal = caloriesPerMeal / foodType.averageCaloriesPerGram

        return PortionRecommendation(
            gramsPerMeal: gramsPerMeal,
            caloriesPerMeal: caloriesPerMeal,
            totalDailyGrams: gramsPerMeal * Double(mealsPerDay),
            totalDailyCalories: dailyCalories,
            mealsPerDay: mealsPerDay,
            foodType: foodType
        )
    }

    /// Convert weight between units
    static func convertWeight(_ weight: Double, from: WeightUnit, to: WeightUnit) -> Double {
        from.convert(weight, to: to)
    }
}

// MARK: - Supporting Types

enum WeightLossAggressiveness: String, CaseIterable {
    case moderate = "Standard"

    var weeklyLossPercentage: Double {
        return 1.0  // Fixed at 1% - safe ceiling
    }

    // Maximum allowed weekly loss percentage (hard ceiling)
    static let maxWeeklyLossPercentage = 2.0
}

struct DailyCalorieRecommendation {
    let calories: Double
    let mer: Double
    let rer: Double
    let reductionPercentage: Double

    var formattedCalories: String {
        String(format: "%.0f", calories)
    }
}

struct PortionRecommendation {
    let gramsPerMeal: Double
    let caloriesPerMeal: Double
    let totalDailyGrams: Double
    let totalDailyCalories: Double
    let mealsPerDay: Int
    let foodType: FoodType

    var formattedGramsPerMeal: String {
        String(format: "%.0f g", gramsPerMeal)
    }

    var formattedTotalGrams: String {
        String(format: "%.0f g", totalDailyGrams)
    }

    // Approximate cup measurement (1 cup dry food ≈ 100g)
    var cupsPerMeal: Double {
        gramsPerMeal / 100
    }

    var formattedCupsPerMeal: String {
        if cupsPerMeal < 0.25 {
            return String(format: "%.0f g", gramsPerMeal)
        } else if cupsPerMeal < 1 {
            return String(format: "%.1f cup", cupsPerMeal)
        } else {
            return String(format: "%.1f cups", cupsPerMeal)
        }
    }
}
