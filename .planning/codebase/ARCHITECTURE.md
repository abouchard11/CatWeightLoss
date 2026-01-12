# Architecture

**Analysis Date:** 2026-01-12

## Pattern Overview

**MVVM + Service-Based Architecture**

Hybrid approach combining:
- SwiftUI declarative views with data binding
- SwiftData for persistence (replaces Core Data)
- Observable services for app-level state
- Computed properties on models for business logic
- No ViewModels needed - services injected directly via `@Environment`

## Conceptual Layers

### 1. Models (`CatWeightLoss/Models/`)
Core domain entities using SwiftData `@Model`:
- `Cat.swift` - Primary aggregate root
- `WeightEntry.swift` - Weight tracking entries
- `ActivitySession.swift` - Exercise logging
- `FeedingSchedule.swift` - Meal planning
- `BrandConfiguration.swift` - Brand metadata
- `FoodSKU.swift` - Product SKUs
- `AnonymousMetric.swift` - Privacy-preserving analytics
- `Enums.swift` - Shared types (WeightUnit, ActivityType, FoodType)

### 2. Services (`CatWeightLoss/Services/`)
Business logic and state management:
- `BrandConfigService.swift` - Singleton `@Observable`, handles QR activation
- `MetricsAggregator.swift` - Singleton `@Observable`, anonymous metrics
- `PortionCalculator.swift` - Stateless calorie calculations
- `DateFormatting.swift` - Cached date formatters

### 3. Views (`CatWeightLoss/Views/`)
Feature-organized screens:
- `CatDetailView.swift` - Main dashboard
- `Weight/` - WeightLogView, WeightChartView, WeightHistoryView
- `Feeding/` - FeedingPlanView, PortionCalculatorView
- `Activity/` - ActivityLogView, ActivityHistoryView
- `Onboarding/` - BrandSplashView, QuickSetupView

### 4. Components (`CatWeightLoss/Components/`)
Reusable UI elements:
- `ActionButton.swift` - Primary action buttons
- `StatCard.swift` - Statistics cards
- `ProgressRing.swift` - Circular progress
- `WeightTrendIndicator.swift` - Trend arrows
- `CatCard.swift` - Cat summary card
- `ViewModifiers.swift` - Custom modifiers

## Data Flow

### App Initialization
```
CatWeightLossApp.swift (Entry Point)
  ├─ Creates ModelContainer with all entities
  ├─ Injects BrandConfigService.shared via .environment()
  └─ Renders RootView

RootView
  ├─ @Query fetches Cats and BrandConfigurations
  ├─ Determines navigation state:
  │   ├─ No brand → DemoActivationView
  │   ├─ Brand, no cat → BrandSplashView → QuickSetupView
  │   └─ Cat exists → CatDetailView
  └─ Handles deep links (.onOpenURL)
```

### Brand Activation Flow
1. User scans QR → `catweighttracker://activate?brand=...&sku=...`
2. `RootView.handleIncomingURL()` → `BrandConfigService.handleURL()`
3. `BrandActivationParams.parse()` extracts URL parameters
4. `BrandConfigService.activateBrand()` creates/updates config
5. `MetricsAggregator.recordActivation()` logs event
6. UI transitions to setup flow

### Data Persistence
- **ModelContainer**: Initialized in `CatWeightLossApp.swift`
- **ModelContext**: Injected via `.modelContainer()` modifier
- **@Query**: Auto-syncs views with database
- **@Bindable**: Enables reactive model updates

## Key Abstractions

### Observable Service Pattern
```swift
@Observable
class BrandConfigService {
    static let shared = BrandConfigService()
    // Properties auto-notify SwiftUI
}
// Injected via @Environment(BrandConfigService.self)
```

### Computed Properties for Logic
```swift
// In Cat.swift - derived values on models
var currentWeight: Double { weightEntries.last?.weight ?? startWeight }
var progressPercentage: Double { ... }
var weightTrend: WeightTrend { ... }
```

### Stateless Calculators
```swift
// Pure functions, easy to test
struct PortionCalculator {
    static func restingEnergyRequirement(weightKg: Double) -> Double
    static func weightLossCalories(...) -> DailyCalorieRecommendation
}
```

### SwiftData Relationships
```swift
@Model final class Cat {
    @Relationship(deleteRule: .cascade, inverse: \WeightEntry.cat)
    var weightEntries: [WeightEntry] = []
}
```

## Entry Points

| Entry | File | Purpose |
|-------|------|---------|
| App | `CatWeightLossApp.swift` | @main, ModelContainer setup |
| State | `RootView` in same file | Navigation routing |
| Dashboard | `CatDetailView.swift` | Main user interface |
| Setup | `QuickSetupView.swift` | Cat creation |

## Module Boundaries

- **Models**: No dependencies on Views/Services
- **Services**: Depend on Models only
- **Views**: Depend on Models + Services via @Environment
- **Components**: Depend on Models only (reusable)

---

*Architecture analysis: 2026-01-12*
*Update when patterns change*
