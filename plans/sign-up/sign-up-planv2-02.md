# Sign-Up Feature — Stage 02: public registration backend

## Objective
Implement the backend-only self-serve registration flow so it can be exercised by REST calls before any public UI is added.

## Scope from `sign-up-planv2.md`
- Original Stage 2.
- Schema, token, and mail prerequisites from Original Stage 3 that are required for registration to work.
- Registration-specific audit emission from Original Stage 5.

## Deliverables
- `POST /.rest/accounts/registration`.
- `email_verification_token` schema and persistence model.
- Token hashing, mail sending, captcha stub, and rate-limiting primitives.
- Compensation logic for partial-failure cases.
- **Feature flag `accounts.registration.enabled` (default `false`) gating the public endpoint.** When false the endpoint returns `503 { code: "REGISTRATION_DISABLED" }`. Stage 04 flips it to `true` once the UI is wired. Without this gate the endpoint is reachable through the Cloudflare tunnel as soon as Stage 01 deploys, and anyone with curl can spam real Organisation + Keycloak user creation in production.
- Unit tests for `RegistrationController`, `KeycloakAdminClient` (new methods added in this stage), `EmailSender`, `RateLimitFilter`, `CaptchaVerifier` stub, `TokenHasher`, `EmailVerificationTokenRepo`. `mvn -pl userservice test` must be green at stage exit.

## Step checklist
1. [ ] Add `email_verification_token` to `core-tables-backup.sql` and the `slinkylinky` section of `schema-migration.sql`.
2. [ ] Create the token entity/repo, token hasher, email sender/template, captcha verifier interface, and registration rate-limit support.
3. [ ] Implement registration request validation, slug generation, duplicate-email handling, and rate-limit responses.
4. [ ] Insert the organisation, create the Keycloak user, assign `tenant_admin`, persist the hashed verification token, and send the verification email.
5. [ ] Apply the full compensation matrix for failures after organisation creation.
6. [ ] Emit best-effort audit events for organisation creation and user registration.
7. [ ] Implement the `accounts.registration.enabled` flag check; default `false`. Verify locally that the endpoint returns 503 when disabled and 201 when enabled via `application-local.properties` override.
8. [ ] Add unit tests for every new class introduced in this stage (see Deliverables). Run `mvn -pl userservice test` and confirm green.
9. [ ] Drive the endpoint locally with REST calls and verify DB, Keycloak, and email side effects.

## Local verification
- Run `POST /.rest/accounts/registration` with valid and invalid payloads.
- Confirm a new organisation row exists, the Keycloak user is created with `emailVerified=false`, and the saved token is hashed only.
- Force at least one failure path locally and verify the expected rollback/disable behaviour.
- With `accounts.registration.enabled=false`, confirm the endpoint returns 503 even with a valid payload; flip to `true` and confirm 201.
- `mvn -pl userservice test` is green.

## Exit criteria
- Registration works end-to-end from a REST client when the flag is on.
- Duplicate email, validation, rate-limit, and compensation paths are all understood and testable.
- Endpoint is unreachable in production until Stage 04 enables the flag (default off in `values.yaml`).
- The feature remains UI-hidden until Stage 04.
- Unit tests for all new classes pass locally.

## Dependencies and notes
- Requires Stage 01 to be complete.
- Keep the captcha contract as a stub so a real provider can be plugged in later without controller changes.
