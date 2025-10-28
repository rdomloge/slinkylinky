--
-- PostgreSQL database cluster dump
--

\restrict MPD21TcoCWGvxXzumSgNHdln3f33UdUZ9xXLXzBel5hCERc8MSR0fZHAZXCR5bw

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE audit;
DROP DATABASE ramsay;
DROP DATABASE slinkylinky;
DROP DATABASE stats;
DROP DATABASE supplierengagement;
DROP DATABASE woo;




--
-- Drop roles
--

DROP ROLE ramsay;
DROP ROLE slinkylinky;


--
-- Roles
--

CREATE ROLE ramsay;
ALTER ROLE ramsay WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE slinkylinky;
ALTER ROLE slinkylinky WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS;

--
-- User Configurations
--








\unrestrict MPD21TcoCWGvxXzumSgNHdln3f33UdUZ9xXLXzBel5hCERc8MSR0fZHAZXCR5bw

--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

\restrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: ramsay
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO ramsay;

\unrestrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw
\connect template1
\restrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: ramsay
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: ramsay
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\unrestrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw
\connect template1
\restrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw

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
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: ramsay
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict gpQfbM18y5vEsqBm83iIJEUJVozxvNxtxXJDsYxPznATqar8sqHLz408Kwv92Nw

--
-- Database "audit" dump
--

--
-- PostgreSQL database dump
--

\restrict bkQ0c8huw6hcVyOY1wZeNXhLn22qOCDu8gUfw0I6LiZnWq9DkJdOCB5gD5RtPrI

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: audit; Type: DATABASE; Schema: -; Owner: slinkylinky
--

CREATE DATABASE audit WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE audit OWNER TO slinkylinky;

\unrestrict bkQ0c8huw6hcVyOY1wZeNXhLn22qOCDu8gUfw0I6LiZnWq9DkJdOCB5gD5RtPrI
\connect audit
\restrict bkQ0c8huw6hcVyOY1wZeNXhLn22qOCDu8gUfw0I6LiZnWq9DkJdOCB5gD5RtPrI

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
-- Name: audit_record; Type: TABLE; Schema: public; Owner: slinkylinky
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


ALTER TABLE public.audit_record OWNER TO slinkylinky;

--
-- Name: audit_record_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.audit_record_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_record_seq OWNER TO slinkylinky;

--
-- Name: audit_record audit_record_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.audit_record
    ADD CONSTRAINT audit_record_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict bkQ0c8huw6hcVyOY1wZeNXhLn22qOCDu8gUfw0I6LiZnWq9DkJdOCB5gD5RtPrI

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

\restrict uCp4l2E7g2NeQZYtFhWPqeT8VmQj3iOoyUewkFkKaxsAmomDhB3JBisYEg4RoJk

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: ramsay
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO ramsay;

\unrestrict uCp4l2E7g2NeQZYtFhWPqeT8VmQj3iOoyUewkFkKaxsAmomDhB3JBisYEg4RoJk
\connect postgres
\restrict uCp4l2E7g2NeQZYtFhWPqeT8VmQj3iOoyUewkFkKaxsAmomDhB3JBisYEg4RoJk

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: ramsay
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

\unrestrict uCp4l2E7g2NeQZYtFhWPqeT8VmQj3iOoyUewkFkKaxsAmomDhB3JBisYEg4RoJk

--
-- Database "ramsay" dump
--

--
-- PostgreSQL database dump
--

\restrict 4ghz0djOcOgER4fxUhDTD8i1vOA0uxRwWDg5iqYreeLHToXUwpmIB1tvyB2O1Ro

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: ramsay; Type: DATABASE; Schema: -; Owner: ramsay
--

CREATE DATABASE ramsay WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE ramsay OWNER TO ramsay;

\unrestrict 4ghz0djOcOgER4fxUhDTD8i1vOA0uxRwWDg5iqYreeLHToXUwpmIB1tvyB2O1Ro
\connect ramsay
\restrict 4ghz0djOcOgER4fxUhDTD8i1vOA0uxRwWDg5iqYreeLHToXUwpmIB1tvyB2O1Ro

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
-- PostgreSQL database dump complete
--

