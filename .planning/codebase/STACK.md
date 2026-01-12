# Technology Stack

**Analysis Date:** 2026-01-12

## Languages

**Primary:**
- Swift 5.9 - All application code

**Markup/Config:**
- YAML - XCGen project configuration (`project.yml`)
- XML - Xcode workspace and plist files

## Runtime & Platform

**iOS:**
- Minimum deployment: iOS 17.0
- Requires Xcode 15.0+
- Swift Package Manager (no external packages)

**Build System:**
- XCGen - YAML-based Xcode project generation (`project.yml`)
- Bundle ID: `com.catweightloss.app`
- Version: 1.0.0

## Frameworks

**Apple Frameworks (Built-in):**
- SwiftUI - Declarative UI framework (`CatWeightLoss/Views/**/*.swift`)
- SwiftData - Modern persistence layer (`CatWeightLoss/Models/*.swift`)
- Charts - Weight trend visualizations (`CatWeightLoss/Views/CatDetailView.swift`, `CatWeightLoss/Views/Weight/WeightChartView.swift`)
- CryptoKit - SHA-256 device hashing (`CatWeightLoss/Models/AnonymousMetric.swift`)
- Foundation - Core utilities
- UIKit - Device identifiers only (`CatWeightLoss/Models/AnonymousMetric.swift`)

**Third-Party Libraries:**
- None - Zero external dependencies

## Key Dependencies

**SwiftData Models:**
- `Cat` - Primary entity with weight tracking
- `WeightEntry` - Weight log entries
- `FeedingSchedule` - Meal planning
- `ActivitySession` - Exercise tracking
- `BrandConfiguration` - Multi-brand support
- `FoodSKU` - Product metadata
- `AnonymousMetric` - Privacy-preserving analytics

**Observable Services:**
- `BrandConfigService` - Brand activation and state
- `MetricsAggregator` - Anonymous metrics collection
- `PortionCalculator` - Calorie/portion calculations
- `DateFormatting` - Cached date formatters

## Configuration

**Project Configuration:**
- `project.yml` - XCGen project definition
- `CatWeightLoss/Info.plist` - App metadata and permissions

**No External Config:**
- No `.env` files (no external services)
- No API keys required
- All data stored locally via SwiftData

## Platform Notes

- **Offline-first**: All functionality works without network
- **Privacy-first**: No data transmission, local-only storage
- **Modern Swift**: Uses Swift 5.9 features (@Observable, @Query, @Model)
- **iOS 17+ Required**: SwiftData and Charts require iOS 17

---

*Stack analysis: 2026-01-12*
*Update when adding frameworks or changing requirements*
