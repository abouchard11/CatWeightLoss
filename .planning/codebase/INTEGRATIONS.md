# External Integrations

**Analysis Date:** 2026-01-12

## APIs & External Services

**Payment Processing:**
- Not applicable - No payment features

**Email/SMS:**
- Not applicable - No messaging features

**External APIs:**
- None detected - App operates fully offline

## Data Storage

**Databases:**
- SwiftData (local SQLite) - Primary data store
  - Connection: Automatic via ModelContainer in `CatWeightLoss/CatWeightLossApp.swift`
  - Client: SwiftData framework (built into iOS 17+)
  - Migrations: Automatic schema migration (SwiftData default)
  - Storage: On-device only (`isStoredInMemoryOnly: false`)

**File Storage:**
- Photo Library - Cat photos stored as Data blobs in SwiftData
  - Permission: `NSPhotoLibraryUsageDescription` in `CatWeightLoss/Info.plist`
  - Storage: `photoData: Data?` property on `Cat` model

**Caching:**
- DateFormatters cached as static properties in `CatWeightLoss/Services/DateFormatting.swift`
- No external caching service

## Authentication & Identity

**Auth Provider:**
- None - No user accounts

**OAuth Integrations:**
- None

**Device Identification:**
- Anonymous device hash using SHA-256 of `identifierForVendor`
- File: `CatWeightLoss/Models/AnonymousMetric.swift` (lines 93-112)
- Hash changes if app is reinstalled (privacy feature)

## Monitoring & Observability

**Error Tracking:**
- None configured - No Sentry, Crashlytics, etc.

**Analytics:**
- Local-only anonymous metrics via `MetricsAggregator`
- File: `CatWeightLoss/Services/MetricsAggregator.swift`
- No external transmission detected
- Data stored in local SwiftData

**Logs:**
- `#if DEBUG` console logging only
- No external log aggregation

## CI/CD & Deployment

**Hosting:**
- App Store distribution (standard iOS app)
- No backend hosting required

**CI Pipeline:**
- Not detected - No GitHub Actions, Fastlane, etc.

**Build System:**
- XCGen for project generation (`project.yml`)
- Xcode for building

## Environment Configuration

**Development:**
- No `.env` files required
- No API keys needed
- Demo mode available: `#if DEBUG` button in `DemoActivationView`

**Staging:**
- Not applicable - Local-only app

**Production:**
- No secrets management needed
- All data stored locally

## Deep Linking & URL Schemes

**Incoming:**
- Custom URL scheme: `catweighttracker://activate`
  - Handler: `CatWeightLoss/CatWeightLossApp.swift` (lines 81-83, `.onOpenURL`)
  - Parser: `CatWeightLoss/Models/BrandConfiguration.swift` (`BrandActivationParams.parse()`)
  - Service: `CatWeightLoss/Services/BrandConfigService.swift` (`handleURL()`)

**URL Parameters:**
| Parameter | Purpose | Example |
|-----------|---------|---------|
| `brand` | Brand identifier | `purina` |
| `sku` | Product SKU | `proplan-adult` |
| `cal` | Calories per gram | `3.5` |
| `serving` | Serving size grams | `35` |
| `primary` | Primary brand color (hex) | `FF5733` |
| `accent` | Accent color (hex) | `33FF57` |

**Example activation URL:**
```
catweighttracker://activate?brand=purina&sku=proplan&cal=3.5&serving=35&primary=FF5733
```

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None - App does not make network requests

## Permissions Required

| Permission | Purpose | Plist Key |
|------------|---------|-----------|
| Photo Library | Cat profile photos | `NSPhotoLibraryUsageDescription` |

## Privacy Summary

- **Fully offline-capable**: All data stored locally
- **No network requests**: Zero external API calls
- **No tracking**: Anonymous metrics stay on device
- **No accounts**: No user authentication
- **Privacy-first**: Device hash is cryptographic one-way hash

---

*Integration audit: 2026-01-12*
*Update when adding external services*
