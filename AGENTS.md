# Forge project instructions

## Project Overview

SlinkyLinky is a link management and supplier engagement platform. It is a full-stack monorepo with a React frontend and multiple Java Spring Boot microservices communicating via RabbitMQ, backed by PostgreSQL, and authenticated through Keycloak (OAuth2/OIDC).

## Monorepo Layout

- `frontend/react/` — React 18 + Vite 5 + Tailwind CSS 3 SPA
- `linkservice/` — Primary Spring Boot 3.5.6 service (Java 17, runs on JDK 21)
- `stats/` — Analytics Spring Boot 3.2.2 service
- `audit/` — Audit Spring Boot service
- `supplierengagement/` — Supplier engagement Spring Boot service
- `userservice/` — User registration, email verification, Keycloak admin, organisation management (Spring Boot 3.5.6, port 8095) — **deployed to K8s**; registration feature-flagged (`accounts.registration.enabled=false` by default)
- `woocommerce/` — WooCommerce integration Spring Boot service — **single-customer, original deployment only**; not deployed by the Jenkins/K8s pipeline (no entry in `values.yaml`); secured via IP allowlist at the network level rather than JWT
- `events/` — Shared event POJOs (Lombok), published as Maven artifact
- `sl-common/` — Shared utilities Maven library (v1.0.0); used by userservice
- `sl-k8s-scripts/` — Docker Compose and K8s deployment configs
- Root `pom.xml` — Maven aggregator (modules: events, linkservice, stats, sl-common, userservice)

## Project structure

- Source code is in `[MODULE]/src/main/java`.
- Tests are in `[MODULE]/src/test/java`
- Before changing code, inspect the relevant files first.
- Prefer existing project conventions over introducing new patterns.
- The kubernetes deployment is handled by Jenkins and Helm and the files are in `sl-k8s-scripts\jenkins-k8s-setup\helm`

## Required response format

At the end of every substantial answer, include:

### Summary
- What changed or was discovered
- Any tests run
- Any files modified
- Any follow-up risks or TODOs

## Tools
- Kubectl is available, but is not configured to connect to the kubernetes environment. You will have to ask questions or infer from the Helm scripts in `sl-k8s-scripts/`

## Mandatory behaviour

- Use tools where needed to inspect files rather than guessing.
- If you cannot use a required tool, create or update `forge-tool-failures.md` before finishing.
- In that file, document:
  - the task attempted
  - the tool that should have been used
  - why it was not used
  - what fallback was used instead

## Writing tests

- Test files are named ```[SOURCE_FILE_NAME]Test.java```
- Test method signatures should be written in the format ```[method being tested]_[test conditions]_[expected outcome]```.

## Build and test commands

Test code is not in the same directory tree as source code. It is in [MODULE]/src/test/java. Test files are named [SOURCE_FILE_NAME]Test.java
Test method signatures should be written in the format [method being tested]_[test conditions]_[expected outcome].
Do not remove existing test code.

When creating new test code, to test it only test the class you changed. Use 
```bash
mvn test -Dtest=MyTestClass#myTestMethod
```
Use these where applicable:

```bash
mvnw test
mvnw -Dtest=SomeTestClass test
```