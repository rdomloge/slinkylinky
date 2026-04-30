# Sign-Up Feature — Plan v2

## Context

SlinkyLinky has no public registration path; a new tenant is created manually by a `global_admin`. The goal is **public self-serve sign-up**: a visitor enters company name, name, email, password; the system creates a new `Organisation` in the shared deployment and provisions them as `tenant_admin` in Keycloak — no new K8s namespace, Cloudflare tunnel, or Keycloak realm per tenant.

This plan supersedes `sign-up-plan.md` and addresses the valid points from `sign-up-plan-critique.md`. Three decisions are locked in:

- **Registration model:** fully public self-serve — so real anti-abuse controls are mandatory, not optional.
- **Email-verified enforcement:** app-side (Keycloak issues a JWT with `email_verified=false`; frontend shows a verification-pending screen; a shared backend filter blocks protected calls).
- **URL prefix:** `/.rest/accounts` (not `/.rest/users` — decouples URL from service name).

### What v1 got right, and is kept

- Extract user/org management into a new `userservice` at port **8095**.
- `userservice` has its own dedicated database. `linkservice` uses `organisation_id` from the JWT (`org_id` claim) for tenant filtering — it does not store or query Organisation data.
- Remove the `TenantBadge` org-display for non-`global_admin` users (Stage 6), plus guard `sl_tenant_override` against non-admins.
- `org_id` JWT wiring: already exists as a manual Keycloak client-scope + protocol-mapper on `sl-webapp` (`docs/multi-tenancy-keycloak-setup.md:13-30`). Setting `attributes.org_id = [orgId]` on the Keycloak user at creation time is sufficient — no Keycloak changes needed for the claim itself.

### What v1 got wrong, and why

- **Schema placement.** v1 put `email_verification_token` in `supplierengagement-schema-backup.sql`. `userservice` uses the `slinkylinky` DB, so it belongs in `core-tables-backup.sql` + the `slinkylinky` section of `schema-migration.sql`.
- **Maven aggregator.** `userservice` must be added to the root `pom.xml` `<modules>` (currently `events, sl-common, linkservice, stats, audit, woocommerce, supplierengagement`).
- **Mail config key casing.** v1 used `MAIL_HOST`; repo convention is lowercase (`mail_host`, `mail_username`, `mail_password`) — per `supplierengagement/application.properties:25-37`.
- **Login-page design contradiction.** v1 said "dark background"; the actual login surface at `Layout.jsx:239` is a light `#fafbfc → #efefef` gradient. Registration page matches the actual light design.
- **Plaintext token at rest.** v1 stored the raw UUID as PK. v2 stores only the SHA-256 hash; the raw token lives only in the email link and the user's inbox.
- **Compensation.** v1 handled one failure case. v2 has a full failure matrix.
- **Single-service `EmailVerifiedFilter`.** v1 only put it in `userservice` + `linkservice`. v2 puts it in `sl-common` (where `TenantFilter` already lives) so every protected service picks it up consistently.
- **`/.rest/users` prefix.** Replaced with `/.rest/accounts`.
- **`TenantBadge` Stage-1 path update.** Redundant — Stage 6 removes that render branch entirely. Dropped.
- **Open-tenant-provisioning handwave.** Ships with concrete anti-abuse controls, not "add later".

### What both docs missed

- **`org_id` claim propagation** is already wired (see above).
- **Mail infrastructure already exists** in `supplierengagement` (SES via `spring-boot-starter-mail`, `EmailSender`/`EmailBuilder` with FreeMarker). v2 copies that pattern into `userservice`.
- **`sl-common` is the natural home for cross-service filters.** `TenantContext` and `TenantFilter` already live there; `EmailVerifiedFilter` joins them.

---

## Stage 1 — New `userservice` Spring Boot module

**Create** `userservice/` mirroring `audit/` or `stats/`:

