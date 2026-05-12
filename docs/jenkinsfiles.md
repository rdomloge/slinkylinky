# Jenkinsfiles Documentation

This document provides a high-level overview of all Jenkinsfiles in the SlinkyLinky project.

## Overview

The SlinkyLinky project uses multiple Jenkinsfiles to manage different aspects of the CI/CD pipeline and Kubernetes deployment lifecycle. Each Jenkinsfile serves a specific purpose in the deployment and operational workflow.

---

## 1. Root Jenkinsfile (`./Jenkinsfile`)

**Purpose:** Main CI/CD pipeline for building, testing, and deploying Docker images.

**Agent:** `maven-worker`

**Main Stages:**

1. **Checkout** — Clones the repository from GitHub
2. **Build Maven Modules** — Builds all Maven modules with tests skipped
3. **Test** — Runs unit tests
4. **Tag and Release** — Creates a git tag with semantic versioning and pushes to GitHub
5. **Docker Login** — Authenticates with Docker Hub
6. **Docker builds** — Parallel builds of all Docker images:
   - frontend (adminwebsite)
   - linkservice
   - stats
   - audit
   - supplierengagement
   - woocommerce
   - userservice
   - keycloak

**Key Features:**
- Uses multi-arch builds (linux/amd64, linux/arm64)
- Automatically pushes images to Docker Hub
- Implements semantic versioning from `${SEMVER_BUILD_NUM}`

---

## 2. Deploy Runonce Jenkinsfile (`./sl-k8s-scripts/jenkins-k8s-setup/deploy/runonce/Jenkinsfile`)

**Purpose:** One-time deployment of Kubernetes infrastructure resources (namespaces, PVCs, databases, RabbitMQ, services).

**Agent:** `kubectl-worker`

**Main Stages:**

1. **Checkout** — Clones the `sl-k8s-scripts` repository
2. **Runonce stuff** — Applies foundational K8s resources:
   - Namespace creation
   - Persistent Volume Claims (PVC)
   - PostgreSQL (postgres.yml)
   - RabbitMQ (rabbit.yml)
   - Services
   - Cloudflare configuration

**Key Features:**
- Runs only once to set up the base infrastructure
- Does not deploy application workloads
- Creates the foundation for tenant namespaces

---

## 3. Helm Jenkinsfile (`./sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile`)

**Purpose:** Full tenant provisioning and deployment via Helm, including secrets generation, database initialization, and Cloudflare tunnel setup.

**Agent:** `helm-worker` (uses `psql-worker` for database operations)

**Main Stages:**

1. **Checkout** — Clones the SlinkyLinky repository
2. **Generate tenant name** — Creates unique tenant identifier (3 letters + 5 numbers)
3. **Generate Password** — Generates cryptographically secure passwords for:
   - Database passwords (24-char base64)
   - Keycloak client secrets
   - RabbitMQ password
4. **Deploy platform via Helm** — Installs the application via Helm chart with all secrets
5. **Update secrets in Kubernetes** — Patches secrets and ConfigMaps
6. **Create tunnel in Cloudflare** — Creates Cloudflare Tunnel for secure ingress
7. **Setup tunnel routes & DNS** — Configures Cloudflare tunnel routing and DNS records
8. **Store the tunnel token as a K8S secret** — Persists tunnel credentials
9. **Run cloudflare tunnel** — Deploys the `cloudflared` StatefulSet
10. **Post-install config updates** — Updates:
    - NEXTAUTH_URL for admin website
    - Keycloak realm configuration (issuers, token URIs)
    - Mail credentials
    - Creates Keycloak realm with clients, service accounts, and client scopes
    - Sets up admin user with realm roles
11. **Scale down** — Scales all workloads to 0 except databases
12. **Load Database Schema** — Loads SQL schema files into all databases
13. **Scale up** — Scales all workloads back to 1
14. **Verify Auth Security** — Tests that all protected endpoints return 401

**Key Features:**
- Full tenant lifecycle management
- Automated Keycloak realm provisioning
- Cloudflare Tunnel integration for secure external access
- Comprehensive security verification tests
- Includes schema loading and migration

---

## 4. Restore Demo Jenkinsfile (`./sl-k8s-scripts/jenkins-k8s-setup/restore-demo/Jenkinsfile`)

**Purpose:** Restores production database backup into a demo tenant namespace for testing/demo purposes.

**Agent:** `psql-worker`

