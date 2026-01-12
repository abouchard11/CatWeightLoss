# CatWeightLoss — B2B Monetization Platform

**Vision:** Transform CatWeightLoss into a white-label B2B platform where pet food brands pay for QR-activated, branded weight management apps that drive reorders through affiliate links.

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
- ✓ Graceful database error recovery — M1 complete
- ✓ Unit tests for core calculations — M1 complete
- ✓ Brand configuration system — session complete
- ✓ Demo brand seed data (4 brands) — session complete
- ✓ Reorder flow with retailer links — session complete
- ✓ DEBUG brand switcher — session complete

### Active (Milestone 2: B2B Monetization)

- [ ] Asset Catalog organization for brand images
- [ ] QR code generator for brand onboarding
- [ ] Analytics dashboard for brand metrics
- [ ] Brand admin documentation/specs
- [ ] End-to-end demo flow validation
- [ ] B2B target company research

### Out of Scope

- CloudKit sync — future milestone
- In-app purchases — brands pay B2B, not consumers
- Push notifications — keep simple
- Social features — weight tracking is private

---

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Fix fatalError first | App crash prevents all other work | ✓ Complete |
| XCTest over Quick/Nimble | Zero dependencies philosophy | ✓ Complete |
| 4 demo brands | Cover major brand aesthetics (Royal Canin, Hill's, Purina, Blue Buffalo) | ✓ Complete |
| Affiliate links for monetization | No in-app purchase friction, brands get attribution | ✓ Complete |
| QR deep link activation | Frictionless brand onboarding from product packaging | ✓ Complete |
| Anonymous metrics only | GDPR-compliant, no PII collected | ✓ Complete |

---

## Business Model

```
Brand pays → QR codes on packaging → Consumer scans → Branded app activates
                                                    ↓
                        Consumer tracks weight → Reorder CTA → Affiliate purchase
                                                    ↓
                        Brand gets: engagement data + reorder attribution
```

**Revenue streams:**
1. Setup fee per brand ($X,XXX)
2. Per-activation fee ($X.XX)
3. Affiliate commission on reorders (X%)

---

## Constraints

- **Platform:** iOS 17.0+, Swift 5.9
- **Architecture:** MVVM + Service-based pattern
- **Dependencies:** Zero (Apple frameworks only)
- **Privacy:** No PII, anonymous device IDs only

---

## Success Criteria (Milestone 2)

1. Asset Catalog properly organized with brand image sets
2. QR generator produces valid deep link codes
3. Analytics dashboard shows key metrics per brand
4. Full demo flow works end-to-end (scan → setup → track → reorder)
5. Target list of 10+ potential brand partners identified

---

*Last updated: 2026-01-12 after B2B Monetization milestone start*
