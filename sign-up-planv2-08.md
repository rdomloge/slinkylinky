# Sign-Up Feature — Stage 08: CI/CD and deployment wiring

## Objective
Make the new service and UI changes build, test, package, and deploy through the existing pipeline without manual intervention.

## Scope from `sign-up-planv2.md`
- Original Stage 9.

## Deliverables
- `userservice` Dockerfile.
- Helm deployment template and completed values.
- Main build Jenkinsfile updates for build, test, Docker, and report publishing.
- Helm Jenkinsfile updates for deploy list, secrets, and Cloudflare routing.
- Any required frontend CI test stage adjustment.

## Step checklist
1. [ ] Add `userservice/Dockerfile` following the existing multi-stage service pattern.
2. [ ] Add the Helm deployment template and complete the `userservice` values block.
3. [ ] Update the main build Jenkinsfile to build, test, report on, dockerise, and push `userservice`, keeping the existing parallel-test structure.
4. [ ] Update the Helm deploy Jenkinsfile to deploy `userservice`, propagate any required secrets, and install the `/.rest/accounts/*` ingress rule ahead of the catch-all.
5. [ ] Confirm existing schema-migration stages will pick up the Stage 02 table changes without extra work.
6. [ ] Check whether frontend CI already runs tests; add the appropriate test stage only if it does not already exist.
7. [ ] Regenerate index docs (`node scripts/gen-docs.js` or, from `frontend/react/`, `npm run gen-docs`) and commit the updated `docs/frontend-components.md`, `docs/frontend-pages.md`, `docs/backend-entities.md`, and `docs/backend-api.md` as part of this stage's PR. CLAUDE.md requires this after structural changes; this stage delivers structural changes (a new service, new endpoints, new pages, new entities).
8. [ ] Run representative local build/test commands and validate the generated deployment artefacts.

## Local verification
- Root-level Maven build including `userservice`.
- Frontend build/test command(s).
- Docker build for `userservice`.
- Helm template or lint validation for the new deployment manifest.
- Regenerated index docs reflect new userservice endpoints, registration/verify-email/admin pages, and `EmailVerificationToken` entity.

## Exit criteria
- `userservice` participates in the standard build-and-deploy flow.
- Cluster routing sends `/.rest/accounts/*` traffic to `userservice` without disturbing existing `/.rest/*` traffic.
- Index docs are regenerated and committed.

## Dependencies and notes
- Index doc regeneration is mandatory under CLAUDE.md ("Regenerate after significant structural changes"). The sign-up feature is a significant structural change.
