# Roadmap: CatWeightLoss Stability

## Overview

Transform CatWeightLoss from functional prototype to production-ready by fixing the critical database initialization crash, adding test coverage for health-critical calorie calculations, and addressing minor stability issues.

## Domain Expertise

None

## Phases

- [ ] **Phase 1: Foundation** - Fix critical fatalError, set up XCTest infrastructure
- [ ] **Phase 2: Core Tests** - Unit tests for PortionCalculator and weight trend algorithm
- [ ] **Phase 3: Polish** - URL parsing tests, device hash caching fix

## Phase Details

### Phase 1: Foundation
**Goal**: Eliminate app crash on database corruption, establish test infrastructure
**Depends on**: Nothing (first phase)
**Research**: Unlikely (SwiftData error handling is documented, XCTest is standard)
**Plans**: 2 plans

Plans:
- [ ] 01-01: Replace fatalError with graceful error recovery in ModelContainer init
- [ ] 01-02: Add CatWeightLossTests target to project.yml

### Phase 2: Core Tests
**Goal**: Test coverage for health-critical calorie calculations and weight trend algorithm
**Depends on**: Phase 1 (test infrastructure)
**Research**: Unlikely (testing pure functions with XCTest)
**Plans**: 2 plans

Plans:
- [ ] 02-01: PortionCalculator unit tests (RER, MER, weightLossCalories, validateTargetWeight)
- [ ] 02-02: Cat.weightTrend and Cat.progressPercentage tests

### Phase 3: Polish
**Goal**: Complete test coverage, fix device hash consistency
**Depends on**: Phase 2
**Research**: Unlikely (internal patterns)
**Plans**: 2 plans

Plans:
- [ ] 03-01: BrandActivationParams URL parsing tests
- [ ] 03-02: Cache device hash fallback in UserDefaults

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 0/2 | Not started | - |
| 2. Core Tests | 0/2 | Not started | - |
| 3. Polish | 0/2 | Not started | - |
