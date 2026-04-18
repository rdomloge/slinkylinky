# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Reference — Index Files

<!-- GENERATED-DOCS-TABLE:START — managed by scripts/gen-docs.js; do not edit this block manually -->
| File | What it covers |
|------|----------------|
| [`docs/frontend-components.md`](docs/frontend-components.md) | Every React component: file path, props, API calls, sub-components used |
| [`docs/frontend-pages.md`](docs/frontend-pages.md) | Full route table (path → component → file, auth status) and per-page API calls |
| [`docs/backend-entities.md`](docs/backend-entities.md) | All JPA entities with fields and relationships |
| [`docs/backend-api.md`](docs/backend-api.md) | All custom REST endpoints by controller + Spring Data REST auto-exposed resources |
<!-- GENERATED-DOCS-TABLE:END -->

Regenerate after significant structural changes:
```bash
node scripts/gen-docs.js
# or from frontend/react:
npm run gen-docs
```

### Operational & Static Reference

| File | What it covers |
|------|----------------|
| [`docs/supplierengagement-ops.md`](docs/supplierengagement-ops.md) | FlareSolverr resource requirements, timeout config, proxy setup, manual cookie fallback |
| [`docs/multi-tenancy-keycloak-setup.md`](docs/multi-tenancy-keycloak-setup.md) | Keycloak configuration steps for multi-tenancy |

## Project Overview

SlinkyLinky is a link management and supplier engagement platform. It is a full-stack monorepo with a React frontend and multiple Java Spring Boot microservices communicating via RabbitMQ, backed by PostgreSQL, and authenticated through Keycloak (OAuth2/OIDC).

## Domain Model

SlinkyLinky is a "dating agency" for SEO link building — it matches **demand** with **supply**:

- **Organisation**: a tenant — a company using the platform. All data except Suppliers and Categories is scoped to an Organisation.
- **DemandSite**: a customer's website that wants inbound links for SEO
- **Demand**: a monthly work order raised by a DemandSite — think of it as "I need a link this month"
- **Supplier**: a website owner who can place a link on their site — **shared across all tenants** (global resource)
- **PaidLink**: the historical record of a link placed between two domains
- **SupplierTenantExclusion**: per-tenant suppression of a Supplier from matching (does not affect other orgs)

A Demand is matched to a Supplier at most once per DemandSite–Supplier domain pair **within the same Organisation**. Since Google SEO gives no benefit from multiple links between the same two domains, a DemandSite must never be matched to the same Supplier again within its tenant. **PaidLink is the authoritative history that enforces this uniqueness constraint.**

## Multi-Tenancy

SlinkyLinky is being converted from per-deployment single-tenancy to a true shared multi-tenant platform. All work is in branch `feature/multi-tenancy`.

**Role hierarchy** (Keycloak realm roles):

| Role | Description |
|------|-------------|
| `global_admin` | Platform admin / root. Cross-tenant access, Supplier CRUD, global-disable Suppliers, Blacklist, Categories, Orders, tenant creation/switching |
| `tenant_admin` | Admin of their org. Manage users, approve Proposals, exclude Suppliers for their org |
| *(default)* | Tenant operator. Read/create within own org only |

**Supplier visibility model:**
- `supplier.disabled` — set by `global_admin`, hides from ALL tenants' matching
- `SupplierTenantExclusion` — per-tenant hide set by `tenant_admin`; only affects matching for that org
- `BlackListedSupplier` — global, `global_admin`-only, used at Supplier onboarding time (not matching)

See [`docs/multi-tenancy-keycloak-setup.md`](docs/multi-tenancy-keycloak-setup.md) for Keycloak configuration steps.

## Architecture

```
Frontend (React/Vite, port 3000 dev / Nginx port 80 prod)
    │
    ├── /.rest              → linkservice   (port 8090) — core CRUD, proposals, demands
    ├── /.rest/engagements  → supplier-engagement (port 8091)
    ├── /.rest/auditrecords → audit service  (port 8092)
    ├── /.rest/stats        → stats service  (port 8093) — analytics, Moz, Semrush
    ├── /.rest/mozsupport   → stats service  (port 8093)
    ├── /.rest/semrush      → stats service  (port 8093)
    └── /.rest/orders       → orders service (port 8094)

Inter-service communication: RabbitMQ (exchange: slinkylinky.exchange)
Auth: Keycloak (OAuth2/OIDC)
Database: PostgreSQL (DDL managed externally, hibernate ddl-auto=none)
```

The `events/` module is a shared Maven library (v6.1.0) containing event classes used across services for RabbitMQ messaging.

## Monorepo Layout

