# linkservice — Proposal & Supplier Matching Business Rules

This document captures the business rules that govern Proposal creation and Supplier matching. Use it as the canonical reference when writing or reviewing tests.

---

## Domain Primer

- **Supplier**: a website owner who can place a guest-post/link on their site.
- **Demand**: a monthly work order from a customer (DemandSite) requesting an inbound link.
- **PaidLink**: the permanent record of a link placed between a Supplier domain and a Demand domain.
- **Proposal**: a transient workflow entity that groups one Supplier with 1–3 Demands. It is backed by 1–3 `PaidLink` rows, one per Demand.

---

## Rule 1 — Proposal structure (1–3 Demands)

A Proposal must contain between 1 and 3 PaidLinks (enforced by `ProposalValidator`).  
Zero or more than 3 PaidLinks is rejected.

_Source: `entity/validator/ProposalValidator.java:21`_

---

## Rule 2 — Cross-domain uniqueness (the core SEO constraint)

A Supplier must **never** be matched to the same DemandSite domain more than once, across all time.  
Multiple links between the same two domains provide zero additional SEO value.

**`PaidLink` is the authoritative history** that enforces this. Before creating a Proposal the system checks:

```
paidLinkRepo.findByDemandDomainAndSupplierDomain(demand.getDomain(), supplier.getDomain())
```

If any existing PaidLink is found → HTTP 400, proposal rejected.

_Source: `controller/ProposalSupportController.java:234–242`_

---

## Rule 3 — Supplier eligibility for a Demand (`findSuppliersForDemandId`)

When the UI asks "which suppliers can satisfy this demand?", ALL of the following must hold:

| # | Rule | Detail |
|---|------|--------|
| 3a | **No prior link** | Supplier has no PaidLink for any Demand whose domain equals the target Demand's domain |
| 3b | **DA meets threshold** | `supplier.da >= demand.daNeeded` |
| 3c | **Category overlap** | Supplier and Demand share ≥ 1 **enabled** (non-disabled) Category |
| 3d | **Not third-party** | `supplier.thirdParty = false` |
| 3e | **Not disabled** | `supplier.disabled = false` |

**Ordering**: results sorted `weWriteFee ASC` then `da DESC` — cheapest first, then highest authority.

_Source: `repo/SupplierRepo.java:38–51` (native SQL query)_

---

## Rule 4 — Additional Demands for a bundle (`findDemandForSupplierId`)

When building a multi-demand proposal (up to 3 Demands per Supplier), candidate "add-on" Demands must satisfy:

| # | Rule | Detail |
|---|------|--------|
| 4a | **Different DemandSite domain** | Demand domain ≠ the already-selected Demand's domain |
| 4b | **Not already satisfied** | Demand has no existing PaidLink (`d.id NOT IN (SELECT pl.demand_id FROM paid_link pl)`) |
| 4c | **No prior history** | Supplier's domain has no existing PaidLink for any Demand from that DemandSite domain (same cross-domain rule as Rule 2) |
| 4d | **DA meets threshold** | `supplier.da >= demand.daNeeded` |
| 4e | **Category match** | Demand shares ≥ 1 **enabled** Category with the Supplier |
| 4f | **Not the chosen Demand** | The primary Demand passed as `demandIdToIgnore` is excluded from results |

_Source: `repo/DemandRepo.java:23–39` (native SQL query)_

---

## Rule 5 — Proposal creation happy path

Steps executed inside a single transaction by `createProposal`:

1. Supplier must exist → 404 if not.
2. All specified Demand IDs must exist → 404 if any are missing.
3. No existing PaidLink for any (supplierDomain, demandDomain) pair in the request → 400 if duplicate.
4. One `PaidLink` record is created per Demand.
5. A `Proposal` is created referencing all PaidLinks, with:
   - `createdBy` set to the requesting user.
   - `dateCreated = now()`.
   - `supplierSnapshotVersion`, `supplierSnapshotRevision`, `supplierSnapshot` (JSON) captured at creation time for historical display.

_Source: `controller/ProposalSupportController.java:199–306`_

---

## Rule 6 — Third-party supplier proposals (`resolveProposal3rdParty`)

Used when a link was placed by an external/manual supplier outside the normal workflow.

- A new `Supplier` is created with `thirdParty = true`; domain/email/website are **not required**.
- Linked to exactly **one** Demand.
- If the resulting Proposal is later aborted, the ephemeral third-party Supplier is also deleted.

_Source: `controller/ProposalSupportController.java:327–360`_  
_Source: `ProposalAbortHandler.java:42–46`_

---

## Rule 7 — Proposal abort / deletion

On abort (`/proposalsupport/abort`):

1. Proposal is deleted.
2. All PaidLinks on the Proposal are deleted.
3. If the Supplier is `thirdParty = true`, the Supplier is also deleted.

