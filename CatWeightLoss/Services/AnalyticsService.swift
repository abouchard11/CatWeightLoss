import Foundation
import FirebaseAnalytics

/// Firebase Analytics service wrapper
/// Tracks user engagement and monetization events for brand partners
/// All data is anonymized - no PII is collected
final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    // MARK: - Configuration

    /// Set the active brand as a user property for segmentation
    func setActiveBrand(brandId: String) {
        Analytics.setUserProperty(brandId, forName: "active_brand")
        #if DEBUG
        print("[Analytics] Set active brand: \(brandId)")
        #endif
    }

    // MARK: - Brand Activation Events

    /// Track when a brand is activated via QR code scan
    func logBrandActivated(brandId: String, skuId: String) {
        Analytics.logEvent("brand_activated", parameters: [
            "brand_id": brandId,
            "sku_id": skuId,
            "timestamp": Date().timeIntervalSince1970
        ])

        // Also set as user property for segmentation
        setActiveBrand(brandId: brandId)

        #if DEBUG
        print("[Analytics] Brand activated: \(brandId), SKU: \(skuId)")
        #endif
    }

    // MARK: - Engagement Events

    /// Track weight logging with trend direction
    func logWeightLogged(brandId: String, trendDirection: WeightTrend) {
        Analytics.logEvent("weight_logged", parameters: [
            "brand_id": brandId,
            "trend_direction": trendDirection.rawValue,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Weight logged: \(brandId), trend: \(trendDirection.rawValue)")
        #endif
    }

    /// Track feeding schedule creation
    func logFeedingScheduleCreated(brandId: String) {
        Analytics.logEvent("feeding_schedule_created", parameters: [
            "brand_id": brandId,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Feeding schedule created: \(brandId)")
        #endif
    }

    /// Track activity logging
    func logActivityLogged(brandId: String, activityType: String, durationMinutes: Int) {
        Analytics.logEvent("activity_logged", parameters: [
            "brand_id": brandId,
            "activity_type": activityType,
            "duration_minutes": durationMinutes,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Activity logged: \(brandId), type: \(activityType), duration: \(durationMinutes)m")
        #endif
    }

    // MARK: - Monetization Events (Reorder Funnel)

    /// Track when reorder screen is viewed
    func logReorderViewed(brandId: String, skuId: String) {
        Analytics.logEvent("reorder_viewed", parameters: [
            "brand_id": brandId,
            "sku_id": skuId,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Reorder viewed: \(brandId), SKU: \(skuId)")
        #endif
    }

    /// Track when user clicks through to a retailer
    func logReorderClicked(brandId: String, skuId: String, retailer: String) {
        Analytics.logEvent("reorder_clicked", parameters: [
            "brand_id": brandId,
            "sku_id": skuId,
            "retailer": retailer,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Reorder clicked: \(brandId), SKU: \(skuId), retailer: \(retailer)")
        #endif
    }

    // MARK: - App Lifecycle Events

    /// Track app open (called on app launch)
    func logAppOpened(brandId: String?) {
        guard let brandId = brandId else { return }

        Analytics.logEvent("app_opened", parameters: [
            "brand_id": brandId,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] App opened: \(brandId)")
        #endif
    }

    /// Track setup completion (when user finishes onboarding)
    func logSetupCompleted(brandId: String, skuId: String) {
        Analytics.logEvent("setup_completed", parameters: [
            "brand_id": brandId,
            "sku_id": skuId,
            "timestamp": Date().timeIntervalSince1970
        ])

        #if DEBUG
        print("[Analytics] Setup completed: \(brandId), SKU: \(skuId)")
        #endif
    }
}

// MARK: - Weight Trend Enum

enum WeightTrend: String {
    case down = "down"
    case up = "up"
    case stable = "stable"

    /// Determine trend from current and previous weight
    static func from(current: Double, previous: Double, threshold: Double = 0.1) -> WeightTrend {
        let diff = current - previous
        if abs(diff) < threshold {
            return .stable
        }
        return diff < 0 ? .down : .up
    }
}
