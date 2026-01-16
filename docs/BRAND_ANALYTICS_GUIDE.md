# Brand Partner Analytics Guide

This guide explains how brand partners can access and interpret their analytics data from the CatWeightLoss app.

## What Data You Receive

All metrics are **anonymized and aggregated** at the brand level. No personal information is collected.

### Activation & Onboarding Funnel
Track how users discover and activate your brand:

1. **QR Code Scans** → Brand Activations
2. **Brand Activations** → Setup Completions
3. **Setup Completion Rate** = Completions / Activations

**Business Value**: Understand QR code effectiveness and onboarding friction.

### Engagement Metrics
Measure how users interact with your brand:

| Metric | Description | Business Value |
|--------|-------------|----------------|
| **Daily/Weekly Active Users** | Users who open app | Brand loyalty |
| **Weight Logs per User** | Avg entries per user | Product effectiveness perception |
| **Days Between Logs** | Logging frequency | User retention proxy |
| **Weight Trends** | Up/Down/Stable | Product efficacy signal |
| **Activity Sessions** | Logged activities | Holistic engagement |
| **Feeding Schedules Created** | Users with meal plans | Serious commitment indicator |

**Business Value**: Identify engaged users, retention issues, and product satisfaction signals.

### Reorder Funnel (Monetization)
Critical revenue attribution data:

```
App Users
   ↓
Reorder Screen Views (# of users who saw reorder screen)
   ↓
Retailer Clicks (# who clicked through to buy)
   ↓
Conversion Rate = Clicks / Views
```

**Retailer Attribution**:
- Which retailers convert best (Amazon, Chewy, Petco, etc.)
- Optimize affiliate partnerships based on performance
- Negotiate better terms with high-converting retailers

**Business Value**: Direct revenue attribution, optimize retailer mix, calculate LTV.

### Key Performance Indicators (KPIs)

**Activation KPIs**:
- QR Scans → Activations (goal: 80%+)
- Activations → Setup Complete (goal: 70%+)
- Time to Complete Setup (goal: <3 minutes)

**Engagement KPIs**:
- 7-Day Retention Rate (goal: 60%+)
- 30-Day Retention Rate (goal: 40%+)
- Avg Weight Logs per Month (goal: 8+)
- Users with 3+ Entries (goal: 70%+)

**Monetization KPIs**:
- Reorder View Rate (goal: 30%+ of users)
- Reorder Click Rate (goal: 15%+ of views)
- Retailer CTR (goal: 40%+ on Amazon/Chewy)

## Accessing Your Dashboard

### Firebase Console Access

1. You'll receive an email invitation to Firebase Console
2. Click "Accept Invitation"
3. Sign in with your Google account
4. Navigate to: **Analytics → Events**

### Dashboard Views

**Events Dashboard**:
- See all tracked events (brand_activated, weight_logged, etc.)
- Filter by date range (last 7, 30, 90 days)
- Export data for deeper analysis

**DebugView** (Real-time):
- See events as they happen (during testing)
- Verify integration is working
- Requires debug mode enabled on test device

**Audiences**:
- Pre-built segments:
  - "Engaged Users" (3+ weight logs in 7 days)
  - "At Risk" (no activity in 14 days)
  - "Reorder Intent" (viewed reorder screen)

### Filtering by Your Brand

All events include `brand_id` parameter. To see only your data:

1. Firebase Console → Analytics → Events
2. Click any event name
3. Add filter: `brand_id = your-brand-id`
4. Apply filter

**Your Brand ID**: Provided when you activate the app via QR code.

## Understanding Your Reports

### Weekly Summary Report
Available every Monday via Firebase Console:

**Activation**:
- New brand activations this week
- Setup completion rate

**Engagement**:
- Weekly active users (WAU)
- Avg weight logs per user
- Avg days between logs

**Monetization**:
- Reorder views and clicks
- Top converting retailers
- Estimated click value (based on affiliate commissions)

### Monthly Deep Dive
Available first week of each month:

- Monthly active users (MAU)
- Cohort retention (how many users from each week are still active)
- Weight loss trends (% of users trending down)
- Reorder conversion funnel
- Retailer performance comparison

## Example Analysis: Evaluating Campaign Success

**Scenario**: You ran a QR code campaign on 10,000 product bags in March.

**What to Track**:
1. **Week 1**: Monitor `brand_activated` spike
   - Expected: 500-1,000 scans (5-10% scan rate)
2. **Week 2-4**: Monitor `setup_completed` rate
   - Goal: 70%+ complete setup
3. **Month 2**: Monitor retention
   - Goal: 40%+ still logging weights
4. **Month 3**: Monitor reorder intent
   - Goal: 20%+ view reorder screen
   - Goal: 5-10% click through to retailers

**ROI Calculation**:
```
Total QR Code Investment: $X
Activations: Y users
Reorder Clicks: Z clicks
Avg Order Value: $A (from retailer data)
Affiliate Commission: B% (from retailer)

Revenue Attribution = Z × A × B
ROI = (Revenue Attribution - Investment) / Investment
```

## Competitive Benchmarking

Based on similar pet health apps:

| Metric | Industry Average | Top Performers |
|--------|------------------|----------------|
| Activation → Setup | 50-60% | 70%+ |
| 7-Day Retention | 40-50% | 60%+ |
| 30-Day Retention | 20-30% | 40%+ |
| Reorder View Rate | 15-25% | 30%+ |
| Reorder Click Rate | 5-10% | 15%+ |

