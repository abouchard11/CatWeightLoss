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
                        seedDemoCat()
                    } label: {
                        Label("Seed Demo Cat (Mittens)", systemImage: "cat")
                    }

                    Button {
                        MetricsAggregator.shared.seedDemoMetrics(in: modelContext)
                    } label: {
                        Label("Seed Demo Analytics Data", systemImage: "chart.line.uptrend.xyaxis")
                    }

                    Button(role: .destructive) {
                        clearDemoCat()
                    } label: {
                        Label("Clear Demo Cat", systemImage: "trash")
                    }

                    Button(role: .destructive) {
                        MetricsAggregator.shared.clearDemoMetrics(in: modelContext)
                    } label: {
                        Label("Clear Demo Metrics", systemImage: "trash")
                    }
                } header: {
                    Text("Demo Data")
                } footer: {
                    Text("Seed demo cat with weight history and analytics data for presentations.")
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

    // MARK: - Demo Cat Seeding

    private func seedDemoCat() {
        // Create demo cat "Mittens" with realistic weight loss journey
        let mittens = Cat(
            name: "Mittens",
            breed: "Domestic Shorthair",
            birthDate: Calendar.current.date(byAdding: .year, value: -5, to: Date()),
            startWeight: 14.0,
            targetWeight: 10.0,
            weightUnit: .lbs,
            dailyActivityMinutes: 20
        )
        modelContext.insert(mittens)

        // Add weight entries showing gradual progress over 30 days
        let calendar = Calendar.current
        var currentWeight = 14.0

        for daysAgo in stride(from: 28, through: 0, by: -3) {
            guard let entryDate = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else { continue }

            // Simulate gradual weight loss with some variation
            let dailyLoss = Double.random(in: 0.05...0.15)
            currentWeight = max(mittens.targetWeight, currentWeight - dailyLoss * 3)

            let entry = WeightEntry(
                weight: currentWeight + Double.random(in: -0.1...0.1),
                date: entryDate,
                notes: daysAgo == 0 ? "Looking great!" : nil
            )
            mittens.addWeightEntry(entry)
        }

        print("[AdminHub] Seeded demo cat: Mittens with \(mittens.weightEntries.count) weight entries")
    }

    private func clearDemoCat() {
        let descriptor = FetchDescriptor<Cat>(
            predicate: #Predicate { $0.name == "Mittens" }
        )

        do {
            let cats = try modelContext.fetch(descriptor)
            for cat in cats {
                modelContext.delete(cat)
            }
            print("[AdminHub] Cleared \(cats.count) demo cat(s)")
        } catch {
            print("[AdminHub] Failed to clear demo cat: \(error.localizedDescription)")
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
