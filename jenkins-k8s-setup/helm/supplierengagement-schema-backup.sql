--
-- PostgreSQL database dump
--

\restrict lgXy2bnYiB0BnWYayqeeIWD4oaSKS82IlgICsLjFbBSfTpXyg1sv0a51OrcHY60

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
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict lgXy2bnYiB0BnWYayqeeIWD4oaSKS82IlgICsLjFbBSfTpXyg1sv0a51OrcHY60

