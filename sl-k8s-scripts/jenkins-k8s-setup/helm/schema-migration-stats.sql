--
-- schema-migration-stats.sql
-- Idempotent stats-database migrations — run as stats_user after restoring a production backup.
-- Safe to run on old or new schema; all statements are IF NOT EXISTS.
--

-- Step 1: Create supplier_responsiveness table if absent.
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
GRANT SELECT, INSERT, UPDATE, DELETE ON public.supplier_responsiveness TO stats_user;
GRANT USAGE, SELECT ON SEQUENCE public.supplier_responsiveness_id_seq TO stats_user;