- Spring Boot 3.x, Java 17, port **8095**.
- Depends on `events`, `sl-common`, `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `spring-boot-starter-security`, `spring-boot-starter-oauth2-resource-server`, `spring-boot-starter-mail`, `spring-boot-starter-amqp`, `spring-boot-starter-freemarker`, `postgresql`, `org.keycloak:keycloak-admin-client`, `com.bucket4j:bucket4j-core:8.10.1`.
- `application.properties` uses the same env-var placeholder style as other services (`${spring_datasource_url}`, `${ISSUER_URI}`, `${mail_host}`, etc.).

**Move from `linkservice` into `userservice`:**

- `keycloak/KeycloakAdminClient.java`
- `controller/KeycloakUserController.java` → remounted at `/.rest/accounts/keycloak-users`
- `controller/OrganisationController.java` → remounted at `/.rest/accounts/organisations`
- `entity/Organisation.java` + `repo/OrganisationRepo.java`
- Relevant `SecurityConfig` pieces + Keycloak-admin bean wiring

**Register `userservice` in:**

- Root `pom.xml` — add `<module>userservice</module>`.
- `vite.config.js` — proxy `/.rest/accounts` → `http://${BACKEND_HOST}:8095`.
- `sl-k8s-scripts/jenkins-k8s-setup/helm/values.yaml` — new entry: image name, port 8095, datasource secret bindings, Keycloak JWT env, RabbitMQ env, mail env, probes — mirror the `audit-service` block.
- `sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile` — in the Cloudflare Tunnel ingress stage (~L211–293), add path rule `/.rest/accounts/*` → `userservice-service:8095` **before** the `/.rest/*` → `linkservice-service` catch-all.
- `.vscode/launch.json` — new launch config with all env vars.

**Frontend API call updates:**

- `pages/organisations/index.jsx`: `/.rest/organisations` → `/.rest/accounts/organisations`.
- `pages/users/index.jsx`: `/.rest/keycloak/users` → `/.rest/accounts/keycloak-users`.
- Skip `TenantBadge.jsx` — Stage 6 removes the render branch.

---

## Stage 2 — Registration endpoint (`userservice`)

**Endpoint:** `POST /.rest/accounts/registration` — public (whitelisted in `userservice` `SecurityConfig`).

**Request:** `{ firstName, lastName, email, password, companyName }`.

**Server-side validation** (HTTP 400 with field-keyed error map):

- All fields required, trimmed, non-blank.
- `companyName`: 2–120 chars.
- `firstName`, `lastName`: 1–80 chars.
- `email`: normalise lowercase, length ≤ 254, `jakarta.validation.constraints.Email` plus a length-bounded regex.
- `password`: delegate strength to Keycloak policy; userservice enforces only `length ≥ 8` pre-flight to avoid wasting a Keycloak round-trip. Keycloak password-policy errors from user creation are surfaced as `{ field: "password", message: <keycloak message> }`.

**Anti-abuse (mandatory for public self-serve):**

- **Per-IP rate limit:** Bucket4j in-memory, 5 registrations per hour per client IP, resolved from `X-Forwarded-For` (last entry — Cloudflare sets this). 429 on exceed.
- **Per-email rate limit:** same bucket config keyed by normalised email.
- **Global bucket:** 200 per hour across all clients. Defensive cap.
- **Captcha:** deferred — stubbed `CaptchaVerifier.verify(token)` interface in place from day 1 so we can drop in hCaptcha later without touching controller code.
- **No disposable-email blocklist in v1** — flagged as follow-up.

**Registration flow** (controller orchestrates; no `@Transactional` because Keycloak is external):

1. Validate input → 400 on failure.
2. Rate-limit check → 429 on exceed.
3. Slugify `companyName` (lowercase, `[^a-z0-9]+` → `-`, trim `-`, default `org`).
4. **Insert `Organisation`** via native `INSERT ... ON CONFLICT (slug) DO NOTHING`; if 0 rows affected, retry with `-2`, `-3`, … up to 10 times, then 503. DB unique constraint is authoritative — no `existsBySlug()` pre-check.
5. **Create Keycloak user** (`emailVerified: false`, `enabled: true`, `attributes: { org_id: [orgId] }`, `credentials: [{ type: password, value, temporary: false }]`).
6. **Assign `tenant_admin` realm role** to the new Keycloak user.
7. **Generate token:** 32 random bytes via `SecureRandom`, Base64url → `rawToken`; SHA-256 → `hashedToken`. Save `EmailVerificationToken(hashedToken, userId, email, orgId, expiresAt = now+24h, used=false, createdAt=now)`.
8. **Send verification email** with link `${slinkylinky_domain}/verify-email?token=${rawToken}` via `JavaMailSender` + FreeMarker template (copy pattern from `supplierengagement/email/EmailSender.java`).
9. **Emit audit events** (Stage 5).
10. Return `201 { message: "Account created. Please check your email to verify before signing in." }`.

**Failure matrix (compensating actions):**

