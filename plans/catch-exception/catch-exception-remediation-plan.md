# catch-exception-remediation-plan

## Objective

Replace all `catch (Exception e)` blocks in production code with narrowly-targeted catches that match the actual exception types the code can throw. This prevents swallowing `InterruptedException`, `StackOverflowError`, `OutOfMemoryError`, and other control-flow exceptions that should propagate.

## Scope

- **Production code only** — test files are excluded.
- **18 files** across 5 modules: `linkservice`, `stats`, `supplierengagement`, `userservice`, `woocommerce`.

---

## Phase 1 — Quick wins: Best-effort side-effects (Category B)

These blocks already have the right *behaviour* (log and continue). The change is purely narrowing the catch type.

### 1. `userservice/controller/KeycloakUserController.java:148`
**Current:** `catch (Exception e)` wrapping `tokenRepo.save()` + `emailSender.sendVerificationEmail()`
**Fix:** `catch (PersistenceException | RuntimeException e)`
**Rationale:** JPA persistence + mail sending. The token is already persisted; email failure is non-fatal.

### 2. `userservice/controller/RegistrationController.java:170`
**Current:** `catch (Exception e)` wrapping `emailSender.sendVerificationEmail()`
**Fix:** `catch (RuntimeException e)` (mail sender throws unchecked exceptions)
**Rationale:** Same pattern — best-effort email.

### 3. `userservice/controller/ResendVerificationController.java:104`
**Current:** `catch (Exception e)` wrapping `emailSender.sendVerificationEmail()`
**Fix:** `catch (RuntimeException e)`

### 4. `userservice/controller/ResendVerificationController.java:186`
**Current:** `catch (Exception e)` wrapping `emailSender.sendVerificationEmail()`
**Fix:** `catch (RuntimeException e)`

### 5. `userservice/controller/OrganisationsOverviewController.java:138`
**Current:** `catch (Exception e)` wrapping `auditRabbitTemplate.convertAndSend()`
**Fix:** `catch (RuntimeException e)` (RabbitMQ template throws `AmqpException` which is `RuntimeException`)

### 6. `userservice/controller/ResendVerificationController.java:225`
**Current:** `catch (Exception e)` wrapping `auditRabbitTemplate.convertAndSend()`
**Fix:** `catch (RuntimeException e)`

### 7. `userservice/controller/VerifyEmailController.java:94`
**Current:** `catch (Exception e)` wrapping `auditRabbitTemplate.convertAndSend()`
**Fix:** `catch (RuntimeException e)`

### 8. `userservice/controller/RegistrationController.java:244`
**Current:** `catch (Exception e)` wrapping `auditRabbitTemplate.convertAndSend()`
**Fix:** `catch (RuntimeException e)`

### 9. `userservice/controller/OrganisationController.java:85`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

### 10. `userservice/controller/RegistrationController.java:220` + `240`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

### 11. `userservice/controller/VerifyEmailController.java:90`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

### 12. `userservice/controller/ResendVerificationController.java:221`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

### 13. `linkservice/entity/audit/ProposalAuditor.java:69`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

### 14. `linkservice/entity/audit/SupplierAuditor.java:61`
**Current:** `catch (Exception e)` wrapping `objectMapper.writeValueAsString()`
**Fix:** `catch (JsonProcessingException e)`

---

## Phase 2 — Dangerous re-throw catches (Category C, highest priority)

These blocks catch `Exception` and re-throw, silently swallowing `InterruptedException` and `Error` subclasses. **Fix these first.**

### 15. `stats/moz/MozFacade.java:112` — ⚠️ MOST DANGEROUS
**Current:**
```java
catch (Exception e) {
    audit(user, domain, e);
    throw new RuntimeException(e);
}
```
**Fix:**
```java
catch (HttpClientErrorException | HttpServerErrorException | ResourceAccessException e) {
    audit(user, domain, e);
    throw new RuntimeException("Moz API call failed for " + domain, e);
}
catch (JsonProcessingException e) {
    audit(user, domain, e);
    throw new RuntimeException("JSON serialization failed for Moz API payload", e);
}
```
**Rationale:** The only exceptions that can arise from the HTTP call and JSON serialization are these four types. Swallowing `InterruptedException` here would silently cancel a thread doing Moz API work with no indication why.

