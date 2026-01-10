import Foundation
import SwiftUI
import SwiftData

@Model
final class BrandConfiguration {
    var id: UUID
    var brandId: String
    var brandName: String
    var primaryColorHex: String
    var accentColorHex: String
    var logoData: Data?
    var defaultSKUId: String
    var activatedAt: Date
    var lastUsedAt: Date

    @Relationship(deleteRule: .cascade)
    var foodSKUs: [FoodSKU] = []

    init(
        brandId: String,
        brandName: String,
        primaryColorHex: String = "#007AFF",
        accentColorHex: String = "#34C759",
        logoData: Data? = nil,
        defaultSKUId: String
    ) {
        self.id = UUID()
        self.brandId = brandId
        self.brandName = brandName
        self.primaryColorHex = primaryColorHex
        self.accentColorHex = accentColorHex
        self.logoData = logoData
        self.defaultSKUId = defaultSKUId
        self.activatedAt = Date()
        self.lastUsedAt = Date()
    }

    // MARK: - Color Accessors

    var primaryColor: Color {
        Color(hex: primaryColorHex) ?? .blue
    }

    var accentColor: Color {
        Color(hex: accentColorHex) ?? .green
    }

    // MARK: - SKU Helpers

    var defaultSKU: FoodSKU? {
        foodSKUs.first { $0.skuId == defaultSKUId }
    }

    func sku(forId skuId: String) -> FoodSKU? {
        foodSKUs.first { $0.skuId == skuId }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    var hexString: String {
        guard let components = UIColor(self).cgColor.components else {
            return "#000000"
        }

        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

// MARK: - QR Deep Link Parser

struct BrandActivationParams {
    let brandId: String
    let brandName: String
    let skuId: String
    let skuName: String
    let caloriesPerGram: Double
    let servingSizeGrams: Double
    let primaryColorHex: String?
    let accentColorHex: String?

    /// Parse URL like: catweighttracker://activate?brand=acme&name=AcmePet&sku=weight-chicken&skuname=Weight%20Management%20Chicken&cal=3.2&serving=35
    static func parse(from url: URL) -> BrandActivationParams? {
        guard url.scheme == "catweighttracker",
              url.host == "activate",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }

        var params: [String: String] = [:]
        for item in queryItems {
            if let value = item.value {
                params[item.name] = value
            }
        }

        guard let brandId = params["brand"],
              let skuId = params["sku"],
              let calString = params["cal"],
              let caloriesPerGram = Double(calString) else {
            return nil
        }

        return BrandActivationParams(
            brandId: brandId,
            brandName: params["name"] ?? brandId.capitalized,
            skuId: skuId,
            skuName: params["skuname"]?.removingPercentEncoding ?? skuId.capitalized,
            caloriesPerGram: caloriesPerGram,
            servingSizeGrams: Double(params["serving"] ?? "35") ?? 35.0,
            primaryColorHex: params["color"],
            accentColorHex: params["accent"]
        )
    }
}
