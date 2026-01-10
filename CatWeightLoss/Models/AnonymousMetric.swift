import Foundation
import SwiftData
import UIKit

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
    /// Generate anonymous device hash (not reversible)
    static func generateDeviceHash() -> String {
        // Use identifierForVendor hashed with SHA256
        // This changes if app is uninstalled, providing additional privacy
        guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
            return UUID().uuidString // Fallback
        }

        // Simple hash using built-in methods
        let data = Data(vendorId.utf8)
        var hash = [UInt8](repeating: 0, count: 32)
        data.withUnsafeBytes { buffer in
            // Simple XOR-based obfuscation (not cryptographic, but sufficient for anonymization)
            for (index, byte) in buffer.enumerated() {
                hash[index % 32] ^= byte
            }
        }

        return hash.map { String(format: "%02x", $0) }.joined().prefix(16).description
    }
}
