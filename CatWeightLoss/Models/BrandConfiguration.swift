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

    // MARK: - Asset Catalog Accessors

    /// Returns the asset catalog folder name for this brand
    private var assetFolderName: String {
        // Map brandId to asset catalog folder name
        // Common mappings for known brands
        switch brandId.lowercased() {
        case "felinecare", "feline-care", "feline_care":
            return "FelineCare"
        case "sciencenutrition", "science-nutrition", "science_nutrition":
            return "ScienceNutrition"
        case "probalance", "pro-balance", "pro_balance":
            return "ProBalance"
        case "bluewellness", "blue-wellness", "blue_wellness":
            return "BlueWellness"
        default:
            // Convert brandId to PascalCase for asset lookup
            return brandId.split(separator: "-")
                .map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
                .joined()
        }
    }

    /// Product image from asset catalog (e.g., cat food bag image)
    var productImage: Image? {
        let imageName = "Brands/\(assetFolderName)/ProductImage"
        if UIImage(named: imageName) != nil {
            return Image(imageName)
        }
        return nil
    }

    /// Brand logo from asset catalog
    var logoImage: Image? {
        let imageName = "Brands/\(assetFolderName)/Logo"
        if UIImage(named: imageName) != nil {
            return Image(imageName)
        }
        return nil
    }

    /// Background image from asset catalog
    var backgroundImage: Image? {
        let imageName = "Brands/\(assetFolderName)/Background"
        if UIImage(named: imageName) != nil {
            return Image(imageName)
        }
        return nil
    }

    /// UIImage version of product image for contexts requiring UIKit
    var productUIImage: UIImage? {
        UIImage(named: "Brands/\(assetFolderName)/ProductImage")
    }

    /// UIImage version of logo for contexts requiring UIKit
    var logoUIImage: UIImage? {
        UIImage(named: "Brands/\(assetFolderName)/Logo")
    }

    /// UIImage version of background for contexts requiring UIKit
    var backgroundUIImage: UIImage? {
        UIImage(named: "Brands/\(assetFolderName)/Background")
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
