# Firebase Analytics - Swift Package Manager Setup

This guide shows how to add Firebase Analytics to the project using Swift Package Manager in Xcode.

## Step-by-Step Instructions

### 1. Open Xcode Project
```bash
cd /Users/sashalabbe/CatWeightLoss
open CatWeightLoss.xcodeproj
```

### 2. Add Firebase Package Dependency

1. In Xcode, go to **File → Add Package Dependencies...**
2. In the search field (top right), enter:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
3. Click on the `firebase-ios-sdk` repository when it appears
4. For **Dependency Rule**, select: **Up to Next Major Version**
   - Minimum: `10.0.0` (or latest available)
5. Click **Add Package**

### 3. Select Package Products

In the package products dialog, select:
- ☑️ **FirebaseAnalytics** (target: CatWeightLoss)
- ☐ All other products (leave unchecked)

Click **Add Package**

### 4. Verify Installation

After adding the package:
1. Check the **Package Dependencies** section in Project Navigator (left sidebar)
2. You should see `firebase-ios-sdk` listed
3. Expand it to see `FirebaseAnalytics` as a dependency

### 5. Clean and Rebuild

1. Clean build folder: **Product → Clean Build Folder** (or Cmd+Shift+K)
2. Build project: **Product → Build** (or Cmd+B)
3. Verify no build errors

## Troubleshooting

### Package Resolution Issues
If the package fails to resolve:
```
File → Packages → Reset Package Caches
File → Packages → Resolve Package Versions
```

### Build Errors
If you see build errors like `No such module 'FirebaseCore'`:
1. Clean build folder (Cmd+Shift+K)
2. Close Xcode
3. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen Xcode and rebuild

### Package Already Added
If Firebase is already in your project but not building:
1. File → Packages → Update to Latest Package Versions
2. Clean and rebuild

## Alternative: Manual Package.swift

If you prefer to manage packages via Package.swift (for command-line builds):

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CatWeightLoss",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.0.0"
        )
    ],
    targets: [
        .target(
            name: "CatWeightLoss",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ]
        )
    ]
)
```

## Verify Integration

After setup, build and run:
1. Check Xcode console for Firebase initialization log:
   ```
   [Firebase] Firebase configured successfully
   ```
2. Enable Analytics debug mode (see main FIREBASE_SETUP.md)
3. Trigger an event (e.g., log weight) and verify in console

## Next Steps

After SPM setup is complete:
1. Add `GoogleService-Info.plist` (see FIREBASE_SETUP.md)
2. Test analytics events
3. Verify events in Firebase Console DebugView

## Command-Line Build (Optional)

If building via command line:
```bash
cd /Users/sashalabbe/CatWeightLoss
xcodebuild -scheme CatWeightLoss -destination 'platform=iOS Simulator,name=iPhone 15' build
```

Verify package resolution:
```bash
xcodebuild -resolvePackageDependencies
```
