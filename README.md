# Cat Weight Loss App

A SwiftUI + SwiftData iOS app for managing cat weight-loss programs.

## Features

- **Multi-Cat Support**: Track multiple cats in one app
- **Weight Tracking**: Log weights, view progress charts, track trends
- **Portion Calculator**: Science-based calorie calculations using RER/MER formulas
- **Feeding Scheduler**: Set meal times with notification reminders
- **Activity Tracking**: Log play sessions, set daily activity goals

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

### Option 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Configure:
   - Product Name: `CatWeightLoss`
   - Interface: `SwiftUI`
   - Storage: `SwiftData`
   - Language: `Swift`
5. Save to `/Users/sashalabbe/CatWeightLoss`
6. Delete the auto-generated `ContentView.swift`
7. Drag the `CatWeightLoss/` folder into the project navigator
8. Build and run

### Option 2: Use Setup Script

```bash
cd /Users/sashalabbe/CatWeightLoss
chmod +x setup.sh
./setup.sh
```

## Project Structure

```
CatWeightLoss/
├── CatWeightLossApp.swift      # App entry point
├── Models/
│   ├── Cat.swift               # Main cat model
│   ├── WeightEntry.swift       # Weight log entries
│   ├── FeedingSchedule.swift   # Meal schedules
│   ├── ActivitySession.swift   # Activity logs
│   └── Enums.swift             # WeightUnit, ActivityType, etc.
├── Views/
│   ├── CatListView.swift       # Home screen
│   ├── CatDetailView.swift     # Cat dashboard
│   ├── AddCatView.swift        # Add new cat
│   ├── Weight/
│   │   ├── WeightLogView.swift
│   │   ├── WeightChartView.swift
│   │   └── WeightHistoryView.swift
│   ├── Feeding/
│   │   ├── FeedingPlanView.swift
│   │   └── PortionCalculatorView.swift
│   └── Activity/
│       ├── ActivityLogView.swift
│       └── ActivityHistoryView.swift
├── Services/
│   ├── PortionCalculator.swift
│   └── NotificationService.swift
└── Components/
    ├── CatCard.swift
    ├── ProgressRing.swift
    ├── StatCard.swift
    └── WeightTrendIndicator.swift
```

## Calorie Calculation

The app uses veterinary-standard formulas:

```
RER (Resting Energy Requirement) = 70 × (weight in kg)^0.75
MER (Maintenance Energy Requirement) = RER × 1.2 (indoor cat)
Weight Loss Calories = MER × 0.80-0.90 (15-20% reduction)
```

Safe weight loss for cats: 1-2% body weight per week.

## License

MIT License
