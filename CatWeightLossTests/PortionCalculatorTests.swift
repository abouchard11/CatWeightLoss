import XCTest
@testable import CatWeightLoss

final class PortionCalculatorTests: XCTestCase {

    // MARK: - RER Tests (Resting Energy Requirement)
    // Formula: RER = 70 × (weight in kg)^0.75

    func testRER_4kgCat() {
        // 70 × 4^0.75 = 70 × 2.828... ≈ 198.0
        let rer = PortionCalculator.restingEnergyRequirement(weightKg: 4.0)
        XCTAssertEqual(rer, 198.0, accuracy: 0.5)
    }

    func testRER_5kgCat() {
        // 70 × 5^0.75 = 70 × 3.344... ≈ 234.1
        let rer = PortionCalculator.restingEnergyRequirement(weightKg: 5.0)
        XCTAssertEqual(rer, 234.1, accuracy: 0.5)
    }

    func testRER_smallKitten() {
        // 70 × 0.5^0.75 ≈ 41.7
        let rer = PortionCalculator.restingEnergyRequirement(weightKg: 0.5)
        XCTAssertEqual(rer, 41.7, accuracy: 0.5)
    }

    func testRER_largeCat() {
        // 70 × 10^0.75 ≈ 393.7
        let rer = PortionCalculator.restingEnergyRequirement(weightKg: 10.0)
        XCTAssertEqual(rer, 393.7, accuracy: 0.5)
    }

    // MARK: - MER Tests (Maintenance Energy Requirement)

    func testMER_indoorCat() {
        // Indoor cat uses 1.2× factor
        let mer = PortionCalculator.maintenanceEnergyRequirement(weightKg: 4.0, isActive: false)
        let expectedRER = PortionCalculator.restingEnergyRequirement(weightKg: 4.0)
        XCTAssertEqual(mer, expectedRER * 1.2, accuracy: 0.1)
    }

    func testMER_activeCat() {
        // Active cat uses 1.4× factor
        let mer = PortionCalculator.maintenanceEnergyRequirement(weightKg: 4.0, isActive: true)
        let expectedRER = PortionCalculator.restingEnergyRequirement(weightKg: 4.0)
        XCTAssertEqual(mer, expectedRER * 1.4, accuracy: 0.1)
    }

    func testMER_defaultIsInactive() {
        // Default should be inactive (indoor)
        let merDefault = PortionCalculator.maintenanceEnergyRequirement(weightKg: 5.0)
        let merInactive = PortionCalculator.maintenanceEnergyRequirement(weightKg: 5.0, isActive: false)
        XCTAssertEqual(merDefault, merInactive, accuracy: 0.001)
    }

    // MARK: - Weight Loss Calories Tests

    func testWeightLossCalories_applies15PercentReduction() {
        let recommendation = PortionCalculator.weightLossCalories(
            currentWeightKg: 5.0,
            targetWeightKg: 4.0
        )
        // MER for 5kg indoor cat ≈ 280.9, 15% reduction ≈ 238.8
        let expectedMER = PortionCalculator.maintenanceEnergyRequirement(weightKg: 5.0)
        XCTAssertEqual(recommendation.calories, expectedMER * 0.85, accuracy: 0.5)
        XCTAssertEqual(recommendation.reductionPercentage, 15.0, accuracy: 0.001)
    }

    func testWeightLossCalories_neverBelowRER() {
        // Very small cat where 15% reduction might go below RER
        // This tests the max(targetCalories, rer) logic
        let recommendation = PortionCalculator.weightLossCalories(
            currentWeightKg: 2.0,
            targetWeightKg: 1.5
        )
        let rer = PortionCalculator.restingEnergyRequirement(weightKg: 2.0)
        XCTAssertGreaterThanOrEqual(recommendation.calories, rer)
    }

    func testWeightLossCalories_includedMetrics() {
        let recommendation = PortionCalculator.weightLossCalories(
            currentWeightKg: 5.0,
            targetWeightKg: 4.5
        )
        XCTAssertGreaterThan(recommendation.mer, 0)
        XCTAssertGreaterThan(recommendation.rer, 0)
        XCTAssertLessThan(recommendation.rer, recommendation.mer)
    }

    // MARK: - Validate Target Weight Tests

    func testValidateTargetWeight_valid10PercentLoss() {
        // 10% loss: current 10, target 9
        let isValid = PortionCalculator.validateTargetWeight(current: 10.0, target: 9.0)
        XCTAssertTrue(isValid)
    }

    func testValidateTargetWeight_valid20PercentLoss() {
        // 20% loss: current 10, target 8
        let isValid = PortionCalculator.validateTargetWeight(current: 10.0, target: 8.0)
        XCTAssertTrue(isValid)
    }

    func testValidateTargetWeight_validMaxLoss30Percent() {
        // Exactly 30% loss should be valid: current 10, target 7
        let isValid = PortionCalculator.validateTargetWeight(current: 10.0, target: 7.0)
        XCTAssertTrue(isValid)
    }

    func testValidateTargetWeight_invalid35PercentLoss() {
        // 35% loss exceeds 30% max: current 10, target 6.5
        let isValid = PortionCalculator.validateTargetWeight(current: 10.0, target: 6.5)
        XCTAssertFalse(isValid)
    }

    func testValidateTargetWeight_invalidTargetGreaterThanCurrent() {
        // Target must be less than current
        let isValid = PortionCalculator.validateTargetWeight(current: 5.0, target: 6.0)
        XCTAssertFalse(isValid)
    }

    func testValidateTargetWeight_invalidTargetEqualsCurrent() {
        // Target must be less than current
        let isValid = PortionCalculator.validateTargetWeight(current: 5.0, target: 5.0)
        XCTAssertFalse(isValid)
    }

    func testValidateTargetWeight_invalidZeroTarget() {
        let isValid = PortionCalculator.validateTargetWeight(current: 5.0, target: 0.0)
        XCTAssertFalse(isValid)
    }

    func testValidateTargetWeight_invalidNegativeTarget() {
        let isValid = PortionCalculator.validateTargetWeight(current: 5.0, target: -1.0)
        XCTAssertFalse(isValid)
    }
}
