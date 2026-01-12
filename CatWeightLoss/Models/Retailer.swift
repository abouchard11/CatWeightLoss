import Foundation
import SwiftUI

/// Retailer configuration for reorder routing
/// Each retailer has affiliate URL templates and display info
struct Retailer: Identifiable, Hashable {
    let id: String
    let name: String
    let logoSystemImage: String
    let brandColor: Color
    let affiliateURLTemplate: String  // e.g., "https://chewy.com/dp/{skuId}?ref={affiliateCode}"
    let deliveryEstimate: String
    let features: [String]

    /// Generate affiliate URL for a specific SKU
    func affiliateURL(skuId: String, affiliateCode: String) -> URL? {
        let urlString = affiliateURLTemplate
            .replacingOccurrences(of: "{skuId}", with: skuId)
            .replacingOccurrences(of: "{affiliateCode}", with: affiliateCode)
        return URL(string: urlString)
    }
}

// MARK: - Built-in Retailers

extension Retailer {
    static let chewy = Retailer(
        id: "chewy",
        name: "Chewy",
        logoSystemImage: "shippingbox.fill",
        brandColor: Color(red: 0.11, green: 0.25, blue: 0.58), // Chewy blue
        affiliateURLTemplate: "https://www.chewy.com/s?query={skuId}&ref={affiliateCode}",
        deliveryEstimate: "1-2 day delivery",
        features: ["Free shipping over $49", "Autoship saves 5%"]
    )

    static let petco = Retailer(
        id: "petco",
        name: "Petco",
        logoSystemImage: "storefront.fill",
        brandColor: Color(red: 0, green: 0.35, blue: 0.61), // Petco blue
        affiliateURLTemplate: "https://www.petco.com/shop/SearchDisplay?searchTerm={skuId}&ref={affiliateCode}",
        deliveryEstimate: "Same day pickup available",
        features: ["In-store pickup", "Vital Care members save 20%"]
    )

    static let petsmart = Retailer(
        id: "petsmart",
        name: "PetSmart",
        logoSystemImage: "pawprint.fill",
        brandColor: Color(red: 0.89, green: 0.1, blue: 0.22), // PetSmart red
        affiliateURLTemplate: "https://www.petsmart.com/search/?q={skuId}&ref={affiliateCode}",
        deliveryEstimate: "2-3 day delivery",
        features: ["Free same-day delivery", "Treats rewards"]
    )

    static let amazon = Retailer(
        id: "amazon",
        name: "Amazon",
        logoSystemImage: "cart.fill",
        brandColor: Color(red: 1.0, green: 0.6, blue: 0), // Amazon orange
        affiliateURLTemplate: "https://www.amazon.com/s?k={skuId}&tag={affiliateCode}",
        deliveryEstimate: "Prime 1-day delivery",
        features: ["Subscribe & Save 15%", "Prime free delivery"]
    )

    /// All available retailers
    static let all: [Retailer] = [chewy, petco, petsmart, amazon]

    /// Get retailer by ID
    static func retailer(for id: String) -> Retailer? {
        all.first { $0.id == id }
    }
}

// MARK: - Reorder Event (for tracking)

struct ReorderEvent: Identifiable {
    let id = UUID()
    let retailerId: String
    let skuId: String
    let brandId: String
    let timestamp: Date
    let estimatedValue: Double?  // Estimated purchase value for attribution

    init(retailer: Retailer, skuId: String, brandId: String, estimatedValue: Double? = nil) {
        self.retailerId = retailer.id
        self.skuId = skuId
        self.brandId = brandId
        self.timestamp = Date()
        self.estimatedValue = estimatedValue
    }
}

// MARK: - Reorder Prediction

struct ReorderPrediction {
    let daysUntilEmpty: Int
    let confidence: Double  // 0-1 based on data quality
    let recommendedOrderDate: Date
    let currentBagPercentage: Double  // Estimated % of bag remaining

    var urgency: Urgency {
        switch daysUntilEmpty {
        case ...3: return .urgent
        case 4...7: return .soon
        case 8...14: return .upcoming
        default: return .notYet
        }
    }

    enum Urgency: String {
        case urgent = "Order Now"
        case soon = "Order Soon"
        case upcoming = "Coming Up"
        case notYet = "You're Set"

        var color: Color {
            switch self {
            case .urgent: return .red
            case .soon: return .orange
            case .upcoming: return .yellow
            case .notYet: return .green
            }
        }

        var icon: String {
            switch self {
            case .urgent: return "exclamationmark.triangle.fill"
            case .soon: return "clock.fill"
            case .upcoming: return "calendar"
            case .notYet: return "checkmark.circle.fill"
            }
        }
    }

    /// Calculate prediction based on feeding schedule and bag size
    static func calculate(
        dailyGrams: Double,
        bagSizeGrams: Double,
        purchaseDate: Date,
        gramsUsed: Double = 0
    ) -> ReorderPrediction {
        let remainingGrams = max(0, bagSizeGrams - gramsUsed)
        let daysRemaining = dailyGrams > 0 ? Int(remainingGrams / dailyGrams) : 999
        let percentage = bagSizeGrams > 0 ? remainingGrams / bagSizeGrams : 1.0

        // Recommend ordering 5 days before empty (shipping buffer)
        let emptyDate = Calendar.current.date(byAdding: .day, value: daysRemaining, to: Date()) ?? Date()
        let orderDate = Calendar.current.date(byAdding: .day, value: -5, to: emptyDate) ?? Date()

        // Confidence based on data quality
        let confidence = min(1.0, Double(gramsUsed) / 500) // Increases with usage data

        return ReorderPrediction(
            daysUntilEmpty: daysRemaining,
            confidence: confidence,
            recommendedOrderDate: orderDate,
            currentBagPercentage: percentage
        )
    }
}
