# Data Handling and Security Documentation

**Document Version:** 1.0
**Last Updated:** January 15, 2026
**Intended Audience:** Enterprise procurement teams, compliance officers, white-label partners

---

## Executive Summary

CatWeightLoss is a privacy-first iOS application with **on-device data storage only**. No personal health information (PHI) or personally identifiable information (PII) is transmitted to remote servers. Analytics data is anonymized and limited to usage patterns only.

**Key Facts:**
- ✅ All user data stored locally on device
- ✅ No user accounts or authentication required
- ✅ No cloud sync or remote storage
- ✅ No PII collected at any time
- ✅ GDPR and CCPA compliant by design
- ✅ Enterprise-ready white-label platform

---

## 1. Data Collection

### 1.1 User-Generated Data (On-Device Only)

The following data is collected and stored **exclusively on the user's device**:

| Data Type | Description | Storage Location | Transmission |
|-----------|-------------|------------------|--------------|
| Weight Measurements | Date, time, weight value (kg/lbs), notes | Local SwiftData | None |
| Feeding Schedules | Time, portion size, food type | Local SwiftData | None |
| Activity Logs | Activity type, duration, intensity | Local SwiftData | None |
| Photos | Cat photos uploaded by user | iOS Photo Library (user permission required) | None |
| Meal Plans | Customized feeding recommendations | Local SwiftData | None |
| Progress Milestones | Achievement tracking, goal progress | Local SwiftData | None |

**Technical Implementation:**
- Storage: Apple SwiftData framework
- Encryption: iOS hardware-level encryption (Data Protection API)
- Sandboxing: iOS app sandbox isolates data from other apps
- Persistence: Data remains until user explicitly deletes or uninstalls app

### 1.2 Analytics Data (Anonymized)

Firebase Analytics collects **anonymized, non-PII data** for app improvement:

| Data Type | Purpose | Retention Period | PII Status |
|-----------|---------|------------------|------------|
| Anonymous Instance ID | Distinguish unique app installations | 14 months | Not PII |
| Device Model | Optimize UI for device types | 14 months | Not PII |
| iOS Version | Ensure compatibility | 14 months | Not PII |
| App Version | Track adoption of updates | 14 months | Not PII |
| Screen Views | Understand user navigation patterns | 14 months | Not PII |
| Feature Usage Events | Identify popular features | 14 months | Not PII |
| Crash Reports | Debug technical issues | 14 months | Not PII |
| Session Duration | Measure engagement | 14 months | Not PII |
| Country/Region | Aggregate geographic insights | 14 months | Not PII |

**What Analytics Does NOT Include:**
- ❌ Weight measurements or health data
- ❌ Names, emails, phone numbers
- ❌ Precise GPS location
- ❌ IP addresses (anonymized by Firebase)
- ❌ Device identifiers (IDFA/IDFV not collected)
- ❌ User-generated content (photos, notes)

### 1.3 Activation Data

QR code activation generates:
- **Activation Token:** One-time token linking app to brand partner
- **Brand Association:** Determines white-label theme and content
- **Processing:** Handled locally via deep link, no server-side storage

---

## 2. What is NOT Collected

CatWeightLoss **never** collects:

### Personal Identifiers
- Names (human or pet)
- Email addresses
- Phone numbers
- Physical addresses
- Social Security numbers
- Payment information

### Sensitive Data
- Precise geolocation (GPS coordinates)
- Biometric data
- Human health information
- Financial records
- Government-issued IDs

### Tracking Technologies
- Cross-app tracking identifiers
- Advertising identifiers (IDFA)
- Third-party cookies
- Web beacons or pixels

---

## 3. Data Storage Architecture

### 3.1 Local Storage Model

```
iOS Device
├── App Sandbox (Encrypted)
│   ├── SwiftData Database
│   │   ├── Weight Entries
│   │   ├── Feeding Schedules
│   │   ├── Activity Logs
│   │   └── User Preferences
│   └── Cache
│       └── Generated Charts/Graphs
└── Photo Library (User Permission)
    └── Cat Photos (if user grants access)
```

