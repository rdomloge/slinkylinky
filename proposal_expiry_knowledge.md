# Proposal Expiry Knowledge

## How Expiry Works

Proposals don't carry their own expiry timestamp. Expiry is tracked through the **Engagement** entity in the `supplierengagement` service.

| Entity | Field | Meaning |
|---|---|---|
| `Engagement` | `supplierEmailSent` | When the proposal email was sent to the supplier — the expiry clock starts here |
| `Engagement` | `status` | `NEW` = active / waiting; `EXPIRED` = auto-cancelled |
| `Proposal` | `doNotExpire` | Boolean — when `true`, skips auto-expiry entirely |

**Expiry window: 2 business days** (Monday–Friday) from `supplierEmailSent`.

## Auto-Canceller

`ProposalAutoCanceller.java` (supplierengagement service) runs every hour via `@Scheduled(fixedRate=3600000)` and also on `@PostConstruct`.

It finds `Engagement` rows where `status = NEW AND supplierEmailSent < calculateTwoBusinessDaysAgo()`, then:
1. Skips if `proposal.doNotExpire = true`
2. Skips if proposal is already accepted / live / paid
3. Calls `httpUtils.abortProposal()` → DELETE on linkservice
4. Sets `engagement.status = EXPIRED`
5. Sends expiry notification email to supplier

## Business Day Calculation

```java
// Two business days ago — Mon=1 to Fri=5
LocalDateTime now = LocalDateTime.now();
int businessDays = 0;
while (businessDays < 2) {
    now = now.minusDays(1);
    if (now.getDayOfWeek().getValue() <= 5) businessDays++;
}
return now; // twoBusinessDaysAgo
```

Forward calculation (expiresAt):
```java
LocalDateTime result = sentAt;
int businessDays = 0;
while (businessDays < 2) {
    result = result.plusDays(1);
    if (result.getDayOfWeek().getValue() <= 5) businessDays++;
}
return result; // expiresAt
```

## Key Queries

| Method | Location | Purpose |
|---|---|---|
| `findByStatusAndSupplierEmailSentBefore(NEW, twoBusinessDaysAgo)` | `EngagementRepo` | Find expired (used by auto-canceller) |
| `findByStatusAndSupplierEmailSentAfterOrderBySupplierEmailSentAsc(NEW, twoBusinessDaysAgo)` | `EngagementRepo` (new) | Find active (still in window), sorted oldest first = most urgent |

## New API Endpoint

`GET /.rest/engagements/expiring-soon`  
Service: `supplierengagement` (port 8091), routed via `/.rest/engagements`  
Auth: requires authenticated JWT (any role)  
Controller: `EngagementSupportController.java`

Response: JSON array, ordered by `supplierEmailSent` ascending (most urgent first)
```json
[
  {
    "id": 42,
    "supplierName": "example.com",
    "proposalId": 99,
    "supplierEmailSent": "2024-01-15T10:30:00",
    "expiresAt": "2024-01-17T10:30:00"
  }
]
```

## Dashboard Integration

- URL added at index 10 in `buildDashboardUrls()` in `dashboard/index.jsx`
- Extracted as `expiringEngagements` in `processResults()`
- Rendered as a 4th column panel in the `grid grid-cols-4 gap-4` insight section
- Link target: `/proposals/{proposalId}`

## Entity File Locations

| File | Path |
|---|---|
| Engagement entity | `supplierengagement/src/main/java/.../entity/Engagement.java` |
| EngagementStatus enum | `supplierengagement/src/main/java/.../entity/EngagementStatus.java` |
| EngagementRepo | `supplierengagement/src/main/java/.../repo/EngagementRepo.java` |
| ProposalAutoCanceller | `supplierengagement/src/main/java/.../ProposalAutoCanceller.java` |
| SecurityConfig | `supplierengagement/src/main/java/.../config/SecurityConfig.java` |
| UploadController (engagement PATCH) | `supplierengagement/src/main/java/.../controller/UploadController.java` |
| EngagementSupportController (new) | `supplierengagement/src/main/java/.../controller/EngagementSupportController.java` |
