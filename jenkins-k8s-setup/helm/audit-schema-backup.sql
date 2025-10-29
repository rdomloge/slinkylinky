--
-- PostgreSQL database dump
--

\restrict u4rKcgZg5dGcl4RtQZYMfxs92WstECDAcKgzUkFWThtZIVJ6DU0jAfkUlsuX069

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_record; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_record (
    entity_id bigint,
    event_time timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    entity_type character varying(255),
    what character varying(255),
    who character varying(255),
    detail text
);


--
-- Name: audit_record_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_record_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_record audit_record_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_record
    ADD CONSTRAINT audit_record_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict u4rKcgZg5dGcl4RtQZYMfxs92WstECDAcKgzUkFWThtZIVJ6DU0jAfkUlsuX069

