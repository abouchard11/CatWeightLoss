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
- [x] **Phase 7: Demo Polish** - End-to-end demo flow, splash screens, brand admin docs ✓
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

---

## Milestone 3: Go-to-Market (CURRENT)

Ship the app and close first design partner deal.

**Depth:** Quick (4 phases) | **Parallelization:** Enabled

### Phases

- [ ] **Phase 9: Ship to App Store** - Firebase SDK + TestFlight + Submit
- [ ] **Phase 10: Deploy Web Assets** - GitHub Pages privacy policy live
- [x] **Phase 10.1: Brand Visual Refresh** - Unified color scheme via Stitch + HTML ✓
- [ ] **Phase 11: Smalls Campaign** - Execute outreach, track responses
- [ ] **Phase 12: Close First Pilot** - Demo → LOI → Signature

### Phase Details

#### Phase 9: Ship to App Store
**Goal**: Get app live on App Store
**Depends on**: Milestone 2 complete
**Research**: Unlikely
**Plans**: 1 plan

Tasks:
- [ ] Add Firebase SPM to Xcode, verify GoogleService-Info.plist
- [ ] Archive and upload to TestFlight
- [ ] Quick device test
- [ ] Submit to App Store with prepared metadata
- [ ] Address review feedback if any

#### Phase 10: Deploy Web Assets
**Goal**: Privacy policy URL live for App Store compliance
**Depends on**: Nothing (parallel with Phase 9)
**Research**: Unlikely
**Plans**: 1 plan

Tasks:
- [ ] Enable GitHub Pages on repo (docs/ folder)
- [ ] Verify privacy-policy.html accessible
- [ ] Update App Store Connect URLs

#### Phase 10.1: Brand Visual Refresh ✓ COMPLETE
**Goal**: Unify app screens and sales PDF with consistent color scheme from DESIGN_SPECS.md
**Depends on**: Phase 10 (web assets deployed)
**Research**: Yes (Google Stitch for app UI)
**Plans**: 2 plans

Tasks:
- [x] Use Google Stitch to generate app UI mockups with unified color scheme
- [x] Redesign sales one-pager HTML with design spec colors (CSS variables)
- [x] Export assets and integrate into codebase (screenshots saved)
- [ ] Update existing SwiftUI views to match new design language (deferred)

**Deliverables:**
- docs/cat-weight-home-stitch.png (Home Dashboard)
- docs/cat-weight-screens-stitch.png (Log Weight, Insights)
- docs/cat-weight-all-screens-stitch.png (All 3 screens)
- docs/sales-one-pager-final.html (redesigned with CSS variables)

**Color Scheme Applied (from DESIGN_SPECS.md):**
- Primary: #0EA5E9 (Sky Blue)
- Success: #22C55E (Green)
- Warning: #F97316 (Orange)
- Purple Accent: #8B5CF6
- Surface: #F8FAFC
- Dark Slate: #0F172A

---

#### Phase 11: Smalls Campaign
**Goal**: Execute outreach to Smalls, get response
**Depends on**: Phase 9 (app live adds credibility)
**Research**: Unlikely (email drafted)
**Plans**: 1 plan

Tasks:
- [ ] Send Email 1 to Matt Michaelson + Melody Park
- [ ] Track opens/clicks
- [ ] Day 3/7/14 follow-ups per sequence
- [ ] Handle any responses immediately

#### Phase 12: Close First Pilot
**Goal**: Signed design partner agreement
**Depends on**: Phase 11 (need interested lead)
**Research**: Unlikely (LOI ready)
**Plans**: 1 plan

Tasks:
- [ ] Schedule demo call with interested party
- [ ] Walk through app + ROI model
- [ ] Send LOI
- [ ] Negotiate and close

---

## Progress

| Milestone | Phases | Status |
|-----------|--------|--------|
| 1. Stability & Testing | 3/3 | ✓ Complete |
| 2. B2B Monetization | 5/5 | ✓ Complete |
| 3. Go-to-Market | 0/4 | 🚧 In Progress |