| Failure at step | Compensation |
|---|---|
| 4 (Org insert) | Nothing to undo. Return 503. |
| 5 (Keycloak create user) | Delete `Organisation` row. Return 503. |
| 6 (role assign) | `keycloakAdminClient.disableUser(newUserId)` (mirrors `linkservice/KeycloakUserController.java:106-116`); delete `Organisation`. Return 503. |
| 7 (token save) | Disable Keycloak user; delete `Organisation`. Return 503. |
| 8 (email send) | Token row stays; user can call `/resend-verification/public`. Organisation + Keycloak user stay. Log at ERROR. Return 201. Retrying email is cheaper than unwinding a successful create. |
| 9 (audit emit) | Best-effort; log WARN and continue. |

**Conflict responses:**

- Keycloak 409 on duplicate email → `409 { code: "EMAIL_EXISTS", message: "An account with this email already exists." }`. Account-enumeration risk accepted for UX clarity.
- Slug collision after 10 retries → `503 { code: "SLUG_EXHAUSTED" }`. Distinct from duplicate email.

---

## Stage 3 — Email verification (userservice-owned)

**Schema** — add to the userservice DB schema file (separate from `core-tables-backup.sql` which belongs to the slinkylinky/linkservice DB) and add an idempotent migration for existing deployments:

```sql
CREATE TABLE IF NOT EXISTS email_verification_token (
    token_hash   CHAR(64)    PRIMARY KEY,
    user_id      VARCHAR(255) NOT NULL,
    email        VARCHAR(254) NOT NULL,
    org_id       UUID        NOT NULL,
    expires_at   TIMESTAMP   NOT NULL,
    used         BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_evt_user_id ON email_verification_token(user_id);
CREATE INDEX IF NOT EXISTS idx_evt_expires_at ON email_verification_token(expires_at);
```

**Verify endpoint:** `GET /.rest/accounts/verify-email?token={raw}` — public.

1. SHA-256 incoming `token`.
2. Look up by `token_hash`. If not found, expired, or used → 400 `{ code: "INVALID_OR_EXPIRED" }`.
3. `PUT /admin/realms/{realm}/users/{userId}` with `{ emailVerified: true }`.
4. Mark row `used=true`.
5. Emit audit `"email verified"`.
6. Return 200.

**Authenticated resend:** `POST /.rest/accounts/resend-verification` — auth required, exempt from `EmailVerifiedFilter`.

1. Read `userId`, `email`, `org_id` from JWT.
2. Invalidate prior unused tokens for this `userId`.
3. Generate + save new token; send email.
4. Rate-limit: 3/hour per `userId`.
5. Audit `"send verification email"`.

**Public resend (recovery path):** `POST /.rest/accounts/resend-verification/public` with `{ email }`.

1. Rate-limit 3/hour per IP + 3/hour per email.
2. Look up Keycloak user by email. **Always return 200** (avoids enumeration).
3. If user exists and is unverified → generate + send token.
4. Audit only when an email is actually sent.

**`EmailVerifiedFilter`** — new filter in `sl-common` alongside `TenantFilter`:

- Reads JWT `email_verified` claim.
- `true` → pass through.
- `false` or missing → 403 `{ code: "EMAIL_NOT_VERIFIED" }`.
- Each service's `SecurityConfig` registers it after the JWT auth filter and whitelists health/actuator + service-specific public paths.
- Services to update: `userservice`, `linkservice`, `stats`, `audit`, `supplierengagement`. `woocommerce` is IP-gated and excluded.

**Token cleanup** — `@Scheduled(cron = "0 0 3 * * *")` in `userservice` deletes rows where `used=true OR expires_at < now() - interval '30 days'`.

**Frontend:**

- New public route `<Route path="/verify-email" element={<VerifyEmail />} />` in `App.jsx`. Calls `GET /.rest/accounts/verify-email?token=…` on mount.
- `AuthProvider.jsx`: decode and expose `user.emailVerified` from JWT `email_verified` claim.
- `Layout.jsx`: fourth render branch — `isAuthenticated && !user.emailVerified` → verification-pending screen with Resend + Sign out.

---

## Stage 4 — Registration UI

**New file** `frontend/react/src/pages/register/index.jsx`:

- Standalone page (no `Layout` wrapper), same pattern as `auth/Callback.jsx`.
- **Light theme** matching `Layout.jsx:239` (gradient `#fafbfc → #f5f5f5 → #efefef`, `ConnectionNodes`, pastel drift nodes, `Space Grotesk`).
- Fields: Company Name, First Name, Last Name, Email, Password, Confirm Password.
- Client-side validation: all required, email regex, passwords match, password ≥ 8 chars.
- Submit → `POST /.rest/accounts/registration`; success → `/?registered=true`.
- 409 `EMAIL_EXISTS` → inline "An account with this email already exists." + sign-in link.
- 429 → inline "Too many attempts. Please try again in an hour."
- Footer: "Already have an account? Sign in" → `href="/"`.

