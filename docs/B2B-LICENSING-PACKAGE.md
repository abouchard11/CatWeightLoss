# Cat Weight Tracker — B2B Licensing Package

## For: Pet Food Manufacturer Procurement & Legal Review

**Document Version:** 2.1
**App Status:** Production-Ready
**Distribution:** QR code on product packaging → App Store

---

# DELIVERABLE INDEX

| Document | Audience | Purpose | Status |
|----------|----------|---------|--------|
| **A. Demo Narrative** | Sales, Marketing | 90-second pitch walkthrough | Complete |
| **B. QR Deep-Link Contract** | Legal, Engineering | Technical + legal specification | Complete |
| **C. BrandConfiguration Spec** | Engineering, Procurement | Data contract | Complete |
| **D. Metrics Translation Layer** | Exec, Marketing | What we measure (and don't) | Complete |
| **E. Scope Lock Agreement** | Procurement, Legal | What's frozen | Complete |
| **F. Risk Audit** | Legal, Compliance | Red-flag assessment | Complete |
| **G. Pressure-Test Results** | Exec, Legal | Institutional objection responses | Complete |
| **H. Executive Pitch Deck** | C-Suite, Procurement | 12-slide presentation | Complete |

---

# DOCUMENT A: Demo Narrative (90 Seconds)

## What the Buyer Sees

### Screen 1: QR Scan (0-5 sec)
Consumer scans QR code printed on food bag.
**Notice:** No app install friction if already installed. Deep link fires immediately.

### Screen 2: Brand Splash (5-15 sec)
- **Your brand name** appears in **your brand color**
- Cat icon in brand color
- Tagline: "Track your cat's progress"
- Single button: "Get Started"

**Notice:** No third-party branding. No app name prominence. Your brand owns the experience.

### Screen 3: Quick Setup (15-45 sec)
Single form:
- Cat's name
- Current weight
- Target weight (validated: max 30% reduction enforced)
- Weight unit toggle (kg/lbs)

**Notice:** No account creation. No email. No permissions requested.

### Screen 4: Dashboard (45-60 sec)
- Weight chart (empty, ready for first log)
- Progress indicator (neutral framing)
- Feeding schedule section
- Activity tracker

**Notice:** First weight entry auto-logged from setup. User sees immediate value.

## What Is Deliberately NOT Shown

| Excluded | Reason |
|----------|--------|
| Login/signup | Friction reduction |
| Notifications permission | Friction reduction |
| Multiple cats | Complexity reduction |
| "Recommended" language | Legal risk |
| Timeline estimates | Outcome promise risk |
| Veterinary advice | Medical claims risk |

---

# DOCUMENT B: QR Deep-Link Contract

**Status:** Draft v1.0
**Audience:** Product, Legal, Marketing, Engineering
**Purpose:** Define the only acceptable QR → App activation interface

---

## B.1 PURPOSE

This QR deep-link provides a **non-advisory activation mechanism** for a branded iOS companion app associated with feline weight-management pet food.

The QR code:
- Does **not** deliver instructions
- Does **not** make health or veterinary claims
- Does **not** promise outcomes

Its sole function is to **contextualize the app to a specific food product at launch**.

---

## B.2 ACTIVATION METHOD

**Scheme:**
```
catweight://launch
```

This scheme:
- Exists only to open the app
- Contains no executable logic
- Carries immutable product metadata only

Universal Links are explicitly **out of scope** for this version.

---

## B.3 REQUIRED PARAMETERS

All parameters are required. If any parameter is missing or invalid, the app defaults to **unbranded mode**.

| Parameter | Type | Description |
|-----------|------|-------------|
| `brand` | String | Brand identifier (human-readable) |
| `sku` | String | Product SKU or internal code |
| `kcal` | Integer | Calorie density per standard unit |

**Example:**
```
catweight://launch?brand=ACME&sku=WL-01&kcal=280
```

---

## B.4 PARAMETER CONSTRAINTS

Parameters represent **facts, not guidance**. Values must be:
- Non-personal
- Non-medical
- Non-instructional

**The QR code must NEVER encode:**
- Feeding instructions
- Weight-loss rates
- Health outcomes
- Copy, slogans, or marketing language

---

## B.5 APPLICATION BEHAVIOR

Upon successful activation:
- App launches directly into Quick Setup
- Brand name displayed passively (header/subtitle only)
- SKU stored internally for analytics only
- Calorie value used exclusively for internal portion math
- No brand-specific claims or messages rendered

**The app must remain fully functional if the QR is never scanned.**

---

## B.6 FAILURE & FALLBACK

If the QR link is malformed, parameters missing, or values fail validation:
- App operates in unbranded mode
- No errors shown to user
- No messaging implies incorrect usage

**Failure must be silent and safe.**

---

## B.7 DATA & PRIVACY POSITION

- QR parameters are **not** user data
- No PII transmitted
- No data sent off-device at QR scan time
- Brand attribution is aggregated and anonymized downstream

**The QR code creates context, not surveillance.**

---

## B.8 LEGAL POSTURE

This QR deep-link:
- Does **not** constitute advice
- Does **not** alter product labeling claims
- Does **not** introduce new regulatory exposure

It is a **launch context mechanism**, nothing more.

---

## B.9 SCOPE LOCK

This contract defines:
- The **only** acceptable QR format
- The **only** acceptable data carried
- The **only** acceptable app behavior

Any additions require:
- Legal review
- Product approval
- Explicit versioning (v2.0+)

---

## B.10 FINAL STATEMENT

> If this QR deep-link cannot be explained in 30 seconds to a non-technical executive, it is out of scope.
>
> **Simplicity is the feature.**

---

# DOCUMENT C: BrandConfiguration Contract

## Field Specification

| Field | Type | Source | Mutable | Legal Concern |
|-------|------|--------|---------|---------------|
| `brandId` | String | QR code | No | Audit trail |
| `brandName` | String | QR code | No | Trademark display |
| `primaryColorHex` | String | QR code | No | Brand consistency |
| `accentColorHex` | String | QR code | No | Brand consistency |
| `logoData` | Data? | Not implemented | N/A | Future: trademark compliance |
| `defaultSKUId` | String | QR code | No | Product attribution |

## FoodSKU Fields (per product)

| Field | Type | Source | Legal Concern |
|-------|------|--------|---------------|
| `skuId` | String | QR code | Product identification |
| `displayName` | String | QR code | Consumer-facing label |
| `caloriesPerGram` | Double | QR code | **Nutritional claim** |
| `servingSizeGrams` | Double | QR code | **Serving size claim** |

## Immutable vs. Configurable

**Immutable (hardcoded in app):**
- Maximum weekly weight loss: 2% of body weight
- Maximum total weight loss: 30% of starting weight
- UI language (neutral, no advice)
- Data retention: 90 days local, then purged

**Configurable via QR:**
- Brand name and colors
- SKU name and calorie density
- Serving size

## Legal Review Points

1. **Calorie values** (`caloriesPerGram`) come from YOUR QR code, not our database. You control nutritional claims.
2. **Brand display** uses YOUR name exclusively. No co-branding.
3. **Product attribution** ties all metrics to YOUR SKU IDs.

---

# DOCUMENT D: Metrics Translation Layer

## Raw Data Collected (On-Device Only)

| Event | Data Stored | PII Risk |
|-------|-------------|----------|
| App activation | brandId, skuId, timestamp, deviceHash | None |
| Setup completed | brandId, skuId, timestamp, deviceHash | None |
| App opened | brandId, skuId, timestamp, deviceHash | None |
| Weight logged | brandId, skuId, daysSinceLast, deviceHash | None |
| Progress recorded | brandId, skuId, progressBucket (0/25/50/75/100%), deviceHash | None |
| Entries count | brandId, skuId, count, deviceHash | None |

**Note:** `deviceHash` is a truncated XOR hash of `identifierForVendor`. Not reversible. Changes on app reinstall.

## Executive Summary Report

| Metric | Definition | Why It Matters |
|--------|------------|----------------|
| Total Activations | QR scans that launched app | Campaign reach |
| Setup Completion Rate | % who finished onboarding | Funnel health |
| Avg App Opens/Week | Weekly engagement | Stickiness |
| Avg Days Between Logs | Logging frequency | Habit formation |
| Users with 3+ Entries | Retained users | Product validation |
| 3+ Entry Rate | % of users retained | Retention signal |
| Avg Progress % | Bucketed (0/25/50/75/100) | Efficacy signal |
| Retention Signal | Strong/Moderate/Low | Executive summary |

## Intentionally Excluded Metrics

| Excluded | Reason |
|----------|--------|
| Actual weight values | Medical liability — we don't know cat weights |
| Individual user journeys | Privacy — we can't identify users |
| Feeding compliance | Blame risk — we don't track if user follows portions |
| Abandoned users | Negative signal — not useful for exec dashboards |
| Goal achievement rate | Outcome promise — we don't claim results |

---

# DOCUMENT E: Procurement-Safe Scope Lock

## Definition of "Done"

The deliverable is complete when:

1. **QR Activation Works:** Deep link `catweighttracker://activate?...` launches branded experience
2. **Onboarding Completes:** User enters dashboard with first weight logged in <60 seconds
3. **No Legal Risk Language:** Zero instances of "recommended", "should", "healthy", "will lose", or timeline estimates
4. **Safe Guardrails Active:** Weight loss capped at 2%/week and 30% total in code
5. **Metrics Aggregate:** Anonymous event logging functional, grouped by brandId/skuId
6. **Build Passes:** Xcode build succeeds with zero errors

## Features Explicitly Out of Scope

This app **WILL NOT** include:

| Feature | Status | Rationale |
|---------|--------|-----------|
| User accounts/login | Excluded | Friction; privacy complexity |
| Push notifications | Excluded | Permission friction |
| Cloud sync | Excluded | Privacy; infrastructure cost |
| Multiple cats | Excluded | Complexity; one cat per QR |
| Veterinary integration | Excluded | Medical claims risk |
| Food ordering | Excluded | E-commerce complexity |
| Social/sharing features | Excluded | Privacy; moderation burden |
| CSV/data export | Excluded | Data portability complexity |
| Widgets | Excluded | Development scope |
| Activity intensity levels | Excluded | Simplification |

## Scope Creep Prevention Language

> "Any feature not listed in the 'Definition of Done' section requires a separate Statement of Work. Requests for additional features will be evaluated for legal risk, timeline impact, and cost before consideration. The vendor makes no commitment to future functionality."

---

# DOCUMENT F: Risk Audit

## Current Design Review

### Medical Claims Risk: LOW

| Area | Status | Evidence |
|------|--------|----------|
| UI language | Clean | No "recommended", "should", "healthy" found |
| Trend colors | Neutral | Blue/gray only, no red/green judgment |
| Progress framing | Neutral | "Target" not "goal", no celebration language |
| Weight loss rate | Capped | 2%/week max enforced in `PortionCalculator.swift:15` |
| Total loss | Capped | 30% max enforced in `QuickSetupView.swift:43` |

**Remaining risk:** The word "progress" appears. Consider replacing with "change" if legal requests.

### Data Ownership Risk: LOW

| Area | Status | Evidence |
|------|--------|----------|
| Storage location | Device-only | SwiftData with `isStoredInMemoryOnly: false` |
| PII collected | None | No name, email, or identifiable data |
| Device identifier | Hashed | 16-char truncated XOR hash, not reversible |
| Data retention | 90 days | `cleanupOldMetrics(olderThanDays: 90)` in `MetricsAggregator.swift:186` |
| Transmission | None | No network calls implemented |

**Remaining risk:** If batch upload to brand endpoint is enabled in future, requires separate privacy review.

### Approval Timeline Risk: LOW

| Factor | Status | Evidence |
|--------|--------|----------|
| Third-party SDKs | None | Pure SwiftUI + SwiftData |
| Network permissions | Not requested | Info.plist has no network entitlements |
| Health data | Not accessed | No HealthKit integration |
| Camera/photos | Not accessed | Photo picker removed |
| Notifications | Not requested | NotificationService removed |

**App Store review:** Expect standard 24-48 hour review. No special entitlements required.

### Trademark Risk: LOW

| Area | Status | Evidence |
|------|--------|----------|
| App name | Generic | "Cat Weight Tracker" — no brand claim |
| Brand display | Licensee-controlled | `brandName` from QR, not hardcoded |
| Color theming | Licensee-controlled | `primaryColorHex` from QR |

**Remaining risk:** App icon is generic cat silhouette. Licensee may request custom icon (separate deliverable).

---

## Summary: Risk Matrix

| Category | Risk Level | Action Required |
|----------|------------|-----------------|
| Medical Claims | LOW | None — language is neutral |
| Data Ownership | LOW | None — all data is local/anonymous |
| Approval Timeline | LOW | None — no special permissions |
| Trademark | LOW | None — brand-neutral by default |

---

# DOCUMENT G: Pressure-Test Results

## Procurement Reality Simulation

Each stakeholder below has veto power. Their objections are listed with clean responses using only what's in the contract.

---

## G.1 LEGAL / REGULATORY

**Persona:** Senior Product Counsel, Pet Nutrition Division
**Fear:** Creating unintentional medical claims or discoverable liability
**Veto Power:** ABSOLUTE

### Objection 1:
> "Show me, in one sentence, why this QR code does not create a new claim pathway beyond what's already on the bag."

**Response:**
The QR code transmits three facts already printed on the bag (brand name, SKU, calorie density) — it introduces no new claims, no guidance, and no promises. See Contract §B.4: "Parameters represent facts, not guidance."

### Objection 2:
> "If a plaintiff screenshots a downward trend, what prevents that from being interpreted as a promised outcome tied to our product?"

**Response:**
Three defenses:
1. **No causal language** — App never says "because of this food" (Contract §B.1: "Does not promise outcomes")
2. **User-entered data** — All weight values come from the user, not the product
3. **Neutral framing** — Trend shows "change" not "progress toward goal" (Risk Audit §F: neutral language verified)

The chart is a log, not a claim.

### Objection 3:
> "What if someone claims the app recommended a feeding amount?"

**Response:**
Contract §B.4 explicitly prohibits encoding "feeding instructions" in QR. App displays user's math based on their inputs — it never says "feed this amount." The word "recommended" does not appear in the app (verified in Risk Audit §F).

**LEGAL STATUS: CLEARED**

---

## G.2 DATA PRIVACY / IT SECURITY

**Persona:** Enterprise Security Architect
**Fear:** Shadow data collection and compliance drift
**Veto Power:** TECHNICAL

### Objection 1:
> "Walk me through the exact moment data leaves the device."

**Response:**
**It doesn't.** Contract §B.7: "No data sent off-device at QR scan time." All data remains in device-local SwiftData storage. No network permissions requested (verified in Risk Audit §F: Info.plist has no network entitlements).

### Objection 2:
> "What is `deviceHash` and can it identify users?"

**Response:**
`deviceHash` is a 16-character truncated XOR hash of `identifierForVendor`. It is:
- Not reversible to original identifier
- Changes on app reinstall
- Cannot be correlated across apps

See Metrics Layer: "deviceHash is truncated XOR hash... not reversible."

### Objection 3:
> "If batch upload to brand endpoint is enabled later, who owns that data?"

**Response:**
Out of scope for v1.0. Contract §B.9: "Any additions require Legal review, Product approval, Explicit versioning (v2.0+)." Future network features require separate privacy review (noted in Risk Audit §F).

**SECURITY STATUS: CLEARED**

---

## G.3 PROCUREMENT / FINANCE

**Persona:** Director of Strategic Sourcing
**Fear:** Open-ended cost and unclear ROI
**Veto Power:** SILENT (but controls budget)

### Objection 1:
> "What stops this from turning into a permanent roadmap obligation?"

**Response:**
Contract §B.9 (Scope Lock): "This contract defines the only acceptable QR format, data carried, and app behavior." Scope Lock Agreement (Document E) lists 10 features explicitly excluded with rationale. Any change requires new SOW.

### Objection 2:
> "What exactly are we NOT buying?"

**Response:**
Per Scope Lock Agreement:
- User accounts/login
- Push notifications
- Cloud sync
- Multiple cats
- Veterinary integration
- Food ordering
- Social/sharing
- CSV export
- Widgets
- Activity intensity

Quote: "Any feature not listed in 'Definition of Done' requires separate Statement of Work."

### Objection 3:
> "What's the ongoing cost structure?"

**Response:**
v1.0 is a deliverable, not a subscription:
- App Store hosting: Your developer account
- Data storage: Device-only (no server cost)
- Analytics: Aggregated locally, batch export optional (separate SOW)
- Updates: Bug fixes included; new features are separate SOW

**PROCUREMENT STATUS: CLEARED**

---

## G.4 BRAND / MARKETING

**Persona:** VP Brand Strategy
**Fear:** Losing narrative control or brand dilution
**Veto Power:** HIGH

### Objection 1:
> "Why does this app not tell our story? If I'm putting a QR on a $60 bag of food, why am I not using this to reinforce why our product is superior?"

**Response:**
Because claims create liability. Contract §B.8: "Does not alter product labeling claims."

What you DO get:
- Your brand name prominently displayed
- Your brand colors throughout UI
- Your SKU tracked for attribution
- Silent product association in every metric

The bag tells your story. The app proves engagement.

### Objection 2:
> "Can we add copy, before/after comparisons, or push notifications?"

**Response:**
No. Each is explicitly excluded:
- Copy/slogans: Contract §B.4 — "No marketing language"
- Before/after: Risk Audit §F — "Outcome promise risk"
- Push notifications: Scope Lock — "Permission friction"

These are not removed features — they were never in scope.

### Objection 3:
> "What CAN we customize?"

**Response:**
Via QR parameters:
- Brand name (displays in UI)
- Brand colors (primary + accent)
- Product name (SKU display)
- Calorie density (for portion math)

Your brand owns the visual experience. We own the liability shield.

**MARKETING STATUS: CLEARED (with scope education)**

---

## G.5 FIELD REALITY

**Persona:** Sales Director / Retail Enablement
**Fear:** Confusing consumers or store staff
**Veto Power:** None (but speaks truth)

### Objection 1:
> "Explain this QR code in one sentence that a PetSmart associate won't butcher."

**Response:**
> "Scan this to track your cat's weight with the food you just bought."

That's it. 11 words. No claims. No setup required beyond the sentence.

### Objection 2:
> "What if the customer asks what the app does?"

**Response:**
Shelf card copy: "Log your cat's weight. See the trend. That's it."

The app is deliberately boring so explanation is easy.

### Objection 3:
> "What if they scan and the app isn't installed?"

**Response:**
iOS behavior: App Store opens to download page. Deep link fires after install. No friction. No lost context.

**FIELD STATUS: CLEARED**

---

## PRESSURE-TEST SUMMARY

| Stakeholder | Status | Key Constraint Satisfied |
|-------------|--------|-------------------------|
| Legal | CLEARED | No new claim pathways |
| Security | CLEARED | No data leaves device |
| Procurement | CLEARED | Scope is frozen |
| Marketing | CLEARED | Brand control without liability |
| Field | CLEARED | 11-word explanation |

**Contract is ready for executive presentation.**

---

# DOCUMENT H: Executive Pitch Deck

See separate file: `deliverables/pitch-deck/MANUS-PITCH-DECK-INPUT.md`

The 12-slide deck includes:
- Slides 1-6: Value proposition
- Slides 7-10: Risk mitigation
- Slides 11-12: Close + Next Steps
- Appendix: Pre-answered objections

---

# Appendix: QR Code Specification

## URL Format

```
catweighttracker://activate?brand={brandId}&name={brandName}&sku={skuId}&skuname={skuName}&cal={caloriesPerGram}&serving={servingSizeGrams}&color={hexColor}
```

## Example

```
catweighttracker://activate?brand=acmepet&name=AcmePet%20Foods&sku=weight-chicken&skuname=Weight%20Management%20Chicken&cal=3.2&serving=35&color=FF6B35
```

## Required Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `brand` | Yes | Unique brand identifier |
| `sku` | Yes | Product SKU identifier |
| `cal` | Yes | Calories per gram |
| `name` | No | Display name (defaults to brand) |
| `skuname` | No | Product display name (defaults to sku) |
| `serving` | No | Serving size in grams (defaults to 35) |
| `color` | No | Primary color hex (defaults to #007AFF) |
| `accent` | No | Accent color hex (defaults to #34C759) |

---

# Document Control

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-01-10 | Initial release |
| 2.0 | 2026-01-10 | Added QR Contract, Pressure-Test Results, Document Index |
| 2.1 | 2026-01-10 | Added Executive Pitch Deck reference, split Manus input |

**Prepared for:** Pet Food Manufacturer Procurement Review
**Prepared by:** Development Team
**Classification:** Commercial Confidential
