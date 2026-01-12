import Foundation
import SwiftData
import UIKit
import CryptoKit

/// Anonymous aggregated metrics for brand analytics
/// No PII is stored - all data is anonymized
@Model
final class AnonymousMetric {
    var id: UUID
    var brandId: String
    var skuId: String
    var metricType: String
    var value: Double
    var recordedAt: Date

    // Device fingerprint (hashed, not stored raw)
    var deviceHash: String

    init(
        brandId: String,
        skuId: String,
        metricType: MetricType,
        value: Double,
        deviceHash: String
    ) {
        self.id = UUID()
        self.brandId = brandId
        self.skuId = skuId
        self.metricType = metricType.rawValue
        self.value = value
        self.recordedAt = Date()
        self.deviceHash = deviceHash
    }
}

// MARK: - Metric Types

enum MetricType: String, CaseIterable {
    // Activation metrics
    case appActivation = "app_activation"
    case setupCompleted = "setup_completed"

    // Engagement metrics
    case appOpen = "app_open"
    case weightLogged = "weight_logged"
    case daysBetweenLogs = "days_between_logs"

    // Progress metrics (anonymized)
    case progressPercentage = "progress_percentage"
    case consistencyStreak = "consistency_streak"

    // Retention signals
    case entriesCount = "entries_count"
    case daysActive = "days_active"

    // Reorder metrics (monetization)
    case reorderViewed = "reorder_viewed"
    case reorderClick = "reorder_click"
    case reorderRetailer = "reorder_retailer"  // Which retailer was selected
}

// MARK: - Aggregated Report (for export)

struct AggregatedMetricsReport: Codable {
    let brandId: String
    let skuId: String
    let reportDate: Date
    let periodDays: Int

    // Activation
    let totalActivations: Int
    let setupCompletionRate: Double

    // Engagement
    let avgAppOpensPerWeek: Double
    let avgDaysBetweenLogs: Double
    let usersWithThreePlusEntries: Int
    let usersWithThreePlusEntriesRate: Double

    // Progress
    let avgProgressPercentage: Double

    // Computed for executives
    var retentionSignal: String {
        if usersWithThreePlusEntriesRate >= 0.5 {
            return "Strong"
        } else if usersWithThreePlusEntriesRate >= 0.25 {
            return "Moderate"
        } else {
            return "Low"
        }
    }
}

// MARK: - Device Hashing

extension AnonymousMetric {
    private static let fallbackHashKey = "anon_device_hash_fallback"

    /// Generate anonymous device hash using SHA-256 (cryptographically secure, not reversible)
    static func generateDeviceHash() -> String {
        // Use identifierForVendor hashed with SHA-256
        // This changes if app is uninstalled, providing additional privacy
        guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
            // Fallback: use cached hash or generate and cache a new one
            if let cachedHash = UserDefaults.standard.string(forKey: fallbackHashKey) {
                return cachedHash
            }

            // Generate new fallback hash and cache it
            let randomData = Data((0..<32).map { _ in UInt8.random(in: 0...255) })
            let fallbackHash = SHA256.hash(data: randomData)
            let hashString = fallbackHash.compactMap { String(format: "%02x", $0) }.joined().prefix(16).description
            UserDefaults.standard.set(hashString, forKey: fallbackHashKey)
            return hashString
        }

        // SHA-256 hash of vendor ID (true cryptographic one-way hash)
        let data = Data(vendorId.utf8)
        let hash = SHA256.hash(data: data)

        // Return first 16 hex characters (64 bits of entropy - sufficient for anonymization)
        return hash.compactMap { String(format: "%02x", $0) }.joined().prefix(16).description
    }
}
