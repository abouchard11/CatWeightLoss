# Brand Administration Specification

## For: Brand Partners & Technical Integrators

**Document Version:** 1.0
**Last Updated:** 2026-01-12
**Status:** Production-Ready

---

## Overview

This document specifies the technical and operational requirements for brand partners integrating with the CatWeightLoss white-label platform. It covers:

1. QR Code Generation & Management
2. Brand Configuration Parameters
3. Analytics Dashboard Access
4. Demo Environment Setup
5. Production Deployment Checklist

---

## 1. QR Code Generation

### 1.1 Deep Link Format

All brand activation uses the following URL scheme:

```
catweighttracker://activate?{parameters}
```

### 1.2 Required Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `brand` | String | Unique brand identifier (lowercase, no spaces) | `acmepet` |
| `name` | String | Display name (URL-encoded) | `Acme%20Pet%20Foods` |
| `sku` | String | Product SKU identifier | `weight-chicken-4lb` |
| `skuname` | String | Product display name (URL-encoded) | `Weight%20Management%20Chicken` |
| `cal` | Double | Kilocalories per gram | `3.2` |

### 1.3 Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `serving` | Double | `35.0` | Serving size in grams |
| `color` | String | `007AFF` | Primary brand color (hex, no #) |
| `accent` | String | `34C759` | Accent color (hex, no #) |

### 1.4 Complete Example

```
catweighttracker://activate?brand=felinecare&name=FelineCare%20Premium&sku=fc-wm-chicken&skuname=Weight%20Management%20Chicken&cal=3.2&serving=35&color=2E7D32&accent=81C784
```

### 1.5 QR Code Specifications

| Attribute | Requirement |
|-----------|-------------|
| Error Correction | Level M (15% recovery) |
| Minimum Size | 2cm x 2cm at 300 DPI |
| Quiet Zone | 4 modules minimum |
| Format | PNG (preferred) or SVG |
| Resolution | 1000x1000px minimum for print |

### 1.6 In-App QR Generator

For internal testing and demo purposes, use the Admin Hub:

1. Launch app in DEBUG mode
2. Navigate to Admin Hub (gear icon in top toolbar)
3. Select "QR Code Generator"
4. Choose brand and SKU
5. Export QR as PNG for print materials

---

## 2. Brand Configuration

### 2.1 BrandConfiguration Model

Each activated brand creates a `BrandConfiguration` record with:

```swift
BrandConfiguration {
    brandId: String         // Unique identifier
    brandName: String       // Display name
    primaryColorHex: String // Primary color (#RRGGBB)
    accentColorHex: String  // Accent color (#RRGGBB)
    defaultSKUId: String    // Active product SKU
    foodSKUs: [FoodSKU]     // All registered products
    lastUsedAt: Date        // Last activation timestamp
}
```

### 2.2 FoodSKU Model

Each product within a brand:

```swift
FoodSKU {
    skuId: String            // Unique SKU identifier
    displayName: String      // Consumer-facing name
    caloriesPerGram: Double  // kcal/g (typically 1.0-4.0)
    servingSizeGrams: Double // Recommended serving (grams)
}
```

### 2.3 Brand Asset Catalog

Brand imagery is organized in the Asset Catalog:

```
Assets.xcassets/Brands/
├── {BrandName}/
│   ├── ProductImage.imageset/   # Product photo (recommended: 600x400px)
│   ├── Logo.imageset/           # Brand logo (recommended: 400x200px)
│   └── Background.imageset/     # Optional background texture
```

Supported brands with pre-configured assets:
- FelineCare
- ScienceNutrition
- ProBalance
- BlueWellness

### 2.4 Accessing Brand Assets in Code

```swift
// Product image
if let productImage = brandConfig.productImage {
    productImage
        .resizable()
        .scaledToFit()
}

// Logo
if let logo = brandConfig.logo {
    logo
        .resizable()
        .scaledToFit()
}

// Background
if let background = brandConfig.backgroundImage {
    background
        .resizable()
        .scaledToFill()
}
```

---

## 3. Analytics Dashboard

### 3.1 Available Metrics

The Analytics Dashboard (DEBUG only) provides:

| Metric | Description |
|--------|-------------|
| Total Activations | QR scans that launched the app |
| Tracking Sessions | Unique days with weight entries |
| Reorder Views | Times reorder screen was viewed |
| Reorder Clicks | Clicks through to retailers |

### 3.2 Reorder Funnel

The dashboard visualizes the conversion funnel:

```
Views → Clicks → (External Conversion)
```

Conversion rate = (Clicks / Views) × 100

### 3.3 Time Series Visualization

Activity over time chart shows:
- Activations (blue line)
- Weight logs (green line)
- Reorder views (orange line)

### 3.4 CSV Export

Export format:

```csv
Date,Brand,SKU,Metric Type,Value,Device Hash
2026-01-12T10:30:00Z,felinecare,fc-wm-chicken,app_activation,1,a1b2c3...
```

### 3.5 Seeding Demo Data

For demo purposes, seed realistic analytics data:

1. Open Admin Hub
2. Select "Seed Demo Analytics Data"
3. View populated dashboard

Data spans 30 days with:
- 12 simulated users
- Varying engagement levels per brand
- Realistic reorder funnel conversion (25-40%)

---

## 4. Demo Environment

### 4.1 Initial Setup

1. Build and run in DEBUG configuration
2. On first launch, tap "Load All Demo Brands"
3. (Optional) Seed demo metrics for analytics

### 4.2 Demo Flow Sequence

```
DemoActivationView
    ↓ (tap "Load All Demo Brands")
BrandSplashView (with animation)
    ↓ (tap "Get Started")
QuickSetupView
    ↓ (enter cat details)
CatDetailView (main dashboard)
```

### 4.3 Brand Switching

To demonstrate multiple brands:

1. Admin Hub → "Switch Brand"
2. Select target brand
3. App reloads with new brand styling

### 4.4 QR Activation Testing

Test deep link activation:

1. Admin Hub → "Testing" section
2. Copy deep link URL
3. Open Safari, paste URL
4. Observe app launch with brand splash

---

## 5. Production Deployment

### 5.1 Pre-Launch Checklist

- [ ] Brand assets added to Asset Catalog
- [ ] QR codes generated for all SKUs
- [ ] Deep link URLs verified working
- [ ] Brand colors render correctly on all devices
- [ ] Calorie values verified against nutrition labels
- [ ] Serving sizes match feeding guidelines

### 5.2 App Store Submission

Required information:
- App Store Connect account
- App icon (1024x1024px)
- Screenshots (iPhone 6.5", 5.5")
- Privacy policy URL
- Support URL

### 5.3 QR Code Placement

Recommended placements on packaging:
- Back panel (near nutrition info)
- Side panel (near feeding guidelines)
- Inside flap (for premium unboxing)

Avoid:
- Front panel (regulatory concerns)
- Areas that may be obscured by shelf tags

### 5.4 Retailer Coordination

For affiliate link integration:
1. Register retailer URLs in `Retailer.swift`
2. Configure affiliate parameters
3. Test click-through attribution

---

## 6. Technical Integration

### 6.1 URL Scheme Registration

The app registers the `catweighttracker://` scheme in `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>catweighttracker</string>
        </array>
    </dict>
</array>
```

### 6.2 Deep Link Handling

URL parsing in `BrandActivationParams.swift`:

```swift
static func parse(from url: URL) -> BrandActivationParams? {
    guard url.scheme == "catweighttracker",
          url.host == "activate",
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
          let queryItems = components.queryItems else {
        return nil
    }
    // Parse parameters...
}
```

### 6.3 Metrics Recording

Anonymous metrics are recorded via `MetricsAggregator`:

```swift
// Record activation
MetricsAggregator.shared.recordActivation(
    brandId: config.brandId,
    skuId: sku.skuId,
    in: modelContext
)

// Record reorder click
MetricsAggregator.shared.recordReorderClick(
    brandId: config.brandId,
    skuId: sku.skuId,
    retailerId: retailer.id,
    in: modelContext
)
```

---

## 7. Support & Troubleshooting

### 7.1 Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| QR doesn't open app | App not installed | User downloads from App Store first |
| Wrong brand shows | Cached activation | Clear app data, scan again |
| Colors look wrong | Invalid hex | Verify 6-character hex without # |
| Metrics not showing | No data yet | Seed demo data or wait for real usage |

### 7.2 Debug Tools

Admin Hub provides:
- Brand switcher for testing
- QR generator for new SKUs
- Analytics dashboard for metrics
- Deep link tester for validation
- Demo data seeding/clearing

### 7.3 Contact

For integration support:
- Technical documentation: This document
- QR specifications: Document B in B2B-LICENSING-PACKAGE.md
- Legal review: Document F in B2B-LICENSING-PACKAGE.md

---

## Document Control

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-01-12 | Initial release |

**Classification:** Partner Confidential
