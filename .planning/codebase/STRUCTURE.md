# Directory Structure

**Analysis Date:** 2026-01-12

## Project Layout

```
CatWeightLoss/
├── .claude/                    # Claude Code configuration
│   └── get-shit-done/          # GSD plugin
├── .planning/                  # Planning documents
│   └── codebase/               # Codebase analysis (this folder)
├── CatWeightLoss/              # Main app source
│   ├── CatWeightLossApp.swift  # Entry point + RootView
│   ├── Info.plist              # App metadata
│   ├── Models/                 # Domain entities (8 files)
│   ├── Services/               # Business logic (4 files)
│   ├── Views/                  # Feature screens (10+ files)
│   ├── Components/             # Reusable UI (6 files)
│   └── Resources/
│       └── Assets.xcassets/    # Images and colors
├── CatWeightLoss.xcodeproj/    # Generated Xcode project
├── project.yml                 # XCGen configuration
└── README.md                   # Project documentation
```

## Source Organization

### Models (`CatWeightLoss/Models/`)
```
Models/
├── Cat.swift              # Primary entity (weight tracking, relationships)
├── WeightEntry.swift      # Weight log entry
├── FeedingSchedule.swift  # Meal planning
├── ActivitySession.swift  # Exercise session
├── BrandConfiguration.swift # Brand metadata and theming
├── FoodSKU.swift          # Product SKU details
├── AnonymousMetric.swift  # Privacy-preserving metrics
└── Enums.swift            # Shared enums (WeightUnit, ActivityType, etc.)
```

### Services (`CatWeightLoss/Services/`)
```
Services/
├── BrandConfigService.swift   # Brand activation, QR handling (@Observable)
├── MetricsAggregator.swift    # Anonymous metrics collection (@Observable)
├── PortionCalculator.swift    # Calorie/portion calculations (stateless)
└── DateFormatting.swift       # Cached date formatters
```

### Views (`CatWeightLoss/Views/`)
```
Views/
├── CatDetailView.swift        # Main dashboard
├── Weight/
│   ├── WeightLogView.swift    # Add/edit weight
│   ├── WeightChartView.swift  # Chart visualization
│   └── WeightHistoryView.swift # Historical entries
├── Feeding/
│   ├── FeedingPlanView.swift      # Meal schedule
│   └── PortionCalculatorView.swift # Portion calculator
├── Activity/
│   ├── ActivityLogView.swift      # Log exercise
│   └── ActivityHistoryView.swift  # Activity history
└── Onboarding/
    ├── BrandSplashView.swift  # Brand splash screen
    └── QuickSetupView.swift   # Cat creation form
```

### Components (`CatWeightLoss/Components/`)
```
Components/
├── ActionButton.swift         # Primary/compact buttons
├── StatCard.swift             # Statistics display cards
├── ProgressRing.swift         # Circular progress indicator
├── WeightTrendIndicator.swift # Trend arrows (up/down/stable)
├── CatCard.swift              # Cat summary card
└── ViewModifiers.swift        # Custom SwiftUI modifiers
```

## Key Locations

| Purpose | Location |
|---------|----------|
| App entry point | `CatWeightLoss/CatWeightLossApp.swift` |
| Root navigation | `RootView` in CatWeightLossApp.swift |
| Main dashboard | `CatWeightLoss/Views/CatDetailView.swift` |
| Calorie logic | `CatWeightLoss/Services/PortionCalculator.swift` |
| Brand activation | `CatWeightLoss/Services/BrandConfigService.swift` |
| Anonymous metrics | `CatWeightLoss/Services/MetricsAggregator.swift` |
| Project config | `project.yml` (XCGen) |
| App permissions | `CatWeightLoss/Info.plist` |

## File Count

| Directory | Swift Files |
|-----------|------------|
| Models/ | 8 |
| Services/ | 4 |
| Views/ | 10+ |
| Components/ | 6 |
| **Total** | ~30 |

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Files | PascalCase | `CatDetailView.swift` |
| Directories | PascalCase | `Models/`, `Services/` |
| View files | `*View.swift` | `WeightLogView.swift` |
| Model files | Entity name | `Cat.swift` |
| Service files | `*Service.swift` or utility name | `BrandConfigService.swift` |
| Component files | Component name | `StatCard.swift` |

---

*Structure analysis: 2026-01-12*
*Update when directory organization changes*