_Source: `ProposalAbortHandler.java:32–49`_

---

## Rule 8 — Supplier snapshot (historical display)

A Supplier's details can change after a Proposal is created (DA updated, name changed, etc.).  
To preserve what the Supplier looked like _at proposal time_:

- At creation, the Supplier is serialised to JSON and stored in `Proposal.supplierSnapshot`.
- The current Envers revision is stored in `supplierSnapshotRevision`.
- At read time, if `proposal.supplierSnapshotVersion != supplier.version` (i.e. supplier has since changed), the original supplier is restored from the JSON snapshot (fast path) or from Envers (legacy/fallback path).
- On first Envers-based restore the snapshot is lazily written back to the DB so subsequent reads use the fast JSON path.

_Source: `controller/ProposalSupportController.java:113–183`_

---

## Rule 9 — Category matching uses enabled categories only

Disabled categories are **excluded** from matching in both `findSuppliersForDemandId` and `findDemandForSupplierId`.  
A Supplier and Demand sharing only a _disabled_ Category do **not** match.

_Source: `repo/SupplierRepo.java:45` and `repo/DemandRepo.java:31–33` (SQL: `c.disabled=false`)_

---

## Rule 10 — Blacklist (upstream gate during supplier onboarding)

The `BlackListedSupplier` table records domains that have been identified as low-quality or spammy.

**Blacklisting happens during supplier onboarding**, not at proposal-matching time:

1. **Bulk upload** (`NewSupplierBulkUpload.jsx`): when a CSV of candidate domains is loaded, each domain is checked against `isBlackListed` before any Moz/SemRush lookup is made. Blacklisted domains are silently skipped — no external API call is made (saving per-query cost).
2. **Individual add** (`AddOrEditSupplier.jsx`): when a domain is typed in, the UI checks both `supplierExists` and `isBlackListed`. Only non-existing, non-blacklisted domains show the "Load stats" button, which fetches DA and SemRush traffic. From the stats modal the user can choose to **blacklist** the domain, storing the DA, spam score, and SemRush data.

Because blacklisted domains are blocked from ever being saved to the `supplier` table, `findSuppliersForDemandId` never encounters them. **The backend does not need to query `blacklistedsuppliers` during proposal creation or supplier matching.**

_Source: `controller/BlackListedSupplierSupportController.java`, `frontend/react/src/components/NewSupplierBulkUpload.jsx:43–92`, `frontend/react/src/components/AddOrEditSupplier.jsx:55–107`_

---

## Rule 11 — Supplier field validation (non-third-party)

| Field | Constraint |
|-------|------------|
| `name` | Required, length ≥ 2 |
| `email` | Required, length ≥ 5 |
| `website` | Required, length ≥ 5 |
| `domain` | Required, length ≥ 5 (auto-derived from `website` via `Util.stripDomain`) |
| `da` | 0–100 inclusive |
| `weWriteFee` | 0–1,000,000 inclusive |
| `weWriteFeeCurrency` | Exactly 1 character |

Third-party suppliers (`thirdParty = true`) skip all constraints except `name` length ≥ 2.

_Source: `entity/validator/SupplierValidator.java`_

---

## Rule 12 — Demand field validation

| Field | Constraint |
|-------|------------|
| `requested` | Required |
| `daNeeded` | > 0 |
| `url` | Required (also auto-sets `domain` via `Util.stripDomain`) |
| `domain` | Required (stripped form of `url`) |
| `source` | Required |
| `createdBy` | Required |

_Source: `entity/validator/DemandValidator.java`_

---

## Test coverage

| Test file | What it covers |
|-----------|----------------|
| `controller/ProposalSupportControllerTest.java` | Proposal creation: 404 (supplier/demand not found), 400 (single-demand duplicate), **400 (multi-demand partial conflict — Rule 2)**; abort: **standard multi-demand (Rule 7)**, **third-party (Rules 6+7)**; supplier snapshot restore: JSON fast path, **Envers direct-find path (revision present, no JSON snapshot — Rule 8)**, Envers legacy path (no revision, no snapshot), unchanged supplier, multi-proposal same supplier, narrow date range |
| `repo/SupplierRepoTest.java` | `findSuppliersForDemandId`: disabled/third-party exclusion, DA threshold, category matching (single/multi), prior-link exclusion, **result ordering (cheapest first, then highest DA — Rule 3)** |
| `repo/DemandRepoTest.java` | `findDemandForSupplierId`: disabled category exclusion, same-domain deduplication, prior paid-link exclusion, DA matching, category matching |
| `repo/SupplierHealthRepoTest.java` | `findAtRiskDemandSites`: at-risk flagging, healthy site not flagged, threshold boundary, mixed sites, disabled/third-party exclusion |
