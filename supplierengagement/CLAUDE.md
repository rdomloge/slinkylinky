# supplierengagement — CLAUDE.md

Spring Boot service (port 8091). Handles lead sourcing from Collaborator.pro, contact discovery,
outreach emails, and supplier conversion. Exposed at `/.rest/engagements` in production.

## Package Map

```
com.domloge.slinkylinky.supplierengagement
├── scraper/          ← Collaborator.pro auth, scraping, contact discovery
├── controller/       ← REST endpoints
├── entity/           ← JPA entities
├── repo/             ← Spring Data repositories
├── email/            ← Outreach email building + sending
└── config/           ← Spring config (security, RabbitMQ, email)
```

---

## Scraper Classes

### `CollaboratorLoginService`
`scraper/CollaboratorLoginService.java`

Automates headless login to collaborator.pro. Uses FlareSolverr to bypass Cloudflare
Turnstile, then Playwright to fill the login form. Holds browser state open across the
`login()` → `submitTwoFactorCode()` boundary if 2FA is required.

| Method | Signature | Notes |
|--------|-----------|-------|
| `login` | `synchronized SessionSnapshot login(String username, String password)` | Returns AUTHENTICATED, AWAITING_2FA, or FAILED |
| `submitTwoFactorCode` | `synchronized SessionSnapshot submitTwoFactorCode(String code)` | Only valid after login() returns AWAITING_2FA; 5-min window |
| `cleanupExpired2fa` | `void cleanupExpired2fa()` | `@Scheduled(fixedDelay=60_000)` — closes leaked browser if 2FA window expired |

Private fields for pending 2FA state: `volatile Playwright pending2faPlaywright`,
`volatile Browser pending2faBrowser`, `volatile BrowserContext pending2faContext`,
`volatile Page pending2faPage`, `volatile Instant pending2faExpiry`.

---

### `CollaboratorAuthSessionService`
`scraper/CollaboratorAuthSessionService.java`

In-memory session broker. Validates imported cookies against the Collaborator.pro API,
stores them under a UUID, and serves them to the scraper. TTL = 15 minutes.

| Method | Signature | Notes |
|--------|-----------|-------|
| `importCookies` | `SessionSnapshot importCookies(String rawCookieHeader, String importedBy, long projectId)` | Sanitises → checks auth hints → calls API to validate → stores session |
| `getStatus` | `SessionSnapshot getStatus(String authSessionId)` | Returns current snapshot; marks EXPIRED if TTL passed |
| `consumeCookies` | `String consumeCookies(String authSessionId)` | Returns raw Cookie header string; does NOT invalidate the session |
| `cleanupExpiredSessions` | `void cleanupExpiredSessions()` | `@Scheduled(fixedDelay=60_000)` — removes sessions expired > 5 min ago |

**SessionSnapshot** (public inner class): `authSessionId`, `status`, `errorMessage`, `expiresAt`  
**SessionState** (private inner class): `id`, `createdAt`, `expiresAt`, `status`, `errorMessage`, `cookies`, `importedBy`

Session statuses: `PENDING` → `AUTHENTICATED` | `FAILED` | `EXPIRED`

> **Note (2026-04-23):** `importCookies` was recently changed to 3 args (adding `projectId`).
> `CollaboratorLoginService` still calls the old 2-arg form — there is currently a compile break
> on this boundary. Fix by threading `projectId` through from the caller, or adding a default overload.

---

### `LeadScraper` (interface)
`scraper/LeadScraper.java`

```java
String getSourceKey();
void scrapeAsync(String cookies, int scrapeLimit, boolean incremental);
ScrapeStatus getStatus();
```

---

### `CollaboratorLeadScraper`
`scraper/CollaboratorLeadScraper.java` — implements `LeadScraper`

Paginates `GET /catalog/api/data/load?project_id=...&page=N&per-page=100`, upserts
`SupplierLead` rows, and optionally skips already-seen domains (incremental mode).

| Method | Signature | Notes |
|--------|-----------|-------|
| `getSourceKey` | `String getSourceKey()` | Returns `"collaborator"` |
| `getStatus` | `ScrapeStatus getStatus()` | Thread-safe; reads `AtomicBoolean running`, `AtomicInteger leadsFound` |
| `scrapeAsync` | `void scrapeAsync(String cookiesOverride, int limitOverride, boolean incremental)` | `@Async` — runs on Spring async pool |

---

### `ContactDiscoveryService`
`scraper/ContactDiscoveryService.java`

HTTP-only contact discovery. Fetches the target domain and extracts emails with Jsoup.

| Method | Signature |
|--------|-----------|
| `discoverEmail` | `String discoverEmail(String domain)` |

---

