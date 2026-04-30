# Tenant Monitoring — Operator-Grade, Zero Budget, Shared Cluster

## Context

Each new SL tenant deploys into its own K8s namespace via `sl-k8s-scripts/jenkins-k8s-setup/helm/`. There is one shared cluster across all tenants. Budget is £0. You want operator-facing monitoring comparable in spirit to Dynatrace (infra + JVM + service health) plus a tenant-aware health page in the SL admin UI. Alerts route to a Slack/Discord webhook.

What you already have (free, already working):
- Spring Boot Actuator on every service (`linkservice` and `stats` expose `*`; `audit`, `supplierengagement`, `userservice`, `woocommerce` expose `health,info` only).
- K8s liveness/readiness probes against `/actuator/health/*` (`sl-k8s-scripts/jenkins-k8s-setup/helm/templates/deployment.yml:63-78`).
- Keycloak metrics enabled (`KC_METRICS_ENABLED`, `templates/keycloak.yml:36`).
- Cloudflare Tunnel per tenant — free edge analytics for hostname-level traffic.

## Sparring-partner notes / blind spots

1. **"Free" still costs cluster RAM.** kube-prometheus-stack steady-state ~2 GB RAM, ~10 GB disk for ~15 days retention. Confirm the cluster has headroom on at least one node, or budget a small node bump.
2. **Shared monitoring co-mingles tenant data.** Acceptable here because all tenants are yours. If you ever sell a self-hosted single-tenant install, this stack moves into that namespace and the multi-tenant Grafana view goes away — keep dashboards parameterised by `namespace` label so they work in both modes.
3. **Some services hide their internals.** `audit`, `supplierengagement`, `userservice`, `woocommerce` only expose `health,info`. Without `prometheus`/`metrics` exposed, you'll get black-box health but no JVM/DB metrics for them. Decide whether to widen exposure (and how to protect those endpoints — they're behind Cloudflare path rules but `/actuator/prometheus` would not currently be routed by the Cloudflare config, so internal-only by default).
4. **Alert noise is the main failure mode.** Start with a tiny, opinionated rule set (pod crashloop, service down >2min, DB connection saturation, high error rate). Add more only after you've ignored an alert.

## Recommended approach

Three layers, deployed in order:

### Layer 1 — Shared monitoring stack (`monitoring` namespace)

Install **kube-prometheus-stack** via Helm into a new `monitoring` namespace.

- Components: Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics (all included in the chart).
- Retention: 15 days, ~10 GB PVC.
- Grafana admin password stored as a K8s secret; expose Grafana via a new Cloudflare tunnel route on a separate hostname (e.g. `grafana.slinkylinky.uk`) protected by Cloudflare Access (free) — **not** through any tenant tunnel.
- Alertmanager → Slack/Discord webhook stored as a K8s secret.

Critical files:
- New: `sl-k8s-scripts/jenkins-k8s-setup/monitoring/` directory with values.yaml + install script (kept outside the per-tenant Helm chart so it deploys once for the whole cluster).
- New Jenkins job (separate from the per-tenant pipeline) to install/upgrade the monitoring stack.

### Layer 2 — Make SL services scrapeable

Per-service changes:

1. **Add Micrometer Prometheus registry** to each service's `pom.xml`:
   ```xml
   <dependency>
       <groupId>io.micrometer</groupId>
       <artifactId>micrometer-registry-prometheus</artifactId>
   </dependency>
   ```
   Files: `linkservice/pom.xml`, `stats/pom.xml`, `audit/pom.xml`, `supplierengagement/pom.xml`, `userservice/pom.xml`. (Skip `woocommerce` — single-customer, not on this pipeline.)

2. **Expose `prometheus` actuator endpoint** in each `application.properties`:
   - `linkservice` and `stats` already use `*` — no change needed.
   - `audit`, `supplierengagement`, `userservice`: change `management.endpoints.web.exposure.include` to add `prometheus` (keep the rest minimal: `health,info,prometheus`).

3. **Add a `ServiceMonitor` per tenant deployment.** Extend `sl-k8s-scripts/jenkins-k8s-setup/helm/templates/` with a new `servicemonitor.yml` template that emits one `ServiceMonitor` per deployment that has `prometheus` enabled (gate via a `values.yaml` flag like `deployment.metrics: true`). The Prometheus operator watches these across all namespaces and starts scraping automatically when a new tenant is deployed — **no monitoring config change needed per tenant**.

