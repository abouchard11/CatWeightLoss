import XCTest
@testable import CatWeightLoss

final class BrandActivationParamsTests: XCTestCase {

    // MARK: - Valid URL Tests

    func testParse_validCompleteURL() {
        let url = URL(string: "catweighttracker://activate?brand=acme&name=AcmePet&sku=weight-chicken&skuname=Weight%20Management&cal=3.2&serving=35&color=%23FF6B35&accent=%23004E64")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params?.brandId, "acme")
        XCTAssertEqual(params?.brandName, "AcmePet")
        XCTAssertEqual(params?.skuId, "weight-chicken")
        XCTAssertEqual(params?.skuName, "Weight Management")
        XCTAssertEqual(params!.caloriesPerGram, 3.2, accuracy: 0.001)
        XCTAssertEqual(params!.servingSizeGrams, 35.0, accuracy: 0.001)
        XCTAssertEqual(params?.primaryColorHex, "#FF6B35")
        XCTAssertEqual(params?.accentColorHex, "#004E64")
    }

    func testParse_minimalRequiredParams() {
        // Only required: brand, sku, cal
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default&cal=3.5")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params?.brandId, "acme")
        XCTAssertEqual(params?.brandName, "Acme") // defaults to capitalized brandId
        XCTAssertEqual(params?.skuId, "default")
        XCTAssertEqual(params?.skuName, "Default") // defaults to capitalized skuId
        XCTAssertEqual(params!.caloriesPerGram, 3.5, accuracy: 0.001)
        XCTAssertEqual(params!.servingSizeGrams, 35.0, accuracy: 0.001) // default
        XCTAssertNil(params?.primaryColorHex)
        XCTAssertNil(params?.accentColorHex)
    }

    func testParse_percentEncodedSkuName() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=chicken&cal=3.0&skuname=Weight%20Management%20Chicken%20%26%20Rice")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params?.skuName, "Weight Management Chicken & Rice")
    }

    func testParse_decimalCalories() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=wet&cal=1.25")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params!.caloriesPerGram, 1.25, accuracy: 0.001)
    }

    // MARK: - Invalid URL Tests

    func testParse_wrongScheme() {
        let url = URL(string: "https://activate?brand=acme&sku=default&cal=3.5")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_wrongHost() {
        let url = URL(string: "catweighttracker://register?brand=acme&sku=default&cal=3.5")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_missingBrand() {
        let url = URL(string: "catweighttracker://activate?sku=default&cal=3.5")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_missingSku() {
        let url = URL(string: "catweighttracker://activate?brand=acme&cal=3.5")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_missingCal() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_invalidCalValue() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default&cal=notanumber")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    // MARK: - Edge Cases

    func testParse_emptyQueryItems() {
        let url = URL(string: "catweighttracker://activate")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNil(params)
    }

    func testParse_extraUnknownParams() {
        // Extra params should be ignored
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default&cal=3.0&unknown=value&extra=data")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params?.brandId, "acme")
    }

    func testParse_servingDefaultsTo35() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default&cal=3.0")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params!.servingSizeGrams, 35.0, accuracy: 0.001)
    }

    func testParse_invalidServingDefaultsTo35() {
        let url = URL(string: "catweighttracker://activate?brand=acme&sku=default&cal=3.0&serving=invalid")!

        let params = BrandActivationParams.parse(from: url)

        XCTAssertNotNil(params)
        XCTAssertEqual(params!.servingSizeGrams, 35.0, accuracy: 0.001)
    }
}
