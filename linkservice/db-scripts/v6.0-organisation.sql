-- v6.0 multi-tenancy: add organisation and supplier_tenant_exclusion tables
-- Run against the slinkylinky database (linkservice_user).
-- Insert at least one Organisation row before running v6.1-add-organisation-id.sql.

CREATE TABLE IF NOT EXISTS public.organisation (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(100) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    active boolean NOT NULL DEFAULT true,
    CONSTRAINT organisation_pkey PRIMARY KEY (id),
    CONSTRAINT organisation_slug_unique UNIQUE (slug)
);

CREATE SEQUENCE IF NOT EXISTS public.supplier_tenant_exclusion_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.supplier_tenant_exclusion (
    id bigint NOT NULL DEFAULT nextval('public.supplier_tenant_exclusion_seq'),
    supplier_id bigint NOT NULL,
    organisation_id uuid NOT NULL,
    CONSTRAINT supplier_tenant_exclusion_pkey PRIMARY KEY (id),
    CONSTRAINT ste_supplier_org_unique UNIQUE (supplier_id, organisation_id),
    CONSTRAINT fk_ste_supplier FOREIGN KEY (supplier_id) REFERENCES public.supplier(id),
    CONSTRAINT fk_ste_organisation FOREIGN KEY (organisation_id) REFERENCES public.organisation(id)
);

-- Example: insert the first organisation (replace UUID with your actual value)
-- INSERT INTO public.organisation (id, name, slug, created_at, active)
-- VALUES ('00000000-0000-0000-0000-000000000001', 'My Company', 'my-company', NOW(), true);
