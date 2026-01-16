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

Ship the app to users and execute comprehensive B2B outreach campaign to pet food brands.

**Depth:** Comprehensive (10 phases)
**Parallelization:** Enabled (Phases 9-10 can run concurrent, 14-17 can run concurrent)

### Phases

- [ ] **Phase 9: Xcode Firebase Integration** - Add Firebase SDK to Xcode project
- [ ] **Phase 10: GitHub Pages Deployment** - Deploy privacy policy and support pages
- [ ] **Phase 11: TestFlight Deployment** - Archive, upload, internal testing
- [ ] **Phase 12: App Store Submission** - Submit for review, handle feedback
- [ ] **Phase 13: Support Infrastructure** - FAQ, contact form, help docs
- [ ] **Phase 14: Smalls Outreach Campaign** - Execute full 4-email sequence
- [ ] **Phase 15: Tier 1 Brand Expansion** - Open Farm, Nulo, Raised Right, Weruva
- [ ] **Phase 16: CRM & Pipeline Setup** - Track all outreach, responses, follow-ups
- [ ] **Phase 17: Demo Recording** - Loom video walkthrough for async pitches
- [ ] **Phase 18: Pilot Agreement Execution** - LOI → signed pilot with first brand

### Phase Details

#### Phase 9: Xcode Firebase Integration
**Goal**: Properly integrate Firebase SDK into Xcode project
**Depends on**: Milestone 2 complete
**Research**: Unlikely (docs in FIREBASE_SPM_SETUP.md)
**Plans**: 1 plan

Tasks:
- [ ] Add Firebase SPM packages to Xcode
- [ ] Copy GoogleService-Info.plist to correct location
- [ ] Initialize Firebase in AppDelegate/App
- [ ] Verify Analytics events fire in Firebase Console
- [ ] Test on real device

#### Phase 10: GitHub Pages Deployment
**Goal**: Deploy required web pages for App Store compliance
**Depends on**: Nothing (can run parallel to Phase 9)
**Research**: Unlikely (GitHub Pages standard)
**Plans**: 1 plan

Tasks:
- [ ] Enable GitHub Pages on CatWeightLoss repo
- [ ] Configure docs/ folder as source
- [ ] Deploy privacy-policy.html at /privacy
- [ ] Verify live URL works
- [ ] Update placeholder URLs in App Store metadata

#### Phase 11: TestFlight Deployment
**Goal**: Get app running on TestFlight for internal testing
**Depends on**: Phase 9
**Research**: Unlikely (standard Xcode flow)
**Plans**: 1 plan

Tasks:
- [ ] Create App Store Connect app record
- [ ] Archive release build
- [ ] Upload to App Store Connect
- [ ] Add internal testers
- [ ] Run through full app flow on device

#### Phase 12: App Store Submission
**Goal**: Submit app for App Store review and get approved
**Depends on**: Phase 10, Phase 11
**Research**: Unlikely (metadata already prepared)
**Plans**: 1 plan

Tasks:
- [ ] Upload screenshots (6.7", 6.5", 5.5")
- [ ] Fill in all App Store metadata
- [ ] Set privacy policy and support URLs
- [ ] Submit for review
- [ ] Address any reviewer feedback

#### Phase 13: Support Infrastructure
**Goal**: Set up support channels for users and brands
**Depends on**: Phase 10
**Research**: Unlikely (simple web pages)
**Plans**: 1 plan

Tasks:
- [ ] Create support.html with FAQ
- [ ] Add contact form (Formspree/Tally)
- [ ] Write help docs for common questions
- [ ] Create brand inquiry contact flow
- [ ] Deploy to GitHub Pages

#### Phase 14: Smalls Outreach Campaign
**Goal**: Execute complete outreach sequence to Smalls
**Depends on**: Phase 12 (app live for credibility)
**Research**: Unlikely (emails already drafted)
**Plans**: 1 plan

Tasks:
- [ ] Personalize Email 1 with latest Smalls research
- [ ] Send to Matt Michaelson (CEO) and Melody Park (Brand Marketing)
- [ ] Track opens with email tracking tool
- [ ] Day 3: Send Email 2 follow-up
- [ ] Day 7: Send Email 3 (competitive angle)
- [ ] Day 14: Send Email 4 (break-up)
- [ ] Document all responses

#### Phase 15: Tier 1 Brand Expansion
**Goal**: Begin outreach to remaining Tier 1 brands
**Depends on**: Phase 14 (learn from Smalls)
**Research**: Likely (need to research each brand)
**Plans**: 2 plans

Tasks:
- [ ] Research Open Farm (contacts, recent news, pain points)
- [ ] Research Nulo (contacts, differentiators)
- [ ] Research Raised Right (contacts, positioning)
- [ ] Research Weruva (contacts, market position)
- [ ] Customize email templates per brand
- [ ] Begin outreach with 2-day stagger

#### Phase 16: CRM & Pipeline Setup
**Goal**: Establish systematic tracking for all outreach
**Depends on**: Phase 14 (need data to track)
**Research**: Unlikely (simple Notion/Sheets)
**Plans**: 1 plan

Tasks:
- [ ] Create outreach tracker (brand, status, next action, notes)
- [ ] Define pipeline stages (researched → contacted → replied → demo → pilot → signed)
- [ ] Set up response templates for common objections
- [ ] Create follow-up reminder system
- [ ] Weekly pipeline review checklist

#### Phase 17: Demo Recording
**Goal**: Create async demo video for email pitches
**Depends on**: Phase 12 (need live app)
**Research**: Unlikely (Loom is straightforward)
**Plans**: 1 plan

Tasks:
- [ ] Write demo script (from LOOM_SCRIPT.md)
- [ ] Record 3-5 minute walkthrough
- [ ] Show: QR scan → app activation → weight tracking → reorder flow
- [ ] Highlight analytics dashboard for brands
- [ ] Upload to Loom, get shareable link
- [ ] Add to email sequence as "See it in action"

#### Phase 18: Pilot Agreement Execution
**Goal**: Sign first design partner pilot agreement
**Depends on**: Phase 14-17 (need active conversations)
**Research**: Unlikely (LOI template ready)
**Plans**: 1 plan

Tasks:
- [ ] Identify warmest lead from outreach
- [ ] Schedule demo call
- [ ] Walk through ROI model with their numbers
- [ ] Send LOI from PILOT_LOI_TEMPLATE.md
- [ ] Negotiate terms if needed
- [ ] Get signature and kick off onboarding

---

## Progress

| Milestone | Phases | Status |
|-----------|--------|--------|
| 1. Stability & Testing | 3/3 | ✓ Complete |
| 2. B2B Monetization | 5/5 | ✓ Complete |
| 3. Go-to-Market | 0/10 | 🚧 In Progress |