### 16. `userservice/controller/KeycloakUserController.java:157`
**Current:** `catch (Exception e)` wrapping Keycloak admin role assignment, re-throws `ResponseStatusException`
**Fix:** `catch (WebApplicationException e)`
**Rationale:** Keycloak admin client (Jersey-based) throws `WebApplicationException` for HTTP errors.

### 17. `linkservice/controller/KeycloakUserController.java:111`
**Current:** Same pattern as #16.
**Fix:** `catch (WebApplicationException e)`

### 18. `userservice/controller/RegistrationController.java:128`
**Current:** `catch (Exception e)` wrapping Keycloak user creation, triggers compensation
**Fix:** `catch (WebApplicationException e)`

### 19. `userservice/controller/RegistrationController.java:139`
**Current:** `catch (Exception e)` wrapping Keycloak role assignment, triggers compensation
**Fix:** `catch (WebApplicationException e)`

### 20. `userservice/controller/RegistrationController.java:159`
**Current:** `catch (Exception e)` wrapping `tokenRepo.save()`, triggers compensation
**Fix:** `catch (PersistenceException e)`

### 21. `userservice/controller/RegistrationController.java:201`
**Current:** `catch (Exception e)` in `silentlyDeleteUser()`, compensation path
**Fix:** `catch (WebApplicationException e)`

### 22. `userservice/controller/ResendVerificationController.java:96`
**Current:** `catch (Exception e)` wrapping `tokenRepo.save()`
**Fix:** `catch (PersistenceException e)`

### 23. `userservice/controller/ResendVerificationController.java:137`
**Current:** `catch (Exception e)` wrapping `keycloakAdminClient.getUserByEmail()`
**Fix:** `catch (WebApplicationException e)`

### 24. `userservice/controller/ResendVerificationController.java:179`
**Current:** `catch (Exception e)` wrapping `tokenRepo.save()`
**Fix:** `catch (PersistenceException e)`

### 25. `userservice/controller/VerifyEmailController.java:66`
**Current:** `catch (Exception e)` wrapping `keycloakAdminClient.setEmailVerified()`
**Fix:** `catch (WebApplicationException e)`

### 26. `supplierengagement/scraper/CollaboratorLoginService.java:197`
**Current:** `catch (Exception e)` wrapping Playwright login + HTTP calls, returns `fail()` result
**Fix:** `catch (PlaywrightException | WebApplicationException | HttpClientErrorException e)`
**Rationale:** Playwright throws `PlaywrightException`; Keycloak/HTTP calls throw the Jersey/WebClient exceptions.

### 27. `supplierengagement/scraper/CollaboratorLoginService.java:288`
**Current:** Same pattern as #26, 2FA submission
**Fix:** `catch (PlaywrightException | WebApplicationException | HttpClientErrorException e)`

### 28. `supplierengagement/scraper/CollaboratorLeadScraper.java:231`
**Current:** `catch (Exception e)` wrapping entity upsert
**Fix:** `catch (DataAccessException e)`

### 29. `supplierengagement/scraper/CollaboratorLeadScraper.java:252`
**Current:** `catch (Exception e)` wrapping entire scrape loop (InterruptedException already caught separately above)
**Fix:** `catch (RuntimeException e)`
**Rationale:** `InterruptedException` is handled by the preceding catch. Only unexpected runtime exceptions (NPE, IAE, etc.) need catching here.

### 30. `supplierengagement/scraper/CollaboratorLeadScraper.java:274`
**Current:** `catch (Exception e)` wrapping `scrapingMetadataRepo.save()`
**Fix:** `catch (DataAccessException e)`

