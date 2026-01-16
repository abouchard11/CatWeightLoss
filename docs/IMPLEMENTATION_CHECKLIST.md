# Firebase Analytics Implementation Checklist

Use this checklist to verify the Firebase Analytics integration is complete and working correctly.

## Pre-Implementation (Setup)

- [ ] Firebase project created at https://console.firebase.google.com/
- [ ] iOS app registered in Firebase Console
- [ ] Bundle ID matches Xcode project (`com.yourcompany.catweightloss`)
- [ ] `GoogleService-Info.plist` downloaded from Firebase
- [ ] `GoogleService-Info.plist` added to `.gitignore`

## Package Installation

- [ ] Xcode project opened
- [ ] Firebase iOS SDK added via Swift Package Manager
  - [ ] URL: `https://github.com/firebase/firebase-ios-sdk`
  - [ ] Product: `FirebaseAnalytics` selected
  - [ ] Version: 10.0.0 or higher
- [ ] `GoogleService-Info.plist` added to Xcode project root
  - [ ] File placed next to Info.plist
  - [ ] "Copy items if needed" checked
  - [ ] Target: CatWeightLoss selected
- [ ] Project builds without errors (Cmd+B)

## Code Integration Verification

### New Files Created
- [ ] `CatWeightLoss/Services/AnalyticsService.swift` exists
- [ ] AnalyticsService is a singleton with `shared` instance
- [ ] All event methods implemented:
  - [ ] `logBrandActivated(brandId:skuId:)`
  - [ ] `logWeightLogged(brandId:trendDirection:)`
  - [ ] `logFeedingScheduleCreated(brandId:)`
  - [ ] `logActivityLogged(brandId:activityType:durationMinutes:)`
  - [ ] `logReorderViewed(brandId:skuId:)`
  - [ ] `logReorderClicked(brandId:skuId:retailer:)`
  - [ ] `logAppOpened(brandId:)`
  - [ ] `logSetupCompleted(brandId:skuId:)`

### Modified Files Verification

#### CatWeightLossApp.swift
- [ ] `import FirebaseCore` at top
- [ ] `FirebaseApp.configure()` in `init()`
- [ ] `AnalyticsService.shared.logAppOpened()` in `loadInitialState()`

#### BrandConfigService.swift
- [ ] `AnalyticsService.shared.logBrandActivated()` in `activateBrand()`

#### WeightLogView.swift
- [ ] `AnalyticsService.shared.logWeightLogged()` in `saveEntry()`
- [ ] Weight trend calculated (up/down/stable)

#### ReorderView.swift
- [ ] `AnalyticsService.shared.logReorderViewed()` in `.onAppear`
- [ ] `AnalyticsService.shared.logReorderClicked()` in `completeReorder()`

#### ActivityLogView.swift
- [ ] `AnalyticsService.shared.logActivityLogged()` in `saveActivity()`

#### FeedingPlanView.swift (AddMealView)
- [ ] `@Environment(\.brandConfig)` added
- [ ] `AnalyticsService.shared.logFeedingScheduleCreated()` in `addMeal()`

#### QuickSetupView.swift
- [ ] `AnalyticsService.shared.logSetupCompleted()` in `createCat()`

### Documentation Created
- [ ] `docs/FIREBASE_SETUP.md` - Firebase Console setup guide
- [ ] `docs/FIREBASE_SPM_SETUP.md` - Swift Package Manager instructions
- [ ] `docs/FIREBASE_INTEGRATION_SUMMARY.md` - Technical overview
- [ ] `docs/BRAND_ANALYTICS_GUIDE.md` - Brand partner guide
- [ ] `docs/IMPLEMENTATION_CHECKLIST.md` (this file)

## Testing

### Build & Launch
- [ ] Clean build folder (Cmd+Shift+K)
- [ ] Build project (Cmd+B) - no errors
- [ ] Run on simulator (Cmd+R)
- [ ] App launches without crashes
- [ ] Check Xcode console for Firebase initialization log

### Enable Debug Mode
- [ ] Edit scheme (Product → Scheme → Edit Scheme)
- [ ] Run → Arguments tab
- [ ] Add launch argument: `-FIRAnalyticsDebugEnabled`
- [ ] Build and run
- [ ] Verify debug logs in Xcode console

### Event Testing: Brand Activation
- [ ] Open app for first time (or reset simulator)
- [ ] Tap "Use Demo Mode" or scan QR code (if available)
- [ ] Complete setup with cat name and weights
- [ ] Check Xcode console for events:
  ```
  [Analytics] Brand activated: demo, SKU: demo-weight-mgmt
  [Analytics] Setup completed: demo, SKU: demo-weight-mgmt
  ```

### Event Testing: Weight Logging
- [ ] Navigate to cat detail view
- [ ] Tap "Log Weight" button
- [ ] Enter weight and save
- [ ] Check Xcode console for event:
  ```
  [Analytics] Weight logged: demo, trend: stable
  ```
- [ ] Log another weight (higher/lower)
- [ ] Verify trend direction changes (up/down)

