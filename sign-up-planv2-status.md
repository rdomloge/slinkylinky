# Sign-Up Plan Status

## Overall status
- Source plan: `sign-up-planv2.md`
- Breakdown request: `sign-up-plan-prompt.md`
- Current stage: Stage 06 — global-admin organisations overview
- Next stage: Stage 07 — integration test and coverage wiring
- Current step in active stage: complete
- Last updated: 2026-04-27 (Stage 06 complete; 4 backend + 6 frontend tests green)

## Stage tracker
| Stage | File | Title | Status | Notes |
|---|---|---|---|---|
| 01 | `sign-up-planv2-01.md` | userservice foundation and route split | DONE | Foundation stage complete. |
| 02 | `sign-up-planv2-02.md` | public registration backend | DONE | All deliverables shipped; 26 tests green. |
| 03 | `sign-up-planv2-03.md` | email verification and verified-only access | DONE | All deliverables shipped; 37 userservice tests + 24 sl-common tests green. |
| 04 | `sign-up-planv2-04.md` | public registration UI | DONE | All deliverables shipped; 25 frontend tests green. |
| 05 | `sign-up-planv2-05.md` | audit coverage and access cleanup | DONE | All deliverables shipped; 27 frontend tests green. |
| 06 | `sign-up-planv2-06.md` | global-admin organisations overview | DONE | All deliverables shipped; 4 backend + 6 frontend tests green. |
| 07 | `sign-up-planv2-07.md` | integration test and coverage wiring | PENDING | Not started. |
| 08 | `sign-up-planv2-08.md` | CI/CD and deployment wiring | PENDING | Helm values block done; Dockerfile, Helm template, Jenkinsfile not yet done. |

## Stage 03 deliverables (all shipped)
- [x] `KeycloakAdminClient` extended with `setEmailVerified(userId, verified)` and `getUserByEmail(email)`
- [x] `VerifyEmailController` — `GET /.rest/accounts/verify-email?token=...` (public)
  - SHA-256 token hash lookup; 400 `INVALID_OR_EXPIRED` if not found/expired/used
  - Keycloak `setEmailVerified=true` (returns 503 if Keycloak fails)
  - Token marked `used=true` after Keycloak success
  - Best-effort audit event `"email verified"`
- [x] `ResendVerificationController` — two endpoints:
  - `POST /.rest/accounts/resend-verification` (auth required, exempt from EmailVerifiedFilter)
    - Reads userId/email/orgId from JWT; rate-limits 3/hr per userId
    - Invalidates old tokens; generates new; sends email; emits audit
  - `POST /.rest/accounts/resend-verification/public` (public, enumeration-safe → always 200)
    - Rate-limits 3/hr per IP + 3/hr per email; Keycloak lookup; only sends if unverified
- [x] `TokenCleanupService` — `@Scheduled(cron = "0 0 3 * * *")` cleans used/30-day-old tokens
- [x] `@EnableScheduling` added to `UserServiceApplication`
- [x] `EmailVerifiedFilter` in `sl-common` — `OncePerRequestFilter`, reads `email_verified` JWT claim, 403 `EMAIL_NOT_VERIFIED` if false/missing
- [x] `EmailVerifiedFilter` registered in `userservice` SecurityConfig (exempt: registration, verify-email, resend public + auth)
- [x] `EmailVerifiedFilter` registered in `linkservice` SecurityConfig
- [x] `EmailVerifiedFilter` registered in `stats` SecurityConfig
- [x] `EmailVerifiedFilter` registered in `audit` SecurityConfig
- [x] `EmailVerifiedFilter` registered in `supplierengagement` SecurityConfig
- [x] `RateLimitFilter.resolveClientIp` made `public` (needed by ResendVerificationController)
- [x] `AuthProvider.jsx` — `user.emailVerified` derived from JWT `email_verified` claim
- [x] `Layout.jsx` — verification-pending branch (4th render branch: isAuthenticated && !emailVerified)
  - Shows email, Resend button (with rate-limit-safe UX), Sign out link
  - Registered-toast on `?registered=true` query param (cleared via history.replaceState)
  - "Create an account" link on unauthenticated branch
- [x] `pages/verify-email/index.jsx` — public page (loading / success / invalid / error states)
- [x] `/verify-email` route added to `App.jsx`
- [x] Unit tests — 11 new userservice tests (37 total green), 6 new sl-common tests (24 total green):
  - `VerifyEmailControllerTest` (4) — happy path, token not found, Keycloak fails, audit emitted
  - `ResendVerificationControllerTest` (7) — auth happy path, no JWT, email-fail non-fatal, public unknown/verified/unverified, blank email
  - `EmailVerifiedFilterTest` (6) — verified passes, unverified 403, missing claim 403, whitelisted path bypasses, unauthenticated passes

