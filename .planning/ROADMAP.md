# Roadmap: CatWeightLoss

## Milestone 1: Stability & Testing ✓ COMPLETE

Transform CatWeightLoss from functional prototype to production-ready by fixing the critical database initialization crash, adding test coverage for health-critical calculations, and addressing minor stability issues.

### Phases (All Complete)

- [x] **Phase 1: Foundation** - Fix critical fatalError, set up XCTest infrastructure
- [x] **Phase 2: Core Tests** - Unit tests for PortionCalculator and weight trend algorithm
- [x] **Phase 3: Polish** - URL parsing tests, device hash caching fix

**Completed:** 2026-01-12 | **Plans:** 6/6

---

## Milestone 2: B2B Monetization (CURRENT)

Build the tools and assets needed to pitch CatWeightLoss as a white-label B2B platform for pet food brands.

### Domain Expertise

Pet food industry B2B sales, affiliate marketing, brand partnership models

### Phases

- [x] **Phase 4: Brand Assets** - Asset Catalog structure with 4 brand folders, accessor methods ✓
- [x] **Phase 5: QR Tooling** - QRCodeGeneratorView with CoreImage, deep link builder ✓
- [x] **Phase 6: Analytics** - AnalyticsDashboardView with Charts, CSV export ✓
- [ ] **Phase 7: Demo Polish** - End-to-end demo flow, splash screens, brand admin docs
- [x] **Phase 8: B2B Outreach** - 18 target brands report, 3-tier priority system ✓

### Phase Details

#### Phase 4: Brand Assets
**Goal**: Organize all brand imagery into proper Asset Catalog structure
**Depends on**: Nothing (starting phase)
**Research**: Unlikely
**Plans**: 1 plan

Tasks:
- Create brand image sets in Assets.xcassets (logo, product, background per brand)
- Move generated Imagen 4 images into appropriate asset slots
- Add placeholder images for missing assets
- Update BrandConfiguration to reference asset catalog

#### Phase 5: QR Tooling
**Goal**: Enable brands to generate their own QR activation codes
**Depends on**: Phase 4
**Research**: Unlikely (CoreImage QR generation is standard)
**Plans**: 1 plan

Tasks:
- QRCodeGeneratorView with brand selector
- Generate catweighttracker:// deep links with brand params
- Export QR as PNG for print materials
- Preview activation flow from generated QR

#### Phase 6: Analytics
**Goal**: Show brands the value they're getting (engagement, reorders)
**Depends on**: Phase 4
**Research**: Unlikely (SwiftUI Charts is standard)
**Plans**: 1-2 plans

Tasks:
- AnalyticsDashboardView showing per-brand metrics
- Activation counts, daily active users, reorder clicks
- Visualize reorder funnel (viewed → clicked → converted)
- Export metrics as CSV for brand reporting

#### Phase 7: Demo Polish
**Goal**: Make the app demo-ready for B2B pitches
**Depends on**: Phase 5, 6
**Research**: Unlikely
**Plans**: 1 plan

Tasks:
- End-to-end demo script validation
- Brand splash screen polish
- Demo data seeding improvements
- Brand admin specification document

#### Phase 8: B2B Outreach
**Goal**: Identify and prioritize potential brand partners
**Depends on**: Phase 7
**Research**: Yes (market research on pet food brands)
**Plans**: 1 plan

Tasks:
- Research smaller/mid-tier pet food brands in acquisition mode
- Identify decision makers (VP Marketing, Digital, etc.)
- Create target list with contact info
- Draft initial outreach messaging

## Progress

| Milestone | Phases | Status |
|-----------|--------|--------|
| 1. Stability & Testing | 3/3 | ✓ Complete |
| 2. B2B Monetization | 4/5 | 90% Complete (Phase 7 remaining) |
