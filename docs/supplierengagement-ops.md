# Supplier Engagement Service — Operational Notes

> Static reference — maintained manually alongside `supplierengagement/`.

## FlareSolverr Sidecar (Cloudflare Bypass)

FlareSolverr runs as a sidecar container inside the `supplierengagement` pod to bypass Cloudflare's anti-bot challenge on `collaborator.pro/login`.

### Minimum resource requirements

| Resource | Minimum working value | Notes |
|---|---|---|
| CPU limit | `2000m` (2 cores) | Below this, Chrome is throttled mid-challenge and the solve times out |
| Memory limit | `1024Mi` | Chromium + Cloudflare JS challenge overhead |
| CPU request | `500m` | Prevents noisy-neighbour starvation at startup |
| Memory request | `512Mi` | |

**Background:** Cloudflare's "Just a moment..." challenge on cloud/datacenter IPs requires sustained CPU to execute browser fingerprinting JS. With a 500m CPU limit the browser stalls part-way through and always hits the 120 s timeout, even though the test URL (`/`) loads fine at startup. Raising the limit to 2000m resolved the issue.

### Timeout configuration

The Java-side FlareSolverr call (`CollaboratorLoginService.callFlareSolverr()`) uses:
- `maxTimeout`: 120 000 ms (passed in the POST body to FlareSolverr)
- HTTP client timeout: 150 s

These replaced the original 60 s / 90 s values after seeing consistent timeouts in K8s.

### Proxy support

If FlareSolverr still fails (e.g. the node's IP is datacenter-blocked by Cloudflare), set a residential proxy via:

```yaml
# supplierengagement.yml
- name: collaborator_flaresolverr_proxy_url
  value: "http://user:pass@proxy-host:port"
```

This is wired through `collaborator.flaresolverr.proxy.url` in `application.properties` and injected into the FlareSolverr POST body as a `"proxy"` field.

### Manual cookie fallback

If automated login is not possible, cookies can be imported manually via:
```
POST /.rest/leads/collaborator/session/import
```
Log in via a browser, copy the cookie header from DevTools, and POST it here.

### K8s deployment reference

Sidecar definition lives in `sl-k8s-scripts/yaml/supplierengagement.yml` (first container in the pod spec). Helm values reference it at `sl-k8s-scripts/jenkins-k8s-setup/helm/values.yaml`.