## Stage 06 deliverables (all shipped)
- [x] `KeycloakAdminClient.getUserRealmRoles(userId)` — fetches realm roles from `/admin/realms/{realm}/users/{userId}/role-mappings/realm`
- [x] `KeycloakAdminClient.getLastLoginTime(userId)` — fetches most recent LOGIN event, extracts Unix ms timestamp, converts to LocalDateTime
- [x] `UserOverviewDto` — Java record (userId, email, firstName, lastName, emailVerified, roles, lastLogin)
- [x] `OrgOverviewDto` — Java record (orgId, orgName, orgSlug, createdAt, users)
- [x] `OrganisationsOverviewController` — `GET /.rest/accounts/admin/organisations-overview`, global_admin gate, 60-sec volatile cache, audit event `"list organisations overview"`
- [x] `OrganisationsOverviewControllerTest` — 4 tests (non-admin 403, happy path, roles fetch fail, events fetch fail)
- [x] `pages/admin/organisations/index.jsx` — global_admin page with role guard, org table, expandable user rows, search filter, CSV export
- [x] `pages/admin/organisations/index.test.jsx` — 6 tests (non-admin redirect, org table, row expansion, search, CSV, null lastLogin)
- [x] `App.jsx` — added route `/admin/organisations` with `AdminOrganisationsIndex` component
- [x] `Menu.jsx` — added nav item `Org Overview` with `adminOnly: true`, added ENTITY_COLORS entry
- [x] `audit/CLAUDE.md` — added `"list organisations overview"` to established `what` values
- [x] `docs/multi-tenancy-keycloak-setup.md` — added Step 8 (enable realm login events), updated per-tenant onboarding checklist

## Stage 05 deliverables (all shipped)
- [x] `audit/CLAUDE.md` — unauthenticated `who` rule added; `"register user"`, `"email verified"`, `"send verification email"` added to established `what` values
- [x] Audit events conform to updated conventions (no code changes needed; they already match)
- [x] `frontend/react/src/components/TenantBadge.jsx` — simplified to return null for non-global_admin users; removed org-fetch dead code
- [x] `frontend/react/src/auth/TenantOverrideContext.jsx` — added `useEffect` to clear `sl_tenant_override` for non-admin users on mount
- [x] `frontend/react/src/auth/TenantOverrideContext.test.jsx` — 2 new Vitest tests covering both admin/non-admin branches

## Stage 04 deliverables (code complete, tests complete)
- [x] `pages/register/index.jsx` — public registration page (light theme, all 6 fields, client-side validation, server-error handling, spinner)
- [x] `/register` route added to `App.jsx`
- [x] `pages/verify-email/index.jsx` — public verify-email landing page (shipped in Stage 03 but routed here)
- [x] `/verify-email` route added to `App.jsx` (shipped in Stage 03)
- [x] `Layout.jsx` — "Create an account" link in unauthenticated branch
- [x] `Layout.jsx` — registered toast on `?registered=true` (strips param via history.replaceState)
- [x] `Layout.jsx` — verification-pending branch (shipped in Stage 03 but listed here for completeness)
- [x] `values.yaml` — `accounts_registration_enabled: "true"` (production flag on)
- [x] `vitest.config.js` + `vitest.setup.js` — test harness wired
- [x] Vitest tests for `pages/register/index.jsx` — 25 tests green (fixed: `noValidate` on form, "Organisation name" → "Company name" in tests, added missing firstName/lastName to spinner test)
- [ ] Browser smoke-test of happy path and error states (deferred — skipped per plan; backend not running locally)

## Pre-flight note (manual operational step — before enabling EmailVerifiedFilter in production)
- Before deploying Stage 03 to any environment with existing users, run the following Keycloak admin check and bulk-update:
  `GET /admin/realms/{realm}/users?max=500` — check that all users have `emailVerified: true`.
  If any are `false`, bulk-set via `PUT /admin/realms/{realm}/users/{id}` with `{ "emailVerified": true }`.
  Only proceed with EmailVerifiedFilter deployment once all pre-existing users are verified.

## Issues and diversions (cumulative)
- **Audit-event emission** relocated from Stage 05 into the stages that own each flow: registration audit in Stage 02, verify/resend audit in Stage 03, overview-read audit in Stage 06.
- **Per-component unit tests** dissolved from Stage 07 into feature stages.
- **Feature flag `accounts.registration.enabled`** (default `false`) added in Stage 02.
- **Stage 03 pre-flight Keycloak audit step** before `EmailVerifiedFilter` rolls out.
- **Stage 06's Keycloak realm-event prerequisite** is a manual Admin-UI config step.
- **Stage 08 includes index-doc regeneration** (`node scripts/gen-docs.js`).
- **Schema**: `email_verification_token` lives in `userservice-schema-backup.sql` (userservice DB), not `core-tables-backup.sql`. Both the backup and migration files were already correctly populated before Stage 02 execution.
- **`EmailVerificationToken` entity** uses `VARCHAR(64)` (not CHAR) in the JPA `@Column` to avoid CHAR padding issues in H2 tests; production PostgreSQL schema uses `CHAR(64)` which is compatible.
- **`RateLimitFilter.resolveClientIp`** made `public` in Stage 03 so `ResendVerificationController` can reuse the X-Forwarded-For logic.

## Completed planning work
- Created eight stage files: `sign-up-planv2-01.md` through `sign-up-planv2-08.md`.
- Preserved the dependency flow from the source plan while grouping related work into increments that can be implemented and tested independently.
