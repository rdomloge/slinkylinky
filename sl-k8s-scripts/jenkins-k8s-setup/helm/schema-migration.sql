--
-- schema-migration.sql
-- Idempotent migration — run after restoring a production backup into a tenant.
-- Uses \connect to apply migrations across all service databases in one pass.
-- Safe to run on old or new schema; all statements are IF NOT EXISTS / IF EXISTS.
--

-- -----------------------------------------------------------------------
-- slinkylinky database
-- -----------------------------------------------------------------------
\connect slinkylinky

-- Step 1: Remove old paid_link domain denormalisation columns.
--   The paidlink_demand_supplier unique constraint must be dropped before its columns.
--   All three statements are no-ops (IF EXISTS) on databases already migrated.
ALTER TABLE IF EXISTS public.paid_link DROP CONSTRAINT IF EXISTS paidlink_demand_supplier;
ALTER TABLE IF EXISTS public.paid_link DROP COLUMN IF EXISTS demand_domain;
ALTER TABLE IF EXISTS public.paid_link DROP COLUMN IF EXISTS supplier_domain;

-- Step 2: Wire up the existing paid_link_duplicate_check() function as a trigger.
--   The function is already defined in slinkylinky-schema-backup.sql but was never applied.
--   DROP + CREATE is safe and idempotent.
DROP TRIGGER IF EXISTS paid_link_duplicate_check_trigger ON public.paid_link;
CREATE TRIGGER paid_link_duplicate_check_trigger
    BEFORE INSERT ON public.paid_link
    FOR EACH ROW EXECUTE FUNCTION public.paid_link_duplicate_check();

-- Step 3: Add supplier snapshot columns to proposal / proposal_aud.
--   supplier_snapshot_version was added in v2.3 and is present in production.
--   supplier_snapshot and supplier_snapshot_revision were added later and may
--   be absent from older production backups. All IF NOT EXISTS — no-ops when
--   columns already exist.
ALTER TABLE IF EXISTS public.proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot          TEXT;
ALTER TABLE IF EXISTS public.proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot          TEXT;
ALTER TABLE IF EXISTS public.proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;
ALTER TABLE IF EXISTS public.proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;

-- -----------------------------------------------------------------------
-- stats database
-- -----------------------------------------------------------------------
\connect stats

-- Step 4: Create supplier_responsiveness table if absent.
--   Added after the production stats database was last backed up, so it is
--   missing from restored tenants. IF NOT EXISTS — no-op on new tenants.
CREATE TABLE IF NOT EXISTS public.supplier_responsiveness (
    id bigserial PRIMARY KEY,
    supplier_id bigint NOT NULL UNIQUE,
    domain character varying(255),
    avg_response_days double precision NOT NULL DEFAULT 0,
    sample_size integer NOT NULL DEFAULT 0,
    last_calculated timestamp without time zone
);
CREATE INDEX IF NOT EXISTS idx_responsiveness_supplier_id ON public.supplier_responsiveness (supplier_id);
CREATE INDEX IF NOT EXISTS idx_responsiveness_domain      ON public.supplier_responsiveness (domain);
