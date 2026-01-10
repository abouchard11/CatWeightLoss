# Demo QR Codes — Sales Enablement

## Quick Start (3 Steps)

### Step 1: Install the App

**Option A: Xcode Simulator (Fastest)**
```bash
open /Users/sashalabbe/CatWeightLoss/CatWeightLoss.xcodeproj
# Press ⌘R to build and run on simulator
```

Or double-click `CatWeightLoss.xcodeproj` in Finder (it's in the project root).

**Option B: Physical iPhone**
1. Connect iPhone via USB
2. Open `CatWeightLoss.xcodeproj` in Xcode
3. Select your iPhone from the device dropdown
4. Press ⌘R to build and install
5. On iPhone: Settings → General → Device Management → Trust developer

**Option C: TestFlight (For Sales Team)**
> TestFlight distribution requires an Apple Developer account ($99/year) and App Store Connect setup. Contact engineering to set up TestFlight builds for the sales team.

### Step 2: Open the QR Codes

**Local (your machine):**
```bash
open /Users/sashalabbe/CatWeightLoss/deliverables/demo-qr-codes/index.html
```

**Shared access options:**
- **Print**: Open HTML → Click "Print QR Codes" button
- **Email**: Print to PDF → Email to sales team
- **Host**: Upload `index.html` to any web server or GitHub Pages

### Step 3: Scan and Demo

1. Open iPhone Camera app
2. Point at QR code on screen (or printed page)
3. Tap the notification banner that appears
4. App opens with brand theming applied

---

## Demo Brands Included

| Brand | Color | Product | Calories |
|-------|-------|---------|----------|
| AcmePet Foods | Orange (#FF6B35) | Weight Management Chicken | 3.5 kcal/g |
| NutriCat Premium | Green (#2E7D32) | Indoor Formula | 3.2 kcal/g |
| Royal Feline | Purple (#7B1FA2) | Satiety Support | 2.8 kcal/g |
| Hill's Style Demo | Blue (#0D47A1) | Metabolic + Mobility | 3.0 kcal/g |

---

## Troubleshooting

### "App not installed" error when scanning
The app must be installed BEFORE scanning. Install via Xcode first (Step 1).

### QR code won't scan from screen
- Increase screen brightness
- Hold phone 6-12 inches from screen
- Try printing the QR code instead

### Brand colors don't appear
- Ensure you scanned the QR code (not just opened the app)
- Kill the app completely and scan again
- Check that the URL scheme is `catweighttracker://` (not `catweight://`)

### Simulator can't scan QR codes
Simulators don't have cameras. For simulator testing:
1. Open Safari in simulator
2. Navigate to: `catweighttracker://activate?brand=acmepet&name=AcmePet%20Foods&sku=wm-chicken-01&skuname=Weight%20Management%20Chicken&cal=3.5&serving=35&color=FF6B35&accent=004E64`
3. Tap "Open" when prompted

---

## Creating Custom Demo Brands

Edit `index.html` and add to the `demoBrands` array:

```javascript
{
    id: "yourbrand",
    url: "catweighttracker://activate?brand=yourbrand&name=Your%20Brand&sku=product-01&skuname=Product%20Name&cal=3.5&serving=35&color=HEX_NO_HASH&accent=HEX_NO_HASH"
}
```

Then add a corresponding card in the HTML grid.

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `index.html` | Interactive QR code generator (open in browser) |
| `README.md` | This file |
| `qr-exports/` | PNG exports for offline use (if generated) |

---

## For Sales Presentations

**Recommended setup:**
1. Print QR codes on cardstock (one per page)
2. Install app on demo iPhone via Xcode
3. Have customer scan printed QR → shows their potential brand experience

**Demo script (90 seconds):**
1. "Scan this QR code" (5 sec)
2. "See your brand colors and name" (10 sec)
3. "Enter cat details" (30 sec)
4. "You now have engagement data" (45 sec)
