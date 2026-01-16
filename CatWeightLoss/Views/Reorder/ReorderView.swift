import SwiftUI
import SwiftData

struct ReorderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    let cat: Cat
    let brandConfig: BrandConfiguration
    let prediction: ReorderPrediction?

    @State private var selectedRetailer: Retailer?
    @State private var showingConfirmation = false

    private let affiliateCode = "cwl2026"  // Your affiliate tracking code

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Urgency Banner
                    if let prediction = prediction {
                        UrgencyBanner(prediction: prediction)
                    }

                    // Product Card
                    ProductCard(brandConfig: brandConfig)

                    // Retailer Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Where to Buy")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(Retailer.all) { retailer in
                            RetailerCard(
                                retailer: retailer,
                                isSelected: selectedRetailer?.id == retailer.id,
                                onSelect: { selectedRetailer = retailer }
                            )
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
            .navigationTitle("Reorder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                // Firebase Analytics: reorder screen viewed
                let skuId = brandConfig.defaultSKUId
                MetricsAggregator.shared.recordReorderViewed(
                    brandId: brandConfig.brandId,
                    skuId: skuId,
                    in: modelContext
                )
                AnalyticsService.shared.logReorderViewed(
                    brandId: brandConfig.brandId,
                    skuId: skuId
                )
            }
            .safeAreaInset(edge: .bottom) {
                // Order Button
                VStack(spacing: 12) {
                    Button(action: initiateReorder) {
                        HStack {
                            if let retailer = selectedRetailer {
                                Image(systemName: retailer.logoSystemImage)
                                Text("Order from \(retailer.name)")
                            } else {
                                Text("Select a Retailer")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedRetailer != nil ? brandConfig.primaryColor : Color.gray)
                        .cornerRadius(14)
                    }
                    .disabled(selectedRetailer == nil)

                    Text("Opens retailer website • Free to browse")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .alert("Opening \(selectedRetailer?.name ?? "Retailer")", isPresented: $showingConfirmation) {
            Button("Continue") {
                completeReorder()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You'll be redirected to \(selectedRetailer?.name ?? "the retailer")'s website to complete your purchase.")
        }
    }

    private func initiateReorder() {
        guard selectedRetailer != nil else { return }
        showingConfirmation = true
    }

    private func completeReorder() {
        guard let retailer = selectedRetailer else { return }

        // Record the reorder event
        let skuId = brandConfig.defaultSKUId
        MetricsAggregator.shared.recordReorderClick(
            brandId: brandConfig.brandId,
            skuId: skuId,
            retailerId: retailer.id,
            in: modelContext
        )

        // Firebase Analytics: reorder clicked
        AnalyticsService.shared.logReorderClicked(
            brandId: brandConfig.brandId,
            skuId: skuId,
            retailer: retailer.name
        )

        // Open retailer URL
        if let url = retailer.affiliateURL(skuId: skuId, affiliateCode: affiliateCode) {
            openURL(url)
        }

        dismiss()
    }
}

// MARK: - Urgency Banner

struct UrgencyBanner: View {
    let prediction: ReorderPrediction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: prediction.urgency.icon)
                .font(.title2)
                .foregroundColor(prediction.urgency.color)

            VStack(alignment: .leading, spacing: 2) {
                Text(prediction.urgency.rawValue)
                    .font(.headline)
                    .foregroundColor(prediction.urgency.color)

                Text(timeDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Bag level indicator
            BagLevelIndicator(percentage: prediction.currentBagPercentage)
        }
        .padding()
        .background(prediction.urgency.color.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var timeDescription: String {
        switch prediction.daysUntilEmpty {
        case 0: return "Running out today!"
        case 1: return "About 1 day left"
        case 2...7: return "About \(prediction.daysUntilEmpty) days left"
        default: return "~\(prediction.daysUntilEmpty / 7) weeks remaining"
        }
    }
}

// MARK: - Bag Level Indicator

struct BagLevelIndicator: View {
    let percentage: Double

    var body: some View {
        ZStack {
            // Bag outline
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 2)
                .frame(width: 30, height: 44)

            // Fill level
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .fill(fillColor)
                    .frame(width: 24, height: max(4, 38 * percentage))
            }
            .frame(width: 30, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }

    private var fillColor: Color {
        switch percentage {
        case 0..<0.2: return .red
        case 0.2..<0.4: return .orange
        default: return .green
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let brandConfig: BrandConfiguration

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Product image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(brandConfig.primaryColor.opacity(0.15))
                        .frame(width: 80, height: 80)

                    if let sku = brandConfig.defaultSKU,
                       let imageData = sku.productImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    } else {
                        Text(brandConfig.brandName.prefix(2).uppercased())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(brandConfig.primaryColor)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(brandConfig.brandName)
                        .font(.headline)

                    if let sku = brandConfig.defaultSKU {
                        Text(sku.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(sku.formattedServing)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Retailer Card

struct RetailerCard: View {
    let retailer: Retailer
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Retailer icon
                ZStack {
                    Circle()
                        .fill(retailer.brandColor.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: retailer.logoSystemImage)
                        .font(.title3)
                        .foregroundColor(retailer.brandColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(retailer.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(retailer.deliveryEstimate)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // Features
                    HStack(spacing: 8) {
                        ForEach(retailer.features.prefix(2), id: \.self) { feature in
                            Text(feature)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.tertiarySystemBackground))
                                .cornerRadius(4)
                        }
                    }
                }

                Spacer()

                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? retailer.brandColor : .secondary.opacity(0.5))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? retailer.brandColor : Color.clear, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
            )
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    let config = BrandConfiguration(
        brandId: "royal-canin",
        brandName: "Royal Canin",
        primaryColorHex: "#E31837",
        accentColorHex: "#1C3F94",
        defaultSKUId: "rc-weight-care"
    )

    let prediction = ReorderPrediction(
        daysUntilEmpty: 5,
        confidence: 0.8,
        recommendedOrderDate: Date(),
        currentBagPercentage: 0.25
    )

    let cat = Cat(name: "Luna", startWeight: 14.0, targetWeight: 11.0, weightUnit: .lbs)

    return ReorderView(cat: cat, brandConfig: config, prediction: prediction)
}