### `BrowserContactDiscoveryService`
`scraper/BrowserContactDiscoveryService.java`

Browser-based contact discovery for sites that require JavaScript rendering.

| Method | Signature | Notes |
|--------|-----------|-------|
| `openSession` | `PlaywrightSession openSession()` | Launches Chromium; caller must close |
| `discoverEmail` | `String discoverEmail(String domain, PlaywrightSession session)` | Navigates to /, /contact, /about etc.; parses with Jsoup |

**PlaywrightSession** (inner class, `implements AutoCloseable`): wraps `Playwright`, `Browser`, `BrowserContext`.

---

### `BrowserDiscoveryQueue`
`scraper/BrowserDiscoveryQueue.java`

Single-threaded worker that processes the `LinkedBlockingQueue<Long>` of lead IDs for
browser-based contact discovery. One `PlaywrightSession` is held open for the worker's
lifetime and reused across all leads.

| Method | Signature | Notes |
|--------|-----------|-------|
| `enqueue` | `void enqueue(long leadId)` | Non-blocking put |
| `getQueueDepth` | `int getQueueDepth()` | Items waiting |
| `getProcessed` | `int getProcessed()` | Cumulative count |
| `isBrowserAvailable` | `boolean isBrowserAvailable()` | False if browser launch failed |
| `startWorker` | `void startWorker()` | `@EventListener(ApplicationReadyEvent)` — daemon thread |

---

### `EmailExtractor`
`scraper/EmailExtractor.java`

Regex-based email extractor operating on a Jsoup `Document`.
Used by both `ContactDiscoveryService` and `BrowserContactDiscoveryService`.

---

### `ScrapeStatus`
`scraper/ScrapeStatus.java`

Value object returned by `LeadScraper.getStatus()`:
`isRunning()`, `getLeadsFound()`, `getSource()`, `getErrorMessage()`

---

### `LeadOutreachService`
`scraper/LeadOutreachService.java`

| Method | Signature |
|--------|-----------|
| `sendOutreach` | `void sendOutreach(long leadId)` throws `MessagingException` |

---

## Controller Classes

### `LeadController`
`controller/LeadController.java` — base path `/.rest/leads` (via supplierengagement proxy)

| Method | HTTP | Path | Description |
|--------|------|------|-------------|
| `list` | GET | `/.rest/leads` | All leads |
| `autoLogin` | POST | `/.rest/leads/collaborator/session/login` | Trigger headless login |
| `verify2fa` | POST | `/.rest/leads/collaborator/session/login/verify` | Submit 2FA code |
| `importCollaboratorCookies` | POST | `/.rest/leads/collaborator/session/import` | Manual cookie import |
| `sessionStatus` | GET | `/.rest/leads/collaborator/session/status` | Poll session state |
| `scrape` | POST | `/.rest/leads/scrape` | Kick off async scrape |
| `scrapeStatus` | GET | `/.rest/leads/scrape/status` | Poll scrape progress |
| `discover` | POST | `/.rest/leads/{id}/discover` | HTTP contact discovery; enqueues browser if needed |
| `requeueBrowser` | POST | `/.rest/leads/{id}/requeueBrowser` | Force browser queue for a lead |
| `browserQueueStatus` | GET | `/.rest/leads/browser-queue/status` | Queue depth + processed count |
| `sendOutreach` | POST | `/.rest/leads/{id}/sendOutreach` | Send outreach email |
| `convertToSupplier` | POST | `/.rest/leads/{id}/convert` | Promote lead → Supplier |
| `getByGuid` | GET | `/.rest/leads/response` | Lead by public GUID |
| `accept` | PATCH | `/.rest/leads/accept` | Mark lead accepted |
| `decline` | PATCH | `/.rest/leads/decline` | Mark lead declined |
| `mappingStatus` | GET | `/.rest/leads/{id}/mapping-status` | Collaborator category → SL category mapping status |
| `downloadFile` | GET | `/.rest/leads/{id}/downloadFile` | Download attachment |

---

## Auth Flow: FlareSolverr → Playwright → Authenticated Session