**`App.jsx`:** add `<Route path="/register" element={<Register />} />` before protected routes.

**`Layout.jsx` (unauthenticated branch):**

- "Create an account" link below "Sign in with SSO".
- On mount: if `?registered=true` → `useToast()` shows "Account created — check your email to verify before signing in.", `history.replaceState` strips the param.

---

## Stage 5 — Audit events

| Trigger | `what` | `entityType` | `entityId` | `who` | `organisationId` | `detail` |
|---|---|---|---|---|---|---|
| Org created during registration | `"create organisation <name>"` | `Organisation` | `orgId` | registrant email | `orgId` | `objectMapper.writeValueAsString(savedOrg)` |
| User created during registration | `"register user"` | `User` | Keycloak `newUserId` | registrant email | `orgId` | `{ email, firstName, lastName, orgId }` — **never password** |
| Email verified | `"email verified"` | `User` | `token.userId` | `token.email` | `token.orgId` | `{ userId, email }` |
| Resend (auth) | `"send verification email"` | `User` | JWT `sub` | `TenantContext.getUsername()` | `TenantContext.getOrganisationId()` | `{ userId }` |
| Resend (public) | `"send verification email"` | `User` | resolved `userId` | `email` submitted | resolved `orgId` | `{ userId, source: "public" }` |

**`who` for unauthenticated flows — explicit standard change:**

Update `audit/CLAUDE.md` with a new rule:

> For **unauthenticated public endpoints** (registration, public-resend-verification, public-verify-email), set `who` to the submitted email. This is the actor — and in the registration case, the Keycloak user about to be created has exactly this email. The audit validator's non-blank `who` rule is still satisfied.

Add the new `what` values:

- `"register user"` (distinct from admin `"create user"`)
- `"email verified"`
- `"send verification email"`

Audit emission is best-effort; RabbitMQ failure logs WARN and returns success.

---

## Stage 6 — Remove org-picker for non-global-admin users

- **`TenantBadge.jsx`**: return `null` for non-`global_admin`. `TenantSwitcher` unchanged.
- **`TenantOverrideContext.jsx`**: on mount, if `!user.roles.includes('global_admin')`, remove `sl_tenant_override` from sessionStorage.

---

## Stage 7 — Global-admin Organisations Overview page

**Why:** once sign-up is open, `global_admin` needs a single view to see what was created, who the admins are, and whether they're actually using it.

**Route:** `/admin/organisations` — new page, `global_admin`-only (redirect to `/` otherwise).

**Page** (`frontend/react/src/pages/admin/organisations/index.jsx`):

- Table of Organisations with columns: **Name**, **Slug**, **Created At**, **# Users**, **# Verified**, **Last Activity**, **Actions** (expand).
- Click a row → expands to a nested table of that org's users: **Email**, **First Name**, **Last Name**, **Roles** (badges), **Email Verified** (✓/⚠), **Last Login** (or "Never"), **Keycloak Status** (enabled/disabled).
- Search box (client-side filter on name/slug/user email).
- Export CSV button (client-side, generated from loaded data).
- Loading skeleton, empty state, error state — follow existing `pages/organisations/index.jsx` patterns.
- Style matches the existing admin pages (reuse `components/` for tables, badges, expandable rows — check for `DataTable`/`ExpandableRow` first, build nothing new unless needed per CLAUDE.md guideline).

**Backend endpoint:** `GET /.rest/accounts/admin/organisations-overview` — `global_admin` only.

Response:
```json
[
  {
    "id": "<uuid>",
    "name": "Acme",
    "slug": "acme",
    "createdAt": "2026-...",
    "users": [
      {
        "userId": "<keycloak sub>",
        "email": "a@acme.com",
        "firstName": "...",
        "lastName": "...",
        "roles": ["tenant_admin"],
        "emailVerified": true,
        "enabled": true,
        "lastLogin": "2026-04-20T10:15:00Z"
      }
    ]
  }
]
```

**Implementation:**

- Controller iterates all `Organisation`s; for each, calls `keycloakAdminClient.listUsersByOrgId(orgId)` (already exists in `linkservice`, moved to `userservice` per Stage 1).
- For each user, fetch roles via Keycloak admin API.
- `lastLogin` comes from **Keycloak realm events**: `GET /admin/realms/{realm}/events?client={clientId}&type=LOGIN&user={userId}&max=1`. If no event (events disabled or user never logged in) → `lastLogin = null`.
- **Prerequisite:** Keycloak realm must have event logging enabled (`Events → Login events enabled`, retention ≥ 30 days). Add to `docs/multi-tenancy-keycloak-setup.md` as a one-line required step.
- N+1 concern: for M orgs × N users this is O(M×N) Keycloak calls. Acceptable for early-stage with < 100 orgs; parallelise with `CompletableFuture` + bounded thread pool if needed. Cache response in-memory for 60s to soften rapid page reloads.
- Authorisation: `@PreAuthorize("hasRole('global_admin')")`.