**Security Characteristics:**
- **Encryption:** AES-256 hardware encryption (iOS default)
- **Access Control:** iOS sandboxing prevents other apps from accessing data
- **Backup:** Included in user's iCloud/iTunes backup (user-controlled)
- **Deletion:** Automatic upon app uninstall

### 3.2 No Remote Storage

**Zero server-side data storage:**
- No databases storing user content
- No file servers hosting photos
- No backup servers replicating data
- No data warehouses aggregating entries

**Architecture Verification:**
- Network traffic analysis shows only Firebase Analytics HTTPS requests
- No endpoints exist for receiving user health data
- Source code audit confirms no upload functionality

---

## 4. Data Transmission

### 4.1 Network Activity

| Service | Data Transmitted | Protocol | Frequency |
|---------|------------------|----------|-----------|
| Firebase Analytics | Anonymous events, device metadata | HTTPS (TLS 1.3) | On app launch, periodic batching |
| QR Code Activation | Activation token (one-time) | HTTPS (TLS 1.3) | Once at activation |
| App Store | Standard iOS telemetry | HTTPS | iOS system-level |

### 4.2 Data Not Transmitted

The following data **never leaves the device**:
- Weight measurements
- Feeding schedules
- Activity logs
- Photos
- User notes
- Generated reports

---

## 5. Third-Party Services

### 5.1 Firebase Analytics (Google LLC)

**Purpose:** Anonymous usage analytics
**Data Shared:** Device metadata, app events (see Section 1.2)
**PII Shared:** None
**Data Location:** Google Cloud Platform (United States)
**Privacy Policy:** https://policies.google.com/privacy
**Compliance:** GDPR-compliant via Standard Contractual Clauses

**Firebase Configuration:**
- IP anonymization enabled
- Personalized advertising disabled
- IDFA collection disabled
- Data sharing with Google products disabled

### 5.2 No Other Third Parties

**We do NOT use:**
- Advertising networks
- Social media SDKs
- Third-party authentication providers
- Payment processors (no in-app purchases)
- Customer support platforms with data collection
- Marketing automation tools

---

## 6. GDPR Compliance

### 6.1 Compliance by Design

| GDPR Principle | Implementation |
|----------------|----------------|
| **Lawfulness, Fairness, Transparency** | Clear privacy policy, transparent data practices |
| **Purpose Limitation** | Data used only for stated purposes (tracking cat health) |
| **Data Minimization** | Only anonymous device ID collected; no PII |
| **Accuracy** | User controls all data entry and corrections |
| **Storage Limitation** | Analytics auto-deleted after 14 months; local data user-controlled |
| **Integrity and Confidentiality** | iOS encryption, sandboxing, HTTPS transmission |
| **Accountability** | This documentation, data protection impact assessment available |

### 6.2 User Rights Under GDPR

| Right | Implementation |
|-------|----------------|
| **Right to Access** | All data visible within app interface |
| **Right to Rectification** | Users can edit any entry |
| **Right to Erasure** | Delete individual entries or uninstall app |
| **Right to Restrict Processing** | Disable analytics via iOS settings |
| **Right to Data Portability** | No vendor lock-in; data remains on device |
| **Right to Object** | Users can stop using app at any time |
| **Automated Decision-Making** | No automated decisions with legal effects |

### 6.3 Legal Basis for Processing

- **User Data (on-device):** User consent implied by voluntary app use
- **Analytics Data:** Legitimate interest in app improvement, user can object via iOS settings

### 6.4 Data Protection Officer

For GDPR inquiries, contact:
**Email:** [DPO_EMAIL]
**Address:** [DPO_ADDRESS]

---

## 7. CCPA Compliance

### 7.1 California Consumer Privacy Act

| CCPA Requirement | Compliance Status |
|------------------|-------------------|
| **Notice at Collection** | Privacy policy discloses all collection practices |
| **Right to Know** | This document details all data collected |
| **Right to Delete** | Users can delete app to remove all data |
| **Right to Opt-Out of Sale** | N/A - We do not sell personal information |
| **Right to Non-Discrimination** | No discrimination for exercising rights |

