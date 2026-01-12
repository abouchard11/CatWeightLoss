import SwiftUI
import SwiftData

#if DEBUG
/// DEBUG-only admin hub for B2B demo and brand management tools
struct AdminHubView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.brandConfig) private var currentBrand

    @State private var showingBrandSwitcher = false
    @State private var showingQRGenerator = false
    @State private var showingAnalytics = false

    var body: some View {
        NavigationStack {
            List {
                // Current Brand Section
                if let brand = currentBrand {
                    Section {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [brand.primaryColor, brand.accentColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(brand.brandName.prefix(2))
                                        .font(.headline.bold())
                                        .foregroundColor(.white)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(brand.brandName)
                                    .font(.headline)
                                Text("ID: \(brand.brandId)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Active Brand")
                    }
                }

                // Brand Management
                Section {
                    Button {
                        showingBrandSwitcher = true
                    } label: {
                        Label("Switch Brand", systemImage: "paintpalette")
                    }

                    Button {
                        BrandConfigService.shared.seedDemoBrands(in: modelContext)
                    } label: {
                        Label("Seed All Demo Brands", systemImage: "square.stack.3d.up")
                    }
                } header: {
                    Text("Brand Management")
                } footer: {
                    Text("Manage white-label brand configurations for demo purposes.")
                }

                // Demo Data
                Section {
                    Button {
                        MetricsAggregator.shared.seedDemoMetrics(in: modelContext)
                    } label: {
                        Label("Seed Demo Analytics Data", systemImage: "chart.line.uptrend.xyaxis")
                    }

                    Button(role: .destructive) {
                        MetricsAggregator.shared.clearDemoMetrics(in: modelContext)
                    } label: {
                        Label("Clear Demo Metrics", systemImage: "trash")
                    }
                } header: {
                    Text("Demo Data")
                } footer: {
                    Text("Seed realistic analytics data spanning 30 days for dashboard demos.")
                }

                // B2B Tools
                Section {
                    Button {
                        showingQRGenerator = true
                    } label: {
                        Label("QR Code Generator", systemImage: "qrcode")
                    }

                    Button {
                        showingAnalytics = true
                    } label: {
                        Label("Analytics Dashboard", systemImage: "chart.bar.xaxis")
                    }
                } header: {
                    Text("B2B Tools")
                } footer: {
                    Text("Tools for brand onboarding and performance tracking.")
                }

                // Deep Link Testing
                Section {
                    if let brand = currentBrand, let sku = brand.defaultSKU {
                        let testURL = buildTestURL(brand: brand, sku: sku)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Test Deep Link")
                                .font(.subheadline.bold())

                            Text(testURL)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(3)

                            Button("Copy to Clipboard") {
                                UIPasteboard.general.string = testURL
                            }
                            .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Testing")
                }

                // Info Section
                Section {
                    LabeledContent("App Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    LabeledContent("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                    LabeledContent("Environment", value: "DEBUG")
                } header: {
                    Text("Info")
                }
            }
            .navigationTitle("Admin Hub")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingBrandSwitcher) {
                BrandSwitcherView()
            }
            .sheet(isPresented: $showingQRGenerator) {
                QRCodeGeneratorView()
            }
            .sheet(isPresented: $showingAnalytics) {
                AnalyticsDashboardView()
            }
        }
    }

    private func buildTestURL(brand: BrandConfiguration, sku: FoodSKU) -> String {
        var components = URLComponents()
        components.scheme = "catweighttracker"
        components.host = "activate"
        components.queryItems = [
            URLQueryItem(name: "brandId", value: brand.brandId),
            URLQueryItem(name: "brandName", value: brand.brandName),
            URLQueryItem(name: "skuId", value: sku.skuId),
            URLQueryItem(name: "skuName", value: sku.displayName),
            URLQueryItem(name: "cal", value: String(sku.caloriesPerGram)),
            URLQueryItem(name: "serving", value: String(sku.servingSizeGrams)),
            URLQueryItem(name: "primary", value: brand.primaryColorHex),
            URLQueryItem(name: "accent", value: brand.accentColorHex)
        ]
        return components.url?.absoluteString ?? ""
    }
}

// MARK: - Preview

#Preview {
    AdminHubView()
        .modelContainer(for: BrandConfiguration.self, inMemory: true)
}
#endif
