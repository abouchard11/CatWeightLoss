# CatWeightLoss — Stability & Testing

**Vision:** Transform CatWeightLoss from functional prototype to production-ready app by addressing critical stability issues and adding test coverage for health-critical calculations.

---

## Requirements

### Validated

- ✓ Cat weight tracking with trend visualization — existing
- ✓ Calorie/portion calculations (RER, MER, weight loss) — existing
- ✓ Feeding schedule management — existing
- ✓ Activity session logging — existing
- ✓ Brand activation via deep linking — existing
- ✓ Privacy-first anonymous metrics — existing
- ✓ SwiftData persistence — existing

### Active

- [ ] Graceful error recovery for database initialization failures
- [ ] Unit tests for PortionCalculator (calorie calculations)
- [ ] Unit tests for Cat.weightTrend algorithm
- [ ] Unit tests for BrandActivationParams URL parsing
- [ ] Consistent device hash caching for metrics

### Out of Scope

- New features — focus on stability first
- UI changes — existing UI is functional
- External integrations — app stays offline-only
- CloudKit sync — future milestone

---

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Fix fatalError first | App crash prevents all other work | Pending |
| XCTest over Quick/Nimble | Zero dependencies philosophy | Pending |
| Test services before models | Pure functions easier to test | Pending |

---

## Constraints

- **Platform:** iOS 17.0+, Swift 5.9
- **Architecture:** Maintain MVVM + Service-based pattern
- **Dependencies:** Keep at zero (Apple frameworks only)
- **Testing:** XCTest only, no third-party test frameworks

---

## Success Criteria

1. App recovers gracefully from corrupted database (no crash)
2. PortionCalculator has >80% test coverage
3. Weight trend algorithm has edge case tests
4. Device hash persists across app launches

---

*Last updated: 2026-01-12 after initialization*