### 31. `supplierengagement/scraper/CollaboratorLeadScraper.java:290`
**Current:** `catch (Exception e)` wrapping REST domain check
**Fix:** `catch (ResourceAccessException e)`

### 32. `linkservice/controller/ProposalSupportController.java:279`
**Current:** `catch (Exception e)` wrapping Envers revision read
**Fix:** `catch (PersistenceException e)`

### 33. `linkservice/controller/ProposalSupportController.java:303`
**Current:** `catch (Exception e)` wrapping proposal creation (transactional service call)
**Fix:** `catch (PersistenceException | ResponseStatusException e)`

---

## Phase 3 — Marginal catches (Category C, lower priority)

### 34. `supplierengagement/scraper/ContactDiscoveryService.java:60`
**Current:** `catch (Exception e)` wrapping Jsoup HTTP fetch + email extraction
**Fix:** `catch (IOException | HttpClientErrorException e)`
**Rationale:** Jsoup throws `IOException`; HTTP layer throws `HttpClientErrorException`.

### 35. `supplierengagement/scraper/ContactDiscoveryService.java:76`
**Current:** `catch (Exception e)` wrapping `SSLContext.getInstance()` + `ctx.init()`
**Fix:** `catch (NoSuchAlgorithmException | KeyManagementException e)`
**Rationale:** These are the two checked exceptions from the SSLContext API.

### 36. `supplierengagement/scraper/EmailExtractor.java:163`
**Current:** `catch (Exception e)` wrapping `MAPPER.readTree()`
**Fix:** `catch (JsonProcessingException e)`

### 37. `supplierengagement/scraper/EmailExtractor.java:187`
**Current:** `catch (Exception e)` wrapping `new URI(url).getPath()`
**Fix:** `catch (URISyntaxException e)`
**Rationale:** Only `URISyntaxException` can be thrown by the URI constructor.

---

## Phase 4 — Keep as-is (Category A/D)

| File:Line | Reason |
|-----------|--------|
| `stats/sync/ResponsivenessSync.java:43` | Bootstrap retry — failure logged and retried weekly |
| `stats/sync/ResponsivenessSync.java:51` | Scheduled job — failure logged and retried weekly |
| `stats/semrush/Loader.java:47` | CSV deserialization utility — empty list fallback is correct |
| `linkservice/setup/Loader.java:36` | Identical CSV utility pattern |
| `linkservice/controller/HealthAggregatorController.java:61` | Health probe — by design to swallow everything |
| `linkservice/controller/HealthAggregatorController.java:99` | Health probe — by design |
| `supplierengagement/scraper/CollaboratorLoginService.java:131` | Optional FlareSolverr bypass — intentional fallback |
| `supplierengagement/scraper/CollaboratorLoginService.java:537` | Diagnostics screenshot — pure side-effect |
| `woocommerce/repo/WebHookController.java:29` | Fire-and-forget async sync |
| `linkservice/controller/ProposalSupportController.java:148` | Intentional JSON→Envers fallback |
| `supplierengagement/scraper/CollaboratorLeadScraper.java:373` | Documented race condition |
| Test files (2) | Low priority |

---

## Execution order

1. **Phase 2** (items 15–33) — highest risk, most dangerous patterns
2. **Phase 3** (items 34–37) — marginal catches, easy wins
3. **Phase 1** (items 1–14) — best-effort side-effects, cleanups
4. **Phase 4** — no changes needed

## Testing strategy

- Run `mvn test` in each affected module after changes.
- Each narrowed catch changes the *exception type* but not the *behaviour* — existing tests should pass.
- If a module's tests rely on the broad catch (e.g., a test that throws an unexpected exception type), update the test to throw the narrowed type instead.

## Rollback

Since this is purely a narrowing change (same catch block body, just tighter type), rollback is trivial: revert the catch type back to `Exception`.
