import XCTest
@testable import CatWeightLoss

final class AnonymousMetricTests: XCTestCase {

    // MARK: - Device Hash Consistency Tests

    func testDeviceHashConsistency() {
        // Call generateDeviceHash twice
        let hash1 = AnonymousMetric.generateDeviceHash()
        let hash2 = AnonymousMetric.generateDeviceHash()

        // Both calls should return the same value
        XCTAssertEqual(hash1, hash2, "Device hash should be consistent across calls")
    }

    func testDeviceHashFormat() {
        let hash = AnonymousMetric.generateDeviceHash()

        // Should be exactly 16 characters
        XCTAssertEqual(hash.count, 16, "Device hash should be 16 characters")

        // Should contain only hex characters [0-9a-f]
        let hexCharacterSet = CharacterSet(charactersIn: "0123456789abcdef")
        let hashCharacterSet = CharacterSet(charactersIn: hash)
        XCTAssertTrue(hashCharacterSet.isSubset(of: hexCharacterSet), "Device hash should contain only hex characters")
    }

    func testDeviceHashNotEmpty() {
        let hash = AnonymousMetric.generateDeviceHash()

        XCTAssertFalse(hash.isEmpty, "Device hash should not be empty")
    }
}
