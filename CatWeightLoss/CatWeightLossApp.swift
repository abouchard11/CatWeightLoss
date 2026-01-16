import SwiftUI
import SwiftData
import FirebaseCore

@main
struct CatWeightLossApp: App {
    @State private var brandService = BrandConfigService.shared
    @State private var sharedModelContainer: ModelContainer?
    @State private var databaseError: Error?

    init() {
        // Initialize Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let error = databaseError {
                DatabaseErrorView(
                    error: error,
                    onRetry: { initializeDatabase() },
                    onReset: { resetDatabase() }
                )
            } else if let container = sharedModelContainer {
                RootView()
                    .environment(brandService)
                    .modelContainer(container)
            } else {
                ProgressView("Loading...")
                    .onAppear { initializeDatabase() }
            }
        }
        .handlesExternalEvents(matching: ["catweighttracker"])
    }

    private func initializeDatabase() {
        let schema = Schema([
            Cat.self,
            WeightEntry.self,
            FeedingSchedule.self,
            ActivitySession.self,
            BrandConfiguration.self,
            FoodSKU.self,
            AnonymousMetric.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            databaseError = nil
        } catch {
            databaseError = error
            sharedModelContainer = nil
        }
    }

    private func resetDatabase() {
        // Get the default store URL and delete it
        let url = URL.applicationSupportDirectory
            .appending(path: "default.store")

        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            // Also remove WAL and SHM files if they exist
            let walURL = url.appendingPathExtension("wal")
            let shmURL = url.appendingPathExtension("shm")
            try? FileManager.default.removeItem(at: walURL)
            try? FileManager.default.removeItem(at: shmURL)
        } catch {
            // If we can't delete, at least try to reinitialize
            print("Failed to delete database: \(error)")
        }

        initializeDatabase()
    }
}

// MARK: - Root View (Handles App State)

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BrandConfigService.self) private var brandService
    @Query private var cats: [Cat]
    @Query(sort: \BrandConfiguration.lastUsedAt, order: .reverse) private var brandConfigs: [BrandConfiguration]

    @State private var showingSplash = false
    @State private var showingSetup = false
    @State private var activeCat: Cat?

    var body: some View {
        Group {
            if let cat = activeCat ?? cats.first {
                // Main dashboard for existing cat
                NavigationStack {
                    CatDetailView(cat: cat)
                        .environment(\.brandConfig, brandService.activeBrandConfig)
                }
            } else if let config = brandService.activeBrandConfig ?? brandConfigs.first {
                // Have brand but no cat - show setup
                if showingSplash {
                    BrandSplashView(brandConfig: config) {
                        showingSplash = false
                        showingSetup = true
                    }
                } else if showingSetup {
                    QuickSetupView(brandConfig: config) { newCat in
                        activeCat = newCat
                        showingSetup = false
                    }
                } else {
                    // Default to setup
                    QuickSetupView(brandConfig: config) { newCat in
                        activeCat = newCat
                    }
                }
            } else {
                // No brand config - show demo activation
                DemoActivationView()
            }
        }
        .onOpenURL { url in
            handleIncomingURL(url)
        }
        .onAppear {
            loadInitialState()
        }
    }

    private func loadInitialState() {
        // Load active brand if available
        if brandService.activeBrandConfig == nil, let config = brandConfigs.first {
            brandService.activeBrandConfig = config
            config.lastUsedAt = Date()
        }

        // Set active cat if available
        if activeCat == nil {
            activeCat = cats.first
        }

        // Record app open metric
        if let config = brandService.activeBrandConfig ?? brandConfigs.first {
            MetricsAggregator.shared.recordAppOpen(
                brandId: config.brandId,
                skuId: config.defaultSKUId,
                in: modelContext
            )

            // Firebase Analytics: app opened
            AnalyticsService.shared.logAppOpened(brandId: config.brandId)
        }
    }

    private func handleIncomingURL(_ url: URL) {
        guard brandService.handleURL(url),
              let params = brandService.pendingActivation else {
            return
        }

        // Activate brand (metrics recorded inside activateBrand)
        _ = brandService.activateBrand(params: params, in: modelContext)

        // Show splash for new brand activation
        showingSplash = true
        showingSetup = false
        activeCat = nil
    }
}

// MARK: - Demo Activation View (No QR scenario)

struct DemoActivationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BrandConfigService.self) private var brandService

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                Text("Scan to Get Started")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Scan the QR code on your cat food\npackaging to activate the app")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            // Demo mode buttons (for testing)
            #if DEBUG
            VStack(spacing: 16) {
                Button("Use Demo Mode") {
                    let _ = brandService.createDemoBrand(in: modelContext)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Button("Load All Demo Brands") {
                    brandService.seedDemoBrands(in: modelContext)
                    // Activate the first one
                    if let first = brandService.getAllBrands(from: modelContext).first {
                        brandService.activeBrandConfig = first
                        first.lastUsedAt = Date()
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.7))
            }
            .padding(.bottom, 40)
            #endif
        }
        .padding()
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Cat.self, BrandConfiguration.self, FoodSKU.self], inMemory: true)
        .environment(BrandConfigService.shared)
}