### 7.2 Categories of Data Collected

Per CCPA terminology:
- **Identifiers:** Anonymous Firebase instance ID only (not considered PI under CCPA)
- **Internet Activity:** App usage patterns (anonymized)
- **Geolocation:** Country/region only (not precise location)
- **Sensitive Personal Information:** None collected

### 7.3 No Sale of Personal Information

**We do NOT sell, rent, or share personal information for monetary or other valuable consideration.** This includes:
- No data broker relationships
- No advertising network integrations
- No cross-context behavioral advertising
- No third-party data monetization

---

## 8. Data Retention

### 8.1 Retention Periods

| Data Category | Retention Period | Deletion Method |
|---------------|------------------|-----------------|
| Local user data | Until user deletes or uninstalls | iOS automatic deletion |
| Firebase Analytics | 14 months | Automatic Firebase deletion |
| Activation tokens | Not stored (processed once) | N/A |
| Crash logs | 90 days | Automatic Firebase deletion |

### 8.2 User Control

Users have complete control:
- Delete individual weight entries, feeding logs, etc. within app
- Uninstall app to permanently delete all local data
- iOS handles backup/restore via iCloud (user-configurable)

---

## 9. Security Measures

### 9.1 Technical Safeguards

| Layer | Security Control |
|-------|------------------|
| **Application** | iOS app sandbox, secure coding practices, input validation |
| **Data Storage** | SwiftData encryption, iOS Data Protection API (Class C) |
| **Network** | TLS 1.3 encryption for all network requests |
| **Authentication** | None required (no accounts) |
| **Authorization** | iOS permission system for photos |
| **Logging** | No sensitive data in logs |

### 9.2 Organizational Safeguards

- Regular security audits of codebase
- Penetration testing of QR activation flow
- Vendor security assessment (Firebase/Google)
- Incident response plan for vulnerabilities
- Secure development lifecycle (SDLC)

### 9.3 Data Breach Protocol

In the unlikely event of a security incident:
1. **Assessment:** Determine scope and affected data
2. **Containment:** Isolate affected systems
3. **Notification:** Notify affected users and regulators per GDPR (72 hours) and CCPA requirements
4. **Remediation:** Fix vulnerability, update app
5. **Documentation:** Maintain incident records

**Note:** Given on-device storage model, risk of large-scale data breach is minimal.

---

## 10. White-Label Partner Considerations

### 10.1 Brand Customization

White-label partners can customize:
- App theme (colors, logos)
- Content (feeding recommendations, educational materials)
- QR code activation endpoints

**Partners CANNOT:**
- Access user health data (stored locally)
- Track individual users
- Inject additional data collection

### 10.2 Partner Data Access

**Analytics Access:** Partners receive aggregated, anonymized analytics:
- Total app installations
- Feature usage percentages
- Average session duration
- Retention/churn rates

**No Individual Data:** Partners cannot access:
- Individual weight measurements
- User identities
- Device-level analytics
- Raw event data

### 10.3 Partner Compliance

White-label partners must:
- Provide contact information for privacy inquiries
- Comply with applicable data protection laws in their jurisdiction
- Not misrepresent data practices to end users
- Maintain brand-specific privacy policy addendum if required

---

## 11. App Store Compliance

### 11.1 Apple Privacy Nutrition Labels

App Store listing declares:
- **Data Used to Track You:** None
- **Data Linked to You:** None
- **Data Not Linked to You:** Device identifier, usage data, diagnostics (analytics only)

### 11.2 Permissions Requested

| Permission | Purpose | Required? |
|------------|---------|-----------|
| Photo Library (Limited) | Allow users to add cat photos | Optional |
| Notifications | Feeding reminders | Optional |

**Not Requested:**
- Location Services
- Camera
- Microphone
- Contacts
- Calendar

---

## 12. Children's Privacy

