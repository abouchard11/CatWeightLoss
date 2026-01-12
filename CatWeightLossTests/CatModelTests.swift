import XCTest
@testable import CatWeightLoss

final class CatModelTests: XCTestCase {

    // MARK: - Test Helpers

    /// Create a Cat with specific weight entries for testing
    private func makeCat(
        startWeight: Double = 12.0,
        targetWeight: Double = 10.0,
        weights: [(Double, Int)] = [] // (weight, daysAgo)
    ) -> Cat {
        let cat = Cat(
            name: "TestCat",
            startWeight: startWeight,
            targetWeight: targetWeight
        )

        // Add weight entries with proper dates
        let calendar = Calendar.current
        for (weight, daysAgo) in weights {
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            let entry = WeightEntry(weight: weight, date: date)
            entry.cat = cat
            cat.weightEntries.append(entry)
        }

        return cat
    }

    // MARK: - progressPercentage Tests

    func testProgressPercentage_halfway() {
        // Start 12, target 10, current 11 → 50% progress
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [(11.0, 0)])
        XCTAssertEqual(cat.progressPercentage, 50.0, accuracy: 0.1)
    }

    func testProgressPercentage_complete() {
        // Start 12, target 10, current 10 → 100% progress
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [(10.0, 0)])
        XCTAssertEqual(cat.progressPercentage, 100.0, accuracy: 0.1)
    }

    func testProgressPercentage_noProgress() {
        // Start 12, target 10, current 12 → 0% progress
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [(12.0, 0)])
        XCTAssertEqual(cat.progressPercentage, 0.0, accuracy: 0.1)
    }

    func testProgressPercentage_noLossNeeded() {
        // Start 12, target 12 → 100% (guard clause)
        let cat = makeCat(startWeight: 12.0, targetWeight: 12.0)
        XCTAssertEqual(cat.progressPercentage, 100.0, accuracy: 0.1)
    }

    func testProgressPercentage_belowTarget() {
        // Current below target → capped at 100%
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [(9.0, 0)])
        XCTAssertEqual(cat.progressPercentage, 100.0, accuracy: 0.1)
    }

    func testProgressPercentage_usesLatestEntry() {
        // Multiple entries, should use most recent (day 0 = 11.0)
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [
            (11.5, 2),  // 2 days ago
            (11.0, 0),  // today (most recent)
            (11.8, 1)   // yesterday
        ])
        // Progress should be based on 11.0 (current) not 11.5 or 11.8
        XCTAssertEqual(cat.progressPercentage, 50.0, accuracy: 0.1)
    }

    func testProgressPercentage_noEntries() {
        // No entries → uses startWeight as current
        let cat = makeCat(startWeight: 12.0, targetWeight: 10.0, weights: [])
        XCTAssertEqual(cat.progressPercentage, 0.0, accuracy: 0.1)
    }

    // MARK: - weightTrend Tests

    func testWeightTrend_insufficientEntries_zero() {
        let cat = makeCat(weights: [])
        XCTAssertEqual(cat.weightTrend, .insufficient)
    }

    func testWeightTrend_insufficientEntries_one() {
        let cat = makeCat(weights: [(11.0, 0)])
        XCTAssertEqual(cat.weightTrend, .insufficient)
    }

    func testWeightTrend_insufficientEntries_two() {
        let cat = makeCat(weights: [(11.0, 0), (11.5, 1)])
        XCTAssertEqual(cat.weightTrend, .insufficient)
    }

    func testWeightTrend_decreasing() {
        // Recent entries lower than older entries by more than 0.1
        // Algorithm: avg of 2 most recent vs avg of rest (from 5 most recent)
        let cat = makeCat(weights: [
            (10.0, 0),  // most recent
            (10.2, 1),  // 2nd most recent
            (11.0, 2),  // older
            (11.2, 3),  // older
            (11.5, 4)   // oldest of 5
        ])
        // avgRecent = (10.0 + 10.2) / 2 = 10.1
        // avgOlder = (11.0 + 11.2 + 11.5) / 3 = 11.23
        // difference = 10.1 - 11.23 = -1.13 < -0.1 → decreasing
        XCTAssertEqual(cat.weightTrend, .decreasing)
    }

    func testWeightTrend_increasing() {
        // Recent entries higher than older entries by more than 0.1
        let cat = makeCat(weights: [
            (11.5, 0),  // most recent
            (11.3, 1),  // 2nd most recent
            (10.5, 2),  // older
            (10.3, 3),  // older
            (10.0, 4)   // oldest of 5
        ])
        // avgRecent = (11.5 + 11.3) / 2 = 11.4
        // avgOlder = (10.5 + 10.3 + 10.0) / 3 = 10.27
        // difference = 11.4 - 10.27 = 1.13 > 0.1 → increasing
        XCTAssertEqual(cat.weightTrend, .increasing)
    }

    func testWeightTrend_stable() {
        // Difference within ±0.1 threshold
        let cat = makeCat(weights: [
            (10.55, 0),
            (10.50, 1),
            (10.52, 2)
        ])
        // avgRecent = (10.55 + 10.50) / 2 = 10.525
        // avgOlder = 10.52
        // difference = 10.525 - 10.52 = 0.005 (within threshold)
        XCTAssertEqual(cat.weightTrend, .stable)
    }

    func testWeightTrend_threeEntries() {
        // Minimum entries for trend calculation
        let cat = makeCat(weights: [
            (10.0, 0),  // most recent
            (10.1, 1),  // 2nd most recent
            (10.5, 2)   // older (just 1 entry in older set)
        ])
        // avgRecent = (10.0 + 10.1) / 2 = 10.05
        // avgOlder = 10.5 / 1 = 10.5
        // difference = 10.05 - 10.5 = -0.45 < -0.1 → decreasing
        XCTAssertEqual(cat.weightTrend, .decreasing)
    }

    func testWeightTrend_usesOnlyRecentFive() {
        // More than 5 entries, should only use 5 most recent
        let cat = makeCat(weights: [
            (10.0, 0),
            (10.1, 1),
            (10.5, 2),
            (10.6, 3),
            (10.7, 4),
            (20.0, 5),  // ignored - not in top 5
            (25.0, 6)   // ignored - not in top 5
        ])
        // Should calculate based on first 5 only
        XCTAssertEqual(cat.weightTrend, .decreasing)
    }
}
