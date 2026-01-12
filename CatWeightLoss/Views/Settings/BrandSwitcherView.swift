import SwiftUI
import SwiftData

#if DEBUG
/// DEBUG-only view for switching between demo brand configurations
/// This allows testing the white-label appearance with different brand themes
struct BrandSwitcherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.brandConfig) private var currentBrand

    @State private var brands: [BrandConfiguration] = []
    @State private var selectedBrandId: String?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(brands, id: \.brandId) { brand in
                        BrandRow(
                            brand: brand,
                            isSelected: brand.brandId == selectedBrandId
                        ) {
                            switchToBrand(brand)
                        }
                    }
                } header: {
                    Text("Available Brands")
                } footer: {
                    Text("Switch brands to preview different white-label configurations. This is a DEBUG feature only.")
                }

                Section {
                    Button("Seed All Demo Brands") {
                        seedBrands()
                    }

                    Button("Reset Brand Data", role: .destructive) {
                        resetBrands()
                    }
                } header: {
                    Text("Actions")
                }
            }
            .navigationTitle("Brand Switcher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadBrands()
                selectedBrandId = currentBrand?.brandId
            }
        }
    }

    private func loadBrands() {
        brands = BrandConfigService.shared.getAllBrands(from: modelContext)
    }

    private func switchToBrand(_ brand: BrandConfiguration) {
        _ = BrandConfigService.shared.switchBrand(to: brand.brandId, in: modelContext)
        selectedBrandId = brand.brandId
        dismiss()
    }

    private func seedBrands() {
        BrandConfigService.shared.seedDemoBrands(in: modelContext)
        loadBrands()
    }

    private func resetBrands() {
        for brand in brands {
            modelContext.delete(brand)
        }
        brands = []
        selectedBrandId = nil
    }
}

// MARK: - Brand Row

private struct BrandRow: View {
    let brand: BrandConfiguration
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Brand color swatch
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [brand.primaryColor, brand.accentColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(brand.brandName.prefix(2))
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(brand.brandName)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if let sku = brand.defaultSKU {
                        Text(sku.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text("ID: \(brand.brandId)")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.7))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(brand.primaryColor)
                        .font(.title2)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Preview

#Preview {
    BrandSwitcherView()
        .modelContainer(for: BrandConfiguration.self, inMemory: true)
}
#endif
