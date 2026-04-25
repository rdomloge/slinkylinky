# Sign-Up Feature — Stage 06: global-admin organisations overview

## Objective
Give `global_admin` users an operational view of every self-serve organisation, its users, and basic activity signals.

## Scope from `sign-up-planv2.md`
- Original Stage 7.

## Deliverables
- `GET /.rest/accounts/admin/organisations-overview` in `userservice`.
- Global-admin-only `/admin/organisations` page with expand, search, and CSV export.
- Navigation link for the page.
- Keycloak event prerequisite documented in `docs/multi-tenancy-keycloak-setup.md`.
- Backend tests for `OrganisationsOverviewController`: non-admin → 403, admin → expected payload shape, partial Keycloak failure on one user → that user's `lastLogin` is null without breaking the rest of the response.
- Frontend tests for `pages/admin/organisations/index.jsx`: non-admin redirect, admin sees table, row expansion loads users, search filter, CSV export rows match data, "Never" rendered for null `lastLogin`.

## Step checklist
1. [ ] Implement the admin overview endpoint, DTOs, `global_admin` authorisation, and short-lived caching.
2. [ ] Aggregate organisations, users, roles, and last-login data from Keycloak, handling partial Keycloak failures gracefully.
3. [ ] Build `frontend/react/src/pages/admin/organisations/index.jsx` with table, expandable user rows, search, CSV export, and the expected loading/empty/error states.
4. [ ] Add the `/admin/organisations` route and a `global_admin` nav entry.
5. [ ] Document the realm login-event prerequisite in `docs/multi-tenancy-keycloak-setup.md`.
6. [ ] Emit the overview-read audit event using the list-view convention.
7. [ ] Add the listed backend and frontend tests; confirm `mvn -pl userservice test` and the relevant Vitest run are green.
8. [ ] Verify admin access, non-admin redirect, search, expansion, CSV export, and last-login display locally.

## Local verification
- Log in as `global_admin` and confirm the overview table loads with expandable rows.
- Confirm `lastLogin` shows a timestamp when realm events exist and `Never` otherwise.
- Log in as a non-admin and confirm redirection away from `/admin/organisations`.
- Export CSV and validate the generated rows.
- Backend and frontend tests for this stage pass locally.

## Exit criteria
- `global_admin` has a workable overview of newly created organisations and their users.
- The page behaves safely when Keycloak event data is absent or partially failing.
- New backend and frontend tests for this stage pass.

## Dependencies and notes
- **Prerequisite (operational):** Keycloak realm login-event logging must be enabled per tenant before this stage's UI is exposed (`Realm Settings → Events → Login events enabled`, retention ≥ 30 days). Without it, every `lastLogin` shows "Never". This is manual Admin-UI configuration in each Keycloak realm — it cannot be inferred from code. Document this in `docs/multi-tenancy-keycloak-setup.md` (step 5 of the checklist) so future tenant provisioning includes it.
- Requires Stage 01 because the endpoint lives in `userservice`.
- Works best once Stages 02–05 have established real organisation/user data and audit conventions.
