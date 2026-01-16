# Firebase Analytics Setup Guide

This guide explains how to set up Firebase Analytics for the CatWeightLoss app to track brand partner metrics.

## Overview

Firebase Analytics provides real-time, anonymized metrics for brand partners:
- App activations and setup completion rates
- Weight logging engagement and trends
- Reorder funnel (views → clicks → conversions)
- Activity tracking patterns
- Brand-specific segmentation

All data is anonymous and complies with privacy regulations. No personally identifiable information (PII) is collected.

## Prerequisites

- Apple Developer account
- Access to Firebase console (free tier is sufficient)
- Xcode 15.0+
- iOS 17.0+ deployment target

## Step 1: Create Firebase Project

1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or use an existing project
3. Enter project name (e.g., "CatWeightLoss-Production")
4. Optional: Enable Google Analytics for the project (recommended)
5. Click "Create project"

## Step 2: Register iOS App

1. In Firebase Console, click "Add app" → iOS
2. Enter your iOS bundle identifier:
   - Found in Xcode → Target → General → Bundle Identifier
   - Example: `com.yourcompany.catweightloss`
3. Optional: Enter App Store ID (for later when published)
4. Optional: Enter nickname (e.g., "CatWeightLoss iOS")
5. Click "Register app"

## Step 3: Download Configuration File

1. Download `GoogleService-Info.plist` file
2. In Xcode, add the file to your project:
   - Right-click on `CatWeightLoss` folder → "Add Files to CatWeightLoss"
   - Select `GoogleService-Info.plist`
   - Ensure "Copy items if needed" is checked
   - Select target: CatWeightLoss
   - Click "Add"

**Important**: Place the file at the root of your main target, not in subfolders.

**Security**: Add `GoogleService-Info.plist` to `.gitignore` to avoid committing sensitive API keys.

```bash
# Add to .gitignore
echo "GoogleService-Info.plist" >> .gitignore
```

## Step 4: Verify Firebase SDK Installation

The Firebase SDK is already configured via Swift Package Manager in this project.

To verify:
1. Open Xcode
2. File → Packages → Resolve Package Versions
3. Check that `FirebaseAnalytics` appears in package dependencies

If not present, add it:
1. File → Add Package Dependencies
2. Enter URL: `https://github.com/firebase/firebase-ios-sdk`
3. Select "Up to Next Major Version" with minimum 10.0.0
4. Add package products: `FirebaseAnalytics`

## Step 5: Initialize Firebase in App

Firebase is initialized in `CatWeightLossApp.swift`:

```swift
import FirebaseCore

@main
struct CatWeightLossApp: App {
    init() {
        FirebaseApp.configure()
    }
    // ... rest of app code
}
```

This is already implemented in the codebase.

## Step 6: Configure Analytics Events

The app tracks the following events automatically:

### Brand Activation Events
- `brand_activated`: When a user scans a QR code
  - Parameters: `brand_id`, `sku_id`

### Engagement Events
- `weight_logged`: When user logs a weight entry
  - Parameters: `brand_id`, `trend_direction` (up/down/stable)
- `feeding_schedule_created`: When user creates a feeding plan
  - Parameters: `brand_id`
- `activity_logged`: When user logs cat activity
  - Parameters: `brand_id`, `activity_type`, `duration_minutes`

### Monetization Events
- `reorder_viewed`: When user opens reorder screen
  - Parameters: `brand_id`, `sku_id`
- `reorder_clicked`: When user clicks a retailer link
  - Parameters: `brand_id`, `sku_id`, `retailer`

### User Properties
- `active_brand`: Current brand the user is using
- User segmentation by brand for detailed analysis

## Step 7: Test Analytics Integration

### Debug Mode
Enable Analytics debug mode on a physical device or simulator:

```bash
# In Xcode, edit scheme → Run → Arguments → Add launch argument:
-FIRAnalyticsDebugEnabled
```

Or via command line for simulator:
```bash
xcrun simctl spawn booted log stream --level debug --predicate 'eventMessage contains "firebase"'
```

### Verify Events in Firebase Console
1. Go to Firebase Console → Analytics → Events
2. Events appear within 24 hours (or immediately in debug mode)
3. Check for custom events: `brand_activated`, `weight_logged`, etc.

