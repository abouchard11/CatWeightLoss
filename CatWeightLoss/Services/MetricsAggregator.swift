import Foundation
import SwiftData

/// Handles anonymous metrics collection and aggregation
/// All data is anonymized - no PII is ever stored or transmitted
@Observable
class MetricsAggregator {
    static let shared = MetricsAggregator()

    private let deviceHash: String

    private init() {
        self.deviceHash = AnonymousMetric.generateDeviceHash()
    }

    // MARK: - Event Recording

    /// Record an app activation event
    func recordActivation(brandId: String, skuId: String, in context: ModelContext) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .appActivation,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    /// Record setup completion
    func recordSetupCompleted(brandId: String, skuId: String, in context: ModelContext) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .setupCompleted,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    /// Record app open event
    func recordAppOpen(brandId: String, skuId: String, in context: ModelContext) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .appOpen,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    /// Record weight logged event with days since last log
    func recordWeightLogged(
        brandId: String,
        skuId: String,
        daysSinceLastLog: Int,
        in context: ModelContext
    ) {
        // Weight logged event
        let logMetric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .weightLogged,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(logMetric)

        // Days between logs (for engagement analysis)
        if daysSinceLastLog > 0 {
            let daysMetric = AnonymousMetric(
                brandId: brandId,
                skuId: skuId,
                metricType: .daysBetweenLogs,
                value: Double(daysSinceLastLog),
                deviceHash: deviceHash
            )
            context.insert(daysMetric)
        }
    }

    /// Record progress percentage (anonymized - no actual weight values)
    func recordProgress(
        brandId: String,
        skuId: String,
        progressPercentage: Double,
        in context: ModelContext
    ) {
        // Bucket progress to further anonymize (0-25, 25-50, 50-75, 75-100)
        let bucketedProgress = (progressPercentage / 25).rounded() * 25

        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .progressPercentage,
            value: bucketedProgress,
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    /// Record total entries count
    func recordEntriesCount(
        brandId: String,
        skuId: String,
        count: Int,
        in context: ModelContext
    ) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .entriesCount,
            value: Double(count),
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    // MARK: - Aggregation

    /// Generate aggregated report for a brand/SKU
    func generateReport(
        brandId: String,
        skuId: String,
        periodDays: Int = 30,
        from context: ModelContext
    ) -> AggregatedMetricsReport? {
        let startDate = Calendar.current.date(byAdding: .day, value: -periodDays, to: Date()) ?? Date()

        // Fetch all metrics for this brand/SKU in period
        let descriptor = FetchDescriptor<AnonymousMetric>(
            predicate: #Predicate {
                $0.brandId == brandId &&
                $0.skuId == skuId &&
                $0.recordedAt >= startDate
            }
        )

        guard let metrics = try? context.fetch(descriptor) else {
            return nil
        }

        // Group by type
        let byType = Dictionary(grouping: metrics) { $0.metricType }

        // Calculate aggregates
        let activations = byType[MetricType.appActivation.rawValue]?.count ?? 0
        let setups = byType[MetricType.setupCompleted.rawValue]?.count ?? 0
        let setupRate = activations > 0 ? Double(setups) / Double(activations) : 0

        let appOpens = byType[MetricType.appOpen.rawValue] ?? []
        let avgOpensPerWeek = Double(appOpens.count) / (Double(periodDays) / 7)

        let daysBetween = byType[MetricType.daysBetweenLogs.rawValue] ?? []
        let avgDaysBetween = daysBetween.isEmpty ? 0 : daysBetween.map(\.value).reduce(0, +) / Double(daysBetween.count)

        let entryCounts = byType[MetricType.entriesCount.rawValue] ?? []
        let uniqueUsers = Set(entryCounts.map(\.deviceHash)).count
        let usersWithThreePlus = entryCounts.filter { $0.value >= 3 }.map(\.deviceHash)
        let uniqueUsersWithThreePlus = Set(usersWithThreePlus).count
        let threePlusRate = uniqueUsers > 0 ? Double(uniqueUsersWithThreePlus) / Double(uniqueUsers) : 0

        let progressMetrics = byType[MetricType.progressPercentage.rawValue] ?? []
        let avgProgress = progressMetrics.isEmpty ? 0 : progressMetrics.map(\.value).reduce(0, +) / Double(progressMetrics.count)

        return AggregatedMetricsReport(
            brandId: brandId,
            skuId: skuId,
            reportDate: Date(),
            periodDays: periodDays,
            totalActivations: activations,
            setupCompletionRate: setupRate,
            avgAppOpensPerWeek: avgOpensPerWeek,
            avgDaysBetweenLogs: avgDaysBetween,
            usersWithThreePlusEntries: uniqueUsersWithThreePlus,
            usersWithThreePlusEntriesRate: threePlusRate,
            avgProgressPercentage: avgProgress
        )
    }

    // MARK: - Cleanup

    /// Remove old metrics (privacy-preserving cleanup)
    func cleanupOldMetrics(olderThanDays: Int = 90, in context: ModelContext) {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -olderThanDays, to: Date()) ?? Date()

        let descriptor = FetchDescriptor<AnonymousMetric>(
            predicate: #Predicate { $0.recordedAt < cutoffDate }
        )

        if let oldMetrics = try? context.fetch(descriptor) {
            for metric in oldMetrics {
                context.delete(metric)
            }
        }
    }
}
