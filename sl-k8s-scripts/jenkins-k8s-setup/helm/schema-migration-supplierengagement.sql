--
-- schema-migration-supplierengagement.sql
-- Idempotent migration for supplierengagement service database — run after restoring a production backup.
-- Safe to run on old or new schema; all statements use IF NOT EXISTS / IF EXISTS.
--

-- Step 9 (v6.1): Add organisation_id to engagement table.
--   Pre-v6.1 production backups will not have this column.
ALTER TABLE IF EXISTS public.engagement ADD COLUMN IF NOT EXISTS organisation_id uuid;

-- Backfill: stamp all un-scoped rows with the demo org UUID.
UPDATE public.engagement SET organisation_id = '00000000-0000-0000-0000-000000000001' WHERE organisation_id IS NULL;

-- Step 10 (v6.2): Performance index.
CREATE INDEX IF NOT EXISTS idx_engagement_org ON public.engagement USING btree (organisation_id);

-- Step 11: Create tables introduced after the production backup was taken.
--   All statements are IF NOT EXISTS — no-ops on already-migrated databases.

CREATE SEQUENCE IF NOT EXISTS public.supplier_lead_seq
    START WITH 1 INCREMENT BY 50 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE IF NOT EXISTS public.supplier_lead (
    id             bigint        NOT NULL DEFAULT nextval('public.supplier_lead_seq'),
    source         varchar(255)  NOT NULL DEFAULT 'collaborator.pro',
    domain         varchar(512)  NOT NULL,
    price          numeric(10,2),
    currency       varchar(10),
    countries      varchar(512),
    language       varchar(255),
    contact_email  varchar(255),
    outreach_sent  timestamp(6)  without time zone,
    guid           varchar(255),
    status         varchar(50)   NOT NULL DEFAULT 'NEW',
    file_blob      bytea,
    file_name      varchar(255),
    google_doc_url varchar(1024),
    decline_reason varchar(255),
    scraped_at     timestamp(6)  without time zone NOT NULL DEFAULT now(),
    CONSTRAINT supplier_lead_pkey        PRIMARY KEY (id),
    CONSTRAINT supplier_lead_guid_unique UNIQUE (guid),
    CONSTRAINT supplier_lead_status_check CHECK (
        status IN ('NEW','SEARCHING','BROWSER_QUEUED','CONTACT_FOUND','CONTACT_NOT_FOUND','OUTREACH_SENT','ACCEPTED','DECLINED','CONVERTED')
    )
);

CREATE TABLE IF NOT EXISTS public.supplier_lead_category (
    lead_id  bigint       NOT NULL REFERENCES public.supplier_lead(id) ON DELETE CASCADE,
    category varchar(255) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_supplier_lead_category_lead_id ON public.supplier_lead_category USING btree (lead_id);
CREATE INDEX IF NOT EXISTS idx_supplier_lead_domain           ON public.supplier_lead USING btree (domain);
CREATE INDEX IF NOT EXISTS idx_supplier_lead_status           ON public.supplier_lead USING btree (status);
CREATE INDEX IF NOT EXISTS idx_supplier_lead_guid             ON public.supplier_lead USING btree (guid);
CREATE INDEX IF NOT EXISTS idx_supplier_lead_source           ON public.supplier_lead USING btree (source);

CREATE SEQUENCE IF NOT EXISTS public.collaborator_category_mapping_seq
    START WITH 1 INCREMENT BY 50 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE TABLE IF NOT EXISTS public.collaborator_category_mapping (
    id                    bigint        NOT NULL DEFAULT nextval('public.collaborator_category_mapping_seq'),
    collaborator_category varchar(255)  NOT NULL,
    sl_category_id        bigint,
    sl_category_name      varchar(255),
    status                varchar(20)   NOT NULL DEFAULT 'PENDING',
    created_at            timestamp(6)  NOT NULL DEFAULT now(),
    updated_at            timestamp(6)  NOT NULL DEFAULT now(),
    CONSTRAINT collaborator_category_mapping_pkey   PRIMARY KEY (id),
    CONSTRAINT collaborator_category_unique         UNIQUE (collaborator_category),
    CONSTRAINT collaborator_category_mapping_status_check
        CHECK (status IN ('PENDING', 'MAPPED', 'IGNORED'))
);

CREATE INDEX IF NOT EXISTS idx_cat_mapping_status ON public.collaborator_category_mapping USING btree (status);

CREATE TABLE IF NOT EXISTS public.scraping_metadata (
    source          varchar(100) NOT NULL,
    last_offset     integer      NOT NULL DEFAULT 0,
    last_scraped_at timestamp(6) without time zone,
    CONSTRAINT scraping_metadata_pkey PRIMARY KEY (source)
);

-- Step 12: Grant supplierengagement_user access to all tables and sequences.
--   Tables created above are owned by the postgres superuser; the application
--   user has no access until explicitly granted.
GRANT ALL ON ALL TABLES    IN SCHEMA public TO supplierengagement_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO supplierengagement_user;
