# Sign-Up Feature — Stage 05: audit coverage and access cleanup

## Objective
Make the new public flows observable in audit and remove legacy tenant-selection affordances from non-global-admin users.

## Scope from `sign-up-planv2.md`
- Original Stage 5, excluding the stage-7 overview read audit which ships with the overview page.
- Original Stage 6.

## Deliverables
- Audit conventions updated for unauthenticated sign-up flows.
- Audit emission for registration, verification, and resend paths is in place (this stage confirms emission already shipped with Stages 02 and 03 conforms to the updated conventions).
- Non-global-admin users no longer see or retain tenant override UI state.
- Frontend test for `TenantOverrideContext.jsx`: clears `sl_tenant_override` for non-`global_admin` on mount; leaves it intact for `global_admin`.

## Step checklist
1. [ ] Update `audit/CLAUDE.md` with the unauthenticated `who` rule and the new `what` values for registration, verification, and verification-email send.
2. [ ] Cross-check audit emission shipped in Stages 02 and 03 against the updated conventions; correct any drift.
3. [ ] Update `frontend/react/src/components/TenantBadge.jsx` so non-`global_admin` users get no org badge output.
4. [ ] Update `frontend/react/src/auth/TenantOverrideContext.jsx` to clear `sl_tenant_override` for non-`global_admin` users on mount.
5. [ ] Add the Vitest + RTL test for `TenantOverrideContext.jsx` covering both role branches.
6. [ ] Verify audit records and front-end role-based behaviour locally.

## Local verification
- Exercise registration, verify-email, and resend flows and inspect emitted audit events.
- Sign in as a non-global-admin and confirm the tenant badge is absent and the session override is cleared.
- Sign in as a `global_admin` and confirm the tenant switching experience remains intact.
- Frontend test for `TenantOverrideContext.jsx` passes locally.

## Exit criteria
- Public account flows have an agreed audit contract.
- Non-global-admin users no longer get misleading tenant-override UI behaviour.
- New frontend test for `TenantOverrideContext.jsx` passes.

## Dependencies and notes
- Best implemented after Stages 02 and 03 because the underlying flows then exist.