```
┌──────────────────────────────────────────────────────────────────────────┐
│  USER (frontend)                                                          │
│                                                                          │
│  POST /.rest/leads/collaborator/session/login                            │
│  { "username": "...", "password": "..." }                                │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  LeadController.autoLogin()                                              │
│  → CollaboratorLoginService.login(username, password)   [synchronized]   │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
              ┌──────────────────▼──────────────────┐
              │  collaborator.flaresolverr.url set?  │
              └──────────────────┬──────────────────┘
               YES               │                  NO
               │                 │                  │
               ▼                 │          (plain headless)
┌─────────────────────────┐      │
│  1. FLARESOLVERR CALL   │      │
│                         │      │
│  POST http://localhost:8191/v1 │
│  {                      │      │
│    "cmd":"request.get", │      │
│    "url":"https://      │      │
│     collaborator.pro    │      │
│     /login",            │      │
│    "maxTimeout":120000  │      │
│  }                      │      │
│                         │      │
│  Response:              │      │
│  {                      │      │
│    "status": "ok",      │      │
│    "solution": {        │      │
│      "userAgent":"...", │      │
│      "cookies": [       │      │
│        { "name":        │      │
│          "cf_clearance",│      │
│          "value":"..." }│      │
│        ...              │      │
│      ]                  │      │
│    }                    │      │
│  }                      │      │
└────────────┬────────────┘      │
             │                   │
             │ bypassCookies     │ bypassCookies = []
             └──────────┬────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  2. LAUNCH PLAYWRIGHT (Chromium, headless)                               │
│                                                                          │
│  BrowserType.LaunchOptions:                                              │
│    --disable-blink-features=AutomationControlled                         │
│    --no-sandbox  --disable-dev-shm-usage  --disable-gpu                  │
│    --window-size=1920,1080  --lang=en-US,en                              │
│    executablePath: collaborator.browser.path (if set)                   │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  3. CREATE BROWSER CONTEXT (stealth config)                              │
│                                                                          │
│  userAgent   = from FlareSolverr (or fallback Mozilla/5.0 Chrome/124)   │
│  viewport    = 1920×1080                                                 │
│  locale      = en-US,  timezone = America/New_York                       │
│  ignoreHTTPSErrors = true                                                │
│                                                                          │
│  addInitScript(STEALTH_SCRIPT):  ← defeats headless fingerprinting       │
│    navigator.webdriver   → undefined                                     │
│    window.chrome         → { runtime, loadTimes, csi, app }             │
│    navigator.plugins     → 5 fake plugin entries                         │
│    navigator.languages   → ['en-US','en']                                │
│    navigator.hardwareConcurrency → 4                                     │
│                                                                          │
│  if bypassCookies not empty:                                             │
│    context.addCookies(bypassCookies)   ← cf_clearance pre-seeded        │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  4. NAVIGATE  page.navigate("https://collaborator.pro/login")            │
│     waitForLoadState(NETWORKIDLE, 30s)                                   │
│                                                                          │
│  Guard: if title == "Just a moment..." → FAILED (CF challenge active)    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  5. FILL LOGIN FORM                                                      │
│                                                                          │
│  emailField    = findField(page,                                         │
│                    "input[type='email']",                                │
│                    "input[name='LoginForm[email]']", …)                  │
│  emailField.fill(username)                                               │
│                                                                          │
│  passwordField = findField(page, "input[type='password']", …)           │
│  passwordField.fill(password)                                            │
│                                                                          │
│  submitBtn     = findField(page,                                         │
│                    "button[type='submit']",                              │
│                    "button:has-text('Login')", …)                        │
│  submitBtn.click()                                                       │
│                                                                          │
│  waitForLoadState(NETWORKIDLE, 15s)                                      │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
              ┌──────────────────▼──────────────────┐
              │         isTwoFactorPage(page)?       │
              │  checks: URL path, page title,       │
              │  input[name*='code/otp/token/pin']   │
              └──────┬──────────────────────┬────────┘
                     │ YES                  │ NO
                     ▼                      ▼
         ┌────────────────────┐  ┌──────────────────────────────────────┐
         │  6a. 2FA PATH      │  │  6b. SUCCESS PATH                    │
         │                    │  │                                      │
         │  Hold open:        │  │  if URL still contains /login        │
         │  pending2fa        │  │  → FAILED (wrong credentials)        │
         │  Playwright/       │  │                                      │
         │  Browser/Context/  │  │  else:                               │
         │  Page              │  │  cookieHeader =                      │
         │  expiry = now+5min │  │    context.cookies()                 │
         │                    │  │    .map(c → c.name+"="+c.value)      │
         │  return            │  │    .joining("; ")                    │
         │  AWAITING_2FA      │  │                                      │
         └────────┬───────────┘  │  → sessionService.importCookies()   │
                  │              └──────────────┬───────────────────────┘
                  │                             │
                  │  User submits code:         │
                  │  POST /login/verify         │
                  │  → submitTwoFactorCode()    │
                  │                             │
                  │  findField(code/otp/…)      │
                  │  .fill(code)                │
                  │  submitBtn.click()          │
                  │  waitForURL(not /login      │
                  │            not /2fa, 15s)   │
                  │  extract cookies            │
                  │  cleanupPending2fa()        │
                  │  → sessionService           │
                  │    .importCookies()         │
                  │                             │
                  └──────────────┬──────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  7. CollaboratorAuthSessionService.importCookies()                       │
│                                                                          │
│  Sanitise: strip whitespace, validate "name=value" pairs                 │
│  Guard: must contain at least one of                                     │
│         "_identity-user" | "PHPSESSID" | "cf_clearance"                  │
│                                                                          │
│  HTTP validation call:                                                   │
│    GET https://collaborator.pro/catalog/api/data/load                    │
│        ?project_id={projectId}&page=1&per-page=1                         │
│    Cookie: <extracted header>                                            │
│    Accept: application/json                                              │
│    X-Requested-With: XMLHttpRequest                                      │
│    Referer: https://collaborator.pro/catalog/creator/article?…           │
│                                                                          │
│  Accept if: HTTP 200 AND body.status == true                             │
│                                                                          │
│  Store:                                                                  │
│    sessions[UUID] = SessionState {                                       │
│      status   = "AUTHENTICATED"                                          │
│      cookies  = sanitized header string                                  │
│      expiresAt = now + 15 min                                            │
│    }                                                                     │
│                                                                          │
│  Return: SessionSnapshot { authSessionId, status, expiresAt }           │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
         authSessionId returned to frontend ──────────────────────────────┐
                                                                          │
┌──────────────────────────────────────────────────────────────────────────┤
│  8. SCRAPE                                                               │
│                                                                          │
│  POST /.rest/leads/scrape  { authSessionId, limit }                      │
│  → LeadController.scrape()                                               │
│  → sessionService.consumeCookies(authSessionId)                          │
│  → CollaboratorLeadScraper.scrapeAsync(cookies, limit, incremental)      │
│     @Async — Spring thread pool                                          │
│                                                                          │
│  Loop:                                                                   │
│    GET /catalog/api/data/load?project_id=…&page=N&per-page=100          │
│    Cookie: <stored header>                                               │
│    → parse JSON → upsert SupplierLead rows → page++ until no data       │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Cookie Lineage

```
FlareSolverr response
  └── cf_clearance, cf_bm
        │ context.addCookies()
        ▼
  Playwright BrowserContext   ← pre-seeded before any navigation
        │ collaborator.pro login form submission
        │ server sets new cookies via Set-Cookie
        ▼
  context.cookies()           ← all cookies combined
  "cf_clearance=…; _identity-user=…; PHPSESSID=…; …"
        │ importCookies()
        ▼
  SessionState.cookies        ← stored in ConcurrentHashMap, TTL 15 min
        │ consumeCookies()
        ▼
  HTTP request Cookie header  ← injected into every scrape API call
