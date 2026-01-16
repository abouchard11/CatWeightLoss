# CatWeightLoss Demo Script

## Pre-Demo Checklist

- [ ] iOS Simulator running (iPhone 17 Pro recommended)
- [ ] App installed and launched
- [ ] Demo brand data loaded (or ready to activate)

## Demo Flow (5-7 minutes)

### 1. Brand Activation (30 seconds)

**Starting Point:** "Scan to Get Started" screen

**Actions:**
1. Point out the QR code scanner prompt - "This is how pet food brands onboard customers"
2. Tap **"Use Demo Mode"** to activate a demo brand
3. (Optional) Show **"Load All Demo Brands"** to demonstrate multi-brand support

**Talking Points:**
- "The app is activated via QR codes on pet food packaging"
- "Each brand gets their own white-labeled experience"

---

### 2. Quick Setup (1 minute)

**Screen:** Quick Setup form

**Actions:**
1. Enter cat name: **"Whiskers"**
2. Select weight unit: **lbs** (default) or **kg**
3. Enter current weight: **12** lbs
4. Enter target weight: **10** lbs
5. Tap **"Start Tracking"**

**Talking Points:**
- "Setup takes under 30 seconds"
- "We capture just enough data to provide value"
- "No account creation required - frictionless onboarding"

---

### 3. Main Dashboard (1-2 minutes)

**Screen:** CatDetailView (Main Dashboard)

**Actions:**
1. Show the weight progress ring
2. Point out current weight vs target
3. Highlight the trend indicator

**Talking Points:**
- "At-a-glance progress visualization"
- "Color-coded trend indicators"
- "Brand-customized UI elements"

---

### 4. Weight Logging (1 minute)

**Actions:**
1. Tap **"Log Weight"** button
2. Enter a new weight (e.g., **11.8** lbs)
3. Show the weight history chart updating
4. Point out the trend calculation

**Talking Points:**
- "Quick daily logging builds engagement"
- "Visual charts show progress over time"
- "Each log is an analytics touchpoint for brands"

---

### 5. Feeding Plan (1 minute)

**Actions:**
1. Navigate to **Feeding Plan** section
2. Show the calculated daily portions
3. Point out brand-specific food recommendations

**Talking Points:**
- "Personalized feeding recommendations"
- "Based on cat's weight loss goals"
- "Drives usage of the brand's products"

---

### 6. Reorder Flow (1 minute) - KEY MONETIZATION

**Actions:**
1. Navigate to **Reorder** section
2. Show product recommendations
3. Tap a retailer link (Amazon, Chewy, etc.)
4. Show affiliate tracking

**Talking Points:**
- "This is where brands monetize"
- "Predictive reorder based on consumption"
- "Affiliate links track conversions"
- "Brands see ROI directly"

---

### 7. Analytics Dashboard (DEBUG mode) (1 minute)

**Actions:**
1. Access **Admin Hub** (DEBUG builds only)
2. Show **Analytics Dashboard**
3. Demonstrate metrics visualization
4. Show CSV export capability

**Talking Points:**
- "B2B dashboard shows engagement metrics"
- "Track reorder funnel performance"
- "Export data for brand partners"

---

## Key Value Propositions to Emphasize

1. **White-Label Platform**
   - Each brand gets customized branding
   - Colors, logos, product images all configurable
   - Feels like brand's own app

2. **Zero Friction Onboarding**
   - QR code activation
   - No account creation
   - Under 30 seconds to value

3. **Clear Monetization Path**
   - Reorder affiliate links
   - Trackable conversions
   - Predictive recommendations

4. **GDPR-Compliant Analytics**
   - Anonymous metrics only
   - No PII collected
   - Privacy policy live at GitHub Pages

---

## Demo Brands Available

| Brand | Style | Primary Color |
|-------|-------|---------------|
| FelineCare | Premium/Clinical | Blue |
| ScienceNutrition | Scientific | Green |
| ProBalance | Athletic | Orange |
| BlueWellness | Natural/Organic | Teal |

---

## Troubleshooting

**App won't launch:**
```bash
xcrun simctl boot "iPhone 17 Pro"
xcrun simctl launch booted com.catweightloss.app
```

**Need fresh data:**
- Access Admin Hub → "Reset Demo Data"

**Simulator keyboard not showing:**
- Menu: I/O → Keyboard → Toggle Software Keyboard
- Or: Cmd+K

---

## Post-Demo

Direct prospects to:
- Privacy Policy: https://abouchard11.github.io/CatWeightLoss/privacy-policy.html
- GitHub: https://github.com/abouchard11/CatWeightLoss

Follow up with:
- Sales toolkit materials in `/docs/sales-toolkit/`
- ROI model spreadsheet
- Letter of Intent template