### DebugView (Real-time)
1. Firebase Console → Analytics → DebugView
2. With debug mode enabled, see events in real-time
3. Verify event parameters are correct

## Step 8: Grant Dashboard Access to Brand Partners

Brand partners need view-only access to their specific data.

### Create Brand-Specific Views

1. Firebase Console → Analytics → Custom Definitions
2. Create user property filter:
   - Name: "brand_filter"
   - Type: User Property
   - Property: `active_brand`

### Grant Partner Access

1. Firebase Console → Settings (gear icon) → Users and Permissions
2. Click "Add member"
3. Enter brand partner's email
4. Select role: "Analytics Viewer"
5. Click "Add member"

### Create Data Studio Dashboard (Optional)

For advanced brand partner dashboards:

1. Go to BigQuery (if enabled in Firebase)
2. Connect to Google Data Studio
3. Create custom dashboards with brand filters
4. Share specific dashboard links with partners

## Analytics Events Reference

### Event Structure

```swift
// Example: Track brand activation
Analytics.logEvent("brand_activated", parameters: [
    "brand_id": "felinecare",
    "sku_id": "felinecare-weight-mgmt",
    "timestamp": Date().timeIntervalSince1970
])
```

### Key Metrics for Brand Partners

**Activation Funnel**
- QR scans → App activations → Setup completions
- Conversion rate at each step

**Engagement**
- Daily/Weekly/Monthly active users (by brand)
- Average weight logs per user
- Average activity sessions per user
- Days between weight logs (retention proxy)

**Monetization**
- Reorder view rate (% of users who view reorder screen)
- Reorder click rate (% who click through to retailers)
- Retailer attribution (which retailers convert best)

**Retention**
- 7-day retention rate
- 30-day retention rate
- Churn indicators (days since last weight log)

## Privacy Compliance

### Data Collection
- No PII collected (names, emails, phone numbers)
- Device identifiers are hashed and anonymized
- All metrics aggregated at brand level
- User cannot be identified from analytics data

### GDPR Compliance
- Analytics data is anonymized
- No cross-device tracking
- Data retention follows Firebase defaults (14 months)
- Users can request app deletion (removes local data)

### CCPA Compliance
- Analytics treated as "business purpose" data
- No personal data sale
- Aggregate metrics only shared with brand partners

### App Privacy Labels (App Store)
When submitting to App Store, declare:
- Usage Data → Product Interaction (not linked to user)
- Usage Data → Other Usage Data (not linked to user)
- Analytics purposes only

## Troubleshooting

### Events Not Appearing
- Check `GoogleService-Info.plist` is in project root
- Verify bundle identifier matches Firebase console
- Enable debug mode and check Xcode console logs
- Wait 24 hours for events to appear (use DebugView for real-time)

### Build Errors
- Clean build folder: Cmd+Shift+K
- Resolve package dependencies: File → Packages → Resolve
- Check Firebase SDK version compatibility

### Analytics Not Initializing
- Verify `FirebaseApp.configure()` is called in `init()`
- Check for console errors about missing configuration
- Validate `GoogleService-Info.plist` format (must be valid plist)

## Advanced: Custom Audiences

Create audiences for targeted insights:

1. Firebase Console → Analytics → Audiences
2. Create audience:
   - "Engaged Users": weight_logged > 3 in last 7 days
   - "Reorder Intent": reorder_viewed > 1 in last 14 days
   - "At Risk": No weight_logged in last 14 days

## Cost Considerations

**Firebase Analytics Limits (Free Tier)**
- 500 distinct events
- Unlimited event volume
- 25 user properties
- 50 audiences

**This app uses**: ~10 custom events, well within limits.

**If you exceed limits**: Contact Firebase for pricing (typically starts at $150/month for enterprise features).

## Support

- Firebase Documentation: https://firebase.google.com/docs/analytics
- Firebase Support: https://firebase.google.com/support
- App Issues: Check project GitHub issues or internal docs

## Next Steps

After setup:
1. Monitor Analytics dashboard weekly
2. Share partner-specific dashboards
3. Adjust event tracking based on partner feedback
4. Consider A/B testing via Firebase Remote Config
5. Set up automated reports for stakeholders
