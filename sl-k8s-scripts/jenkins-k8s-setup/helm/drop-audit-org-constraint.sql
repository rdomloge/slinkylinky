--
-- drop-audit-org-constraint.sql
-- Ensures organisation_id column in audit_record is nullable.
-- Safe to run repeatedly; idempotent.
--

-- Drop NOT NULL constraint if present
ALTER TABLE IF EXISTS public.audit_record ALTER COLUMN organisation_id DROP NOT NULL;

-- Verify the column is now nullable
-- SELECT column_name, is_nullable FROM information_schema.columns
-- WHERE table_name = 'audit_record' AND column_name = 'organisation_id';