\unrestrict 4ghz0djOcOgER4fxUhDTD8i1vOA0uxRwWDg5iqYreeLHToXUwpmIB1tvyB2O1Ro

--
-- Database "slinkylinky" dump
--

--
-- PostgreSQL database dump
--

\restrict rz7qRsLqfzldntFOFeeP5ftl3rINod9IP3lbHpWaOWx6i0KximRa5NCQYXg6ewM

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: slinkylinky; Type: DATABASE; Schema: -; Owner: slinkylinky
--

CREATE DATABASE slinkylinky WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE slinkylinky OWNER TO slinkylinky;

\unrestrict rz7qRsLqfzldntFOFeeP5ftl3rINod9IP3lbHpWaOWx6i0KximRa5NCQYXg6ewM
\connect slinkylinky
\restrict rz7qRsLqfzldntFOFeeP5ftl3rINod9IP3lbHpWaOWx6i0KximRa5NCQYXg6ewM

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
-- Name: paid_link_duplicate_check(); Type: FUNCTION; Schema: public; Owner: slinkylinky
--

CREATE FUNCTION public.paid_link_duplicate_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        if tg_table_name = 'paid_link' and tg_op = 'INSERT' then
            if exists (select 1 from paid_link pl
                        join demand d on pl.demand_id = d.id
                        join demand_site ds on d.demand_site_id = ds.id
                        join supplier s on s.id=pl.supplier_id
                        where s.id = new.supplier_id and ds.domain = (
                                select innerds.domain 
                                from demand_site innerds 
                                join demand innerd on innerd.demand_site_id = innerds.id
                                where innerd.id = new.demand_id
                            )
                        ) then
                raise exception 'A paid link already exists between the supplier domain and the demand site domain';
            end if;
        end if; 
       return new; 
    end;
    $$;


ALTER FUNCTION public.paid_link_duplicate_check() OWNER TO slinkylinky;

--
-- Name: audit_record_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.audit_record_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_record_seq OWNER TO slinkylinky;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: black_listed_supplier; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.black_listed_supplier (
    id bigint NOT NULL,
    created_by character varying(255) NOT NULL,
    da integer NOT NULL,
    data_points_json text,
    date_created timestamp(6) without time zone NOT NULL,
    domain character varying(255) NOT NULL,
    spam_rating integer NOT NULL
);


ALTER TABLE public.black_listed_supplier OWNER TO slinkylinky;

--
-- Name: black_listed_supplier_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.black_listed_supplier_seq
    START WITH 101
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.black_listed_supplier_seq OWNER TO slinkylinky;

--
-- Name: category; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.category (
    id bigint NOT NULL,
    name character varying(255),
    created_by character varying(255),
    disabled boolean DEFAULT false,
    updated_by character varying(255),
    version bigint DEFAULT 0
);


ALTER TABLE public.category OWNER TO slinkylinky;

--
-- Name: category_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.category_aud (
    id bigint NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    created_by character varying(255),
    disabled boolean DEFAULT false,
    name character varying(255),
    updated_by character varying(255)
);


ALTER TABLE public.category_aud OWNER TO slinkylinky;

--
-- Name: category_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.category_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_seq OWNER TO slinkylinky;

--
-- Name: demand; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.demand (
    id bigint NOT NULL,
    anchor_text character varying(255),
    created_by character varying(255),
    da_needed integer NOT NULL,
    domain character varying(255),
    name character varying(255),
    requested timestamp(6) without time zone,
    updated_by character varying(255),
    url character varying(255),
    demand_site_id bigint,
    source character varying(255),
    word_count integer DEFAULT 0
);


ALTER TABLE public.demand OWNER TO slinkylinky;

