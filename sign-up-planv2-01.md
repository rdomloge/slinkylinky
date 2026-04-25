# Sign-Up Feature — Stage 01: userservice foundation and route split

## Objective
Establish the new `userservice` module and move organisation and Keycloak-admin ownership out of `linkservice` without changing end-user behaviour.

## Scope from `sign-up-planv2.md`
- Original Stage 1 only.

## Deliverables
- New Spring Boot `userservice` module on port `8095`.
- Moved organisation and Keycloak-admin controllers, entities, repos, and security wiring.
- Repo-wide plumbing for build, proxying, local launch, and cluster routing.
- Frontend admin pages switched to `/.rest/accounts/*`.

## Step checklist
1. [ ] Create `userservice/` with baseline dependencies, config, and application bootstrap.
2. [ ] Move `KeycloakAdminClient`, organisation management, and Keycloak user admin endpoints from `linkservice` into `userservice`.
3. [ ] Leave `linkservice` with read-only organisation access and add the ownership comment on its repo.
4. [ ] Register `userservice` in root `pom.xml`, `vite.config.js`, Helm values, Helm Jenkinsfile tunnel routes, and `.vscode/launch.json`.
5. [ ] Update `frontend/react/src/pages/organisations/index.jsx` and `frontend/react/src/pages/users/index.jsx` to call `/.rest/accounts/*`.
6. [ ] Boot the service locally and smoke-test the moved admin flows.

## Local verification
- `mvn -pl userservice -am test`
- Start `userservice` locally on `8095` and confirm the moved admin endpoints respond.
- Run the frontend against the dev proxy and verify the organisations and users admin pages still load.

## Exit criteria
- `userservice` builds locally and is wired into the repo toolchain.
- Admin organisation and Keycloak-user flows are served from `/.rest/accounts/*`.
- No user-facing sign-up flow exists yet; this is the foundation cut.

## Dependencies and notes
- Do not start public registration work until this stage is green.
- `linkservice` does not retain the Organisation entity — it uses `org_id` from the JWT for all tenant filtering. No Organisation code remains in `linkservice`.