4. **Add Postgres + RabbitMQ exporters** as sidecars or sibling deployments in each tenant namespace. Both have official Bitnami/community images.
   - `prometheus-postgres-exporter` reads from each tenant's Postgres.
   - `rabbitmq_prometheus` plugin (built into RabbitMQ ≥3.8) — just enable it in `templates/rabbit.yml` and add a service port.

### Layer 3 — Frontend tenant health page (`global_admin` / `tenant_admin`)

A new admin page in the SL frontend that serves a tenant-aware view your customers and you can both use without leaving the app.

Backend (linkservice):
- New controller `linkservice/src/main/java/.../HealthAggregatorController.java` exposing `GET /.rest/admin/tenant-health`.
- Fans out (in parallel, with short timeout) to each in-cluster service URL (`http://linkservice-service:8090/actuator/health`, etc.) and aggregates `{ service, status, version, uptime, db, rabbit }`.
- Auth: existing JWT filter; require `global_admin` or `tenant_admin` role (see existing role checks in linkservice for the pattern).

Frontend:
- New page `frontend/react/src/pages/admin/health/index.jsx` rendering a status grid.
- Reuse existing components from `frontend/react/src/components/` (per CLAUDE.md guidance) — likely card/badge/spinner primitives.
- Add route in the page router (see `docs/frontend-pages.md` for the route table to update).
- Polls every 30 s.

After regenerating: `node scripts/gen-docs.js` to update the docs index.

### Alerting rules (minimal, opinionated)

Drop these into the kube-prometheus-stack `values.yaml` as `additionalPrometheusRulesMap`:

| Alert | Condition | Severity |
|---|---|---|
| `PodCrashLooping` | `kube_pod_container_status_restarts_total` rate > 0 over 10 min | warning |
| `ServiceDown` | `up == 0` for 2 min | critical |
| `HighJvmHeap` | `jvm_memory_used_bytes / jvm_memory_max_bytes > 0.9` for 10 min | warning |
| `DbConnectionSaturated` | `hikaricp_connections_active / hikaricp_connections_max > 0.8` for 5 min | warning |
| `RabbitQueueBacklog` | `rabbitmq_queue_messages_ready > 1000` for 10 min | warning |
| `Http5xxRate` | `rate(http_server_requests_seconds_count{status=~"5.."}[5m]) > 0.05` per service | warning |

All routed to one Slack/Discord webhook, grouped by `namespace` so a tenant's noise doesn't drown others.

### Pre-built Grafana dashboards to import

Free dashboards from grafana.com (import by ID):
- JVM (Micrometer) — 4701
- Spring Boot 2.1+ Statistics — 11378
- Kubernetes / Compute Resources / Namespace (Pods) — 12117
- PostgreSQL Database — 9628
- RabbitMQ-Overview — 10991
- Node Exporter Full — 1860

## Build sequence

1. Stand up kube-prometheus-stack in shared cluster, wire Slack webhook, import dashboards. Confirm node/pod metrics flowing.
2. Add Micrometer Prometheus to each Spring Boot service; widen actuator exposure where needed; rebuild images.
3. Add `ServiceMonitor` template + `metrics: true` flags in `values.yaml` for each tenant. Redeploy a test tenant; confirm scraping.
4. Add Postgres exporter + enable RabbitMQ Prometheus plugin in tenant Helm chart. Confirm dashboards populate.
5. Build frontend health-aggregator endpoint + admin page.
6. Author and load alert rules. Test by killing a pod.

## Verification

- Kill a service pod (`kubectl delete pod -n <tenant> linkservice-...`) → expect `ServiceDown` alert in Slack within ~3 min, red tile in frontend health page within 30 s.
- Run Postgres into connection saturation via a load script → expect `DbConnectionSaturated` alert and visible saturation in the Postgres dashboard.
- Deploy a brand-new tenant via the existing pipeline → expect it to appear automatically in Grafana's namespace dropdown with no monitoring config change.
- Hit `/.rest/admin/tenant-health` as a tenant_admin and confirm all services return `UP` with expected versions.
