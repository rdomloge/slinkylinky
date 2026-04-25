# Sign-Up Feature — Stage 07: integration test and coverage wiring

## Objective
Add the cross-cutting end-to-end integration test for the sign-up lifecycle and wire JaCoCo / coverage reporting for `userservice` and `sl-common`. Per-component unit tests now ship inside their owning stages (02–06); this stage covers only what genuinely cannot be tested in isolation.

## Scope from `sign-up-planv2.md`
- Stage 8's `RegistrationFlowIT` integration test only.
- Coverage tooling and reporting wiring referenced in original Stage 8.

## Deliverables
- `RegistrationFlowIT` in `userservice`: Spring Boot `@SpringBootTest` with H2, WireMock-backed Keycloak, and `GreenMail` for SMTP. Covers the full happy path (register → email received → click verification link → verified) and at least one failure-injection scenario that exercises the compensation matrix end-to-end.
- JaCoCo plugin configuration for `userservice` and (if not already present) `sl-common`.
- Coverage report published to the build output directory in a format reviewers can open locally.

## Step checklist
1. [ ] Add `GreenMail`, WireMock, and any missing test scopes to `userservice/pom.xml`.
2. [ ] Implement `RegistrationFlowIT` covering: happy-path register → verify; duplicate-email 409; one compensation path (e.g., role-assign failure → user disabled, org deleted).
3. [ ] Add JaCoCo plugin configuration to `userservice/pom.xml` and `sl-common/pom.xml` if not already inherited from a parent. Mirror the configuration of any existing service that already publishes coverage.
4. [ ] Run `mvn -pl userservice -am verify` (and equivalent for `sl-common`) and inspect the generated coverage report.
5. [ ] Record the per-class coverage numbers for new classes in the PR description so reviewers can spot uncovered branches.

## Local verification
- `mvn -pl userservice -am verify` runs `RegistrationFlowIT` green.
- JaCoCo HTML report exists at the expected output path and shows new classes with non-zero coverage.

## Exit criteria
- The full registration-to-verified flow is exercised end-to-end by an automated test.
- Coverage numbers for new code are visible to reviewers.

## Dependencies and notes
- Per-component unit tests are NOT in this stage. Each feature stage (02–06) ships its own unit tests as part of its exit criteria. If you reach this stage and find a feature stage without unit tests, that's a Stage 02–06 bug; fix it there, not here.
- Coverage is reported, not enforced. Treat low coverage on new code as a reviewer-gated blocker, not a CI-blocker — the goal is to surface gaps, not to game percentages.
