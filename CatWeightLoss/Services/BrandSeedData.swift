import Foundation
import SwiftUI
import SwiftData

/// Seed data definitions for demo brand configurations
/// These represent fictional brands styled after major pet food companies

// MARK: - Seed Data Structures

struct BrandSeed {
    let brandId: String
    let brandName: String
    let tagline: String
    let primaryColorHex: String
    let accentColorHex: String
    let skus: [SKUSeed]
}

struct SKUSeed {
    let skuId: String
    let displayName: String
    let caloriesPerGram: Double
    let servingSizeGrams: Double
    let bagSizeGrams: Double
}

// MARK: - Demo Brands

enum BrandSeeds {

    /// FELINE CARE - Royal Canin style (Red/Navy)
    static let felineCare = BrandSeed(
        brandId: "feline-care",
        brandName: "FELINE CARE",
        tagline: "Precision nutrition for healthy weight",
        primaryColorHex: "#E31837",  // Royal Canin red
        accentColorHex: "#1C3F94",   // Navy blue
        skus: [
            SKUSeed(
                skuId: "fc-weight-chicken",
                displayName: "Weight Control Chicken",
                caloriesPerGram: 3.4,
                servingSizeGrams: 30.0,
                bagSizeGrams: 3500.0
            ),
            SKUSeed(
                skuId: "fc-weight-fish",
                displayName: "Weight Control Fish",
                caloriesPerGram: 3.3,
                servingSizeGrams: 30.0,
                bagSizeGrams: 3500.0
            )
        ]
    )

    /// SCIENCE NUTRITION - Hill's style (Blue/Green)
    static let scienceNutrition = BrandSeed(
        brandId: "science-nutrition",
        brandName: "SCIENCE NUTRITION",
        tagline: "Clinically proven weight management",
        primaryColorHex: "#0066CC",  // Hill's blue
        accentColorHex: "#00A651",   // Green
        skus: [
            SKUSeed(
                skuId: "sn-perfect-weight",
                displayName: "Perfect Weight Formula",
                caloriesPerGram: 3.2,
                servingSizeGrams: 35.0,
                bagSizeGrams: 3600.0
            ),
            SKUSeed(
                skuId: "sn-metabolic",
                displayName: "Metabolic Support",
                caloriesPerGram: 3.0,
                servingSizeGrams: 32.0,
                bagSizeGrams: 3600.0
            )
        ]
    )

    /// PRO BALANCE - Purina style (Purple/Gold)
    static let proBalance = BrandSeed(
        brandId: "pro-balance",
        brandName: "PRO BALANCE",
        tagline: "Professional nutrition for optimal weight",
        primaryColorHex: "#6B2D87",  // Purple
        accentColorHex: "#D4AF37",   // Gold
        skus: [
            SKUSeed(
                skuId: "pb-weight-control",
                displayName: "Weight Control Formula",
                caloriesPerGram: 3.3,
                servingSizeGrams: 32.0,
                bagSizeGrams: 3800.0
            ),
            SKUSeed(
                skuId: "pb-indoor-weight",
                displayName: "Indoor Weight Management",
                caloriesPerGram: 3.1,
                servingSizeGrams: 30.0,
                bagSizeGrams: 3800.0
            )
        ]
    )

    /// BLUE WELLNESS - Blue Buffalo style (Cobalt/Light Blue)
    static let blueWellness = BrandSeed(
        brandId: "blue-wellness",
        brandName: "BLUE WELLNESS",
        tagline: "Natural nutrition for healthy weight",
        primaryColorHex: "#0047AB",  // Cobalt blue
        accentColorHex: "#4A90E2",   // Light blue
        skus: [
            SKUSeed(
                skuId: "bw-healthy-weight",
                displayName: "Healthy Weight Chicken",
                caloriesPerGram: 3.1,
                servingSizeGrams: 33.0,
                bagSizeGrams: 3200.0
            ),
            SKUSeed(
                skuId: "bw-weight-salmon",
                displayName: "Weight Support Salmon",
                caloriesPerGram: 3.2,
                servingSizeGrams: 33.0,
                bagSizeGrams: 3200.0
            )
        ]
    )

    /// All demo brands
    static let all: [BrandSeed] = [
        felineCare,
        scienceNutrition,
        proBalance,
        blueWellness
    ]
}

// MARK: - Brand Creation Helper

extension BrandSeedData {

    /// Create a BrandConfiguration from seed data
    @MainActor
    static func createBrandConfiguration(
        from seed: BrandSeed,
        in context: ModelContext
    ) -> BrandConfiguration {
        let config = BrandConfiguration(
            brandId: seed.brandId,
            brandName: seed.brandName,
            primaryColorHex: seed.primaryColorHex,
            accentColorHex: seed.accentColorHex,
            defaultSKUId: seed.skus.first?.skuId ?? ""
        )

        // Add all SKUs
        for skuSeed in seed.skus {
            let sku = FoodSKU(
                skuId: skuSeed.skuId,
                displayName: skuSeed.displayName,
                caloriesPerGram: skuSeed.caloriesPerGram,
                servingSizeGrams: skuSeed.servingSizeGrams,
                bagSizeGrams: skuSeed.bagSizeGrams
            )
            sku.brand = config
            config.foodSKUs.append(sku)
        }

        context.insert(config)
        return config
    }
}

// MARK: - Namespace

enum BrandSeedData {}
