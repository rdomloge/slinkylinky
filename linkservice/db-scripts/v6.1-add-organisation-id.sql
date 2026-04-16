-- v6.1 — Add organisation_id to tenant-scoped tables
-- Run AFTER v6.0-organisation.sql and after at least one Organisation row exists.
--
-- Migration order:
--   1. Add columns as nullable
--   2. Backfill from the first (or only) organisation row
--   3. Make NOT NULL
--   4. Update paid_link uniqueness constraint to be per-tenant
--   5. Update paid_link_duplicate_check() trigger to scope by organisation_id
--
-- Replace '<existing-org-uuid>' with the actual UUID of the root organisation before running.
-- Example: SELECT id FROM organisation LIMIT 1;

-- ─── Step 1: Add nullable columns ────────────────────────────────────────────

ALTER TABLE public.demand
    ADD COLUMN IF NOT EXISTS organisation_id uuid;

ALTER TABLE public.demand_site
    ADD COLUMN IF NOT EXISTS organisation_id uuid;

ALTER TABLE public.proposal
    ADD COLUMN IF NOT EXISTS organisation_id uuid;

ALTER TABLE public.paid_link
    ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- ─── Step 1b: Patch Envers audit tables ──────────────────────────────────────
-- Both Proposal and PaidLink are @Audited. Envers mirrors every mapped column
-- into the _aud shadow table. organisation_id must be added here too.

ALTER TABLE IF EXISTS public.proposal_aud  ADD COLUMN IF NOT EXISTS organisation_id uuid;
ALTER TABLE IF EXISTS public.paid_link_aud ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- ─── Step 2: Backfill ─────────────────────────────────────────────────────────
-- Replace '<existing-org-uuid>' with the real UUID before running.

-- UPDATE public.demand       SET organisation_id = '<existing-org-uuid>'::uuid WHERE organisation_id IS NULL;
-- UPDATE public.demand_site  SET organisation_id = '<existing-org-uuid>'::uuid WHERE organisation_id IS NULL;
-- UPDATE public.proposal     SET organisation_id = '<existing-org-uuid>'::uuid WHERE organisation_id IS NULL;
-- UPDATE public.paid_link    SET organisation_id = '<existing-org-uuid>'::uuid WHERE organisation_id IS NULL;

-- ─── Step 3: Make NOT NULL (run AFTER backfill is verified) ───────────────────

-- ALTER TABLE public.demand      ALTER COLUMN organisation_id SET NOT NULL;
-- ALTER TABLE public.demand_site ALTER COLUMN organisation_id SET NOT NULL;
-- ALTER TABLE public.proposal    ALTER COLUMN organisation_id SET NOT NULL;
-- ALTER TABLE public.paid_link   ALTER COLUMN organisation_id SET NOT NULL;

-- ─── Step 4: Per-tenant paid_link uniqueness ──────────────────────────────────
-- The existing paidlink_demand_supplier constraint (if present) is global.
-- Drop it and rely on the trigger (which will be updated in Step 5) for per-tenant uniqueness.

-- ALTER TABLE public.paid_link DROP CONSTRAINT IF EXISTS paidlink_demand_supplier;

-- ─── Step 5: Update paid_link_duplicate_check() to scope by organisation_id ───
-- Run AFTER Step 3 (organisation_id is NOT NULL).

CREATE OR REPLACE FUNCTION public.paid_link_duplicate_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        if tg_table_name = 'paid_link' and tg_op = 'INSERT' then
            if exists (select 1 from paid_link pl
                        join demand d on pl.demand_id = d.id
                        join demand_site ds on d.demand_site_id = ds.id
                        join supplier s on s.id=pl.supplier_id
                        where s.id = new.supplier_id
                          and pl.organisation_id = new.organisation_id
                          and ds.domain = (
                                select innerds.domain
                                from demand_site innerds
                                join demand innerd on innerd.demand_site_id = innerds.id
                                where innerd.id = new.demand_id
                            )
                        ) then
                raise exception 'A paid link already exists between the supplier domain and the demand site domain within this organisation';
            end if;
        end if;
       return new;
    end;
    $$;
