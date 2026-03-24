# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SlinkyLinky is a link management and supplier engagement platform. It is a full-stack monorepo with a React frontend and multiple Java Spring Boot microservices communicating via RabbitMQ, backed by PostgreSQL, and authenticated through Keycloak (OAuth2/OIDC).

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

## Environment Variables

Backend services expect these env vars (not in application.properties defaults):
- `spring_datasource_url`, `spring_datasource_username`, `spring_datasource_password`
- `chatgpt_api_key`, `chatgpt_model`
- `slinkylinky_rabbitmq_host`, `slinkylinky_vhost`
- `ISSUER_URI`, `JWK_SET_URI` (Keycloak OAuth2)

Frontend expects (in `.env`):
- `BACKEND_HOST` (defaults to `localhost`)
- `VITE_KEYCLOAK_URL`, `VITE_KEYCLOAK_REALM`, `VITE_KEYCLOAK_CLIENT_ID`