```

---

## Contact Discovery Flow

```
POST /.rest/leads/{id}/discover
  → ContactDiscoveryService.discoverEmail(domain)        [HTTP + Jsoup]
        │
        ├── email found   → persist, status = EMAIL_FOUND
        │
        └── not found     → BrowserDiscoveryQueue.enqueue(leadId)
                                │  LinkedBlockingQueue<Long>
                                ▼
              BrowserDiscoveryQueue worker thread (daemon, started at boot)
              holds one PlaywrightSession open for its lifetime
                    │
                    ├── BrowserContactDiscoveryService.discoverEmail(domain, session)
                    │   navigates to /, /contact, /contact-us, /about …
                    │   page.content() → Jsoup.parse() → EmailExtractor
                    │
                    └── persist result, mark BROWSER_QUEUED → EMAIL_FOUND | NOT_FOUND
```

---

## Background Threads & Schedules

| Thread / Schedule | Class | Trigger | What it does |
|---|---|---|---|
| Spring async pool | `CollaboratorLeadScraper` | `@Async` on `scrapeAsync` | Paginated catalog scrape |
| `browser-discovery-worker` | `BrowserDiscoveryQueue` | `@EventListener(ApplicationReadyEvent)` daemon | Browser email discovery loop |
| `cleanupExpiredSessions` | `CollaboratorAuthSessionService` | `@Scheduled fixedDelay=60s` | Remove expired sessions |
| `cleanupExpired2fa` | `CollaboratorLoginService` | `@Scheduled fixedDelay=60s` | Close leaked browser if 2FA timed out |

---

## Environment Variables (supplierengagement-specific)

| Variable | Purpose |
|---|---|
| `collaborator.flaresolverr.url` | FlareSolverr base URL, e.g. `http://localhost:8191`. Empty = disabled (plain headless fallback). |
| `collaborator.browser.path` | Absolute path to system Chromium binary. Empty = use Playwright's bundled browser. |

See `docs/supplierengagement-ops.md` for FlareSolverr resource requirements and deployment notes.
