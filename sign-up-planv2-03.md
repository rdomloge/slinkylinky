# Sign-Up Feature — Stage 03: email verification and verified-only access

## Objective
Complete the post-registration lifecycle by adding verification, resend flows, and cross-service blocking for unverified users.

## Scope from `sign-up-planv2.md`
- Original Stage 3.
- Verification/resend audit emission from Original Stage 5.

## Deliverables
- `GET /.rest/accounts/verify-email?token=...`.
- Authenticated and public resend-verification endpoints.
- Shared `EmailVerifiedFilter` in `sl-common`, registered across the protected services.
- Frontend verification-pending state and public verify-email page.
- Pre-flight audit confirming all existing Keycloak users are `emailVerified=true` so the new filter does not lock anyone out.
- Unit tests for `VerifyEmailController`, `ResendVerificationController` (auth + public), `EmailVerifiedFilter` (in `sl-common`). Frontend tests for `pages/verify-email/index.jsx`, `Layout.jsx` verification-pending branch, and `AuthProvider.jsx` `emailVerified` derivation.

## Step checklist
1. [ ] Implement the verify-email endpoint, token lookup, expiry/used checks, Keycloak update, token consumption, and audit event.
2. [ ] Implement authenticated resend and public resend, including enumeration-safe behaviour and rate limits.
3. [ ] Add token cleanup scheduling in `userservice`.
4. [ ] **Pre-flight: audit existing Keycloak users in every realm.** For each user, check `emailVerified`. If any are `false`, bulk-set to `true` via Keycloak Admin API (one-off script using `KeycloakAdminClient`, or `kcadm.sh`). Document the count of users updated. Only proceed to step 5 once this audit shows zero unverified pre-existing users — otherwise registering the filter will 403 those users on every protected call.
5. [ ] Create `EmailVerifiedFilter` in `sl-common` and register it in `userservice`, `linkservice`, `stats`, `audit`, and `supplierengagement` with the correct whitelist paths.
6. [ ] Add the `/verify-email` route/page, expose `emailVerified` in `AuthProvider`, and add the verification-pending branch in `Layout.jsx`.
7. [ ] Add unit tests for every new class introduced in this stage and the listed frontend tests. `mvn -pl userservice test`, `mvn -pl sl-common test`, and the relevant frontend Vitest run must be green.
8. [ ] Verify the before/after behaviour by signing in pre-verification, confirming the `403 EMAIL_NOT_VERIFIED` responses, then re-testing after verification.

## Local verification
- Open a real verification link and confirm the token becomes used and the Keycloak user flips to `emailVerified=true`.
- Re-open the same link and confirm `INVALID_OR_EXPIRED`.
- Sign in before verification and confirm protected APIs return `403 EMAIL_NOT_VERIFIED` while resend still works.
- Sign in after verification and confirm normal app access resumes.
- All listed unit/component tests pass locally.

## Exit criteria
- An unverified user can register, receive/resend email, verify, and then access the rest of the app.
- Verification enforcement is shared across services, not duplicated ad hoc.
- Pre-existing users have been confirmed `emailVerified=true` before `EmailVerifiedFilter` was deployed; no regression for current tenants.
- Unit and component tests for new code pass locally.

## Dependencies and notes
- Requires Stage 02 to be complete.
- `woocommerce` remains excluded from the shared verification filter because it is IP-gated.
