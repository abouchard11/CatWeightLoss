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

    // MARK: - Reorder Metrics (Monetization)

    /// Record when reorder screen is viewed
    func recordReorderViewed(brandId: String, skuId: String, in context: ModelContext) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .reorderViewed,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(metric)
    }

    /// Record when user clicks through to a retailer
    func recordReorderClick(
        brandId: String,
        skuId: String,
        retailerId: String,
        in context: ModelContext
    ) {
        // Record the click event
        let clickMetric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .reorderClick,
            value: 1,
            deviceHash: deviceHash
        )
        context.insert(clickMetric)

        // Record which retailer (for attribution analysis)
        let retailerMetric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: .reorderRetailer,
            value: Double(retailerId.hashValue % 1000),  // Anonymized retailer identifier
            deviceHash: deviceHash
        )
        context.insert(retailerMetric)
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

        let metrics: [AnonymousMetric]
        do {
            metrics = try context.fetch(descriptor)
        } catch {
            #if DEBUG
            print("[MetricsAggregator] Failed to fetch metrics: \(error.localizedDescription)")
            #endif
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

    // MARK: - Demo Data Seeding (DEBUG only)

    #if DEBUG
    /// Seed demo metrics for analytics dashboard demos
    /// Creates realistic-looking data spanning the last 30 days
    func seedDemoMetrics(in context: ModelContext) {
        let calendar = Calendar.current

        // Generate demo device hashes (simulates multiple users)
        let demoDevices = (1...12).map { "demo_device_\($0)_\(UUID().uuidString.prefix(8))" }

        // Seed metrics for each demo brand
        for brand in BrandSeeds.all {
            let brandId = brand.brandId
            let skuId = brand.skus.first?.skuId ?? "\(brandId)-sku"

            // Distribute users across brands (not evenly - some brands more popular)
            let brandPopularity: Double = {
                switch brandId {
                case "felinecare": return 1.0
                case "sciencenutrition": return 0.8
                case "probalance": return 0.6
                case "bluewellness": return 0.9
                default: return 0.5
                }
            }()

            let brandDevices = demoDevices.filter { _ in Double.random(in: 0...1) < brandPopularity }

            for deviceHash in brandDevices {
                // Random activation date in last 30 days
                let activationDaysAgo = Int.random(in: 3...28)
                let activationDate = calendar.date(byAdding: .day, value: -activationDaysAgo, to: Date()) ?? Date()

                // Activation metric
                insertDemoMetric(
                    brandId: brandId,
                    skuId: skuId,
                    type: .appActivation,
                    value: 1,
                    deviceHash: deviceHash,
                    date: activationDate,
                    in: context
                )

                // Setup completion (90% complete setup)
                if Double.random(in: 0...1) < 0.9 {
                    insertDemoMetric(
                        brandId: brandId,
                        skuId: skuId,
                        type: .setupCompleted,
                        value: 1,
                        deviceHash: deviceHash,
                        date: activationDate.addingTimeInterval(300), // 5 min later
                        in: context
                    )
                }

                // Weight logs over time (engagement varies)
                let engagementLevel = Double.random(in: 0.3...1.0)
                let daysSinceActivation = activationDaysAgo

                for dayOffset in 0..<daysSinceActivation {
                    let logDate = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()

                    // More engaged users log more frequently
                    if Double.random(in: 0...1) < engagementLevel * 0.7 {
                        insertDemoMetric(
                            brandId: brandId,
                            skuId: skuId,
                            type: .weightLogged,
                            value: 1,
                            deviceHash: deviceHash,
                            date: logDate,
                            in: context
                        )
                    }

                    // App opens (more frequent than logs)
                    if Double.random(in: 0...1) < engagementLevel {
                        insertDemoMetric(
                            brandId: brandId,
                            skuId: skuId,
                            type: .appOpen,
                            value: 1,
                            deviceHash: deviceHash,
                            date: logDate,
                            in: context
                        )
                    }
                }

                // Reorder funnel (view → click conversion)
                let reorderViews = Int.random(in: 1...5)
                for viewOffset in 0..<reorderViews {
                    let viewDate = calendar.date(byAdding: .day, value: -Int.random(in: 1...activationDaysAgo), to: Date()) ?? Date()

                    insertDemoMetric(
                        brandId: brandId,
                        skuId: skuId,
                        type: .reorderViewed,
                        value: 1,
                        deviceHash: deviceHash,
                        date: viewDate,
                        in: context
                    )

                    // 25-40% click through rate
                    if Double.random(in: 0...1) < 0.32 {
                        insertDemoMetric(
                            brandId: brandId,
                            skuId: skuId,
                            type: .reorderClick,
                            value: 1,
                            deviceHash: deviceHash,
                            date: viewDate.addingTimeInterval(Double.random(in: 10...120)),
                            in: context
                        )
                    }
                }
            }
        }

        #if DEBUG
        print("[MetricsAggregator] Seeded demo metrics for \(BrandSeeds.all.count) brands")
        #endif
    }

    private func insertDemoMetric(
        brandId: String,
        skuId: String,
        type: MetricType,
        value: Double,
        deviceHash: String,
        date: Date,
        in context: ModelContext
    ) {
        let metric = AnonymousMetric(
            brandId: brandId,
            skuId: skuId,
            metricType: type,
            value: value,
            deviceHash: deviceHash
        )
        // Manually set the date for demo data
        metric.recordedAt = date
        context.insert(metric)
    }

    /// Clear all demo metrics (for reset)
    func clearDemoMetrics(in context: ModelContext) {
        let descriptor = FetchDescriptor<AnonymousMetric>(
            predicate: #Predicate { $0.deviceHash.contains("demo_device_") }
        )

        do {
            let demoMetrics = try context.fetch(descriptor)
            for metric in demoMetrics {
                context.delete(metric)
            }
            #if DEBUG
            print("[MetricsAggregator] Cleared \(demoMetrics.count) demo metrics")
            #endif
        } catch {
            #if DEBUG
            print("[MetricsAggregator] Failed to clear demo metrics: \(error.localizedDescription)")
            #endif
        }
    }
    #endif

    // MARK: - Cleanup

    /// Remove old metrics (privacy-preserving cleanup)
    func cleanupOldMetrics(olderThanDays: Int = 90, in context: ModelContext) {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -olderThanDays, to: Date()) ?? Date()

        let descriptor = FetchDescriptor<AnonymousMetric>(
            predicate: #Predicate { $0.recordedAt < cutoffDate }
        )

        do {
            let oldMetrics = try context.fetch(descriptor)
            for metric in oldMetrics {
                context.delete(metric)
            }
        } catch {
            #if DEBUG
            print("[MetricsAggregator] Failed to cleanup old metrics: \(error.localizedDescription)")
            #endif
        }
    }
}