--
-- Name: demand_categories; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.demand_categories (
    demand_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


ALTER TABLE public.demand_categories OWNER TO slinkylinky;

--
-- Name: demand_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.demand_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demand_seq OWNER TO slinkylinky;

--
-- Name: demand_site; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.demand_site (
    id bigint NOT NULL,
    created_by character varying(255),
    domain character varying(255),
    email character varying(255),
    name character varying(255),
    updated_by character varying(255),
    url character varying(255)
);


ALTER TABLE public.demand_site OWNER TO slinkylinky;

--
-- Name: demand_site_categories; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.demand_site_categories (
    demand_site_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


ALTER TABLE public.demand_site_categories OWNER TO slinkylinky;

--
-- Name: demand_site_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.demand_site_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.demand_site_seq OWNER TO slinkylinky;

--
-- Name: link_demand_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.link_demand_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_demand_seq OWNER TO slinkylinky;

--
-- Name: paid_link; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.paid_link (
    id bigint NOT NULL,
    demand_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    version bigint DEFAULT 0
);


ALTER TABLE public.paid_link OWNER TO slinkylinky;

--
-- Name: paid_link_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.paid_link_aud (
    id bigint NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    supplier_id bigint
);


ALTER TABLE public.paid_link_aud OWNER TO slinkylinky;

--
-- Name: paid_link_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.paid_link_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paid_link_seq OWNER TO slinkylinky;

--
-- Name: proposal; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.proposal (
    id bigint NOT NULL,
    article text,
    blog_live boolean NOT NULL,
    content_ready boolean NOT NULL,
    created_by character varying(255),
    date_accepted_by_supplier timestamp(6) without time zone,
    date_blog_live timestamp(6) without time zone,
    date_created timestamp(6) without time zone,
    date_invoice_paid timestamp(6) without time zone,
    date_invoice_received timestamp(6) without time zone,
    date_sent_to_supplier timestamp(6) without time zone,
    invoice_paid boolean NOT NULL,
    invoice_received boolean NOT NULL,
    live_link_title character varying(255),
    live_link_url character varying(255),
    proposal_accepted boolean NOT NULL,
    proposal_sent boolean NOT NULL,
    updated_by character varying(255),
    supplier_snapshot_version bigint DEFAULT 0 NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    validated boolean DEFAULT false,
    date_validated timestamp(6) without time zone,
    do_not_expire boolean DEFAULT false
);


ALTER TABLE public.proposal OWNER TO slinkylinky;

--
-- Name: proposal_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.proposal_aud (
    id bigint NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    article text,
    blog_live boolean,
    content_ready boolean,
    created_by character varying(255),
    date_accepted_by_supplier timestamp(6) without time zone,
    date_blog_live timestamp(6) without time zone,
    date_created timestamp(6) without time zone,
    date_invoice_paid timestamp(6) without time zone,
    date_invoice_received timestamp(6) without time zone,
    date_sent_to_supplier timestamp(6) without time zone,
    invoice_paid boolean,
    invoice_received boolean,
    live_link_title character varying(255),
    live_link_url character varying(255),
    proposal_accepted boolean,
    proposal_sent boolean,
    supplier_snapshot_version bigint DEFAULT 0,
    updated_by character varying(255),
    validated boolean DEFAULT false,
    date_validated timestamp(6) without time zone,
    do_not_expire boolean DEFAULT false
);


ALTER TABLE public.proposal_aud OWNER TO slinkylinky;

--
-- Name: proposal_paid_links; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.proposal_paid_links (
    proposal_id bigint NOT NULL,
    paid_links_id bigint NOT NULL
);


ALTER TABLE public.proposal_paid_links OWNER TO slinkylinky;

--
-- Name: proposal_paid_links_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.proposal_paid_links_aud (
    rev integer NOT NULL,
    proposal_id bigint NOT NULL,
    paid_links_id bigint NOT NULL,
    revtype smallint
);


ALTER TABLE public.proposal_paid_links_aud OWNER TO slinkylinky;

--
-- Name: proposal_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.proposal_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proposal_seq OWNER TO slinkylinky;

--
-- Name: revinfo; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.revinfo (
    rev integer NOT NULL,
    revtstmp bigint
);


ALTER TABLE public.revinfo OWNER TO slinkylinky;

--
-- Name: revinfo_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.revinfo_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.revinfo_seq OWNER TO slinkylinky;

--
-- Name: supplier; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.supplier (
    id bigint NOT NULL,
    created_by character varying(255),
    da integer NOT NULL,
    disabled boolean NOT NULL,
    domain character varying(255),
    email character varying(255),
    name character varying(255),
    third_party boolean NOT NULL,
    updated_by character varying(255),
    we_write_fee integer NOT NULL,
    we_write_fee_currency character varying(255),
    website character varying(255),
    source character varying(255),
    created_date bigint DEFAULT 0 NOT NULL,
    modified_date bigint DEFAULT 0,
    version bigint DEFAULT 0
);


ALTER TABLE public.supplier OWNER TO slinkylinky;

--
-- Name: supplier_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.supplier_aud (
    id bigint NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    created_by character varying(255),
    created_date bigint DEFAULT 0,
    da integer,
    disabled boolean,
    domain character varying(255),
    email character varying(255),
    modified_date bigint DEFAULT 0,
    name character varying(255),
    source character varying(255),
    third_party boolean,
    updated_by character varying(255),
    we_write_fee integer,
    we_write_fee_currency character varying(255),
    website character varying(255)
);


ALTER TABLE public.supplier_aud OWNER TO slinkylinky;

--
-- Name: supplier_categories; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.supplier_categories (
    supplier_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


ALTER TABLE public.supplier_categories OWNER TO slinkylinky;

--
-- Name: supplier_categories_aud; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.supplier_categories_aud (
    rev integer NOT NULL,
    supplier_id bigint NOT NULL,
    categories_id bigint NOT NULL,
    revtype smallint
);


ALTER TABLE public.supplier_categories_aud OWNER TO slinkylinky;

--
-- Name: supplier_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.supplier_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_seq OWNER TO slinkylinky;

--
-- Name: black_listed_supplier black_listed_supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.black_listed_supplier
    ADD CONSTRAINT black_listed_supplier_pkey PRIMARY KEY (id);


--
-- Name: category_aud category_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category_aud
    ADD CONSTRAINT category_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: demand demand_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand
    ADD CONSTRAINT demand_pkey PRIMARY KEY (id);


--
-- Name: demand_site demand_site_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_site
    ADD CONSTRAINT demand_site_pkey PRIMARY KEY (id);


--
-- Name: paid_link_aud paid_link_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.paid_link_aud
    ADD CONSTRAINT paid_link_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: paid_link paid_link_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT paid_link_pkey PRIMARY KEY (id);


--
-- Name: proposal_aud proposal_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_aud
    ADD CONSTRAINT proposal_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: proposal_paid_links_aud proposal_paid_links_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_paid_links_aud
    ADD CONSTRAINT proposal_paid_links_aud_pkey PRIMARY KEY (proposal_id, rev, paid_links_id);


--
-- Name: proposal proposal_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal
    ADD CONSTRAINT proposal_pkey PRIMARY KEY (id);


--
-- Name: revinfo revinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.revinfo
    ADD CONSTRAINT revinfo_pkey PRIMARY KEY (rev);


--
-- Name: supplier_aud supplier_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_aud
    ADD CONSTRAINT supplier_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: supplier_categories_aud supplier_categories_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories_aud
    ADD CONSTRAINT supplier_categories_aud_pkey PRIMARY KEY (rev, supplier_id, categories_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: proposal uk2vmbkbuh4k77vr7rv8rq7688o; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal
    ADD CONSTRAINT uk2vmbkbuh4k77vr7rv8rq7688o UNIQUE (live_link_url);


--
-- Name: category uk46ccwnsi9409t36lurvtyljak; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT uk46ccwnsi9409t36lurvtyljak UNIQUE (name);


--
-- Name: proposal_paid_links uk_1gf3ogiwft3jjirf9uiy5nrui; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT uk_1gf3ogiwft3jjirf9uiy5nrui UNIQUE (paid_links_id);


--
-- Name: black_listed_supplier ukb9rjxhwahqtfklf7ubammbuoh; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.black_listed_supplier
    ADD CONSTRAINT ukb9rjxhwahqtfklf7ubammbuoh UNIQUE (domain);


--
-- Name: demand_site ukj5iivx7l7shhb20pavm5j8u1d; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_site
    ADD CONSTRAINT ukj5iivx7l7shhb20pavm5j8u1d UNIQUE (domain);


--
-- Name: supplier ukr9ii2bdptwiwljggtkn44ygkg; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT ukr9ii2bdptwiwljggtkn44ygkg UNIQUE (domain);


--
-- Name: supplier_categories unique_supplier_categories_constraint; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT unique_supplier_categories_constraint UNIQUE (supplier_id, categories_id);


--
-- Name: idx1yjwfqgjvlk0xap48jehr33jy; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx1yjwfqgjvlk0xap48jehr33jy ON public.proposal USING btree (date_created);


--
-- Name: idx33xvng0gu4a3tdntxbneql2uy; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx33xvng0gu4a3tdntxbneql2uy ON public.demand USING btree (name);


--
-- Name: idx3n69bmrxsxqkayeq3mqjwufkh; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx3n69bmrxsxqkayeq3mqjwufkh ON public.demand_site USING btree (url);


--
-- Name: idx46ccwnsi9409t36lurvtyljak; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx46ccwnsi9409t36lurvtyljak ON public.category USING btree (name);


--
-- Name: idx89n7ob7c5lfrwae25a9jx68yi; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx89n7ob7c5lfrwae25a9jx68yi ON public.demand USING btree (requested);


--
-- Name: idx99nij26shrfy7d1so2xhjjqff; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx99nij26shrfy7d1so2xhjjqff ON public.demand_site USING btree (name);


--
-- Name: idx9liwt4tol1sq0pbs0d2htxdgi; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx9liwt4tol1sq0pbs0d2htxdgi ON public.demand USING btree (domain);


--
-- Name: idxb9rjxhwahqtfklf7ubammbuoh; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxb9rjxhwahqtfklf7ubammbuoh ON public.black_listed_supplier USING btree (domain);


--
-- Name: idxc3fclhmodftxk4d0judiafwi3; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxc3fclhmodftxk4d0judiafwi3 ON public.supplier USING btree (name);


--
-- Name: idxg7qiwwu4vpciysmeeyme9gg1d; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxg7qiwwu4vpciysmeeyme9gg1d ON public.supplier USING btree (email);


--
-- Name: idxj5hmqh6l9pysqf270heieapvi; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxj5hmqh6l9pysqf270heieapvi ON public.demand USING btree (da_needed);


--
-- Name: idxj5iivx7l7shhb20pavm5j8u1d; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxj5iivx7l7shhb20pavm5j8u1d ON public.demand_site USING btree (domain);


--
-- Name: idxjh6ueu99didab475jafjxvsut; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxjh6ueu99didab475jafjxvsut ON public.supplier USING btree (da);


--
-- Name: idxkki22xfo8qoijthsi5wfre5vg; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxkki22xfo8qoijthsi5wfre5vg ON public.demand_site USING btree (email);


--
-- Name: idxr9ii2bdptwiwljggtkn44ygkg; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxr9ii2bdptwiwljggtkn44ygkg ON public.supplier USING btree (domain);


--
-- Name: paid_link fk3qcr9j3m3bvlo26fqcf9b0uo0; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT fk3qcr9j3m3bvlo26fqcf9b0uo0 FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: supplier_categories fk4buchj73r1akl6kx2rk2msu2i; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT fk4buchj73r1akl6kx2rk2msu2i FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: supplier_categories_aud fk5qusdv1jexi76506lm9nub3kv; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories_aud
    ADD CONSTRAINT fk5qusdv1jexi76506lm9nub3kv FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_site_categories fkai4ogv5i0k4rx9butditc9jra; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_site_categories
    ADD CONSTRAINT fkai4ogv5i0k4rx9butditc9jra FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: category_aud fkc9m640crhsib2ws80um6xuk1w; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category_aud
    ADD CONSTRAINT fkc9m640crhsib2ws80um6xuk1w FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: proposal_paid_links fkchy3rfktop5akb4b0uiq3gqsr; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT fkchy3rfktop5akb4b0uiq3gqsr FOREIGN KEY (paid_links_id) REFERENCES public.paid_link(id);


--
-- Name: supplier_aud fkd8mhbb2j0c9woft7uaik3opek; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_aud
    ADD CONSTRAINT fkd8mhbb2j0c9woft7uaik3opek FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: proposal_aud fkgqaws0nt50391dvtg5gy63mhq; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_aud
    ADD CONSTRAINT fkgqaws0nt50391dvtg5gy63mhq FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_categories fkidwtisqev76vdbsjp7qlatp0v; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_categories
    ADD CONSTRAINT fkidwtisqev76vdbsjp7qlatp0v FOREIGN KEY (demand_id) REFERENCES public.demand(id);


--
-- Name: paid_link_aud fkircge39g5e8w9smys4vcu1l7o; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.paid_link_aud
    ADD CONSTRAINT fkircge39g5e8w9smys4vcu1l7o FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: supplier_categories fkk2mqj6ffc0ppgcpw7w40n3kbm; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT fkk2mqj6ffc0ppgcpw7w40n3kbm FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: demand fklcw8dtf2b233srjxtbdtt3b23; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand
    ADD CONSTRAINT fklcw8dtf2b233srjxtbdtt3b23 FOREIGN KEY (demand_site_id) REFERENCES public.demand_site(id);


--
-- Name: proposal_paid_links fkmamwwc6u0hawrjnvgxuayh3ke; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT fkmamwwc6u0hawrjnvgxuayh3ke FOREIGN KEY (proposal_id) REFERENCES public.proposal(id);


--
-- Name: paid_link fkp2hacsth1xttb7emwar2r931x; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT fkp2hacsth1xttb7emwar2r931x FOREIGN KEY (demand_id) REFERENCES public.demand(id);


--
-- Name: proposal_paid_links_aud fkq1iikwi86pdlroww7syyeaqj2; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.proposal_paid_links_aud
    ADD CONSTRAINT fkq1iikwi86pdlroww7syyeaqj2 FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_site_categories fkrs8n4pdausjqo6m3ajfetbmrn; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_site_categories
    ADD CONSTRAINT fkrs8n4pdausjqo6m3ajfetbmrn FOREIGN KEY (demand_site_id) REFERENCES public.demand_site(id);


--
-- Name: demand_categories fktip66e4fne5up6c2n02gn4l7s; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.demand_categories
    ADD CONSTRAINT fktip66e4fne5up6c2n02gn4l7s FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict rz7qRsLqfzldntFOFeeP5ftl3rINod9IP3lbHpWaOWx6i0KximRa5NCQYXg6ewM

--
-- Database "stats" dump
--

--
-- PostgreSQL database dump
--

\restrict oMghRoX51Ol3fvMlcnSgjpqkPcpym46sS3g05X7xvhb0QpJsyfawEvuGvfigtcx

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: stats; Type: DATABASE; Schema: -; Owner: slinkylinky
--

CREATE DATABASE stats WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE stats OWNER TO slinkylinky;

\unrestrict oMghRoX51Ol3fvMlcnSgjpqkPcpym46sS3g05X7xvhb0QpJsyfawEvuGvfigtcx
\connect stats
\restrict oMghRoX51Ol3fvMlcnSgjpqkPcpym46sS3g05X7xvhb0QpJsyfawEvuGvfigtcx

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
-- Name: da_monthly_data; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.da_monthly_data (
    id bigint NOT NULL,
    date date NOT NULL,
    domain character varying(255),
    unique_year_month character varying(255) NOT NULL,
    da integer NOT NULL
);


ALTER TABLE public.da_monthly_data OWNER TO slinkylinky;

--
-- Name: da_monthly_data_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.da_monthly_data_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.da_monthly_data_seq OWNER TO slinkylinky;

--
-- Name: sem_rush_monthly_data; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.sem_rush_monthly_data (
    id bigint NOT NULL,
    date date NOT NULL,
    domain character varying(255),
    unique_year_month character varying(255) NOT NULL,
    srrank bigint NOT NULL,
    traffic bigint NOT NULL
);


ALTER TABLE public.sem_rush_monthly_data OWNER TO slinkylinky;

--
-- Name: sem_rush_monthly_data_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.sem_rush_monthly_data_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sem_rush_monthly_data_seq OWNER TO slinkylinky;

--
-- Name: spam_monthly_data; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.spam_monthly_data (
    id bigint NOT NULL,
    date date NOT NULL,
    domain character varying(255),
    unique_year_month character varying(255) NOT NULL,
    spam_score integer NOT NULL
);


ALTER TABLE public.spam_monthly_data OWNER TO slinkylinky;

--
-- Name: spam_monthly_data_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.spam_monthly_data_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.spam_monthly_data_seq OWNER TO slinkylinky;

--
-- Name: da_monthly_data da_monthly_data_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.da_monthly_data
    ADD CONSTRAINT da_monthly_data_pkey PRIMARY KEY (id);


--
-- Name: sem_rush_monthly_data sem_rush_monthly_data_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.sem_rush_monthly_data
    ADD CONSTRAINT sem_rush_monthly_data_pkey PRIMARY KEY (id);


--
-- Name: spam_monthly_data spam_monthly_data_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.spam_monthly_data
    ADD CONSTRAINT spam_monthly_data_pkey PRIMARY KEY (id);


--
-- Name: sem_rush_monthly_data uk2ib3ijqbswi44itvbuqliihy3; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.sem_rush_monthly_data
    ADD CONSTRAINT uk2ib3ijqbswi44itvbuqliihy3 UNIQUE (unique_year_month, domain);


--
-- Name: spam_monthly_data ukj726ul7xt96gpmvpqfjpml8l8; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.spam_monthly_data
    ADD CONSTRAINT ukj726ul7xt96gpmvpqfjpml8l8 UNIQUE (unique_year_month, domain);


--
-- Name: da_monthly_data ukmevsdhi1eh18peo4vmu40k5x; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.da_monthly_data
    ADD CONSTRAINT ukmevsdhi1eh18peo4vmu40k5x UNIQUE (unique_year_month, domain);


--
-- Name: idxa55mpivdhdxlnwdcg0haqrdn; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxa55mpivdhdxlnwdcg0haqrdn ON public.sem_rush_monthly_data USING btree (date, domain);


--
-- Name: idxfhdurnnjtvq16upq02q7psp75; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxfhdurnnjtvq16upq02q7psp75 ON public.spam_monthly_data USING btree (date, domain);


--
-- Name: idxrd91crsguk75xa5ehfwqjfg8t; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxrd91crsguk75xa5ehfwqjfg8t ON public.da_monthly_data USING btree (date, domain);


--
-- PostgreSQL database dump complete
--

\unrestrict oMghRoX51Ol3fvMlcnSgjpqkPcpym46sS3g05X7xvhb0QpJsyfawEvuGvfigtcx

--
-- Database "supplierengagement" dump
--

--
-- PostgreSQL database dump
--

\restrict iuFyb6lq6qeIgv9GJLbbbLYXMYDqfBhxoINTgAmbDCxXjOn4dowXp3RUSkA0qQp

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: supplierengagement; Type: DATABASE; Schema: -; Owner: slinkylinky
--

CREATE DATABASE supplierengagement WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE supplierengagement OWNER TO slinkylinky;

\unrestrict iuFyb6lq6qeIgv9GJLbbbLYXMYDqfBhxoINTgAmbDCxXjOn4dowXp3RUSkA0qQp
\connect supplierengagement
\restrict iuFyb6lq6qeIgv9GJLbbbLYXMYDqfBhxoINTgAmbDCxXjOn4dowXp3RUSkA0qQp

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
-- Name: audit_record_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.audit_record_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_record_seq OWNER TO slinkylinky;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: engagement; Type: TABLE; Schema: public; Owner: slinkylinky
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


ALTER TABLE public.engagement OWNER TO slinkylinky;

--
-- Name: engagement_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.engagement_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.engagement_seq OWNER TO slinkylinky;

--
-- Name: engagement engagement_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.engagement
    ADD CONSTRAINT engagement_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict iuFyb6lq6qeIgv9GJLbbbLYXMYDqfBhxoINTgAmbDCxXjOn4dowXp3RUSkA0qQp

--
-- Database "woo" dump
--

--
-- PostgreSQL database dump
--

\restrict SEDbxqp3aR88O2foiYbeJ13d7qutqdAny4ahUgQbor7JN0KmNjUU4kCI4thUoOJ

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
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
-- Name: woo; Type: DATABASE; Schema: -; Owner: slinkylinky
--

CREATE DATABASE woo WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE woo OWNER TO slinkylinky;

\unrestrict SEDbxqp3aR88O2foiYbeJ13d7qutqdAny4ahUgQbor7JN0KmNjUU4kCI4thUoOJ
\connect woo
\restrict SEDbxqp3aR88O2foiYbeJ13d7qutqdAny4ahUgQbor7JN0KmNjUU4kCI4thUoOJ

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
-- Name: line_item; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.line_item (
    id bigint NOT NULL,
    demand_id bigint,
    linked_proposal_id bigint,
    proposal_complete boolean DEFAULT false,
    price double precision DEFAULT 0 NOT NULL,
    product_id bigint DEFAULT 0 NOT NULL,
    product_name character varying(255),
    product_name_with_word_count character varying(255),
    tax double precision DEFAULT 0 NOT NULL,
    word_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.line_item OWNER TO slinkylinky;

--
-- Name: line_item_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.line_item_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.line_item_seq OWNER TO slinkylinky;

--
-- Name: woo_order; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.woo_order (
    id bigint NOT NULL,
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    external_id bigint,
    woo_order_json text,
    billing_email_address character varying(255),
    customer_name character varying(255),
    shipping_email_address character varying(255),
    link_details_email_sent boolean DEFAULT false,
    link_details_email_sent_date timestamp(6) without time zone,
    archived boolean DEFAULT false,
    total double precision
);


ALTER TABLE public.woo_order OWNER TO slinkylinky;

--
-- Name: woo_order_line_items; Type: TABLE; Schema: public; Owner: slinkylinky
--

CREATE TABLE public.woo_order_line_items (
    order_entity_id bigint NOT NULL,
    line_items_id bigint NOT NULL
);


ALTER TABLE public.woo_order_line_items OWNER TO slinkylinky;

--
-- Name: woo_order_seq; Type: SEQUENCE; Schema: public; Owner: slinkylinky
--

CREATE SEQUENCE public.woo_order_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.woo_order_seq OWNER TO slinkylinky;

--
-- Name: woo_order externalid; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.woo_order
    ADD CONSTRAINT externalid UNIQUE (external_id);


--
-- Name: line_item line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.line_item
    ADD CONSTRAINT line_item_pkey PRIMARY KEY (id);


--
-- Name: line_item uk_gn9kpg5bp8p6qbu4doki7hc1t; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.line_item
    ADD CONSTRAINT uk_gn9kpg5bp8p6qbu4doki7hc1t UNIQUE (demand_id);


--
-- Name: woo_order_line_items uk_ni5r2727p76ur2u4q5tdichf5; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.woo_order_line_items
    ADD CONSTRAINT uk_ni5r2727p76ur2u4q5tdichf5 UNIQUE (line_items_id);


--
-- Name: woo_order woo_order_pkey; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.woo_order
    ADD CONSTRAINT woo_order_pkey PRIMARY KEY (id);


--
-- Name: woo_order_line_items fkdjok0p2y73kne6ynvnqayutj4; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.woo_order_line_items
    ADD CONSTRAINT fkdjok0p2y73kne6ynvnqayutj4 FOREIGN KEY (line_items_id) REFERENCES public.line_item(id);


--
-- Name: woo_order_line_items fkntoxhy7bj8xsufda24dyw8k63; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.woo_order_line_items
    ADD CONSTRAINT fkntoxhy7bj8xsufda24dyw8k63 FOREIGN KEY (order_entity_id) REFERENCES public.woo_order(id);


--
-- PostgreSQL database dump complete
--

\unrestrict SEDbxqp3aR88O2foiYbeJ13d7qutqdAny4ahUgQbor7JN0KmNjUU4kCI4thUoOJ

--
-- PostgreSQL database cluster dump complete
--

