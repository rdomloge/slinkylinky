--
-- schema-migration.sql
-- Idempotent migration — run after restoring a production backup into a tenant.
-- Uses \connect to apply migrations across all service databases in one pass.
-- Safe to run on old or new schema; all statements are IF NOT EXISTS / IF EXISTS.
--
-- IMPORTANT — Demo org UUID
-- A fixed UUID is used as the seed organisation for restored demo data:
--   00000000-0000-0000-0000-000000000001
-- The Keycloak realm for this tenant must have the org_id mapper configured
-- to emit this UUID in the org_id JWT claim, otherwise all queries will return
-- empty results (data exists but is scoped to a different org).
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

-- Step 3: Add missing columns to proposal / proposal_aud and paid_link_aud.
--   supplier_snapshot_version was added in v2.3 and is present in production.
--   supplier_snapshot and supplier_snapshot_revision were added later and may
--   be absent from older production backups.
--   All IF NOT EXISTS — no-ops when columns already exist.
ALTER TABLE IF EXISTS public.proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot          TEXT;
ALTER TABLE IF EXISTS public.proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot          TEXT;
ALTER TABLE IF EXISTS public.proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;
ALTER TABLE IF EXISTS public.proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;

-- Step 4 (v6.0): Create multi-tenancy support tables if not present.
--   These exist in new tenant deployments but not in pre-v6.0 production backups.
CREATE TABLE IF NOT EXISTS public.organisation (
    id         uuid                        NOT NULL,
    name       character varying(255)      NOT NULL,
    slug       character varying(100)      NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    active     boolean                     NOT NULL DEFAULT true,
    CONSTRAINT organisation_pkey        PRIMARY KEY (id),
    CONSTRAINT organisation_slug_unique UNIQUE (slug)
);

CREATE SEQUENCE IF NOT EXISTS public.supplier_tenant_exclusion_seq
    START WITH 1 INCREMENT BY 50 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE IF NOT EXISTS public.supplier_tenant_exclusion (
    id              bigint NOT NULL DEFAULT nextval('public.supplier_tenant_exclusion_seq'),
    supplier_id     bigint NOT NULL,
    organisation_id uuid   NOT NULL,
    CONSTRAINT supplier_tenant_exclusion_pkey PRIMARY KEY (id),
    CONSTRAINT ste_supplier_org_unique         UNIQUE (supplier_id, organisation_id),
    CONSTRAINT fk_ste_supplier     FOREIGN KEY (supplier_id)     REFERENCES public.supplier(id),
    CONSTRAINT fk_ste_organisation FOREIGN KEY (organisation_id) REFERENCES public.organisation(id)
);

-- Seed the demo organisation (no-op if one already exists from the backup).
INSERT INTO public.organisation (id, name, slug, created_at, active)
VALUES ('00000000-0000-0000-0000-000000000001', 'Demo', 'demo', NOW(), true)
ON CONFLICT DO NOTHING;

-- Step 5 (v6.1): Add organisation_id to all tenant-scoped tables.
--   All IF NOT EXISTS — no-ops on DBs already at v6.1.
ALTER TABLE IF EXISTS public.demand      ADD COLUMN IF NOT EXISTS organisation_id uuid;
ALTER TABLE IF EXISTS public.demand_site ADD COLUMN IF NOT EXISTS organisation_id uuid;
ALTER TABLE IF EXISTS public.proposal    ADD COLUMN IF NOT EXISTS organisation_id uuid;
ALTER TABLE IF EXISTS public.paid_link   ADD COLUMN IF NOT EXISTS organisation_id uuid;

ALTER TABLE IF EXISTS public.proposal_aud  ADD COLUMN IF NOT EXISTS organisation_id uuid;
ALTER TABLE IF EXISTS public.paid_link_aud ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- Step 6 (v6.1): Backfill organisation_id on all rows that have none.
--   Uses the seed org inserted above. Rows already stamped (from a partially-migrated
--   backup) are untouched by the WHERE organisation_id IS NULL guard.
DO $$
DECLARE
    v_org_id uuid;
BEGIN
    SELECT id INTO v_org_id FROM public.organisation ORDER BY created_at LIMIT 1;
    UPDATE public.demand       SET organisation_id = v_org_id WHERE organisation_id IS NULL;
    UPDATE public.demand_site  SET organisation_id = v_org_id WHERE organisation_id IS NULL;
    UPDATE public.proposal     SET organisation_id = v_org_id WHERE organisation_id IS NULL;
    UPDATE public.paid_link    SET organisation_id = v_org_id WHERE organisation_id IS NULL;
END;
$$;

-- Step 7 (v6.1): Replace paid_link_duplicate_check() with the multi-tenant version
--   that scopes uniqueness by organisation_id.
CREATE OR REPLACE FUNCTION public.paid_link_duplicate_check() RETURNS trigger
    LANGUAGE plpgsql AS $$
    BEGIN
        IF tg_table_name = 'paid_link' AND tg_op = 'INSERT' THEN
            IF EXISTS (
                SELECT 1 FROM paid_link pl
                JOIN demand d   ON pl.demand_id      = d.id
                JOIN demand_site ds ON d.demand_site_id = ds.id
                JOIN supplier s ON s.id              = pl.supplier_id
                WHERE s.id                = new.supplier_id
                  AND pl.organisation_id  = new.organisation_id
                  AND ds.domain           = (
                        SELECT innerds.domain
                        FROM demand_site innerds
                        JOIN demand innerd ON innerd.demand_site_id = innerds.id
                        WHERE innerd.id = new.demand_id
                    )
            ) THEN
                RAISE EXCEPTION 'A paid link already exists between the supplier domain and the demand site domain within this organisation';
            END IF;
        END IF;
        RETURN new;
    END;
$$;

-- Step 8 (v6.2): Performance indexes for organisation_id columns.
CREATE INDEX IF NOT EXISTS idx_demand_org      ON public.demand(organisation_id);
CREATE INDEX IF NOT EXISTS idx_demand_site_org ON public.demand_site(organisation_id);
CREATE INDEX IF NOT EXISTS idx_proposal_org    ON public.proposal(organisation_id);
CREATE INDEX IF NOT EXISTS idx_paid_link_org   ON public.paid_link(organisation_id);

-- -----------------------------------------------------------------------
-- supplierengagement database
-- -----------------------------------------------------------------------
\connect supplierengagement

-- Step 9 (v6.1): Add organisation_id to engagement table.
--   Pre-v6.1 production backups will not have this column.
ALTER TABLE IF EXISTS public.engagement ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- Backfill: stamp all un-scoped rows with the demo org UUID.
UPDATE public.engagement SET organisation_id = '00000000-0000-0000-0000-000000000001' WHERE organisation_id IS NULL;

-- Step 10 (v6.2): Performance index.
CREATE INDEX IF NOT EXISTS idx_engagement_org ON public.engagement USING btree (organisation_id);

