--
-- userservice database schema
-- Applied to the `userservice` database as `userservice_user`
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: organisation; Type: TABLE; Schema: public
--

CREATE TABLE public.organisation (
    id          uuid                        NOT NULL,
    name        character varying(255)      NOT NULL,
    slug        character varying(100)      NOT NULL,
    created_at  timestamp without time zone NOT NULL,
    active      boolean                     NOT NULL DEFAULT true
);

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_slug_key UNIQUE (slug);

--
-- Name: email_verification_token; Type: TABLE; Schema: public
-- Stage 3: used by the email verification flow
--

CREATE TABLE public.email_verification_token (
    token_hash  character(64)               NOT NULL,
    user_id     character varying(255)      NOT NULL,
    email       character varying(254)      NOT NULL,
    org_id      uuid                        NOT NULL,
    expires_at  timestamp without time zone NOT NULL,
    used        boolean                     NOT NULL DEFAULT false,
    created_at  timestamp without time zone NOT NULL DEFAULT now()
);

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_pkey PRIMARY KEY (token_hash);

CREATE INDEX idx_evt_user_id    ON public.email_verification_token USING btree (user_id);
CREATE INDEX idx_evt_expires_at ON public.email_verification_token USING btree (expires_at);
