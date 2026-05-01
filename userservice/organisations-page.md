# Organisations Overview Page Logic

## Overview

Organisation status (including "abandoned", "new", "active", and "inactive") is computed entirely on the frontend in `frontend/react/src/pages/admin/organisations/index.jsx`. The backend returns raw data with no status field.

## Backend

`OrganisationsOverviewController` returns `OrgOverviewDto` containing:
- `orgId`, `orgName`, `orgSlug`, `createdAt`
- `users` — list of `UserOverviewDto` with `lastLogin` timestamps from Keycloak

No server-side status computation is performed.

## Frontend Logic

The classification logic resides in two main functions within `frontend/react/src/pages/admin/organisations/index.jsx`. Both use hardcoded date thresholds computed from `new Date()` at runtime:
- `thirtyDaysAgo = now - 30 days` — age threshold
- `sixtyDaysAgo = now - 60 days` — inactivity threshold

### Per-org status: `getOrgStatus()` (lines 63–80)

This function determines the status badge displayed for each individual organisation in the table. The evaluation order is critical as it returns the first matching condition:

1. **`'new'`**
   - Created within 30 days **AND** has at least one user.
2. **`'abandoned'`**
   - **No users + older than 30 days**: `org.users.length === 0 && created < thirtyDaysAgo`
   - **OR No last activity recorded**: No user in the org has a `lastLogin` value.
3. **`'active'`**
   - At least one user logged in within the last 60 days.
4. **`'inactive'`**
   - Has users, but none have logged in within the last 60 days.

### Dashboard metrics count: `calculateMetrics()` (lines 32–61)

The dashboard summary cards use slightly different criteria for their counts:

- **`activeOrgs`**: Count of organisations where at least one user has logged in within the last 60 days.
- **`abandonedOrgs`**: An org is counted as abandoned in this metric only if it was created more than 30 days ago **AND** (it has no users **OR** all users are 60+ days inactive).

*Note: This means the "Abandoned Orgs" dashboard count may include organisations that the `getOrgStatus()` function classifies as `'inactive'`.*

## Thresholds Summary

| Threshold | Value |
| :--- | :--- |
| **Age (New/Abandoned)** | 30 days |
| **Inactivity (Active/Inactive)** | 60 days |

The classification is dynamic and changes over time as dates shift.
