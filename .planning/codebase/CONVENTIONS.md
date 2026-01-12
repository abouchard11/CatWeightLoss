# Coding Conventions

**Analysis Date:** 2026-01-12

## Naming Patterns

**Files:**
- PascalCase for all files (`CatDetailView.swift`, `WeightEntry.swift`)
- View files suffixed with `View` (`WeightLogView.swift`)
- Service files suffixed with `Service` (`BrandConfigService.swift`)
- No special suffix for models (`Cat.swift`, `WeightEntry.swift`)

**Functions:**
- camelCase for all functions (`addWeightEntry()`, `recordActivation()`)
- No special prefix for async functions
- Handler pattern: `handle*` for event handlers (`handleIncomingURL()`)

**Variables:**
- camelCase for properties (`currentWeight`, `progressPercentage`)
- No underscore prefix for private properties
- Computed properties: same naming as stored properties

**Types:**
- PascalCase for classes, structs, enums (`Cat`, `WeightTrend`, `FoodType`)
- No `I` prefix for protocols
- Enum cases: camelCase (`WeightTrend.losing`, `FoodType.dry`)

## Code Style

**Formatting:**
- 4 space indentation
- No trailing whitespace
- Opening brace on same line
- No enforced line length limit

**Linting:**
- No SwiftLint configuration (`.swiftlint.yml` not present)
- No SwiftFormat configuration
- Relies on Xcode defaults

## Import Organization

**Order:**
1. Apple frameworks (Foundation, SwiftUI, SwiftData)
2. System frameworks (CryptoKit, Charts)
3. No third-party imports (no external dependencies)

**Example from `CatWeightLoss/Models/AnonymousMetric.swift`:**
```swift
import Foundation
import SwiftData
import UIKit
import CryptoKit
```

## Error Handling

**Patterns:**
- Assertions for debug validation: `assert(weight > 0, "Weight must be positive")`
- Safe coercion for release builds: `max(0.1, startWeight)`
- Guard statements for early return
- Optional chaining with nil-coalescing

**Examples:**
```swift
// From Cat.swift - Debug assertion + release safety
assert(startWeight > 0, "Start weight must be positive")
self.startWeight = max(0.1, startWeight)

// From PortionCalculator.swift - Guard against division by zero
let effectiveMeals = max(1, mealsPerDay)
```

## Logging

**Framework:**
- No dedicated logging framework
- `#if DEBUG` blocks for debug-only logging
- No console logs in production code

**Pattern:**
```swift
#if DEBUG
print("Debug: \(message)")
#endif
```

## Comments

**When to Comment:**
- Explain validation logic and edge cases
- Document business rules (`// Fixed 15% reduction - no user choice to avoid liability`)
- MARK: comments for section organization

**MARK Comments:**
```swift
// MARK: - Computed Properties
// MARK: - Weight Entry Management
// MARK: - Device Hashing
```

**Doc Comments:**
- Triple-slash for public APIs: `/// Calculate Resting Energy Requirement (RER)`
- Include parameter descriptions for complex functions
- Document return values and thrown errors

**Examples from `CatWeightLoss/Services/PortionCalculator.swift`:**
```swift
/// Calculate Resting Energy Requirement (RER) for a cat
/// Formula: RER = 70 × (body weight in kg)^0.75
static func restingEnergyRequirement(weightKg: Double) -> Double
```

## Function Design

**Size:**
- Keep functions focused and single-purpose
- Extract computed properties for derived values
- Use static methods for pure calculations

**Parameters:**
- Use default parameter values where sensible
- Destructure options in initializers when needed

**Return Values:**
- Return custom types for complex results (`DailyCalorieRecommendation`)
- Use computed properties for derived model values

## Module Design

**Exports:**
- No explicit export control (single module app)
- All types accessible within app target

**SwiftData Models:**
```swift
@Model
final class Cat {
    // Use final class for SwiftData models
}
```

**Observable Services:**
```swift
@Observable
class BrandConfigService {
    static let shared = BrandConfigService()
}
```

**Stateless Utilities:**
```swift
struct PortionCalculator {
    static func calculation(...) -> Result
}
```

## SwiftUI Patterns

**View State:**
- `@State` for local view state
- `@Environment` for injected dependencies
- `@Query` for SwiftData fetches
- `@Bindable` for mutable model binding

**Preview Blocks:**
```swift
#Preview {
    ViewName()
        .modelContainer(for: [Model.self], inMemory: true)
}
```

---

*Convention analysis: 2026-01-12*
*Update when patterns change*