- `frontend/react/` — React 18 + Vite 5 + Tailwind CSS 3 SPA
- `linkservice/` — Primary Spring Boot 3.5.6 service (Java 17, runs on JDK 21)
- `stats/` — Analytics Spring Boot 3.2.2 service
- `audit/` — Audit Spring Boot service
- `supplierengagement/` — Supplier engagement Spring Boot service
- `woocommerce/` — WooCommerce integration Spring Boot service — **single-customer, original deployment only**; not deployed by the Jenkins/K8s pipeline (no entry in `values.yaml`); secured via IP allowlist at the network level rather than JWT
- `events/` — Shared event POJOs (Lombok), published as Maven artifact
- `sl-k8s-scripts/` — Docker Compose and K8s deployment configs
- Root `pom.xml` — Maven aggregator (modules: events, linkservice, stats)

## Build & Run Commands

### Frontend
```bash
cd frontend/react
npm ci                  # install dependencies
npm run dev             # dev server on port 3000
npm run dev:docker      # dev server using BACKEND_HOST from .env.docker
npm run build           # production build to dist/
```
The Vite config uses `@` as an alias for `/src`. Proxy routes are configured in `vite.config.js`.

## Frontend Component Guidelines

    React components live in `frontend/react/src/components/`. Prefer creating and reusing shared components from this folder over writing inline JSX. Before building
    something new, check whether a suitable component already exists here. If it doesn't quite work as we want, prefer making it dynamic and configurable.

### Backend (individual service)
```bash
cd linkservice
./mvnw clean package                         # build JAR
./mvnw spring-boot:run                       # run locally
./mvnw clean package -Dmaven.test.skip=true  # build skipping tests
```

### Build all Maven modules from root
```bash
mvn clean install
```

### Run tests
```bash
cd linkservice && ./mvnw test          # linkservice unit tests (H2 in-memory DB)
cd stats && ./mvnw test                # stats unit tests
```
Run a single test class:
```bash
cd linkservice && ./mvnw test -Dtest=ProposalSupportControllerTest
```

### Database
```bash
docker compose -f sl-k8s-scripts/docker-compose-postgres.yml up
# PostgreSQL on localhost:5432, user: postgres, password: postgres
```
Schema is managed externally (not by Hibernate). The `slinkylinky` role must own the databases.

## Key Technical Details

- **Spring Data REST**: APIs auto-exposed at `/.rest` base path from JPA repositories
- **Hibernate Envers**: Entity audit history tracked automatically
- **ChatGPT integration**: linkservice calls OpenAI API for content assistance (configured via `chatgpt_*` env vars)
- **Frontend auth**: Keycloak JS integration; JWT tokens decoded client-side with `jwt-decode`
- **Docker builds**: Multi-arch (amd64/arm64) via `docker buildx`; frontend uses multi-stage Node→Nginx build
- **Environment config**: Backend uses Spring property placeholders (`${spring_datasource_url}` etc.); frontend uses Vite env vars (`VITE_*`) — see `.env.example` files

## Frontend Auth Flow (detail)

Auth lives entirely in `frontend/react/src/auth/`:

- **`AuthProvider.jsx`** — React context. Reads tokens from `sessionStorage` on mount (`isLoading = true` while checking), exposes `{ user, accessToken, signIn, signOut, isAuthenticated, isLoading }`. Tokens are stored under keys `sl_access_token`, `sl_refresh_token`, `sl_id_token`. Sets `sl_return_to` before redirecting so the callback can return the user to the page they were on. Sets `sl_just_authenticated` after a fresh login so Layout can play the entry animation.
- **`Callback.jsx`** — handles the `/callback` route; exchanges the OAuth `code` for tokens, calls `loadSession()`, then navigates to `sl_return_to` (default `/`).
- **`Layout.jsx`** — the auth gate for all protected pages. Renders three distinct states: loading spinner (`isLoading`), the full login page (`!isAuthenticated`), or the authenticated app shell. The login page includes the Keycloak redirect animation (portal circle-expand from button) and is self-contained here — there is no separate `/login` route.

## Frontend CSS Animations

All custom keyframe animations are defined in `frontend/react/src/styles/globals.css` and use the `sl-` prefix:

| Keyframe | Used for |
|---|---|
| `sl-fade-up` | Page/element entrance |
| `sl-callback-breathe` | Logo pulse on loading screens |
| `sl-ping-ring` | Expanding ring around logo |
| `sl-loading-dot` | Three-dot bouncing loader |
| `sl-entry-reveal` | Authenticated app shell entry |
| `sl-orb-drift-a/b/c` | Ambient background orbs on login page |
| `sl-toast-progress` | Toast auto-dismiss progress bar |
| `sl-login-progress` | Sweeping progress bar during Collaborator.pro login |

When adding new animations, define them here with the `sl-` prefix.

## Leads / Collaborator.pro Scraper

The Leads page (`pages/leads/index.jsx`) is `global_admin`-only and drives the Collaborator.pro lead-scraping workflow:

