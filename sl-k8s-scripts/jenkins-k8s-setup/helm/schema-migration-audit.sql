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

-- Step 3 (v6.3): Explicitly ensure organisation_id is nullable.
--   Guards against any environment where a NOT NULL constraint was manually added.
--   Required for action events (login, scrape start) that do not upsert a DB entity
--   and therefore have no organisation_id scope.
ALTER TABLE IF EXISTS public.audit_record ALTER COLUMN organisation_id DROP NOT NULL;

-- Step 4 (v6.4): Migrate entity_id from bigint to text.
--   Supports numeric IDs (converted to decimal strings), UUIDs (as canonical strings),
--   and external string IDs (e.g., Keycloak UUIDs).
--   Idempotent: check current column type before altering.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'audit_record' AND column_name = 'entity_id' AND data_type = 'bigint'
  ) THEN
    ALTER TABLE public.audit_record ALTER COLUMN entity_id TYPE text USING entity_id::text;
  END IF;
END $$;