### Event Testing: Reorder Funnel
- [ ] Navigate to cat detail view
- [ ] Tap "Reorder" or reorder-related button
- [ ] Check Xcode console for event:
  ```
  [Analytics] Reorder viewed: demo, SKU: demo-weight-mgmt
  ```
- [ ] Select a retailer (e.g., Amazon)
- [ ] Tap "Order from [Retailer]"
- [ ] Confirm alert
- [ ] Check Xcode console for event:
  ```
  [Analytics] Reorder clicked: demo, SKU: demo-weight-mgmt, retailer: Amazon
  ```

### Event Testing: Activity Logging
- [ ] Navigate to activity section
- [ ] Tap "Log Activity"
- [ ] Select activity type, duration, save
- [ ] Check Xcode console for event:
  ```
  [Analytics] Activity logged: demo, type: play, duration: 15m
  ```

### Event Testing: Feeding Schedule
- [ ] Navigate to feeding plan
- [ ] Tap "Add Meal"
- [ ] Enter meal details and save
- [ ] Check Xcode console for event:
  ```
  [Analytics] Feeding schedule created: demo
  ```

### Firebase Console Verification
- [ ] Open Firebase Console (https://console.firebase.google.com)
- [ ] Select your project
- [ ] Navigate to Analytics → DebugView
- [ ] Run app on simulator/device with debug mode enabled
- [ ] Trigger events (weight log, reorder, etc.)
- [ ] Verify events appear in DebugView in real-time
- [ ] Check event parameters are correct

## Production Readiness

### Privacy Compliance
- [ ] Review event parameters - no PII included
- [ ] Verify device identifiers are hashed
- [ ] Confirm no actual weight values in events
- [ ] Validate no cat names or user names in events
- [ ] Check no location data collected

### App Store Submission
- [ ] Remove debug mode launch argument from release scheme
- [ ] Update App Privacy Labels in App Store Connect:
  - [ ] Usage Data → Product Interaction (not linked to user)
  - [ ] Usage Data → Other Usage Data (not linked to user)
- [ ] Test release build on physical device
- [ ] Verify GoogleService-Info.plist is NOT in git repo

### Brand Partner Setup
- [ ] Compile list of brand partner emails
- [ ] Add partners to Firebase Console with "Analytics Viewer" role
- [ ] Send `BRAND_ANALYTICS_GUIDE.md` to partners
- [ ] Schedule dashboard walkthrough with partners

## Optional Enhancements

### Advanced Features
- [ ] A/B testing with Firebase Remote Config
- [ ] Push notifications with Firebase Cloud Messaging
- [ ] Crash reporting with Firebase Crashlytics
- [ ] Performance monitoring with Firebase Performance

### Custom Dashboards
- [ ] Enable BigQuery export in Firebase
- [ ] Create Google Data Studio dashboards
- [ ] Set up automated weekly reports
- [ ] Build brand-specific dashboard templates

## Troubleshooting

### Build Errors
If you encounter build errors:
- [ ] Clean build folder (Cmd+Shift+K)
- [ ] Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- [ ] Resolve package versions: File → Packages → Resolve Package Versions
- [ ] Reset package caches: File → Packages → Reset Package Caches
- [ ] Close and reopen Xcode

### Events Not Appearing
If events don't show in Firebase:
- [ ] Verify `GoogleService-Info.plist` is in project root
- [ ] Check bundle ID matches Firebase Console
- [ ] Enable debug mode and check Xcode console logs
- [ ] Wait 24 hours for non-debug events to appear
- [ ] Use DebugView for real-time verification

### Firebase Not Initializing
If Firebase doesn't initialize:
- [ ] Check `FirebaseApp.configure()` is in `init()`
- [ ] Verify `import FirebaseCore` at top of file
- [ ] Validate `GoogleService-Info.plist` format (must be valid XML)
- [ ] Check Xcode console for Firebase errors

## Sign-Off

When all items are checked:

**Developer**: _____________________ Date: _____
- [ ] All code changes implemented
- [ ] All tests passing
- [ ] Documentation complete

**QA**: _____________________ Date: _____
- [ ] All events verified in app
- [ ] Firebase Console shows events correctly
- [ ] No PII in event data

**Product**: _____________________ Date: _____
- [ ] Brand partner access configured
- [ ] Dashboard guide sent to partners
- [ ] Analytics goals established

## Maintenance

### Regular Checks (Monthly)
- [ ] Review Firebase SDK for updates
- [ ] Update package versions if needed
- [ ] Check for deprecated API calls
- [ ] Review event schema for consistency
- [ ] Audit event parameters for PII

### Performance Monitoring
- [ ] Monitor Firebase quota usage (free tier limits)
- [ ] Track distinct event types (max 500 on free tier)
- [ ] Review event volume trends
- [ ] Optimize high-volume events if needed

## Resources

- **Firebase Documentation**: https://firebase.google.com/docs/analytics/ios/start
- **Firebase Console**: https://console.firebase.google.com
- **Integration Docs**: See `docs/FIREBASE_SETUP.md`
- **Brand Guide**: See `docs/BRAND_ANALYTICS_GUIDE.md`

---

**Version**: 1.0
**Last Updated**: 2026-01-15
**Next Review**: 2026-02-15