**Parameters:**
- `TENANT` — Target Kubernetes namespace
- `BACKUP_FILE` — Upload of production SQL backup file

**Main Stages:**

1. **Checkout** — Copies uploaded backup file, clones repository
2. **Scale Down** — Scales all services to 0
3. **Strip Backup** — Removes PostgreSQL 18 restrict/unrestrict authentication tokens
4. **Copy Files to Pod** — Copies backup and SQL files into the PostgreSQL pod
5. **Restore Database** — Executes restore, drops schema, applies migration
6. **Post-Restore** — Runs migrations for all schemas, applies grants, cleans up
7. **Configure Keycloak for Demo** — Updates all Keycloak users to use demo org UUID

**Key Features:**
- Handles production-to-demo data restore
- Strips PostgreSQL 18-specific auth tokens
- Executes schema migrations after restore
- Aligns Keycloak user org_ids with demo organization
- Scales services back up automatically on failure

---

## 5. Monitoring Jenkinsfile (`./sl-k8s-scripts/jenkins-k8s-setup/monitoring/Jenkinsfile`)

**Purpose:** Deploys Prometheus/Grafana monitoring stack to the Kubernetes cluster.

**Agent:** `helm-worker`

**Main Stages:**

1. **Checkout** — Clones the SlinkyLinky repository
2. **Install monitoring stack** — Deploys:
   - Adds Prometheus Helm repository
   - Creates `monitoring` namespace
   - Sets up Pod Security Policy (privileged for node-exporter)
   - Creates Grafana admin secret
   - Creates Alertmanager Slack secret
   - Installs `kube-prometheus-stack` with custom values

**Key Features:**
- One-time monitoring stack deployment
- Pre-configured for SlinkyLinky alerting via Slack
- Includes Prometheus, Grafana, Alertmanager

---

## 6. Update Versions Jenkinsfile (`./sl-k8s-scripts/jenkins-k8s-setup/update-versions/Jenkinsfile`)

**Purpose:** Rolls out new Docker image versions to an existing tenant namespace.

**Agent:** `kubectl-worker`

**Parameters:**
- `IMAGE_VERSION` — Docker image tag to deploy (required)
- `TENANT` — Target tenant namespace (required)

**Main Stages:**

1. **Validate parameters** — Ensures IMAGE_VERSION and TENANT are provided
2. **Roll deployments** — Updates image tags for:
   - audit
   - frontend (adminwebsite)
   - linkservice
   - stats
   - supplierengagement

**Key Features:**
- Simple version update workflow
- Validates rollout status before completing
- No secrets or configuration changes needed

---

## Summary Table

| Jenkinsfile | Purpose | Primary Action |
|-------------|---------|----------------|
| `Jenkinsfile` | CI/CD Build | Build Docker images |
| `deploy/runonce/Jenkinsfile` | Infrastructure | Setup K8s namespaces, DB, RabbitMQ |
| `helm/Jenkinsfile` | Tenant Provisioning | Full tenant deployment |
| `restore-demo/Jenkinsfile` | Data Restore | Production backup to demo tenant |
| `monitoring/Jenkinsfile` | Observability | Deploy Prometheus/Grafana |
| `update-versions/Jenkinsfile` | Version Rollout | Update image versions in tenant |

---

## Workflow Dependencies

```
deploy/runonce → helm (tenant creation)
               → monitoring (observability)
               → update-versions (runtime updates)
```

The `restore-demo` Jenkinsfile operates independently on existing tenants.

---

## Security Notes

1. **Password Generation** — All passwords are generated cryptographically (24-char base64)
2. **Cloudflare Tunnel** — Provides secure ingress without exposing internal services
3. **Tenant Isolation** — Each tenant has its own namespace and secrets
4. **Secret Storage** — All secrets are stored in Kubernetes secrets, not in code
5. **Auth Verification** — Helm pipeline includes automated security tests

---

## File Locations

```
./Jenkinsfile
./sl-k8s-scripts/jenkins-k8s-setup/deploy/runonce/Jenkinsfile
./sl-k8s-scripts/jenkins-k8s-setup/helm/Jenkinsfile
./sl-k8s-scripts/jenkins-k8s-setup/monitoring/Jenkinsfile
./sl-k8s-scripts/jenkins-k8s-setup/restore-demo/Jenkinsfile
./sl-k8s-scripts/jenkins-k8s-setup/update-versions/Jenkinsfile
```