**Goal**: Outperform industry averages through better product-app integration.

## Privacy & Compliance

### What We Track (Anonymous)
- Event counts (how many users did X)
- Trend directions (weight up/down, not actual values)
- Timing (when events happen)
- Brand/SKU associations

### What We DON'T Track (PII)
- User names or emails
- Actual weight values
- Cat names or photos
- Location data
- Cross-app behavior

### Compliance
- GDPR compliant (anonymized, aggregated data)
- CCPA compliant (no personal data sale)
- COPPA compliant (no data from children)
- App Store privacy labels accurate

### User Rights
- Users can delete the app (removes local data)
- No account system means no user profiles to delete
- Firebase auto-anonymizes device identifiers

## Exporting Data

### Firebase Console Export
1. Analytics → Events → Click event name
2. Click "View in BigQuery" (if enabled)
3. Query data with SQL for custom analysis

### CSV Export (Local MetricsAggregator)
The app also includes local CSV export:
1. Accessible via Admin Hub in app
2. Generates CSV with same metrics
3. Provides data ownership for brands

**When to Use Each**:
- **Firebase**: Real-time dashboards, funnels, retention
- **CSV Export**: Offline analysis, import to your BI tools

## Custom Dashboards with Data Studio

For advanced visualization:

1. Connect Firebase to BigQuery (free tier available)
2. Connect BigQuery to Google Data Studio
3. Create custom dashboards:
   - Filter by your brand_id
   - Build custom funnels
   - Compare time periods
   - Cohort analysis

**Pre-built Templates**: Contact us for brand-specific dashboard templates.

## Frequently Asked Questions

**Q: How often does data update?**
A: Events appear within 24 hours in standard views. DebugView is real-time (for testing).

**Q: Can I see individual user behavior?**
A: No. All data is anonymized and aggregated. You see counts and averages, not individual users.

**Q: How do I calculate ROI from app engagement?**
A: Track reorder_clicked events × avg order value × affiliate commission rate.

**Q: Can I compare my metrics to other brands?**
A: No. Each brand only sees their own data (privacy by design).

**Q: What if I see low retention?**
A: Common fixes:
- Improve onboarding clarity
- Add QR code placement on multiple touch points
- Offer in-app incentives (e.g., "Log 7 days, get 10% off")
- Better packaging integration (make QR prominent)

**Q: How do I optimize reorder conversion?**
A: Test:
- Different retailer order (put highest-converting first)
- Promotional pricing visible in app
- Urgency messaging ("Running low!")
- Auto-reorder reminders

**Q: Can I share this data with my team?**
A: Yes. Add team members via Firebase Console → Settings → Users & Permissions. Assign "Analytics Viewer" role.

**Q: How long is data retained?**
A: Firebase retains 14 months by default. CSV exports available anytime for archival.

## Getting Help

**Technical Issues**:
- Firebase Documentation: https://firebase.google.com/docs/analytics
- Integration Questions: Contact development team

**Analytics Interpretation**:
- Schedule dashboard walkthrough: [Contact info]
- Request custom reports: [Contact info]

**Business Questions**:
- ROI calculation assistance
- Benchmarking against industry
- Campaign optimization consulting

## Next Steps

1. **Access Firebase Console**: Accept invitation email
2. **Review Your Brand ID**: Confirm it matches your QR code
3. **Explore Events Dashboard**: Familiarize with interface
4. **Set Baseline Metrics**: Track current numbers before campaigns
5. **Schedule Review Cadence**: Weekly check-ins recommended
6. **Export Initial Data**: Backup to your BI tools

## Appendix: Event Reference

| Event Name | When It Fires | Key Parameters |
|------------|---------------|----------------|
| `brand_activated` | User scans QR code | brand_id, sku_id |
| `setup_completed` | User finishes onboarding | brand_id, sku_id |
| `app_opened` | User launches app | brand_id |
| `weight_logged` | User logs weight | brand_id, trend_direction |
| `feeding_schedule_created` | User creates meal plan | brand_id |
| `activity_logged` | User logs activity | brand_id, activity_type, duration_minutes |
| `reorder_viewed` | User opens reorder screen | brand_id, sku_id |
| `reorder_clicked` | User clicks retailer link | brand_id, sku_id, retailer |

All events include `timestamp` (Unix epoch).

## Success Story Template

Use this template to communicate value to stakeholders:

```
Campaign: [QR Code on 10K bags, March 2026]

Activation:
- 847 QR scans (8.5% scan rate)
- 612 brand activations (72% activation rate)
- 441 setup completions (72% setup rate)

Engagement (30 days):
- 283 users still active (64% retention)
- 6.2 avg weight logs per user
- 4.3 avg days between logs

Monetization:
- 89 reorder views (31% of active users)
- 23 retailer clicks (26% conversion)
- Est. $2,070 in attributed sales ($90 AOV × 23 clicks)
- Est. $207 in commissions (10% affiliate rate)

ROI: 4.1x (assuming $50 QR code printing cost)
```

---

**Version**: 1.0 (January 2026)
**Maintainer**: CatWeightLoss Development Team
**Last Updated**: 2026-01-15
