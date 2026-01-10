import Foundation
import SwiftUI
import SwiftData

@Observable
class BrandConfigService {
    static let shared = BrandConfigService()

    var activeBrandConfig: BrandConfiguration?
    var pendingActivation: BrandActivationParams?
    var isActivating = false

    private init() {}

    // MARK: - URL Handling

    /// Handle incoming deep link URL
    func handleURL(_ url: URL) -> Bool {
        guard let params = BrandActivationParams.parse(from: url) else {
            return false
        }

        pendingActivation = params
        return true
    }

    // MARK: - Brand Activation

    /// Activate a brand from QR params and create/update configuration
    @MainActor
    func activateBrand(
        params: BrandActivationParams,
        in context: ModelContext
    ) -> BrandConfiguration {
        isActivating = true
        defer { isActivating = false }

        // Check for existing brand config
        let brandId = params.brandId
        let descriptor = FetchDescriptor<BrandConfiguration>(
            predicate: #Predicate { $0.brandId == brandId }
        )

        if let existing = try? context.fetch(descriptor).first {
            // Update existing
            existing.lastUsedAt = Date()

            // Update or add SKU
            if let existingSKU = existing.sku(forId: params.skuId) {
                existingSKU.caloriesPerGram = params.caloriesPerGram
                existingSKU.servingSizeGrams = params.servingSizeGrams
            } else {
                let newSKU = FoodSKU(
                    skuId: params.skuId,
                    displayName: params.skuName,
                    caloriesPerGram: params.caloriesPerGram,
                    servingSizeGrams: params.servingSizeGrams
                )
                newSKU.brand = existing
                existing.foodSKUs.append(newSKU)
            }

            existing.defaultSKUId = params.skuId
            activeBrandConfig = existing
            return existing
        }

        // Create new brand config
        let config = BrandConfiguration(
            brandId: params.brandId,
            brandName: params.brandName,
            primaryColorHex: params.primaryColorHex ?? "#007AFF",
            accentColorHex: params.accentColorHex ?? "#34C759",
            defaultSKUId: params.skuId
        )

        let sku = FoodSKU(
            skuId: params.skuId,
            displayName: params.skuName,
            caloriesPerGram: params.caloriesPerGram,
            servingSizeGrams: params.servingSizeGrams
        )
        sku.brand = config
        config.foodSKUs.append(sku)

        context.insert(config)
        activeBrandConfig = config

        // Clear pending
        pendingActivation = nil

        return config
    }

    // MARK: - Load Active Brand

    /// Load the most recently used brand configuration
    @MainActor
    func loadActiveBrand(from context: ModelContext) {
        let descriptor = FetchDescriptor<BrandConfiguration>(
            sortBy: [SortDescriptor(\.lastUsedAt, order: .reverse)]
        )

        if let config = try? context.fetch(descriptor).first {
            activeBrandConfig = config
            config.lastUsedAt = Date()
        }
    }

    // MARK: - Test/Demo Brand

    /// Create a demo brand configuration for testing
    @MainActor
    func createDemoBrand(in context: ModelContext) -> BrandConfiguration {
        let config = BrandConfiguration(
            brandId: "demo",
            brandName: "Demo Pet Food",
            primaryColorHex: "#FF6B35",
            accentColorHex: "#004E64",
            defaultSKUId: "demo-weight-mgmt"
        )

        let sku = FoodSKU(
            skuId: "demo-weight-mgmt",
            displayName: "Weight Management Formula",
            caloriesPerGram: 3.2,
            servingSizeGrams: 35.0
        )
        sku.brand = config
        config.foodSKUs.append(sku)

        context.insert(config)
        activeBrandConfig = config
        return config
    }
}

// MARK: - Environment Key

private struct BrandConfigKey: EnvironmentKey {
    static let defaultValue: BrandConfiguration? = nil
}

extension EnvironmentValues {
    var brandConfig: BrandConfiguration? {
        get { self[BrandConfigKey.self] }
        set { self[BrandConfigKey.self] = newValue }
    }
}
