--
-- schema-migration-audit.sql
-- Idempotent migration for audit service database — run after restoring a production backup.
-- Safe to run on old or new schema; all statements use IF NOT EXISTS / IF EXISTS.
--

-- Step 1 (v6.1): Add organisation_id column to audit_record if not present.
--   Pre-v6.1 production backups will not have this column.
ALTER TABLE IF EXISTS public.audit_record ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- Step 2 (v6.2): Create performance index for organisation_id.
CREATE INDEX IF NOT EXISTS idx_audit_org ON public.audit_record USING btree (organisation_id);
