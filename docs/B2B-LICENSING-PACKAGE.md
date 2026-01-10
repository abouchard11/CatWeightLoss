# Cat Weight Tracker — B2B Licensing Package

## For: Pet Food Manufacturer Procurement & Legal Review

**Document Version:** 1.0
**App Status:** Production-Ready
**Distribution:** QR code on product packaging → App Store

---

# 1. Demo Narrative (90 Seconds)

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

# 2. BrandConfiguration Contract

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

# 3. Metrics Translation Layer

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

# 4. Procurement-Safe Scope Lock

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

# 5. Red-Flag Audit

## Current Design Review

### Medical Claims Risk: LOW ✓

| Area | Status | Evidence |
|------|--------|----------|
| UI language | Clean | No "recommended", "should", "healthy" found |
| Trend colors | Neutral | Blue/gray only, no red/green judgment |
| Progress framing | Neutral | "Target" not "goal", no celebration language |
| Weight loss rate | Capped | 2%/week max enforced in `PortionCalculator.swift:15` |
| Total loss | Capped | 30% max enforced in `QuickSetupView.swift:43` |

**Remaining risk:** The word "progress" appears. Consider replacing with "change" if legal requests.

### Data Ownership Risk: LOW ✓

| Area | Status | Evidence |
|------|--------|----------|
| Storage location | Device-only | SwiftData with `isStoredInMemoryOnly: false` |
| PII collected | None | No name, email, or identifiable data |
| Device identifier | Hashed | 16-char truncated XOR hash, not reversible |
| Data retention | 90 days | `cleanupOldMetrics(olderThanDays: 90)` in `MetricsAggregator.swift:186` |
| Transmission | None | No network calls implemented |

**Remaining risk:** If batch upload to brand endpoint is enabled in future, requires separate privacy review.

### Approval Timeline Risk: LOW ✓

| Factor | Status | Evidence |
|--------|--------|----------|
| Third-party SDKs | None | Pure SwiftUI + SwiftData |
| Network permissions | Not requested | Info.plist has no network entitlements |
| Health data | Not accessed | No HealthKit integration |
| Camera/photos | Not accessed | Photo picker removed |
| Notifications | Not requested | NotificationService removed |

**App Store review:** Expect standard 24-48 hour review. No special entitlements required.

### Trademark Risk: LOW ✓

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

**Prepared for:** Pet Food Manufacturer Procurement Review
**Prepared by:** Development Team
**Classification:** Commercial Confidential
