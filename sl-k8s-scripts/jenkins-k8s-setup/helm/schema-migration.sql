--
-- schema-migration.sql
-- Idempotent migration — run inside Jenkins new-tenant pipeline AFTER backup files are loaded.
-- Safe to run on old schema (with demand_domain/supplier_domain) or new schema (without).
--

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
