--
-- Idempotent migration for the userservice database.
-- Safe to run on any existing userservice schema.
-- Applied to the `userservice` database as `userservice_user`
--

--
-- Create organisation table if this is an upgrade from before userservice had its own DB.
--
CREATE TABLE IF NOT EXISTS public.organisation (
    id          uuid                        NOT NULL,
    name        character varying(255)      NOT NULL,
    slug        character varying(100)      NOT NULL,
    created_at  timestamp without time zone NOT NULL,
    active      boolean                     NOT NULL DEFAULT true
);

ALTER TABLE public.organisation
    ADD CONSTRAINT IF NOT EXISTS organisation_pkey PRIMARY KEY (id);

ALTER TABLE public.organisation
    ADD CONSTRAINT IF NOT EXISTS organisation_slug_key UNIQUE (slug);

--
-- Create email_verification_token table (Stage 3).
--
CREATE TABLE IF NOT EXISTS public.email_verification_token (
    token_hash  character(64)               NOT NULL,
    user_id     character varying(255)      NOT NULL,
    email       character varying(254)      NOT NULL,
    org_id      uuid                        NOT NULL,
    expires_at  timestamp without time zone NOT NULL,
    used        boolean                     NOT NULL DEFAULT false,
    created_at  timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE public.email_verification_token
    ADD CONSTRAINT IF NOT EXISTS email_verification_token_pkey PRIMARY KEY (token_hash);

CREATE INDEX IF NOT EXISTS idx_evt_user_id    ON public.email_verification_token USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_evt_expires_at ON public.email_verification_token USING btree (expires_at);

--
-- DATA MIGRATION NOTE (existing tenants only)
-- If upgrading a tenant whose organisation rows currently live in the slinkylinky DB,
-- copy them to this database before decommissioning the old table.
-- Run this once manually (or via a one-off Jenkinsfile step) against a running Postgres
-- that has both databases accessible:
--
--   PGPASSWORD=<linkservice_pw> psql -h localhost -U linkservice_user -d slinkylinky \
--     -c "COPY public.organisation TO STDOUT" | \
--   PGPASSWORD=<userservice_pw> psql -h localhost -U userservice_user -d userservice \
--     -c "COPY public.organisation FROM STDIN"
--
-- This is a one-time operation per tenant and is idempotent if the destination table is empty.
--
