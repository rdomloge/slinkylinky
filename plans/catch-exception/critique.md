# Critique of `catch-exception-remediation-plan.md`

Reviewed against the actual codebase on `main` (2026-05-21). Spot-checks against `MozFacade.java`, `linkservice/KeycloakUserController.java`, and `userservice/RegistrationController.java` were used to validate the plan's claims; multiple claims do not hold up.

The plan is *directionally* reasonable — narrowing `catch (Exception e)` is a worthwhile hygiene exercise — but the **stated motivation is technically wrong**, several proposed catch types are **incorrect for the libraries actually in use**, and the testing/rollback story is **understated**. Treat it as a draft, not an execution-ready plan.

---

## 1. The headline motivation is factually wrong

The Objective states the change "prevents swallowing `InterruptedException`, `StackOverflowError`, `OutOfMemoryError`".

- `StackOverflowError` and `OutOfMemoryError` extend `Error`, not `Exception`. **`catch (Exception e)` does not catch them today.** Narrowing to `RuntimeException` (the plan's most common proposed type — items #2–#8, #29) likewise does not change this. The premise that the current code "swallows OOM/SOE" is false.
- `InterruptedException` *is* a real concern in code that calls `Thread.sleep`, `Playwright.waitFor*`, `Future.get`, `BlockingQueue.take`, etc. But many of the blocks the plan flags — `tokenRepo.save()`, `objectMapper.writeValueAsString()`, `auditRabbitTemplate.convertAndSend()` — **do not declare or throw `InterruptedException`** on the request thread. The "we might silently cancel a thread" argument is only load-bearing for items #15, #26, #27 (Moz HTTP + Playwright). For the rest the InterruptedException risk is essentially zero, and the rationale should be honest about that: "the change is cosmetic / defensive against future code edits", not "we are fixing a thread-interrupt bug".

The plan should be reframed around the *real* benefits — clearer documentation of what the call site actually throws, and making future maintenance safer when someone adds a `Thread.sleep` inside the try block — rather than overclaiming current harm.

## 2. Several proposed catch types are wrong for the libraries in use

### `WebApplicationException` is not what the Keycloak admin client throws

Items #16, #17, #18, #19, #21, #23, #25, #26, #27 all propose `catch (WebApplicationException e)`. The justification ("Keycloak admin client (Jersey-based)") is **disproved by the code itself**:

```java
// RegistrationController.java:122
} catch (HttpClientErrorException.Conflict e) {
    log.info("Registration rejected: email already exists in Keycloak: {}", email);
```

That line proves the `KeycloakAdminClient` wrapper bubbles up **Spring's `HttpClientErrorException`**, not Jersey's `WebApplicationException`. Narrowing to `WebApplicationException` on lines 128, 139, 201 would mean those catches **never fire** — Keycloak failures would become uncaught and short-circuit the compensation (Org deletion, user rollback) the plan is trying to preserve. **This is a correctness regression, not a hygiene improvement.**

The plan should grep for actual throw sites in `KeycloakAdminClient` and pick the real type. Likely candidates: `HttpClientErrorException` / `HttpServerErrorException` / `RestClientException`.

### `PersistenceException` is rarely what JPA-via-Spring throws

Items #20, #22, #24, #32 propose `catch (PersistenceException e)` for `tokenRepo.save()` / Envers reads. Spring Data wraps `javax.persistence.PersistenceException` into `org.springframework.dao.DataAccessException` (a `RuntimeException`) via the `PersistenceExceptionTranslationPostProcessor` that is enabled by default in Spring Boot. **The runtime exceptions you'll see at these sites are `DataAccessException` subclasses (e.g., `DataIntegrityViolationException`)**, not raw `PersistenceException`. Use `DataAccessException`.

### Item #15 (MozFacade) — narrowing as proposed would *break* current behaviour

The actual catch is at line **121**, not 112 (line numbers throughout the plan look stale — see §3). More importantly, the proposed narrow types miss exceptions the inner code explicitly throws:

```java
// MozFacade.java:98–124
try {
    ResponseEntity<...> response = restTemplate.exchange(...);
    if (response.getStatusCode().isError()) {
        throw new RuntimeException("Moz API returned " + response.getStatusCode().value());
    }
    ...
    if (response.getBody().getResults().length == 0) {
        throw new RuntimeException("No results for " + domain);
    }
    ...
}
catch (Exception e) { audit(user, domain, e); throw new RuntimeException(e); }
```

The outer `catch (Exception e)` is currently the **only place these `RuntimeException("Moz API returned …")` / `"No results for …"` throws are audited**. Narrowing to `HttpClientErrorException | HttpServerErrorException | ResourceAccessException | JsonProcessingException` would let those explicit `RuntimeException` paths escape *un-audited*, and would also miss a `NullPointerException` from `response.getBody().getResults()` when the body is null. Also note `JsonProcessingException` cannot occur in this outer catch — it's already caught and re-thrown by the inner try at line 94. The proposed narrowing is the wrong shape; either keep `Exception` here (and document why) or refactor so the explicit throws are also audited deliberately.

## 3. Line numbers are stale

Spot-checks show MozFacade is at 121 (plan: 112) and the linkservice `KeycloakUserController` catch behaviour at "line 111" no longer matches the file (the controller has been edited and is currently dirty in git status). Recommend regenerating the location list at the start of execution and verifying each one — otherwise the plan can't be safely applied as a sequence of mechanical edits.

## 4. "Category B / Quick Win" framing understates the risk and overstates the benefit

The plan calls items #2–#8 "quick wins" because they "already have the right behaviour". But:

- Narrowing to `RuntimeException` while keeping a swallow-and-log body is essentially a **no-op for runtime behaviour** (it catches almost the same set as `Exception`, since the only excluded thing is checked exceptions, none of which the listed APIs declare). So it's a hygiene change with little payoff and non-zero merge-conflict cost.
- Conversely, item #5 / #6 / #7 / #8 (audit emission) is exactly the kind of place where "best-effort + swallow" is itself a **silent audit-integrity bug**. The deeper question — "should audit emission failure be visible / retried / queued for replay?" — is not asked. The plan treats audit-event swallowing as "Category B already correct" when it's arguably the highest-value place to *not* swallow.

## 5. Testing strategy is too thin

> "Each narrowed catch changes the *exception type* but not the *behaviour* — existing tests should pass."

This is the wrong test to run. The point of narrowing is that *some* exception types should now propagate instead of being swallowed. The testing strategy should include at least one *negative* test per Phase-2 site: "if an unexpected exception X is thrown, the request now propagates / returns 500 rather than the previous swallow path." Without such a test the change is unobservable and easy to silently revert.

## 6. "Rollback is trivial" overstates safety

Pure type narrowing *is* trivial to revert. But the effect on production traffic is not: after Phase 2, exceptions that previously returned `503 SERVICE_UNAVAILABLE` (with compensation) may now propagate as `500` (no compensation, partial state left behind — half-created Keycloak users, dangling tokens, etc.). Rollback would require *redeploying*, by which time inconsistent state may already exist. The plan should call out: deploy Phase 2 to a non-prod environment first, monitor 5xx mix, and add structured logging for the newly-propagated exception types **before** the merge.

## 7. Smaller issues

- **Item #29** rationale: `catch (Exception)` *does* catch `InterruptedException` (it's a checked Exception). The justification "InterruptedException already caught separately above" only works if a `catch (InterruptedException)` block precedes it in the same try — please verify that's actually the case at line 252.
- **Item #33**: `ResponseStatusException` is a `RuntimeException` that Spring is designed to handle via its `ResponseEntityExceptionHandler`. Catching it locally is suspicious — what does the body do with it? Probably it should propagate. Re-examine whether the catch should exist at all.
- **Phase 4 "Keep as-is" table**: some of these (e.g. health probe, fire-and-forget webhook) would benefit from at least a **`// intentional: swallow everything because …`** comment so the next reviewer doesn't try to "fix" them.
- **Items #1, #18–25 in `RegistrationController` / `ResendVerificationController`**: these are *compensation* paths (delete user, delete org). A failure in compensation should arguably be **alerted on**, not just logged. Narrowing the catch is the smallest possible improvement; the bigger improvement is observability.

## 8. What I'd change before executing

1. **Rewrite the Objective** to drop the OOM/SOE claim and be honest that this is mostly hygiene + a few real Phase-2 fixes (Moz, Playwright).
2. **Regenerate locations** with current line numbers; add a one-line code excerpt under each item so reviewers don't have to open the file.
3. **Replace `WebApplicationException` with the actual type** — verify by reading `KeycloakAdminClient`. The Conflict catch at `RegistrationController:122` already tells you the answer.
4. **Replace `PersistenceException` with `DataAccessException`** for Spring-managed JPA call sites.
5. **Reconsider MozFacade #15** — either keep `Exception` or refactor the explicit `RuntimeException` throws inside the try so a narrow catch is feasible without losing audit coverage.
6. **Add negative tests** that prove the post-narrowing propagation works as intended.
7. **Demote the "audit emit" catches from Category B "no-op narrowing" to a follow-up question**: do we want a retry queue / DLQ for audit-event publish failures?
8. **Re-sequence**: do *one* Phase-2 item end-to-end (e.g., `MozFacade`) with a real test, deploy to non-prod, and confirm the rollout plan before batching the rest.

## TL;DR

- Motivation is overstated (OOM/SOE claim is wrong).
- At least one large class of fixes (`WebApplicationException` for Keycloak) is **demonstrably wrong** for this codebase and would regress error handling in the registration compensation path.
- `PersistenceException` is the wrong layer; use `DataAccessException`.
- Line numbers are stale.
- "Quick wins" in Category B are mostly no-ops; the **real** win in those blocks is questioning whether audit failures should be silently swallowed at all — a question the plan doesn't ask.
- Testing and rollback claims are too optimistic.

Narrowing exception catches is still a good idea. This plan is the right *shape* but needs a careful revision before it goes into PRs.
