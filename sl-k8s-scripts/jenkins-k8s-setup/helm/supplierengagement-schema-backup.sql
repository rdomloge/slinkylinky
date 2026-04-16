--
-- PostgreSQL database dump
--

\restrict J02Tygg3BgbchzTzLrLrKBXOyIZFYpbkhkQsLvsEfYqLRaLhBSBjQWEfpBbYrxT

-- Dumped from database version 16.6 (Debian 16.6-1.pgdg120+1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit_record_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_record_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: engagement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.engagement (
    do_not_contact boolean NOT NULL,
    supplier_we_write_fee integer NOT NULL,
    id bigint NOT NULL,
    proposal_id bigint NOT NULL,
    supplier_email_sent timestamp(6) without time zone,
    blog_title character varying(255),
    blog_url character varying(255),
    declined_reason character varying(255),
    guid character varying(255),
    status character varying(255),
    supplier_email character varying(255),
    supplier_name character varying(255),
    supplier_we_write_fee_currency character varying(255),
    supplier_website character varying(255),
    article text,
    invoice_url character varying(512),
    organisation_id uuid,
    CONSTRAINT engagement_status_check CHECK (((status)::text = ANY (ARRAY[('NEW'::character varying)::text, ('ACCEPTED'::character varying)::text, ('DECLINED'::character varying)::text, ('CANCELLED'::character varying)::text, ('EXPIRED'::character varying)::text])))
);


--
-- Name: engagement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.engagement_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: engagement engagement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.engagement
    ADD CONSTRAINT engagement_pkey PRIMARY KEY (id);


--
-- Name: idx_engagement_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_engagement_org ON public.engagement USING btree (organisation_id);


--
-- Name: supplier_lead_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supplier_lead_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_lead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_lead (
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
    CONSTRAINT supplier_lead_pkey PRIMARY KEY (id),
    CONSTRAINT supplier_lead_guid_unique UNIQUE (guid),
    CONSTRAINT supplier_lead_status_check CHECK (
        status IN ('NEW','SEARCHING','BROWSER_QUEUED','CONTACT_FOUND','CONTACT_NOT_FOUND','OUTREACH_SENT','ACCEPTED','DECLINED','CONVERTED')
    )
);

CREATE TABLE public.supplier_lead_category (
    lead_id  bigint       NOT NULL REFERENCES public.supplier_lead(id) ON DELETE CASCADE,
    category varchar(255) NOT NULL
);

CREATE INDEX idx_supplier_lead_category_lead_id ON public.supplier_lead_category USING btree (lead_id);


--
-- Name: idx_supplier_lead_domain; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_supplier_lead_domain ON public.supplier_lead USING btree (domain);


--
-- Name: idx_supplier_lead_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_supplier_lead_status ON public.supplier_lead USING btree (status);


--
-- Name: idx_supplier_lead_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_supplier_lead_guid ON public.supplier_lead USING btree (guid);


--
-- Name: idx_supplier_lead_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_supplier_lead_source ON public.supplier_lead USING btree (source);


--
-- Name: collaborator_category_mapping_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collaborator_category_mapping_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collaborator_category_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collaborator_category_mapping (
    id                    bigint        NOT NULL DEFAULT nextval('public.collaborator_category_mapping_seq'),
    collaborator_category varchar(255)  NOT NULL,
    sl_category_id        bigint,
    sl_category_name      varchar(255),
    status                varchar(20)   NOT NULL DEFAULT 'PENDING',
    created_at            timestamp(6)  NOT NULL DEFAULT now(),
    updated_at            timestamp(6)  NOT NULL DEFAULT now(),
    CONSTRAINT collaborator_category_mapping_pkey PRIMARY KEY (id),
    CONSTRAINT collaborator_category_unique UNIQUE (collaborator_category),
    CONSTRAINT collaborator_category_mapping_status_check
        CHECK (status IN ('PENDING', 'MAPPED', 'IGNORED'))
);


--
-- Name: idx_cat_mapping_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cat_mapping_status ON public.collaborator_category_mapping USING btree (status);


--
-- Name: scraping_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scraping_metadata (
    source            varchar(100)  NOT NULL,
    last_offset       integer       NOT NULL DEFAULT 0,
    last_scraped_at   timestamp(6)  without time zone,
    CONSTRAINT scraping_metadata_pkey PRIMARY KEY (source)
);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict J02Tygg3BgbchzTzLrLrKBXOyIZFYpbkhkQsLvsEfYqLRaLhBSBjQWEfpBbYrxT