1. **Authenticate** — user enters Collaborator.pro credentials in the scrape modal; the frontend POSTs to `/.rest/leads/collaborator/session/login`. The backend drives a real browser login (Playwright/Selenium) which takes several seconds. 2FA is supported via `/.rest/leads/collaborator/session/login/verify`. Manual cookie fallback available via `/.rest/leads/collaborator/session/import`.
2. **Scrape** — once authenticated, POST `/.rest/leads/scrape` with `{ authSessionId, limit }`. Polling every 5s via `/.rest/leads/scrape/status`.
3. **Discover contacts** — per-lead POST `/.rest/leads/{id}/discover`; may queue for browser-based discovery (`BROWSER_QUEUED` status).
4. **Outreach** — POST `/.rest/leads/{id}/sendOutreach` once a contact email is found.
5. **Convert** — POST `/.rest/leads/{id}/convert` to promote an accepted lead to a Supplier.

Key state vars in the page component: `autoLoggingIn`, `submittingTwoFactor`, `scraping`, `collabConnectStatus`, `collabAuthSessionId`.

## Routing: Development vs Production

### Development
Vite's dev server (`vite.config.js`) proxies all backend traffic from `localhost:3000`:
- `/.rest/engagements` → `http://${BACKEND_HOST}:8091` (supplierengagement)
- `/.rest/auditrecords` → `http://${BACKEND_HOST}:8092` (audit)
- `/.rest/stats`, `/mozsupport`, `/semrush` → `http://${BACKEND_HOST}:8093` (stats)
- `/.rest/orders` → `http://${BACKEND_HOST}:8094` (woocommerce)
- `/.rest` → `http://${BACKEND_HOST}:8090` (linkservice)
- `/realms`, `/resources` → `http://10.0.0.12:8100` (Keycloak)

`BACKEND_HOST` defaults to `localhost`; override via `.env` or `.env.docker`.

### Production
Production traffic is routed via **Cloudflare Tunnel** — not Nginx. The `frontend/nginx.conf` is a minimal SPA config only (serves `index.html` for all unmatched routes); it does **not** proxy any backend or Keycloak traffic.

Each tenant gets its own tunnel, created and configured by the **`Setup tunnel routes & DNS`** stage in `sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile`. That stage calls the Cloudflare API to set path-based ingress rules on the single tenant domain `${TENANT}.slinkylinky.uk`:

| Path pattern | Backend service |
|---|---|
| `/realms/*` | `keycloak-service:8100` |
| `/resources/*` | `keycloak-service:8100` |
| `/.rest/stats*` | `stats-service:8093` |
| `/.rest/mozsupport` | `stats-service:8093` |
| `/.rest/semrush` | `stats-service:8093` |
| `/.rest/auditrecords` | `audit-service:8092` |
| `/.rest/engagements/*` | `supplierengagement-service:8091` |
| `/.rest/*` | `linkservice-service:8090` |
| (catch-all) | `adminwebsite-service:80` |

The same Jenkins stage also creates the DNS CNAME record and stores the tunnel token as a K8s secret. To change routing in production, update the Cloudflare ingress config via the API (or re-run the pipeline stage) — **do not** modify `nginx.conf`.

## Environment Variables

Backend services use Spring property placeholders (`${var_name}`) in `application.properties` — the values must be supplied as environment variables at runtime. There are no defaults for these in the properties files.

**How env vars are supplied per environment:**
- **Production (K8s)**: Injected from K8s Secrets and ConfigMaps, defined in `sl-k8s-scripts/jenkins-k8s-setup/helm/values.yaml`
- **Development (local)**: Set in `.vscode/launch.json` under the `"env"` key for each service's launch configuration

Backend services expect these env vars:
- `spring_datasource_url`, `spring_datasource_username`, `spring_datasource_password`
- `chatgpt_api_key`, `chatgpt_model`
- `slinkylinky_rabbitmq_host`, `slinkylinky_vhost`, `slinkylinky_rabbitmq_username`, `slinkylinky_rabbitmq_password`
- `ISSUER_URI`, `JWK_SET_URI` (Keycloak OAuth2)

Frontend expects (in `.env.development` for dev, injected via `window.__CONFIG__` in production):
- `BACKEND_HOST` (defaults to `localhost`)
- `VITE_KEYCLOAK_URL`, `VITE_KEYCLOAK_REALM`, `VITE_KEYCLOAK_CLIENT_ID`

## Database Schema & CI

The Jenkinsfile (`sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile`) loads the schema for each new tenant from these SQL files in `sl-k8s-scripts/jenkins-k8s-setup/helm/`:

| File | Database / owner |
|---|---|
| `slinkylinky-schema-backup.sql` | `slinkylinky` DB — base schema (roles, sequences, etc.) |
| `core-tables-backup.sql` | `slinkylinky` DB — core tables (loaded as `linkservice_user`) |
| `stats-tables-backup.sql` | `stats` DB (loaded as `stats_user`) |
| `audit-schema-backup.sql` | `audit` DB (loaded as `audit_user`) |
| `supplierengagement-schema-backup.sql` | `supplierengagement` DB (loaded as `supplierengagement_user`) |

**Whenever you add or change a column/table/index on a JPA entity, you must also update the corresponding SQL file(s) above** so that new tenant deployments via CI get the correct schema.
