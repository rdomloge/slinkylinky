# Sign-Up Feature — Stage 04: public registration UI

## Objective
Expose the self-serve sign-up flow through a polished public page that matches the existing unauthenticated login surface.

## Scope from `sign-up-planv2.md`
- Original Stage 4.

## Deliverables
- Public `/register` page.
- Route wiring in `App.jsx`.
- Sign-in page link to create an account.
- Registered-success toast on the login page.
- Flip `accounts.registration.enabled=true` so the public endpoint introduced in Stage 02 becomes reachable.
- Frontend tests for `pages/register/index.jsx`: required-field validation, email regex, password match, password length, submit POST shape, success navigation, `EMAIL_EXISTS` inline error, `429` inline error, spinner during submit.

## Step checklist
1. [ ] Build `frontend/react/src/pages/register/index.jsx` with the required fields, light-theme layout, and client-side validation.
2. [ ] Submit to `POST /.rest/accounts/registration` and handle success, `EMAIL_EXISTS`, and `429` states inline.
3. [ ] Add the `/register` route to `App.jsx` before protected routes.
4. [ ] Add the unauthenticated "Create an account" link in `Layout.jsx`.
5. [ ] Show the `registered=true` success toast on the login screen and strip the query param after display.
6. [ ] Set `accounts.registration.enabled=true` in `values.yaml` and any local `.env` / launch.json entries used for end-to-end testing. Confirm the endpoint goes from 503 to 201 once flipped.
7. [ ] Add Vitest + RTL tests for the registration page covering all listed scenarios.
8. [ ] Exercise the happy path and all major validation/error states in the browser locally.

## Local verification
- Visit `/register` without authentication and confirm the page renders correctly.
- Submit invalid input and confirm client-side validation messages.
- Submit a valid registration and confirm redirect to `/?registered=true` with the success toast.
- Force duplicate-email and rate-limit responses and confirm the inline error handling.
- Frontend test suite for the registration page passes.

## Exit criteria
- Public users can discover and use registration without a direct REST client.
- The sign-up screen visually matches the existing light unauthenticated experience.
- The `accounts.registration.enabled` flag is on in deployed environments where the UI ships.
- Registration page tests pass locally.

## Dependencies and notes
- Requires Stage 02 to be complete.
- Stage 03 does not have to be fully merged first, but the registration UI is much more useful once verification flow exists.