**Add "Organisations Overview" to the global-admin nav** in `components/layout/Sidebar.jsx` (or wherever existing admin links live — check first; do not invent a new nav system).

**Audit** (Stage 5 family): reading the overview emits `"view organisations overview"` (`what`), `Organisation` (`entityType`), entityId blank-or-`"*"` per `audit/CLAUDE.md` conventions for list views. Include in the updated `audit/CLAUDE.md` `what` list.

---

## Stage 8 — Unit tests for new code

**Baseline:** every new class in `userservice`, new sl-common class, and new React component ships with unit tests. No test, no merge.

**Backend (JUnit 5 + Mockito + Spring Boot Test, following the pattern of `linkservice`'s existing tests, e.g. `ProposalSupportControllerTest`):**

| Subject | Test class | What it covers |
|---|---|---|
| `RegistrationController` | `RegistrationControllerTest` | Valid request → 201 + org created + Keycloak user created + role assigned + token saved + email sent (mocks). Each failure step (4–8) → correct compensation called. Validation (blank fields, bad email, short password) → 400 with field map. Rate-limit exceeded → 429. Duplicate email (Keycloak 409) → 409 `EMAIL_EXISTS`. Slug collision retry → second slug used. 10 collisions → 503. |
| `VerifyEmailController` | `VerifyEmailControllerTest` | Valid token → 200 + Keycloak update + token marked used + audit fired. Unknown hash → 400. Expired → 400. Already used → 400. Replay → 400. |
| `ResendVerificationController` | `ResendVerificationControllerTest` | Auth path: token invalidation + new token + email. Public path: enumeration safety (200 for unknown email, 200 for verified user, no email sent); 200 + email for unverified existing user. Rate limits. |
| `OrganisationsOverviewController` | `OrganisationsOverviewControllerTest` | Non-admin → 403. Admin → full payload shape. Keycloak error on one user → degrades gracefully (user's row shows null `lastLogin`, rest of data intact). |
| `KeycloakAdminClient` | `KeycloakAdminClientTest` | WireMock-backed. createUser, assignRealmRole, disableUser, getEvents(userId, LOGIN) parse correctly; 4xx/5xx surface as typed exceptions. |
| `EmailSender` (userservice) | `EmailSenderTest` | FreeMarker template renders `${slinkylinky_domain}/verify-email?token=…`. Email subject + from-address from config. Send failure propagates. |
| `RateLimitFilter` | `RateLimitFilterTest` | Per-IP, per-email, global buckets all trigger at their configured thresholds. `X-Forwarded-For` parsing picks the last entry. Missing header falls back to `request.getRemoteAddr()`. |
| `CaptchaVerifier` (stub) | `CaptchaVerifierTest` | Default impl returns true. Interface exists so a real impl can be swapped. |
| `TokenHasher` | `TokenHasherTest` | 32-byte entropy, SHA-256 hex output is 64 chars, stable across calls. |
| `EmailVerificationTokenRepo` | `EmailVerificationTokenRepoTest` | `@DataJpaTest` with H2 — find by hash, expired-filter, cleanup deletion. |
| `EmailVerifiedFilter` (sl-common) | `EmailVerifiedFilterTest` | `email_verified=true` JWT passes; `false` → 403; missing → 403; whitelisted path bypasses. |
| `RegistrationFlowIT` (integration) | — | Spring Boot `@SpringBootTest` with H2 + WireMocked Keycloak + `GreenMail` for SMTP. Full happy path end-to-end. One failure-injection scenario to verify compensation. |

**Frontend (Vitest + React Testing Library, following existing frontend test patterns):**

| Subject | What it covers |
|---|---|
| `pages/register/index.jsx` | Field validation (required, email, passwords match, password ≥ 8); submit → correct POST body; 201 → navigates to `/?registered=true`; 409 → inline error; 429 → inline error; spinner during submit. |
| `pages/verify-email/index.jsx` | On mount, calls verify endpoint with URL token; success state; `INVALID_OR_EXPIRED` state; network error state. |
| `pages/admin/organisations/index.jsx` | Non-admin redirect; admin sees table; row expansion loads user list; CSV export produces expected rows; search filter; "Never" rendered when `lastLogin` null. |
| `Layout.jsx` verification-pending branch | Rendered when `isAuthenticated && !emailVerified`; Resend triggers POST; Sign-out works. |
| `AuthProvider.jsx` | `emailVerified` correctly derived from JWT `email_verified` claim. |
| `TenantOverrideContext.jsx` | Clears `sl_tenant_override` on mount for non-global-admin; leaves it for global_admin. |

**Coverage gate (non-enforcing but reported):** backend new classes ≥ 80% line coverage via JaCoCo (already configured in other services — extend to userservice). Frontend new files ≥ 80% via Vitest coverage. Regressions in coverage are reviewer-gated, not CI-blocking, to avoid deferring genuine work for trivial uncovered lines.

---

## Stage 9 — CI pipeline changes

**Goal:** `userservice` builds, tests, dockerises, and deploys through the same pipeline as the other services with no manual steps.

**Maven aggregator** (already in Stage 1): root `pom.xml` adds `<module>userservice</module>`. A top-level `mvn clean install` now builds, tests, and packages userservice alongside the others.

**Dockerfile:** new `userservice/Dockerfile`. Pattern mirrors `audit/Dockerfile` or `stats/Dockerfile` (multi-stage: `eclipse-temurin:21-jdk` or equivalent for build, `eclipse-temurin:21-jre` for runtime). Copies the shaded JAR, exposes 8095, `ENTRYPOINT java -jar …`. Multi-arch via `docker buildx` consistent with other services (per recent commits to supplierengagement's Dockerfile).

**Helm chart template:** new `sl-k8s-scripts/jenkins-k8s-setup/helm/templates/userservice.yml` — a Deployment + Service manifest mirroring the `audit-service` template. Pulls image name, tag, ports, env, secrets from `values.yaml`.

**values.yaml entry** (already in Stage 1) defines the full shape the template consumes:

```yaml
userservice:
  image: registry/userservice
  tag: <version>
  port: 8095
  env:
    spring_datasource_url: { fromSecret: … }
    spring_datasource_username: { fromSecret: … }
    spring_datasource_password: { fromSecret: … }
    ISSUER_URI: …
    JWK_SET_URI: …
    slinkylinky_rabbitmq_host: …
    slinkylinky_vhost: …
    slinkylinky_rabbitmq_username: { fromSecret: … }
    slinkylinky_rabbitmq_password: { fromSecret: … }
    keycloak_server_url: …
    keycloak_realm: …
    keycloak_admin_client_id: { fromSecret: … }
    keycloak_admin_client_secret: { fromSecret: … }
    mail_host: …
    mail_port: "587"
    mail_username: { fromSecret: … }
    mail_password: { fromSecret: … }
    mail_from: …
    slinkylinky_domain: …
  readinessProbe: { path: /actuator/health/readiness, port: 8095 }
  livenessProbe:  { path: /actuator/health/liveness,  port: 8095 }
```

**Jenkinsfile(s):** two Jenkinsfiles are relevant and both need updating.

1. **Main build Jenkinsfile** (the one that drives `mvn test` / `docker build` / `docker push` for every service — typically at repo root or `jenkins/`). Add:
   - A `Build userservice` stage (runs `./mvnw -pl userservice -am clean package`).
   - A `Test userservice` stage (runs `./mvnw -pl userservice test` + publishes JUnit + JaCoCo reports).
   - A `Docker build + push userservice` stage (multi-arch buildx, tag from `POM_VERSION` or git SHA, matching the pattern of other services).
   - Run backend + frontend test stages **in parallel** where the existing pipeline does so; drop userservice tests into that parallel block.
   - Fail the overall build if userservice tests fail.
2. **Helm deploy Jenkinsfile** (`sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile`):
   - Add `userservice` to the list of services the pipeline expects to deploy (wherever the existing service list is defined).
   - Add the Cloudflare tunnel ingress rule `/.rest/accounts/*` → `userservice-service:8095` in the Setup tunnel routes & DNS stage (~L211–293), inserted **before** the `/.rest/*` → `linkservice-service` catch-all.
   - Ensure secret propagation stage creates/refreshes any new secrets userservice needs (mail creds, Keycloak admin creds if not already mounted).
   - Order: userservice deploys **in parallel with** or **before** linkservice (they share the DB but linkservice no longer reads organisations via API — it reads from DB directly, so order doesn't strictly matter).

**Schema migration in CI:**

- The `email_verification_token` table belongs in the **userservice** DB, not `core-tables-backup.sql` (which is the slinkylinky/linkservice DB). The userservice DB needs its own provisioning step in CI, mirroring how `audit-schema-backup.sql` provisions the audit DB separately. Add a `userservice-schema-backup.sql` and a corresponding idempotent migration script; wire both into the Jenkinsfile new-tenant provisioning stage alongside the other per-service schema files.

**Frontend CI:** existing `npm ci && npm run build` picks up the new routes automatically. Add `npm test` (Vitest) as a pipeline stage if not already present (check the existing frontend pipeline first; do not duplicate).

**Docs regeneration:** after merging, run `node scripts/gen-docs.js` locally or via CI to update `docs/frontend-components.md`, `docs/frontend-pages.md`, `docs/backend-entities.md`, `docs/backend-api.md`. Commit the regenerated docs as part of the same PR or a follow-up.

---

## Critical Files

| File | Stage | Change |
|---|---|---|
| `pom.xml` (root) | 1, 9 | Add `<module>userservice</module>` |
| `userservice/` (new) | 1–5, 7 | New Spring Boot module |
| `userservice/Dockerfile` (new) | 9 | Multi-stage image, mirrors audit/stats |
| `userservice/src/test/**` (new) | 8 | Unit + integration tests per Stage 8 |
| `vite.config.js` | 1 | Proxy `/.rest/accounts` → 8095 |
| `sl-k8s-scripts/jenkins-k8s-setup/helm/templates/userservice.yml` (new) | 9 | K8s Deployment + Service template |
| `sl-k8s-scripts/jenkins-k8s-setup/helm/values.yaml` | 1, 9 | `userservice` block: image, port, env, probes |
| `sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile` | 1, 9 | Cloudflare tunnel rule; service deployment list |
| Main build Jenkinsfile | 9 | Build/test/docker stages for userservice |
| `.vscode/launch.json` | 1 | userservice launch config, full env |
| `pages/organisations/index.jsx` | 1 | API path → `/.rest/accounts/organisations` |
| `pages/users/index.jsx` | 1 | API path → `/.rest/accounts/keycloak-users` |
| `sl-common/src/main/java/.../EmailVerifiedFilter.java` (new) | 3 | JWT `email_verified` gate |
| `sl-common/src/test/.../EmailVerifiedFilterTest.java` (new) | 8 | Filter unit tests |
| `linkservice/.../config/SecurityConfig.java` | 3 | Register `EmailVerifiedFilter` |
| `stats/.../config/SecurityConfig.java` | 3 | Register `EmailVerifiedFilter` |
| `audit/.../SecurityConfig.java` | 3 | Register `EmailVerifiedFilter` |
| `supplierengagement/.../config/SecurityConfig.java` | 3 | Register `EmailVerifiedFilter` |
| `userservice/.../SecurityConfig.java` (new) | 2–3, 7 | Whitelist public paths; exempt resend from `EmailVerifiedFilter`; gate admin overview with `global_admin` |
| `userservice/.../RegistrationController.java` (new) | 2, 5 | Public register + audit |
| `userservice/.../VerifyEmailController.java` (new) | 3, 5 | Verify + audit |
| `userservice/.../ResendVerificationController.java` (new) | 3, 5 | Auth + public resend + audit |
| `userservice/.../OrganisationsOverviewController.java` (new) | 7 | global_admin overview endpoint |
| `userservice/.../RateLimitFilter.java` (new) | 2 | Bucket4j per-IP/per-email/global |
| `userservice/.../CaptchaVerifier.java` (new, stub) | 2 | Pluggable anti-bot hook |
| `userservice/.../email/EmailSender.java` (new) | 2–3 | FreeMarker template, `JavaMailSender` |
| `userservice/.../keycloak/KeycloakAdminClient.java` (moved) | 1–3, 7 | User create, role assign, set `emailVerified`, disable on rollback, list login events |
| `userservice/.../entity/EmailVerificationToken.java` (new) | 3 | JPA entity |
| `userservice/.../entity/Organisation.java` (moved) | 1 | Owned here |
| `sl-k8s-scripts/.../userservice-schema-backup.sql` (new) | 3 | `email_verification_token` table — userservice DB |
| userservice-specific migration script (new) | 3 | Idempotent migration for `email_verification_token` |
| `auth/AuthProvider.jsx` | 3 | Expose `emailVerified` from JWT |
| `components/layout/Layout.jsx` | 3, 4 | Verification-pending branch; "Create an account" link; registered toast; **light theme only** |
| `components/layout/Sidebar.jsx` (or equivalent) | 7 | "Organisations Overview" link for `global_admin` |
| `pages/verify-email/index.jsx` (new) | 3 | Public verification landing |
| `pages/register/index.jsx` (new) | 4 | Public registration, light theme |
| `pages/admin/organisations/index.jsx` (new) | 7 | global_admin overview page |
| `App.jsx` | 4, 7 | Add `/register`, `/verify-email`, `/admin/organisations` routes |
| `components/TenantBadge.jsx` | 6 | Return null for non-global-admin |
| `auth/TenantOverrideContext.jsx` | 6 | Clear stale override for non-global-admin |
| `frontend/react/src/**/__tests__/**` (new) | 8 | Vitest + RTL tests per Stage 8 |
| `audit/CLAUDE.md` | 5, 7 | Unauthenticated-`who` rule + new `what` values |
| `docs/multi-tenancy-keycloak-setup.md` | 7 | Add one-line prerequisite: enable realm login events |

---

## Environment variables (userservice)

Added to `values.yaml` + `.vscode/launch.json`:

- `spring_datasource_url`, `spring_datasource_username`, `spring_datasource_password` — userservice's own database (separate from linkservice; same env var names, different values injected per service in K8s)
- `ISSUER_URI`, `JWK_SET_URI`
- `slinkylinky_rabbitmq_host`, `slinkylinky_vhost`, `slinkylinky_rabbitmq_username`, `slinkylinky_rabbitmq_password`
- `keycloak_server_url`, `keycloak_realm`, `keycloak_admin_client_id`, `keycloak_admin_client_secret`
- `mail_host`, `mail_port`, `mail_username`, `mail_password`, `mail_from`
- `slinkylinky_domain`

---

## Verification

1. `POST /.rest/accounts/registration` (no JWT) with valid body → 201; `organisation` row in DB; Keycloak user with `tenant_admin` role and `org_id` attribute, `emailVerified: false`; verification email received; `email_verification_token` row has only the hashed token.
2. Audit log shows `"create organisation <name>"` and `"register user"` with `who` = submitted email.
3. Click email link → `GET /.rest/accounts/verify-email?token=…` → 200; Keycloak user `emailVerified` true; token row `used=true`; `"email verified"` audit recorded. Re-clicking → 400 `INVALID_OR_EXPIRED`.
4. Signing in before verification → login succeeds; JWT has `email_verified: false`; frontend shows verification-pending screen; calls to `/.rest/organisations` (linkservice), `/.rest/stats/*`, `/.rest/auditrecords`, `/.rest/engagements/*` all return 403 `EMAIL_NOT_VERIFIED`. Resend works.
5. After verification, full app access; `email_verified: true` in next JWT.
6. Public resend: non-existent email → 200 no send; verified email → 200 no send; unverified → 200 + email sent.
7. Rate limits: 6th registration from one IP/hour → 429; 4th resend from one IP/hour → 429.
8. Slug collision: two concurrent signups with identical `companyName` → `acme`, `acme-2`; neither errors.
9. Compensating rollback: force a role-assign failure → Keycloak user disabled, Organisation deleted, 503 to caller, no orphan state.
10. `/register` (light theme) renders without auth; duplicate email → inline 409; success → `/?registered=true` with toast.
11. `tenant_admin` user: no `TenantBadge`; `sl_tenant_override` cleared. `global_admin`: `TenantSwitcher` intact.
12. `/admin/organisations` (global_admin): table of orgs, expandable user rows, `lastLogin` populated from Keycloak events (or "Never"), `emailVerified` rendered ✓/⚠, CSV export works, search filter works. Non-admin → redirected to `/`.
13. Root `mvn clean install` builds `userservice`, runs all its tests, publishes JaCoCo report.
14. Frontend `npm test` runs new Vitest suites green.
15. CI pipeline: full build (backend + frontend + docker + test stages) passes; a failing userservice test fails the pipeline as expected.
16. Cloudflare tunnel (after Jenkins pipeline run for at least one tenant) routes `/.rest/accounts/*` to `userservice-service:8095`; all other paths unchanged.

---

## Deferred / out of scope (named so they're not forgotten)

- hCaptcha integration (stubbed interface in place).
- Disposable-email domain blocklist.
- Terms-of-service / privacy-policy acceptance + GDPR consent capture.
- Billing / paywall gate before Organisation activation.
- Domain-ownership verification (e.g., DNS TXT) for B2B signup.
- Self-service account deletion.
- Pagination on Organisations Overview when > ~100 orgs — current design loads all; pagination + server-side search kicks in then.
- Real-time "Last Activity" (e.g., last API call) — current design uses Keycloak login events only.

These are product decisions, not tech decisions, and belong in a follow-up.
