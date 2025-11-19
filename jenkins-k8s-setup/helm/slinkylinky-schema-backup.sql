--
-- PostgreSQL database dump
--

\restrict y8sVMzxgFa1abp7LlySv7mx6YVFD6B17VT73J0edH4XeXMZuotlFAW0EKaIA5zM

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
-- Name: paid_link_duplicate_check(); Type: FUNCTION; Schema: public; Owner: -
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
-- Name: black_listed_supplier; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: black_listed_supplier_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.black_listed_supplier_seq
    START WITH 101
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id bigint NOT NULL,
    name character varying(255),
    created_by character varying(255),
    disabled boolean DEFAULT false,
    updated_by character varying(255),
    version bigint DEFAULT 0
);


--
-- Name: category_aud; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: category_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demand; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: demand_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.demand_categories (
    demand_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


--
-- Name: demand_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.demand_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demand_site; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: demand_site_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.demand_site_categories (
    demand_site_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


--
-- Name: demand_site_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.demand_site_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_demand_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.link_demand_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paid_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paid_link (
    id bigint NOT NULL,
    demand_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    version bigint DEFAULT 0
);


--
-- Name: paid_link_aud; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paid_link_aud (
    id bigint NOT NULL,
    rev integer NOT NULL,
    revtype smallint,
    supplier_id bigint
);


--
-- Name: paid_link_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paid_link_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proposal; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: proposal_aud; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: proposal_paid_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proposal_paid_links (
    proposal_id bigint NOT NULL,
    paid_links_id bigint NOT NULL
);


--
-- Name: proposal_paid_links_aud; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proposal_paid_links_aud (
    rev integer NOT NULL,
    proposal_id bigint NOT NULL,
    paid_links_id bigint NOT NULL,
    revtype smallint
);


--
-- Name: proposal_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proposal_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revinfo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revinfo (
    rev integer NOT NULL,
    revtstmp bigint
);


--
-- Name: revinfo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revinfo_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: supplier_aud; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: supplier_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_categories (
    supplier_id bigint NOT NULL,
    categories_id bigint NOT NULL
);


--
-- Name: supplier_categories_aud; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_categories_aud (
    rev integer NOT NULL,
    supplier_id bigint NOT NULL,
    categories_id bigint NOT NULL,
    revtype smallint
);


--
-- Name: supplier_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supplier_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: black_listed_supplier black_listed_supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.black_listed_supplier
    ADD CONSTRAINT black_listed_supplier_pkey PRIMARY KEY (id);


--
-- Name: category_aud category_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_aud
    ADD CONSTRAINT category_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: demand demand_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand
    ADD CONSTRAINT demand_pkey PRIMARY KEY (id);


--
-- Name: demand_site demand_site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_site
    ADD CONSTRAINT demand_site_pkey PRIMARY KEY (id);


--
-- Name: paid_link_aud paid_link_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_link_aud
    ADD CONSTRAINT paid_link_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: paid_link paid_link_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT paid_link_pkey PRIMARY KEY (id);


--
-- Name: proposal_aud proposal_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_aud
    ADD CONSTRAINT proposal_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: proposal_paid_links_aud proposal_paid_links_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_paid_links_aud
    ADD CONSTRAINT proposal_paid_links_aud_pkey PRIMARY KEY (proposal_id, rev, paid_links_id);


--
-- Name: proposal proposal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal
    ADD CONSTRAINT proposal_pkey PRIMARY KEY (id);


--
-- Name: revinfo revinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revinfo
    ADD CONSTRAINT revinfo_pkey PRIMARY KEY (rev);


--
-- Name: supplier_aud supplier_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_aud
    ADD CONSTRAINT supplier_aud_pkey PRIMARY KEY (rev, id);


--
-- Name: supplier_categories_aud supplier_categories_aud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_categories_aud
    ADD CONSTRAINT supplier_categories_aud_pkey PRIMARY KEY (rev, supplier_id, categories_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: proposal uk2vmbkbuh4k77vr7rv8rq7688o; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal
    ADD CONSTRAINT uk2vmbkbuh4k77vr7rv8rq7688o UNIQUE (live_link_url);


--
-- Name: category uk46ccwnsi9409t36lurvtyljak; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT uk46ccwnsi9409t36lurvtyljak UNIQUE (name);


--
-- Name: proposal_paid_links uk_1gf3ogiwft3jjirf9uiy5nrui; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT uk_1gf3ogiwft3jjirf9uiy5nrui UNIQUE (paid_links_id);


--
-- Name: black_listed_supplier ukb9rjxhwahqtfklf7ubammbuoh; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.black_listed_supplier
    ADD CONSTRAINT ukb9rjxhwahqtfklf7ubammbuoh UNIQUE (domain);


--
-- Name: demand_site ukj5iivx7l7shhb20pavm5j8u1d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_site
    ADD CONSTRAINT ukj5iivx7l7shhb20pavm5j8u1d UNIQUE (domain);


--
-- Name: supplier ukr9ii2bdptwiwljggtkn44ygkg; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT ukr9ii2bdptwiwljggtkn44ygkg UNIQUE (domain);


--
-- Name: supplier_categories unique_supplier_categories_constraint; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT unique_supplier_categories_constraint UNIQUE (supplier_id, categories_id);


--
-- Name: idx1yjwfqgjvlk0xap48jehr33jy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx1yjwfqgjvlk0xap48jehr33jy ON public.proposal USING btree (date_created);


--
-- Name: idx33xvng0gu4a3tdntxbneql2uy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx33xvng0gu4a3tdntxbneql2uy ON public.demand USING btree (name);


--
-- Name: idx3n69bmrxsxqkayeq3mqjwufkh; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx3n69bmrxsxqkayeq3mqjwufkh ON public.demand_site USING btree (url);


--
-- Name: idx46ccwnsi9409t36lurvtyljak; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx46ccwnsi9409t36lurvtyljak ON public.category USING btree (name);


--
-- Name: idx89n7ob7c5lfrwae25a9jx68yi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx89n7ob7c5lfrwae25a9jx68yi ON public.demand USING btree (requested);


--
-- Name: idx99nij26shrfy7d1so2xhjjqff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx99nij26shrfy7d1so2xhjjqff ON public.demand_site USING btree (name);


--
-- Name: idx9liwt4tol1sq0pbs0d2htxdgi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx9liwt4tol1sq0pbs0d2htxdgi ON public.demand USING btree (domain);


--
-- Name: idxb9rjxhwahqtfklf7ubammbuoh; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxb9rjxhwahqtfklf7ubammbuoh ON public.black_listed_supplier USING btree (domain);


--
-- Name: idxc3fclhmodftxk4d0judiafwi3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxc3fclhmodftxk4d0judiafwi3 ON public.supplier USING btree (name);


--
-- Name: idxg7qiwwu4vpciysmeeyme9gg1d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxg7qiwwu4vpciysmeeyme9gg1d ON public.supplier USING btree (email);


--
-- Name: idxj5hmqh6l9pysqf270heieapvi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxj5hmqh6l9pysqf270heieapvi ON public.demand USING btree (da_needed);


--
-- Name: idxj5iivx7l7shhb20pavm5j8u1d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxj5iivx7l7shhb20pavm5j8u1d ON public.demand_site USING btree (domain);


--
-- Name: idxjh6ueu99didab475jafjxvsut; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxjh6ueu99didab475jafjxvsut ON public.supplier USING btree (da);


--
-- Name: idxkki22xfo8qoijthsi5wfre5vg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxkki22xfo8qoijthsi5wfre5vg ON public.demand_site USING btree (email);


--
-- Name: idxr9ii2bdptwiwljggtkn44ygkg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxr9ii2bdptwiwljggtkn44ygkg ON public.supplier USING btree (domain);


--
-- Name: paid_link fk3qcr9j3m3bvlo26fqcf9b0uo0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT fk3qcr9j3m3bvlo26fqcf9b0uo0 FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: supplier_categories fk4buchj73r1akl6kx2rk2msu2i; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT fk4buchj73r1akl6kx2rk2msu2i FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: supplier_categories_aud fk5qusdv1jexi76506lm9nub3kv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_categories_aud
    ADD CONSTRAINT fk5qusdv1jexi76506lm9nub3kv FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_site_categories fkai4ogv5i0k4rx9butditc9jra; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_site_categories
    ADD CONSTRAINT fkai4ogv5i0k4rx9butditc9jra FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: category_aud fkc9m640crhsib2ws80um6xuk1w; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_aud
    ADD CONSTRAINT fkc9m640crhsib2ws80um6xuk1w FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: proposal_paid_links fkchy3rfktop5akb4b0uiq3gqsr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT fkchy3rfktop5akb4b0uiq3gqsr FOREIGN KEY (paid_links_id) REFERENCES public.paid_link(id);


--
-- Name: supplier_aud fkd8mhbb2j0c9woft7uaik3opek; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_aud
    ADD CONSTRAINT fkd8mhbb2j0c9woft7uaik3opek FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: proposal_aud fkgqaws0nt50391dvtg5gy63mhq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_aud
    ADD CONSTRAINT fkgqaws0nt50391dvtg5gy63mhq FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_categories fkidwtisqev76vdbsjp7qlatp0v; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_categories
    ADD CONSTRAINT fkidwtisqev76vdbsjp7qlatp0v FOREIGN KEY (demand_id) REFERENCES public.demand(id);


--
-- Name: paid_link_aud fkircge39g5e8w9smys4vcu1l7o; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_link_aud
    ADD CONSTRAINT fkircge39g5e8w9smys4vcu1l7o FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: supplier_categories fkk2mqj6ffc0ppgcpw7w40n3kbm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT fkk2mqj6ffc0ppgcpw7w40n3kbm FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: demand fklcw8dtf2b233srjxtbdtt3b23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand
    ADD CONSTRAINT fklcw8dtf2b233srjxtbdtt3b23 FOREIGN KEY (demand_site_id) REFERENCES public.demand_site(id);


--
-- Name: proposal_paid_links fkmamwwc6u0hawrjnvgxuayh3ke; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_paid_links
    ADD CONSTRAINT fkmamwwc6u0hawrjnvgxuayh3ke FOREIGN KEY (proposal_id) REFERENCES public.proposal(id);


--
-- Name: paid_link fkp2hacsth1xttb7emwar2r931x; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_link
    ADD CONSTRAINT fkp2hacsth1xttb7emwar2r931x FOREIGN KEY (demand_id) REFERENCES public.demand(id);


--
-- Name: proposal_paid_links_aud fkq1iikwi86pdlroww7syyeaqj2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposal_paid_links_aud
    ADD CONSTRAINT fkq1iikwi86pdlroww7syyeaqj2 FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: demand_site_categories fkrs8n4pdausjqo6m3ajfetbmrn; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_site_categories
    ADD CONSTRAINT fkrs8n4pdausjqo6m3ajfetbmrn FOREIGN KEY (demand_site_id) REFERENCES public.demand_site(id);


--
-- Name: demand_categories fktip66e4fne5up6c2n02gn4l7s; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demand_categories
    ADD CONSTRAINT fktip66e4fne5up6c2n02gn4l7s FOREIGN KEY (categories_id) REFERENCES public.category(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT ALL ON SCHEMA public TO slinkylinky;


--
-- PostgreSQL database dump complete
--

\unrestrict y8sVMzxgFa1abp7LlySv7mx6YVFD6B17VT73J0edH4XeXMZuotlFAW0EKaIA5zM

