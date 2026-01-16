# Cat Weight Companion - Design Specifications

## Color Scheme

### Primary Colors
- **Primary (Teal/Sky Blue)**
  - Light mode: `#0EA5E9`
  - Dark mode: `#38BDF8`
  - Usage: Buttons, links, active states, app icon background

### Background Colors
- **Background**
  - Light mode: `#FFFFFF` (White)
  - Dark mode: `#0F172A` (Dark slate)
  - Usage: Main screen background

- **Surface**
  - Light mode: `#F8FAFC` (Light gray)
  - Dark mode: `#1E293B` (Darker slate)
  - Usage: Cards, elevated surfaces, input fields

### Text Colors
- **Foreground (Primary Text)**
  - Light mode: `#0F172A` (Dark slate)
  - Dark mode: `#F8FAFC` (Light gray)
  - Usage: Headings, primary text

- **Muted (Secondary Text)**
  - Light mode: `#64748B` (Slate gray)
  - Dark mode: `#94A3B8` (Light slate)
  - Usage: Subtitles, helper text, placeholders

### UI Colors
- **Border**
  - Light mode: `#E2E8F0` (Light slate)
  - Dark mode: `#334155` (Medium slate)
  - Usage: Dividers, input borders, card borders

- **Success (Green)**
  - Light mode: `#22C55E`
  - Dark mode: `#4ADE80`
  - Usage: Success messages, positive trends, completed states

- **Warning (Orange)**
  - Light mode: `#F97316`
  - Dark mode: `#FB923C`
  - Usage: Warnings, alerts, attention states

- **Error (Red)**
  - Light mode: `#EF4444`
  - Dark mode: `#F87171`
  - Usage: Error messages, destructive actions, negative trends

- **Purple (Accent)**
  - Light mode: `#8B5CF6`
  - Dark mode: `#A78BFA`
  - Usage: Activity tracking, special features

---

## App Icon Specifications

### iOS App Store
- **Format**: PNG
- **Dimensions**: 2048 x 2048 pixels (1024x1024 minimum required)
- **Color Space**: sRGB or Display P3
- **No Transparency**: Must have opaque background
- **No Rounded Corners**: iOS applies corner radius automatically
- **File**: `icon.png` (2048x2048px)

### Google Play Store
- **Format**: PNG (32-bit)
- **Dimensions**: 512 x 512 pixels
- **Adaptive Icon Components**:
  - **Foreground**: `android-icon-foreground.png` (2048x2048px)
  - **Background**: `android-icon-background.png` (solid color or pattern)
  - **Monochrome** (optional): `android-icon-monochrome.png` (for themed icons)
- **Safe Zone**: Keep important content within center 66% circle
- **Background Color**: `#E6F4FE` (light teal/cyan)

### Current Icon Design
- **Main Icon**: White cat face with teal background
- **Symbol**: Scale icon below cat (representing weight tracking)
- **Style**: Flat, minimalist, friendly
- **Background**: Solid teal gradient (#0EA5E9)
- **Current Size**: 2048 x 2048 pixels

### Splash Screen
- **Icon**: `splash-icon.png` (200px width, centered)
- **Background**: 
  - Light mode: `#FFFFFF`
  - Dark mode: `#000000`
- **Resize Mode**: contain

### Favicon (Web)
- **Format**: PNG
- **Dimensions**: 48 x 48 pixels (or larger)
- **File**: `favicon.png`

---

## Icon Export Requirements

### For iOS Submission
1. Export at 1024x1024px minimum (current: 2048x2048px ✓)
2. Remove alpha channel (make background opaque) ✓
3. Use sRGB color profile
4. Save as PNG without transparency ✓

### For Google Play Submission
1. **High-res icon**: 512x512px
2. **Adaptive icon foreground**: 432x432px safe zone within 512x512px canvas
3. **Feature graphic**: 1024x500px (for store listing)
4. **Screenshots**: 
   - Phone: 16:9 or 9:16 ratio, minimum 320px
   - Tablet: 16:9 or 9:16 ratio, minimum 1080px

---

## Typography

### Font Family
- **System Default**: San Francisco (iOS), Roboto (Android)
- **Fallback**: System UI fonts

### Font Sizes (Tailwind Classes)
- `text-4xl`: 36px (Hero headings)
- `text-3xl`: 30px (Page titles)
- `text-2xl`: 24px (Section headings)
- `text-xl`: 20px (Card titles)
- `text-lg`: 18px (Large body text)
- `text-base`: 16px (Body text)
- `text-sm`: 14px (Small text)
- `text-xs`: 12px (Captions, labels)

### Font Weights
- `font-bold`: 700 (Headings)
- `font-semibold`: 600 (Subheadings, buttons)
- `font-medium`: 500 (Emphasized text)
- `font-normal`: 400 (Body text)

---

## Spacing & Layout

### Border Radius
- `rounded-xl`: 12px (Cards, buttons)
- `rounded-2xl`: 16px (Large cards)
- `rounded-full`: 9999px (Circular elements, pills)

### Padding/Margin
- `p-1`: 4px
- `p-2`: 8px
- `p-3`: 12px
- `p-4`: 16px
- `p-6`: 24px
- `p-8`: 32px

---

## Component Styles

### Buttons
- **Primary**: `bg-primary`, white text, rounded-xl, py-4, px-6
- **Press State**: opacity 0.9, scale 0.98
- **Disabled**: `bg-muted`, reduced opacity

### Cards
- **Background**: `bg-surface`
- **Border**: `border border-border`
- **Radius**: `rounded-2xl`
- **Padding**: `p-4`

### Input Fields
- **Background**: `bg-surface`
- **Border**: `border border-border`
- **Radius**: `rounded-xl`
- **Padding**: `px-4 py-3`
- **Focus**: Primary border color

---

## App Configuration

### Bundle Identifiers
- **iOS**: `space.manus.cat.weight.loss.t20250116031453`
- **Android**: `space.manus.cat.weight.loss.t20250116031453`

### App Name
- **Display Name**: Cat Weight Companion
- **Slug**: cat-weight-loss

### Deep Link Scheme
- **Scheme**: `manus20250116031453://`

---

## Notes for Developers

1. **Color tokens** are defined in `theme.config.js` and automatically work in both Tailwind classes and runtime via `useColors()` hook
2. **Dark mode** is handled automatically through CSS variables - no need for `dark:` prefix in most cases
3. **Icon files** are located in `/assets/images/` directory
4. **All icons** must be mapped in `components/ui/icon-symbol.tsx` before use
5. **Responsive design** uses standard Tailwind breakpoints (sm, md, lg, xl)