**Target Audience:** Adults (pet owners)
**COPPA Compliance:** App is not directed at children under 13
**Age Verification:** None required (no accounts)
**Parental Controls:** Rely on iOS Screen Time restrictions

---

## 13. International Data Transfers

### 13.1 Data Residency

- **User Health Data:** Remains on user's device in their jurisdiction
- **Analytics Data:** Transferred to Google Cloud Platform (United States)

### 13.2 Transfer Mechanisms

For analytics data transferred outside the EEA:
- **Legal Basis:** Standard Contractual Clauses (SCCs) between Google and data subjects
- **Adequacy:** Google Privacy Shield successor frameworks
- **Safeguards:** Encryption in transit, access controls, data minimization

---

## 14. Audit and Verification

### 14.1 Available Documentation

For enterprise procurement review, we provide:
- ✅ Source code review access (NDA required)
- ✅ Network traffic analysis reports
- ✅ Firebase configuration screenshots
- ✅ iOS App Store privacy label
- ✅ Data flow diagrams
- ✅ Security architecture documentation
- ✅ Vendor security assessments (Firebase/Google)

### 14.2 Certification and Attestations

- iOS App Store approval (Apple review process)
- Firebase GDPR compliance attestation
- Available: Third-party penetration test report (upon request)

---

## 15. Contact and Escalation

### 15.1 Privacy Inquiries

**General Questions:**
Email: [PRIVACY_EMAIL]
Response Time: 5 business days

**Data Subject Requests (GDPR/CCPA):**
Email: [DSR_EMAIL]
Response Time: 30 days (GDPR) / 45 days (CCPA)

**Security Incidents:**
Email: [SECURITY_EMAIL]
Response Time: 24 hours

### 15.2 Enterprise Partner Support

**White-Label Partners:**
Email: [PARTNER_SUPPORT_EMAIL]
Dedicated Account Manager: [ASSIGN_PER_PARTNER]

**Procurement/Legal Teams:**
Email: [LEGAL_EMAIL]
Contracts and Compliance: [CONTRACTS_EMAIL]

---

## 16. Document Revision History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-01-15 | Initial document creation | [AUTHOR_NAME] |

---

## 17. Appendices

### Appendix A: Data Flow Diagram

```
User's iPhone
    │
    ├─→ Local App Storage (SwiftData)
    │   └─→ Weight, Feeding, Activity Data
    │       └─→ NEVER transmitted off device
    │
    ├─→ Firebase Analytics (HTTPS)
    │   └─→ Anonymous events only
    │       └─→ Google Cloud Platform (US)
    │
    └─→ QR Code Activation (one-time)
        └─→ Token validation via deep link
            └─→ Brand association stored locally
```

### Appendix B: Firebase Analytics Events

**Events Tracked:**
- `app_open` - App launched
- `screen_view` - User navigates to screen
- `weight_entry_added` - Weight measurement logged (value NOT transmitted)
- `feeding_schedule_created` - Schedule set up (details NOT transmitted)
- `milestone_achieved` - Progress goal reached (details NOT transmitted)

**Event Parameters:**
- Screen name
- Event timestamp
- Session ID (anonymous)

**NOT Tracked:**
- Actual weight values
- Cat names
- User notes
- Photo metadata

### Appendix C: Compliance Checklist

Enterprise procurement teams can verify:

- [ ] No PII collected or transmitted
- [ ] All health data stored on-device only
- [ ] Analytics anonymized and limited
- [ ] GDPR user rights implementable
- [ ] CCPA "do not sell" complied (no sale occurs)
- [ ] Encryption in transit (TLS 1.3)
- [ ] Encryption at rest (iOS hardware encryption)
- [ ] Third-party vendors disclosed (Firebase only)
- [ ] Data retention policies defined
- [ ] Security incident response plan exists
- [ ] Privacy policy publicly available
- [ ] Contact information for inquiries provided

---

**Document Classification:** Public
**Distribution:** Approved for sharing with enterprise customers, procurement teams, and compliance auditors

**For questions regarding this document, contact:**
[LEGAL_OR_COMPLIANCE_CONTACT]
