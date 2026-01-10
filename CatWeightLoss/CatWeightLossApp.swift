import SwiftUI
import SwiftData

@main
struct CatWeightLossApp: App {
    @State private var brandService = BrandConfigService.shared

    var sharedModelContainer: ModelContainer = {
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
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(brandService)
        }
        .modelContainer(sharedModelContainer)
        .handlesExternalEvents(matching: ["catweighttracker"])
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
                CatDetailView(cat: cat)
                    .environment(\.brandConfig, brandService.activeBrandConfig)
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
    }

    private func handleIncomingURL(_ url: URL) {
        guard brandService.handleURL(url),
              let params = brandService.pendingActivation else {
            return
        }

        // Activate brand
        let config = brandService.activateBrand(params: params, in: modelContext)

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

            // Demo mode button (for testing)
            #if DEBUG
            Button("Use Demo Mode") {
                let _ = brandService.createDemoBrand(in: modelContext)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
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
