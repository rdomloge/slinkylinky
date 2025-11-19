--
-- PostgreSQL database dump
--

\restrict bbLUnxxji6QLsk1gg6mtnpAWMPtxWfyV6BxAX2I2gwKiyq8a2xRDrhyMQ3e9QJ4

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
-- Data for Name: black_listed_supplier; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.black_listed_supplier (id, created_by, da, data_points_json, date_created, domain, spam_rating) FROM stdin;
52	rdomloge@gmail.com	54	38031	2024-03-30 12:39:12.53406	ventsmagazine.co.uk	8
53	rdomloge@gmail.com	58	38034	2024-03-30 12:41:01.311783	designerwomen.co.uk	1
54	chris.p@frontpageadvantage.com	47	39589	2024-04-09 14:22:47.876165	ratemypoo.com	53
102	chris.p@frontpageadvantage.com	58	82634	2024-05-22 10:59:45.325253	brazendenver.com	2
103	chris.p@frontpageadvantage.com	55	82637	2024-05-22 10:59:55.476231	ecomuch.com	1
104	chris.p@frontpageadvantage.com	43	82641	2024-05-22 11:00:04.91859	bluesmartmia.com	6
105	chris.p@frontpageadvantage.com	44	82645	2024-05-22 11:00:13.107649	mariahpride.com	1
106	chris.p@frontpageadvantage.com	20	82649	2024-05-22 11:00:23.584527	koloroo.com	-1
107	chris.p@frontpageadvantage.com	56	82841	2024-05-23 09:13:00.658355	citizen-series.co.uk	3
108	chris.p@frontpageadvantage.com	52	82844	2024-05-23 09:15:36.516207	bingopoker.co.uk	-1
109	chris.p@frontpageadvantage.com	51	82848	2024-05-23 09:15:42.647769	softwareblog.co.uk	-1
110	chris.p@frontpageadvantage.com	52	82852	2024-05-23 09:15:49.463414	the-casino.co.uk	-1
111	chris.p@frontpageadvantage.com	52	82856	2024-05-23 09:15:57.408596	familyparenting.co.uk	-1
112	chris.p@frontpageadvantage.com	53	82860	2024-05-23 09:16:04.043851	parentings.co.uk	-1
113	chris.p@frontpageadvantage.com	51	82864	2024-05-23 09:16:09.94072	momblogs.co.uk	-1
114	chris.p@frontpageadvantage.com	59	82868	2024-05-23 09:16:17.155609	womenlikethat.co.uk	-1
115	chris.p@frontpageadvantage.com	53	82872	2024-05-23 09:16:24.22809	natural-health.co.uk	-1
116	chris.p@frontpageadvantage.com	53	82876	2024-05-23 09:16:31.025801	mytravelmagazine.co.uk	-1
117	chris.p@frontpageadvantage.com	44	82880	2024-05-23 09:16:37.200924	tripsite.co.uk	-1
118	chris.p@frontpageadvantage.com	68	82884	2024-05-23 09:17:42.840415	dirbook.com	4
119	chris.p@frontpageadvantage.com	61	82890	2024-05-23 09:18:31.746588	futureblogs.net	4
120	chris.p@frontpageadvantage.com	53	82894	2024-05-23 09:18:43.535689	smartblogging.net	2
121	chris.p@frontpageadvantage.com	24	82898	2024-05-23 09:26:32.478914	takeapplepayzone.com	3
122	chris.p@frontpageadvantage.com	60	82902	2024-05-23 09:26:43.836384	webtechmantra.com	1
123	chris.p@frontpageadvantage.com	55	82906	2024-05-23 09:26:52.863964	thefashioncounty.com	1
124	chris.p@frontpageadvantage.com	58	82910	2024-05-23 09:27:00.040812	thebusinessgoals.com	1
125	chris.p@frontpageadvantage.com	55	82914	2024-05-23 09:27:06.911378	techcrazy.org	5
126	chris.p@frontpageadvantage.com	26	82918	2024-05-23 09:27:13.214639	alltechdownload.com	2
127	chris.p@frontpageadvantage.com	57	82922	2024-05-23 09:27:21.752721	todaysought.com	16
128	chris.p@frontpageadvantage.com	55	82926	2024-05-23 09:27:31.666642	trendy2news.com	9
129	chris.p@frontpageadvantage.com	56	82930	2024-05-23 09:27:36.926885	evofoxx.com	9
130	chris.p@frontpageadvantage.com	58	82934	2024-05-23 09:27:45.769011	protalkzone.com	14
131	chris.p@frontpageadvantage.com	59	82940	2024-05-23 09:28:35.317087	sociallykeeda.com	4
132	chris.p@frontpageadvantage.com	58	82944	2024-05-23 09:29:21.73093	digitaltreed.com	2
133	chris.p@frontpageadvantage.com	24	82948	2024-05-23 09:29:37.300308	today-tech-news.com	1
134	chris.p@frontpageadvantage.com	52	82952	2024-05-23 09:29:53.372321	deltaprohike.com	1
135	chris.p@frontpageadvantage.com	9	82956	2024-05-23 09:30:06.95281	varshasaini.in	1
136	chris.p@frontpageadvantage.com	61	82960	2024-05-23 09:30:32.487527	fashion-key.com	1
137	chris.p@frontpageadvantage.com	50	82964	2024-05-23 09:30:45.655076	insidecatholic.com	1
138	chris.p@frontpageadvantage.com	53	82968	2024-05-23 09:30:51.998777	amazingviraltips.com	6
139	chris.p@frontpageadvantage.com	54	82972	2024-05-23 09:30:57.443462	hawkerstreetfood.com	-1
140	chris.p@frontpageadvantage.com	56	82976	2024-05-23 09:34:05.389846	thefashioninfo.com	4
141	chris.p@frontpageadvantage.com	71	82980	2024-05-23 09:34:10.870141	roohome.com	2
142	chris.p@frontpageadvantage.com	54	82984	2024-05-23 09:34:16.647442	webfrenz.com	1
143	chris.p@frontpageadvantage.com	54	82989	2024-05-23 09:34:24.063559	womensbeautyoffers.com	3
144	chris.p@frontpageadvantage.com	44	82993	2024-05-23 09:34:30.545999	trustingeeks.com	-1
145	chris.p@frontpageadvantage.com	57	82997	2024-05-23 09:34:36.279996	travelforfoodhub.com	3
146	chris.p@frontpageadvantage.com	48	83001	2024-05-23 09:34:42.970511	mippin.com	12
147	chris.p@frontpageadvantage.com	53	83005	2024-05-23 09:34:54.419813	areyoufashion.com	1
148	chris.p@frontpageadvantage.com	19	83009	2024-05-23 09:35:15.076054	aitechtrend.com	1
149	chris.p@frontpageadvantage.com	54	83013	2024-05-23 09:35:25.000304	kefimind.com	4
150	chris.p@frontpageadvantage.com	53	83017	2024-05-23 09:35:34.845228	expressdigest.com	1
151	chris.p@frontpageadvantage.com	40	83021	2024-05-23 09:35:41.262201	oneluckytext.com	2
152	chris.p@frontpageadvantage.com	55	83025	2024-05-23 09:35:46.869639	guidebytips.com	5
153	chris.p@frontpageadvantage.com	25	83029	2024-05-23 09:35:54.749813	bolsterfizz.com	3
154	chris.p@frontpageadvantage.com	70	83033	2024-05-23 09:36:03.216989	noragouma.com	5
155	chris.p@frontpageadvantage.com	90	83039	2024-05-23 09:36:14.469727	zshare.net	5
156	chris.p@frontpageadvantage.com	65	83043	2024-05-23 09:37:59.439589	derektime.com	3
157	chris.p@frontpageadvantage.com	41	83052	2024-05-23 09:39:10.622657	googiehost.com	1
158	chris.p@frontpageadvantage.com	43	83056	2024-05-23 09:39:18.864409	rationalinsurgent.com	1
159	chris.p@frontpageadvantage.com	45	83063	2024-05-23 09:40:43.547881	thefashionalists.com	5
160	chris.p@frontpageadvantage.com	56	83067	2024-05-23 09:40:51.889549	techgloss.com	4
161	sam.b@frontpageadvantage.com	28	83073	2024-05-23 10:59:40.151985	forkstofeet.com	2
162	sam.b@frontpageadvantage.com	50	83077	2024-05-23 10:59:47.976755	studieseducation.com	3
163	sam.b@frontpageadvantage.com	58	83081	2024-05-23 11:00:21.202192	techduffer.com	2
164	sam.b@frontpageadvantage.com	56	83087	2024-05-23 11:00:52.887675	odishadiscoms.com	6
165	sam.b@frontpageadvantage.com	59	83091	2024-05-23 11:01:02.941589	blogalmariaplus.com	1
166	sam.b@frontpageadvantage.com	28	83095	2024-05-23 11:01:13.807095	soundgenetics.com	5
167	sam.b@frontpageadvantage.com	57	83099	2024-05-23 11:01:35.691521	mitmunk.com	4
168	sam.b@frontpageadvantage.com	56	83103	2024-05-23 11:01:43.466842	way2earning.com	4
169	sam.b@frontpageadvantage.com	57	83115	2024-05-23 11:07:44.541178	techmediatoday.com	1
170	sam.b@frontpageadvantage.com	42	83121	2024-05-23 11:08:24.899593	wrestling-online.com	1
171	sam.b@frontpageadvantage.com	55	83125	2024-05-23 11:08:35.522074	top10films.co.uk	6
174	sam.b@frontpageadvantage.com	55	83137	2024-05-23 11:08:59.89667	mfidie.com	2
176	sam.b@frontpageadvantage.com	52	83145	2024-05-23 11:09:17.799659	andysowards.com	4
180	sam.b@frontpageadvantage.com	61	83161	2024-05-23 11:10:00.494915	techquark.com	1
182	sam.b@frontpageadvantage.com	32	83169	2024-05-23 11:10:19.994857	brilliantread.com	2
185	sam.b@frontpageadvantage.com	37	83181	2024-05-23 11:10:44.956224	techmediaguide.com	5
186	sam.b@frontpageadvantage.com	34	83185	2024-05-23 11:10:55.896383	mynaturalpestsolutions.com	1
187	sam.b@frontpageadvantage.com	23	83189	2024-05-23 11:11:08.533422	gossipbucket.com	1
172	sam.b@frontpageadvantage.com	53	83129	2024-05-23 11:08:42.808998	interest-library.com	2
175	sam.b@frontpageadvantage.com	41	83141	2024-05-23 11:09:08.140715	forpressrelease.com	1
177	sam.b@frontpageadvantage.com	40	83149	2024-05-23 11:09:29.777105	gaugemagazine.com	1
181	sam.b@frontpageadvantage.com	39	83165	2024-05-23 11:10:09.652425	bestkoditips.com	3
183	sam.b@frontpageadvantage.com	37	83173	2024-05-23 11:10:27.222872	bornrealist.com	3
188	sam.b@frontpageadvantage.com	41	83193	2024-05-23 11:11:15.070624	thestarscoop.com	2
173	sam.b@frontpageadvantage.com	53	83133	2024-05-23 11:08:49.084919	doctorfolk.com	4
178	sam.b@frontpageadvantage.com	59	83153	2024-05-23 11:09:39.50389	designbeep.com	3
179	sam.b@frontpageadvantage.com	56	83157	2024-05-23 11:09:52.551982	asianmoviepulse.com	2
184	sam.b@frontpageadvantage.com	44	83177	2024-05-23 11:10:36.806815	northbridgetimes.com	4
189	sam.b@frontpageadvantage.com	39	83197	2024-05-23 11:11:23.462458	businessmodulehub.com	2
190	sam.b@frontpageadvantage.com	35	83203	2024-05-23 13:27:14.604986	masterreplicashop.com	-1
191	sam.b@frontpageadvantage.com	51	83206	2024-05-23 13:27:23.420655	technewsbusiness.com	1
192	sam.b@frontpageadvantage.com	54	83210	2024-05-23 13:27:34.69405	techbtimes.com	1
193	sam.b@frontpageadvantage.com	54	83214	2024-05-23 13:27:45.734791	itsforbes.com	2
194	sam.b@frontpageadvantage.com	53	83218	2024-05-23 13:27:54.430636	businessnewsdaily.net	10
195	sam.b@frontpageadvantage.com	9	83222	2024-05-23 13:28:06.85871	timefinest.com	2
196	chris.p@frontpageadvantage.com	27	83226	2024-05-24 10:40:20.90377	damteq.co.uk	1
197	chris.p@frontpageadvantage.com	23	85711	2024-06-14 12:22:00.985642	teawashere.com	10
198	sam.b@frontpageadvantage.com	57	86151	2024-06-25 12:21:16.085585	supanet.com	13
199	sam.b@frontpageadvantage.com	22	86159	2024-06-25 12:22:55.043752	megri.co.uk	31
200	sam.b@frontpageadvantage.com	44	86177	2024-06-25 12:25:27.101648	yourcoffeebreak.co.uk	16
201	sam.b@frontpageadvantage.com	56	86200	2024-06-25 12:45:24.860276	ukhomeimprovement.co.uk	4
202	sam.b@frontpageadvantage.com	75	86203	2024-06-25 12:46:03.168895	davidicke.com	9
203	sam.b@frontpageadvantage.com	49	86207	2024-06-25 12:46:20.670688	apps.uk	6
204	sam.b@frontpageadvantage.com	45	86213	2024-06-25 12:46:40.943853	prowess.org.uk	5
205	sam.b@frontpageadvantage.com	41	86260	2024-06-25 13:02:43.263987	voucherix.co.uk	3
206	sam.b@frontpageadvantage.com	44	86271	2024-06-25 13:05:29.937771	dontstopliving.net	1
207	sam.b@frontpageadvantage.com	45	86283	2024-06-25 13:27:24.570425	skopemag.com	1
208	sam.b@frontpageadvantage.com	35	86291	2024-06-25 13:29:33.564662	diversitynewsmagazine.com	3
209	sam.b@frontpageadvantage.com	55	86295	2024-06-25 13:29:44.944233	thetophints.com	4
210	sam.b@frontpageadvantage.com	50	86299	2024-06-25 13:29:58.418672	culturebully.com	2
211	sam.b@frontpageadvantage.com	40	86303	2024-06-25 13:30:09.499578	justaveragejen.com	1
212	sam.b@frontpageadvantage.com	54	86307	2024-06-25 13:30:22.287825	cravemag.co.uk	1
213	sam.b@frontpageadvantage.com	57	86315	2024-06-25 13:31:44.991324	ravishmag.co.uk	1
214	sam.b@frontpageadvantage.com	37	86319	2024-06-25 13:32:01.891936	savings4savvymums.co.uk	3
215	sam.b@frontpageadvantage.com	62	86323	2024-06-25 13:32:17.433659	newsanyway.com	1
216	sam.b@frontpageadvantage.com	45	86331	2024-06-25 13:33:48.97994	streettalklive.com	1
217	sam.b@frontpageadvantage.com	39	86335	2024-06-25 13:33:59.448886	abeautifulspace.co.uk	1
218	sam.b@frontpageadvantage.com	39	86339	2024-06-25 13:34:10.448321	getblogo.com	9
219	sam.b@frontpageadvantage.com	31	86343	2024-06-25 13:34:21.842924	myuniquehome.co.uk	1
220	sam.b@frontpageadvantage.com	53	86347	2024-06-25 13:34:36.624121	rslonline.com	2
221	sam.b@frontpageadvantage.com	26	86351	2024-06-25 13:34:47.165933	financial-expert.co.uk	1
222	sam.b@frontpageadvantage.com	44	86355	2024-06-25 13:34:58.470269	businesstelegraph.co.uk	1
223	sam.b@frontpageadvantage.com	40	86402	2024-06-26 10:06:42.814433	b31.org.uk	7
224	sam.b@frontpageadvantage.com	36	86405	2024-06-26 10:06:51.372659	thegooddogguide.com	8
225	sam.b@frontpageadvantage.com	56	86409	2024-06-26 10:06:57.804945	thebestof.co.uk	7
226	sam.b@frontpageadvantage.com	55	86486	2024-06-26 13:46:09.896481	homify.co.uk	11
227	sam.b@frontpageadvantage.com	33	86496	2024-06-26 13:47:37.808379	spursforlife.com	6
228	sam.b@frontpageadvantage.com	31	86514	2024-06-27 13:52:21.25333	womentalking.co.uk	11
229	sam.b@frontpageadvantage.com	55	86522	2024-06-27 13:53:38.950014	lawnews.co.uk	11
230	sam.b@frontpageadvantage.com	61	86540	2024-06-27 13:57:21.475272	pitpass.com	16
231	sam.b@frontpageadvantage.com	42	86544	2024-06-27 13:57:29.043035	collthings.co.uk	7
232	sam.b@frontpageadvantage.com	38	86548	2024-06-27 13:57:40.344178	cyberkendra.com	5
233	sam.b@frontpageadvantage.com	34	86552	2024-06-27 13:57:54.187368	searchengineinsight.com	-1
234	sam.b@frontpageadvantage.com	40	86556	2024-06-27 13:58:03.316565	telemediaonline.co.uk	1
252	james.p@frontpageadvantage.com	38	92189	2024-08-28 12:44:48.17067	thehansindia.co.uk	-1
253	james.p@frontpageadvantage.com	35	92192	2024-08-28 12:44:58.543668	whatsmind.co.uk	8
254	james.p@frontpageadvantage.com	37	92200	2024-08-28 12:46:07.432188	mysterioushub.co.uk	-1
255	james.p@frontpageadvantage.com	56	92204	2024-08-28 12:46:23.26013	cricbuzz.uk	6
256	james.p@frontpageadvantage.com	37	92208	2024-08-28 12:46:32.185344	pressmagazine.co.uk	-1
257	james.p@frontpageadvantage.com	36	98424	2024-09-03 11:00:00.868857	bsranker.com	-1
258	james.p@frontpageadvantage.com	37	98428	2024-09-03 11:00:23.873004	timemagazene.com	-1
259	james.p@frontpageadvantage.com	36	98431	2024-09-03 11:00:36.363243	topbusinessinsight.com	-1
260	james.p@frontpageadvantage.com	56	98941	2024-09-10 08:40:16.848621	ukbusinessmagazine.co.uk	-1
261	james.p@frontpageadvantage.com	35	99199	2024-09-10 11:15:18.100252	celebritiesdoingnow.com	5
262	james.p@frontpageadvantage.com	36	99205	2024-09-10 11:15:27.439192	celebhunk.com	10
263	james.p@frontpageadvantage.com	36	99218	2024-09-10 11:16:10.842613	bioviki.com	7
264	james.p@frontpageadvantage.com	71	99228	2024-09-10 11:19:09.231819	fundly.com	8
265	james.p@frontpageadvantage.com	37	99456	2024-09-11 12:34:12.101463	getfont.net	6
266	james.p@frontpageadvantage.com	44	99464	2024-09-11 12:35:49.220244	speedwaymedia.com	1
267	james.p@frontpageadvantage.com	31	99468	2024-09-11 12:35:57.318556	yourstudyblog.com	1
268	james.p@frontpageadvantage.com	56	99472	2024-09-11 12:36:14.26701	cybersectors.com	3
269	james.p@frontpageadvantage.com	58	99477	2024-09-11 12:36:56.796139	media-kom.com	4
270	james.p@frontpageadvantage.com	62	99485	2024-09-11 12:37:59.143613	amirarticles.com	4
271	james.p@frontpageadvantage.com	64	99489	2024-09-11 12:38:06.547175	sisidunia.com	4
273	james.p@frontpageadvantage.com	81	99497	2024-09-11 12:38:20.129352	uploading.com	6
275	james.p@frontpageadvantage.com	61	99505	2024-09-11 12:38:33.782571	bollywood-media.com	1
277	james.p@frontpageadvantage.com	63	99513	2024-09-11 12:38:46.299417	snappernews.com	7
283	james.p@frontpageadvantage.com	58	99541	2024-09-11 12:40:29.298837	dcrazed.net	8
285	james.p@frontpageadvantage.com	61	99549	2024-09-11 12:40:47.386971	sneadstate.org	6
287	james.p@frontpageadvantage.com	57	99557	2024-09-11 12:41:05.349187	designdare.com	1
290	james.p@frontpageadvantage.com	73	99569	2024-09-11 12:41:23.296246	articleify.com	2
291	james.p@frontpageadvantage.com	72	99573	2024-09-11 12:41:46.482045	nykdaily.com	1
292	james.p@frontpageadvantage.com	72	99577	2024-09-11 12:41:54.87746	imcgrupo.com	4
293	james.p@frontpageadvantage.com	55	99581	2024-09-11 12:42:00.697867	lifeneedslemons.com	2
294	james.p@frontpageadvantage.com	53	99585	2024-09-11 12:42:06.76095	greathomesaz.com	10
272	james.p@frontpageadvantage.com	78	99493	2024-09-11 12:38:13.069871	feedsportal.com	6
274	james.p@frontpageadvantage.com	47	99501	2024-09-11 12:38:27.387203	fortunetelleroracle.com	3
276	james.p@frontpageadvantage.com	56	99509	2024-09-11 12:38:39.453458	trendytarzan.com	4
278	james.p@frontpageadvantage.com	57	99517	2024-09-11 12:38:58.225855	zainview.com	3
279	james.p@frontpageadvantage.com	70	99521	2024-09-11 12:39:06.273307	lerablog.org	4
280	james.p@frontpageadvantage.com	71	99525	2024-09-11 12:39:12.382591	foodnhealth.org	4
281	james.p@frontpageadvantage.com	66	99529	2024-09-11 12:39:18.902322	whatisfullformof.com	7
282	james.p@frontpageadvantage.com	79	99533	2024-09-11 12:39:33.300368	chiangraitimes.com	2
284	james.p@frontpageadvantage.com	65	99545	2024-09-11 12:40:40.950744	thesbb.com	8
286	james.p@frontpageadvantage.com	62	99553	2024-09-11 12:40:58.916529	outlookappins.com	6
288	james.p@frontpageadvantage.com	56	99561	2024-09-11 12:41:11.508472	hebcljx.com	3
289	james.p@frontpageadvantage.com	61	99565	2024-09-11 12:41:17.31035	stopie.com	3
295	james.p@frontpageadvantage.com	58	99590	2024-09-11 12:42:12.86808	whatsmagazine.com	1
296	james.p@frontpageadvantage.com	68	99593	2024-09-11 12:42:19.75602	duluthfurniturestore.com	4
297	james.p@frontpageadvantage.com	76	99597	2024-09-11 12:42:25.866361	truthbaoutabs.com	2
298	james.p@frontpageadvantage.com	61	99601	2024-09-11 12:42:34.034954	condition-best.com	7
299	james.p@frontpageadvantage.com	62	99605	2024-09-11 12:42:39.88689	idooonline.com	4
300	james.p@frontpageadvantage.com	58	99609	2024-09-11 12:42:46.412966	viralrang.com	3
301	james.p@frontpageadvantage.com	60	99613	2024-09-11 12:42:54.049336	newssearchportal.com	3
302	james.p@frontpageadvantage.com	60	99617	2024-09-11 12:43:00.406698	quantumcristal.com	8
303	james.p@frontpageadvantage.com	58	99621	2024-09-11 12:43:06.943236	eclinknews.com	7
304	james.p@frontpageadvantage.com	66	99625	2024-09-11 12:43:13.027868	worddocx.com	7
305	james.p@frontpageadvantage.com	58	99629	2024-09-11 12:43:19.63454	press-business.com	3
306	james.p@frontpageadvantage.com	62	99633	2024-09-11 12:43:24.938589	electronicdiscountsales.com	1
307	james.p@frontpageadvantage.com	65	99637	2024-09-11 12:43:30.179599	scumdoctor.com	3
308	james.p@frontpageadvantage.com	57	99641	2024-09-11 12:43:35.388589	vvplawfirm.com	-1
309	james.p@frontpageadvantage.com	64	99645	2024-09-11 12:43:41.419027	asouthernlighthouse.com	7
310	james.p@frontpageadvantage.com	64	99649	2024-09-11 12:43:51.380819	spikysnail.com	4
311	james.p@frontpageadvantage.com	58	99654	2024-09-11 12:44:50.714302	urdufeed.com	8
312	james.p@frontpageadvantage.com	64	99657	2024-09-11 12:44:57.380696	digitalforhealth.com	4
313	james.p@frontpageadvantage.com	60	99661	2024-09-11 12:52:14.944638	universityfitnesscenter.com	4
314	james.p@frontpageadvantage.com	55	99666	2024-09-11 12:52:23.379216	myzeo.com	3
315	james.p@frontpageadvantage.com	57	99669	2024-09-11 12:52:33.754632	homeconstructionnews.com	18
316	james.p@frontpageadvantage.com	57	99673	2024-09-11 12:52:40.020145	houseconstructioninfo.com	2
317	james.p@frontpageadvantage.com	56	99677	2024-09-11 12:52:47.590191	healthmedcity.com	3
318	james.p@frontpageadvantage.com	72	99681	2024-09-11 12:52:53.581675	stylishster.com	8
319	james.p@frontpageadvantage.com	55	99685	2024-09-11 12:53:01.326161	invixtechnology.com	5
320	james.p@frontpageadvantage.com	57	99689	2024-09-11 12:53:08.118929	zellersrestaurants.com	1
321	james.p@frontpageadvantage.com	63	99693	2024-09-11 12:53:15.170579	beaudermaskincare.com	3
322	james.p@frontpageadvantage.com	60	99697	2024-09-11 12:53:22.240245	cwcb-law.com	9
323	james.p@frontpageadvantage.com	55	99701	2024-09-11 12:53:28.343146	industrial-techno.com	13
324	james.p@frontpageadvantage.com	56	99705	2024-09-11 12:53:35.303399	whizzherald.com	9
325	james.p@frontpageadvantage.com	37	99709	2024-09-11 12:53:50.506648	novelsoul.com	2
326	james.p@frontpageadvantage.com	38	99713	2024-09-11 12:54:00.110696	breakingbyte.org	3
327	james.p@frontpageadvantage.com	37	99717	2024-09-11 12:54:08.250268	statusborn.com	2
328	james.p@frontpageadvantage.com	59	99721	2024-09-11 12:54:31.279133	showtimelive.co.uk	1
329	james.p@frontpageadvantage.com	58	99725	2024-09-11 12:54:38.07595	thevictoriainnderby.co.uk	4
330	james.p@frontpageadvantage.com	59	99729	2024-09-11 12:54:45.56827	wzrd.co.uk	12
331	james.p@frontpageadvantage.com	33	99733	2024-09-11 12:54:53.525375	bitparade.co.uk	8
332	james.p@frontpageadvantage.com	54	99737	2024-09-11 12:55:00.411636	awodevents.co.uk	2
333	james.p@frontpageadvantage.com	52	99741	2024-09-11 12:55:10.519095	investmenttips.co.uk	8
334	james.p@frontpageadvantage.com	58	99745	2024-09-11 12:55:45.450878	thewonderblog.co.uk	3
335	james.p@frontpageadvantage.com	58	99749	2024-09-11 12:55:57.683985	3hundredand65.co.uk	19
336	james.p@frontpageadvantage.com	59	99753	2024-09-11 12:56:04.786765	gnutella.co.uk	9
337	james.p@frontpageadvantage.com	35	99757	2024-09-11 12:56:12.566564	maximvengerovfans.co.uk	5
338	james.p@frontpageadvantage.com	48	99761	2024-09-11 12:56:21.073924	247newshub.co.uk	15
339	james.p@frontpageadvantage.com	49	99765	2024-09-11 12:56:26.302009	dailynews247.co.uk	19
340	james.p@frontpageadvantage.com	55	99777	2024-09-11 13:06:32.627426	abusinesspoint.com	4
341	james.p@frontpageadvantage.com	66	99781	2024-09-11 13:06:52.168967	trendingbird.com	6
342	james.p@frontpageadvantage.com	64	99785	2024-09-11 13:07:00.222778	famavip.com	3
343	james.p@frontpageadvantage.com	61	99791	2024-09-11 13:28:45.3547	cricfor.com	5
344	james.p@frontpageadvantage.com	1	99798	2024-09-11 13:29:56.072631	gisuser.co	-1
345	james.p@frontpageadvantage.com	55	99802	2024-09-11 13:30:08.938089	thewebmagazine.org	5
346	james.p@frontpageadvantage.com	55	99806	2024-09-11 13:30:14.784573	blogsact.com	5
347	james.p@frontpageadvantage.com	51	99811	2024-09-11 13:49:36.526969	gadgetsng.com	1
348	james.p@frontpageadvantage.com	68	99815	2024-09-11 13:49:44.477905	your-home-design.com	1
349	james.p@frontpageadvantage.com	57	99819	2024-09-11 13:49:52.117923	hypowerfuel.com	7
350	james.p@frontpageadvantage.com	62	99823	2024-09-11 13:50:05.251943	thefoodbuff.com	6
351	james.p@frontpageadvantage.com	71	99827	2024-09-11 13:50:12.604502	teleshowupdates.com	5
352	james.p@frontpageadvantage.com	61	99832	2024-09-11 13:50:20.866076	lendingblocklibrary.com	9
354	james.p@frontpageadvantage.com	60	99839	2024-09-11 13:50:36.492875	restaurants-by-city.com	1
356	james.p@frontpageadvantage.com	58	99847	2024-09-11 13:50:52.959546	shopchoicefoods.com	3
358	james.p@frontpageadvantage.com	57	99855	2024-09-11 13:51:08.76452	homeliga.com	-1
360	james.p@frontpageadvantage.com	57	99863	2024-09-11 13:51:20.9341	homesmallkitchen.com	3
362	james.p@frontpageadvantage.com	54	99871	2024-09-11 13:51:37.345949	mybusinesscardsusa.com	5
364	james.p@frontpageadvantage.com	71	99879	2024-09-11 13:51:49.952306	pullmanbalilegiannirwana.com	4
366	james.p@frontpageadvantage.com	62	99887	2024-09-11 13:52:02.566746	e-medicinehealth.com	7
368	james.p@frontpageadvantage.com	71	99895	2024-09-11 13:52:15.04031	homesinteriordesign.net	4
370	james.p@frontpageadvantage.com	58	99903	2024-09-11 13:52:28.90742	darkhome-ent.com	5
372	james.p@frontpageadvantage.com	60	99911	2024-09-11 13:52:41.102581	tt-technoteam.com	7
376	james.p@frontpageadvantage.com	62	99928	2024-09-11 13:56:46.162462	house-realestate.com	6
378	james.p@frontpageadvantage.com	49	99947	2024-09-11 13:58:16.815305	bgonews.com	8
380	james.p@frontpageadvantage.com	54	99955	2024-09-11 13:58:32.090777	housedecorin.com	1
381	james.p@frontpageadvantage.com	53	99961	2024-09-11 13:58:49.172188	itsmyownway.com	1
384	james.p@frontpageadvantage.com	36	99984	2024-09-11 14:02:21.478104	morninglif.com	4
353	james.p@frontpageadvantage.com	71	99835	2024-09-11 13:50:28.159271	cinziamorini.com	1
355	james.p@frontpageadvantage.com	52	99843	2024-09-11 13:50:44.296744	armorytechairsoft.com	1
357	james.p@frontpageadvantage.com	61	99851	2024-09-11 13:51:02.128519	beautyprog.com	1
359	james.p@frontpageadvantage.com	58	99859	2024-09-11 13:51:15.288846	refinohomes.com	3
361	james.p@frontpageadvantage.com	59	99867	2024-09-11 13:51:29.003296	dydepune.com	7
363	james.p@frontpageadvantage.com	57	99875	2024-09-11 13:51:43.549597	inserve-ehealth.com	20
365	james.p@frontpageadvantage.com	55	99883	2024-09-11 13:51:56.255996	healtheasyremedy.com	7
367	james.p@frontpageadvantage.com	53	99891	2024-09-11 13:52:08.314079	manwomanfashion.com	-1
369	james.p@frontpageadvantage.com	54	99899	2024-09-11 13:52:22.29172	cityroomescape.com	2
371	james.p@frontpageadvantage.com	59	99907	2024-09-11 13:52:35.105613	thehealthking.com	3
373	james.p@frontpageadvantage.com	63	99916	2024-09-11 13:56:16.738618	wetechtricks.com	9
374	james.p@frontpageadvantage.com	67	99920	2024-09-11 13:56:24.708741	myhealthyprosperity.com	2
375	james.p@frontpageadvantage.com	59	99924	2024-09-11 13:56:39.611417	sniffleshomecare.com	6
377	james.p@frontpageadvantage.com	46	99943	2024-09-11 13:58:10.58661	zootoo.com	3
379	james.p@frontpageadvantage.com	56	99951	2024-09-11 13:58:23.805832	educationdailynews.com	6
382	james.p@frontpageadvantage.com	57	99965	2024-09-11 13:58:54.695006	socialtalky.com	4
383	james.p@frontpageadvantage.com	37	99980	2024-09-11 14:02:13.418328	allcelebo.com	5
385	james.p@frontpageadvantage.com	62	99992	2024-09-11 14:03:39.484303	filmyques.net	5
386	james.p@frontpageadvantage.com	38	100001	2024-09-11 14:31:35.935884	grindrprofiles.com	2
387	james.p@frontpageadvantage.com	8	100004	2024-09-11 14:32:38.792049	thetravellino.com	2
388	james.p@frontpageadvantage.com	50	100008	2024-09-11 14:32:45.679861	topportal.co	4
389	james.p@frontpageadvantage.com	58	100012	2024-09-11 14:32:56.687991	bollybio.org	8
390	james.p@frontpageadvantage.com	7	100016	2024-09-11 14:34:25.997576	newigcaptions.com	4
391	james.p@frontpageadvantage.com	27	100020	2024-09-11 14:34:35.258271	jokescoff.com	2
392	james.p@frontpageadvantage.com	39	100028	2024-09-11 14:35:55.997327	embedds.com	2
393	james.p@frontpageadvantage.com	57	100032	2024-09-11 14:36:04.733939	masstamilan.in	3
394	james.p@frontpageadvantage.com	36	100036	2024-09-11 14:36:42.802618	htv.com.pk	1
395	james.p@frontpageadvantage.com	30	100040	2024-09-11 14:36:55.962326	vlivetricks.com	4
396	james.p@frontpageadvantage.com	34	100044	2024-09-11 14:37:16.533079	amrajani.com	2
397	james.p@frontpageadvantage.com	61	100052	2024-09-11 14:38:48.000521	bdtipsnet.com	10
398	james.p@frontpageadvantage.com	61	100056	2024-09-11 14:39:02.182784	banglablogpost.com	-1
399	james.p@frontpageadvantage.com	55	100060	2024-09-11 14:39:18.613855	banglastatustext.com	58
400	james.p@frontpageadvantage.com	27	100064	2024-09-11 14:39:25.425216	foodrfitness.com	7
401	james.p@frontpageadvantage.com	6	100068	2024-09-11 14:39:31.519309	noteindia.com	54
402	james.p@frontpageadvantage.com	59	100072	2024-09-11 14:40:05.238772	emagazine.com	43
403	james.p@frontpageadvantage.com	46	100083	2024-09-11 14:57:07.927094	dillo.org	9
404	james.p@frontpageadvantage.com	45	100090	2024-09-11 14:58:26.134959	sallybernstein.com	3
405	james.p@frontpageadvantage.com	53	100094	2024-09-11 14:58:39.793857	psychreg.org	5
406	james.p@frontpageadvantage.com	48	100098	2024-09-11 15:05:13.282947	worldnews24.uk	8
407	james.p@frontpageadvantage.com	49	100102	2024-09-11 15:05:21.813782	autowreckersandparts.com	6
408	james.p@frontpageadvantage.com	49	100106	2024-09-11 15:05:28.186292	goldontheweb.com	3
409	james.p@frontpageadvantage.com	48	100110	2024-09-11 15:05:36.935613	newsbroadcast.uk	9
410	james.p@frontpageadvantage.com	48	100114	2024-09-11 15:05:55.018716	partners-friends.com	6
411	james.p@frontpageadvantage.com	48	100118	2024-09-11 15:09:30.651152	thrivebusinessadvisor.com	3
412	james.p@frontpageadvantage.com	48	100122	2024-09-11 15:09:38.301139	ivytechoamtc.com	1
413	james.p@frontpageadvantage.com	49	100126	2024-09-11 15:09:56.974423	recipes2all.com	1
414	james.p@frontpageadvantage.com	49	100131	2024-09-11 15:10:07.735576	thetravelpop.com	6
415	james.p@frontpageadvantage.com	48	100134	2024-09-11 15:10:33.134708	gradivahotels.com	1
416	james.p@frontpageadvantage.com	48	100138	2024-09-11 15:10:40.216979	poutineweekmtl.com	7
417	james.p@frontpageadvantage.com	49	100142	2024-09-11 15:10:46.993151	businessnetpages.org	16
418	james.p@frontpageadvantage.com	49	100146	2024-09-11 15:11:06.710237	binatani.com	12
419	james.p@frontpageadvantage.com	49	100150	2024-09-11 15:11:12.964195	therono.com	4
420	james.p@frontpageadvantage.com	48	100154	2024-09-11 15:11:19.288777	motoburg.com	11
421	james.p@frontpageadvantage.com	48	100158	2024-09-11 15:11:34.441238	businessthunder.com	7
422	james.p@frontpageadvantage.com	48	100162	2024-09-11 15:11:51.140127	healthwaterfront.com	23
423	james.p@frontpageadvantage.com	48	100166	2024-09-11 15:11:58.667047	automotivestick.com	10
424	james.p@frontpageadvantage.com	48	100170	2024-09-11 15:12:08.406553	shoppingstamp.com	6
425	james.p@frontpageadvantage.com	48	100174	2024-09-11 15:12:15.935956	automotivecharts.com	6
426	james.p@frontpageadvantage.com	49	100179	2024-09-11 15:12:23.645078	shoppingredhot.com	7
427	james.p@frontpageadvantage.com	49	100182	2024-09-11 15:12:32.233168	technologystick.com	9
428	james.p@frontpageadvantage.com	48	100186	2024-09-11 15:12:40.886695	americanamusicfestusa.com	61
429	james.p@frontpageadvantage.com	48	100191	2024-09-11 15:12:48.262136	araexpo.org	9
430	james.p@frontpageadvantage.com	48	100194	2024-09-11 15:12:54.834039	7continentsmedia.com	4
431	james.p@frontpageadvantage.com	47	100198	2024-09-11 15:13:02.622143	163m.cc	52
432	james.p@frontpageadvantage.com	48	100202	2024-09-11 15:13:14.798471	cialisb.com	38
452	james.p@frontpageadvantage.com	82	100306	2024-09-12 09:43:57.824934	thisismoney.co.uk	7
453	james.p@frontpageadvantage.com	24	100311	2024-09-12 09:45:25.257341	socialstudent.co.uk	51
454	james.p@frontpageadvantage.com	41	100630	2024-09-12 14:17:23.599234	stereotude.com	1
455	james.p@frontpageadvantage.com	53	100633	2024-09-12 14:17:41.710534	goshoppingzone.com	3
456	james.p@frontpageadvantage.com	54	100637	2024-09-12 14:17:56.348099	discussanythinghere.com	4
457	james.p@frontpageadvantage.com	52	100646	2024-09-13 07:44:14.702151	tojug.com	3
458	james.p@frontpageadvantage.com	31	100856	2024-09-13 15:26:49.106383	savvyinsomerset.com	1
459	james.p@frontpageadvantage.com	58	101079	2024-09-17 08:05:58.245657	hubbyhelps.com	1
502	james.p@frontpageadvantage.com	30	101664	2024-09-24 08:05:32.520568	poundsandsense.com	-1
503	james.p@frontpageadvantage.com	36	101680	2024-09-24 10:21:35.263183	startupguys.co.uk	7
504	james.p@frontpageadvantage.com	36	101683	2024-09-24 10:22:06.8394	businessstand.co.uk	-1
505	james.p@frontpageadvantage.com	37	101691	2024-09-24 10:23:15.526468	jypost.co.uk	-1
506	james.p@frontpageadvantage.com	35	101698	2024-09-24 10:23:33.681276	spacejournal.co.uk	-1
507	james.p@frontpageadvantage.com	36	101701	2024-09-24 10:23:41.243099	makeeasylife.co.uk	-1
508	james.p@frontpageadvantage.com	54	101738	2024-09-24 14:27:02.560948	fictionistic.com	3
552	james.p@frontpageadvantage.com	3	14937465	2024-10-23 08:25:19.907073	themarialiberatishow.com	-1
553	james.p@frontpageadvantage.com	35	14937468	2024-10-23 08:27:10.855146	marialiberati.com	60
554	chris.p@frontpageadvantage.com	64	14937479	2024-10-23 08:40:48.84557	breadcentrale.co.uk	6
555	chris.p@frontpageadvantage.com	70	14937482	2024-10-23 08:44:48.548089	supremeuk.co.uk	2
556	chris.p@frontpageadvantage.com	65	14937486	2024-10-23 08:45:06.249108	flamusements.co.uk	3
557	chris.p@frontpageadvantage.com	66	14937490	2024-10-23 08:46:06.45428	njug.co.uk	3
558	james.p@frontpageadvantage.com	12	14937500	2024-10-23 09:41:50.01266	techmadam.com	19
559	james.p@frontpageadvantage.com	75	14937504	2024-10-23 09:42:36.568525	catalysticmedia.com	1
560	james.p@frontpageadvantage.com	71	14937508	2024-10-23 09:42:56.894824	thehunkies.com	6
561	james.p@frontpageadvantage.com	70	14937513	2024-10-23 09:43:53.290681	carworldnetwork.com	1
562	frontpage.ga@gmail.com	71	14937537	2024-10-24 10:30:48.513709	ldnconnected.co.uk	-1
563	frontpage.ga@gmail.com	65	14937540	2024-10-24 10:31:39.217286	pcsite.co.uk	1
564	frontpage.ga@gmail.com	65	14937548	2024-10-24 10:34:03.388566	e-architect.co.uk	2
565	frontpage.ga@gmail.com	62	14937559	2024-10-24 10:44:21.473525	boove.co.uk	5
566	frontpage.ga@gmail.com	57	14937562	2024-10-24 10:45:27.729723	sports-view.co.uk	-1
567	frontpage.ga@gmail.com	55	14937566	2024-10-24 10:45:56.558493	dailyhawker.co.uk	1
568	frontpage.ga@gmail.com	53	14937572	2024-10-24 10:47:03.950934	mycelebritylife.co.uk	2
569	frontpage.ga@gmail.com	51	14937576	2024-10-24 10:47:33.419461	businesscomputingworld.co.uk	1
570	frontpage.ga@gmail.com	51	14937582	2024-10-24 10:48:04.969292	mightygadget.co.uk	1
571	frontpage.ga@gmail.com	46	14937586	2024-10-24 10:48:13.140503	filmoria.co.uk	2
572	frontpage.ga@gmail.com	47	14937590	2024-10-24 10:48:29.002376	bobfm.co.uk	4
573	frontpage.ga@gmail.com	45	14937596	2024-10-24 10:48:59.499797	businessmotoring.co.uk	2
574	frontpage.ga@gmail.com	45	14937600	2024-10-24 10:49:09.778412	etspeaksfromhome.co.uk	1
575	frontpage.ga@gmail.com	41	14937613	2024-10-24 10:50:19.568901	techregister.co.uk	2
576	frontpage.ga@gmail.com	41	14937616	2024-10-24 10:50:33.291953	on-magazine.co.uk	1
577	frontpage.ga@gmail.com	34	14937641	2024-10-24 10:52:50.517976	realmensow.co.uk	6
578	frontpage.ga@gmail.com	35	14937648	2024-10-24 10:53:20.965438	newscabal.co.uk	1
579	frontpage.ga@gmail.com	34	14937666	2024-10-24 10:54:37.457364	mediarunsearch.co.uk	5
580	frontpage.ga@gmail.com	32	14937676	2024-10-24 10:55:11.202041	randrlife.co.uk	5
581	frontpage.ga@gmail.com	31	14937680	2024-10-24 10:55:17.417861	fullsync.co.uk	5
582	frontpage.ga@gmail.com	31	14937684	2024-10-24 10:55:24.121934	behealthynow.co.uk	2
583	frontpage.ga@gmail.com	66	14937696	2024-10-24 11:04:09.118703	zaikalivingston.co.uk	3
584	frontpage.ga@gmail.com	64	14937700	2024-10-24 11:04:19.041602	lukemurphypt.co.uk	8
585	frontpage.ga@gmail.com	64	14937704	2024-10-24 11:04:29.438274	iscuk.co.uk	7
586	frontpage.ga@gmail.com	64	14937708	2024-10-24 11:04:37.666484	stclareshospice.co.uk	6
587	frontpage.ga@gmail.com	65	14937712	2024-10-24 11:05:12.175181	bromilowsflorist.co.uk	5
588	frontpage.ga@gmail.com	65	14937716	2024-10-24 11:05:19.333567	hopeforharmonie.co.uk	4
589	frontpage.ga@gmail.com	64	14937720	2024-10-24 11:05:27.096683	mofpb.co.uk	4
590	frontpage.ga@gmail.com	64	14937724	2024-10-24 11:05:34.48726	theriverhut.co.uk	3
591	frontpage.ga@gmail.com	66	14937728	2024-10-24 11:05:41.993403	blandfordhillwindfarm.co.uk	3
592	frontpage.ga@gmail.com	65	14937732	2024-10-24 11:05:49.321565	quiethavenhotel.co.uk	2
593	frontpage.ga@gmail.com	59	14937736	2024-10-24 11:05:59.652869	oeneo.co.uk	8
594	frontpage.ga@gmail.com	65	14937740	2024-10-24 11:06:13.266651	conti-central.co.uk	7
595	frontpage.ga@gmail.com	64	14937746	2024-10-24 11:06:33.435279	myworldgame.co.uk	2
596	frontpage.ga@gmail.com	64	14937750	2024-10-24 11:06:40.326836	darmarrakech.co.uk	2
597	frontpage.ga@gmail.com	64	14937754	2024-10-24 11:06:53.386097	ndependent.co.uk	2
598	frontpage.ga@gmail.com	63	14937758	2024-10-24 11:07:06.996891	excelinecatering.co.uk	9
599	frontpage.ga@gmail.com	63	14937762	2024-10-24 11:07:14.163146	earn-moneyuk.co.uk	7
600	frontpage.ga@gmail.com	63	14937767	2024-10-24 11:07:21.865048	villagers-game.co.uk	5
601	frontpage.ga@gmail.com	63	14937771	2024-10-24 11:07:28.669329	brilliantassignment.co.uk	4
602	frontpage.ga@gmail.com	64	14937775	2024-10-24 11:07:36.244655	stlohnschurchgalashlels.co.uk	4
603	frontpage.ga@gmail.com	64	14937779	2024-10-24 11:07:43.884723	spenboroughtoday.co.uk	4
604	frontpage.ga@gmail.com	63	14937783	2024-10-24 11:07:52.236295	pistuffing.co.uk	3
605	frontpage.ga@gmail.com	63	14937787	2024-10-24 11:08:24.292342	hawickroyalalbert.co.uk	2
606	frontpage.ga@gmail.com	61	14937791	2024-10-24 11:08:33.472276	didcot-gateway.co.uk	7
607	frontpage.ga@gmail.com	63	14937795	2024-10-24 11:08:42.134222	crepeshop.co.uk	5
608	frontpage.ga@gmail.com	62	14937809	2024-10-24 11:12:33.937591	fujitsu-siemens-shop.co.uk	4
609	frontpage.ga@gmail.com	61	14937813	2024-10-24 11:12:45.288971	eurorscglondon.co.uk	3
610	frontpage.ga@gmail.com	61	14937817	2024-10-24 11:12:57.456907	dancingtrousers.co.uk	2
611	frontpage.ga@gmail.com	61	14937821	2024-10-24 11:13:08.32907	thehgwells.co.uk	2
612	frontpage.ga@gmail.com	62	14937825	2024-10-24 11:13:16.513838	thorpemarshgaspipeline.co.uk	2
613	frontpage.ga@gmail.com	61	14937829	2024-10-24 11:13:26.419557	salisburyarlscenlre.co.uk	8
614	frontpage.ga@gmail.com	61	14937833	2024-10-24 11:13:36.548398	ivoryarch-elephantcastle.co.uk	6
615	frontpage.ga@gmail.com	61	14937837	2024-10-24 11:13:46.950936	thairoomlondon.co.uk	5
616	frontpage.ga@gmail.com	60	14937841	2024-10-24 11:14:00.425193	heronproductions.co.uk	5
617	frontpage.ga@gmail.com	61	14937845	2024-10-24 11:14:12.988543	milkwoodhernehill.co.uk	5
618	frontpage.ga@gmail.com	62	14937849	2024-10-24 11:14:20.164512	myarchitecturalservices.co.uk	4
619	frontpage.ga@gmail.com	62	14937855	2024-10-24 11:14:42.705841	advertiserhub.co.uk	3
620	frontpage.ga@gmail.com	61	14937859	2024-10-24 11:14:54.991333	bufcsupportersclub.co.uk	1
621	frontpage.ga@gmail.com	61	14937863	2024-10-24 11:15:02.977179	quattrozerodelivery.co.uk	1
622	frontpage.ga@gmail.com	60	14937867	2024-10-24 11:15:11.267514	ronindo.co.uk	9
623	frontpage.ga@gmail.com	60	14937871	2024-10-24 11:15:20.627538	iconicbritain.co.uk	7
624	frontpage.ga@gmail.com	61	14937875	2024-10-24 11:15:29.60046	insolvency8hlca.co.uk	4
625	frontpage.ga@gmail.com	60	14937879	2024-10-24 11:15:38.035653	marylebonecleaners.co.uk	4
626	frontpage.ga@gmail.com	60	14937883	2024-10-24 11:15:49.373308	owensfarm.co.uk	3
627	frontpage.ga@gmail.com	61	14937887	2024-10-24 11:15:59.766294	abbeyrenovations.co.uk	2
628	frontpage.ga@gmail.com	60	14937891	2024-10-24 11:16:07.832834	chezvousrestaurant.co.uk	2
629	frontpage.ga@gmail.com	61	14937895	2024-10-24 11:16:16.310801	stiamesprimarypettswood.co.uk	2
630	frontpage.ga@gmail.com	61	14937899	2024-10-24 11:16:22.658238	shadowseekers.co.uk	2
631	frontpage.ga@gmail.com	61	14937903	2024-10-24 11:16:30.621056	laurenralphs-outlet.co.uk	1
632	frontpage.ga@gmail.com	60	14937907	2024-10-24 11:16:39.497499	vatonlinecalculator.co.uk	1
633	frontpage.ga@gmail.com	59	14937911	2024-10-24 11:16:46.770538	newssiiopper.co.uk	5
634	frontpage.ga@gmail.com	60	14937915	2024-10-24 11:16:55.350487	info0knighttraining.co.uk	4
635	frontpage.ga@gmail.com	60	14937919	2024-10-24 11:17:03.971244	ralph-lauren-uk.co.uk	3
636	frontpage.ga@gmail.com	59	14937923	2024-10-24 11:17:14.854275	thebusinessofyorkshire.co.uk	3
637	frontpage.ga@gmail.com	59	14937927	2024-10-24 11:17:43.134639	nexttravels.co.uk	3
638	frontpage.ga@gmail.com	58	14937931	2024-10-24 11:17:54.869837	travelmatrix.co.uk	2
639	frontpage.ga@gmail.com	59	14937935	2024-10-24 11:18:03.514337	insolvencyebaldwinandco.co.uk	2
640	frontpage.ga@gmail.com	59	14937939	2024-10-24 11:18:11.94773	k300property.co.uk	11
641	frontpage.ga@gmail.com	59	14937943	2024-10-24 11:18:22.186469	cornerhouse-gallery.co.uk	1
642	frontpage.ga@gmail.com	58	14937947	2024-10-24 11:18:31.91937	rent-a-ghost.co.uk	7
643	frontpage.ga@gmail.com	59	14937951	2024-10-24 11:18:41.131261	diydecor.co.uk	7
644	frontpage.ga@gmail.com	58	14937955	2024-10-24 11:18:52.70556	callenderdesigns.co.uk	6
645	frontpage.ga@gmail.com	58	14937959	2024-10-24 11:19:05.924987	rdfranks.co.uk	5
646	frontpage.ga@gmail.com	58	14937963	2024-10-24 11:19:14.716665	petfayre-reading.co.uk	4
647	frontpage.ga@gmail.com	58	14937967	2024-10-24 11:19:23.052299	bemyhouse.co.uk	4
648	frontpage.ga@gmail.com	58	14937971	2024-10-24 11:19:32.926053	thezenithbuilding.co.uk	3
649	frontpage.ga@gmail.com	57	14937975	2024-10-24 11:19:41.95638	pandadunks.co.uk	3
650	frontpage.ga@gmail.com	58	14937979	2024-10-24 11:19:49.254253	mjoconstruction.co.uk	2
651	frontpage.ga@gmail.com	58	14937983	2024-10-24 11:20:01.36743	ice-diving.co.uk	2
652	frontpage.ga@gmail.com	58	14937987	2024-10-24 11:20:09.74673	free-emoticons.co.uk	2
653	frontpage.ga@gmail.com	59	14937991	2024-10-24 11:20:16.165545	decornow.co.uk	12
654	frontpage.ga@gmail.com	58	14937995	2024-10-24 11:20:28.148156	sundecor.co.uk	12
655	frontpage.ga@gmail.com	59	14937999	2024-10-24 11:20:36.184737	decorspy.co.uk	11
656	frontpage.ga@gmail.com	58	14938003	2024-10-24 11:20:45.914258	quickfastcashloan.co.uk	10
657	frontpage.ga@gmail.com	58	14938007	2024-10-24 11:20:57.021628	jeepcars.co.uk	10
658	frontpage.ga@gmail.com	58	14938011	2024-10-24 11:21:04.662666	getyoursockout.co.uk	1
659	frontpage.ga@gmail.com	58	14938015	2024-10-24 11:21:12.971266	andrassydesign.co.uk	5
660	frontpage.ga@gmail.com	57	14938019	2024-10-24 11:21:20.300941	ourworkshop-shop.co.uk	3
661	frontpage.ga@gmail.com	57	14938023	2024-10-24 11:21:29.231296	thedayshallcomefilm.co.uk	3
662	frontpage.ga@gmail.com	57	14938027	2024-10-24 11:21:43.308762	chimes-of-pimlico.co.uk	3
663	frontpage.ga@gmail.com	57	14938031	2024-10-24 11:21:49.654553	popledge.co.uk	2
664	frontpage.ga@gmail.com	58	14938035	2024-10-24 11:21:56.591471	mytunstall.co.uk	2
665	frontpage.ga@gmail.com	58	14938039	2024-10-24 11:22:13.304665	mrsdecor.co.uk	11
666	frontpage.ga@gmail.com	58	14938043	2024-10-24 11:22:23.830885	restowarehouse.co.uk	1
667	frontpage.ga@gmail.com	57	14938047	2024-10-24 11:22:33.965616	burbsbags.co.uk	1
668	frontpage.ga@gmail.com	57	14938051	2024-10-24 11:22:41.96879	albanianconferenceinterpreter.co.uk	1
669	frontpage.ga@gmail.com	57	14938055	2024-10-24 11:22:50.668036	italiatour.co.uk	1
670	frontpage.ga@gmail.com	57	14938059	2024-10-24 11:22:58.633636	schooltripsplus.co.uk	1
671	frontpage.ga@gmail.com	57	14938063	2024-10-24 11:23:08.705066	dieselmotorcycle.co.uk	1
672	frontpage.ga@gmail.com	57	14938067	2024-10-24 11:23:17.120104	londondiary.co.uk	-1
673	frontpage.ga@gmail.com	56	14938071	2024-10-24 11:23:26.883101	eltorosteak.co.uk	7
674	frontpage.ga@gmail.com	56	14938075	2024-10-24 11:23:36.527766	cleaningregentspark.co.uk	6
675	frontpage.ga@gmail.com	57	14938079	2024-10-24 11:23:45.434973	laptoprepair-stoke.co.uk	5
676	frontpage.ga@gmail.com	57	14938085	2024-10-24 11:24:11.090822	anoservices.co.uk	4
677	frontpage.ga@gmail.com	56	14938089	2024-10-24 11:24:24.008205	thegoldengrove.co.uk	4
678	frontpage.ga@gmail.com	56	14938093	2024-10-24 11:24:31.50028	travel-scotland.co.uk	4
679	frontpage.ga@gmail.com	56	14938097	2024-10-24 11:24:37.475402	fryclubconference.co.uk	4
680	frontpage.ga@gmail.com	55	14938101	2024-10-24 11:24:44.736236	gopspgo.co.uk	4
681	frontpage.ga@gmail.com	56	14938105	2024-10-24 11:24:51.657726	beats-by-dre.co.uk	3
682	frontpage.ga@gmail.com	56	14938109	2024-10-24 11:25:16.418054	birminghamexilesrfc.co.uk	3
683	frontpage.ga@gmail.com	57	14938113	2024-10-24 11:25:24.367692	uknewswallet.co.uk	2
684	frontpage.ga@gmail.com	56	14938117	2024-10-24 11:25:34.510649	adaptingmanchester.co.uk	2
685	frontpage.ga@gmail.com	56	14938121	2024-10-24 11:25:42.633895	directfoto.co.uk	2
686	frontpage.ga@gmail.com	55	14938125	2024-10-24 11:25:53.311011	lockonskins.co.uk	2
687	frontpage.ga@gmail.com	57	14938129	2024-10-24 11:26:01.261923	esmediagroup.co.uk	1
688	frontpage.ga@gmail.com	56	14938133	2024-10-24 11:26:09.090765	innatlathones.co.uk	1
689	frontpage.ga@gmail.com	57	14938137	2024-10-24 11:26:15.322964	healthleadership.co.uk	1
690	frontpage.ga@gmail.com	56	14938141	2024-10-24 11:26:23.448295	thenowypolskishow.co.uk	1
691	frontpage.ga@gmail.com	56	14938145	2024-10-24 11:26:29.791455	andrewskurth.co.uk	1
692	frontpage.ga@gmail.com	57	14938149	2024-10-24 11:26:44.225339	oxfordwire.co.uk	-1
693	frontpage.ga@gmail.com	55	14938153	2024-10-24 11:26:54.744015	thecomptonarms.co.uk	6
694	frontpage.ga@gmail.com	55	14938157	2024-10-24 11:27:00.733191	rockhouse-cottage.co.uk	5
695	frontpage.ga@gmail.com	55	14938161	2024-10-24 11:27:10.387936	moon-sixpence.co.uk	4
696	frontpage.ga@gmail.com	55	14938165	2024-10-24 11:27:20.711324	cryptoku.co.uk	3
697	frontpage.ga@gmail.com	55	14938169	2024-10-24 11:27:29.198822	cryptomu.co.uk	3
698	frontpage.ga@gmail.com	55	14938173	2024-10-24 11:27:37.097559	crowtreesfarm.co.uk	2
699	frontpage.ga@gmail.com	56	14938177	2024-10-24 11:27:43.195283	thamesriveradventures.co.uk	2
700	frontpage.ga@gmail.com	55	14938181	2024-10-24 11:27:51.327337	cernunnos-homes.co.uk	2
701	frontpage.ga@gmail.com	55	14938185	2024-10-24 11:27:59.528698	essayclick.co.uk	2
702	frontpage.ga@gmail.com	56	14938189	2024-10-24 11:28:11.690991	ralphlaurenpolooutlet.co.uk	10
703	frontpage.ga@gmail.com	56	14938196	2024-10-24 11:28:41.326399	yimusanfendi.co.uk	1
704	frontpage.ga@gmail.com	56	14938200	2024-10-24 11:28:50.132164	showdogsexpress.co.uk	1
705	frontpage.ga@gmail.com	55	14938204	2024-10-24 11:28:58.457228	thewinchesterroyalhotel.co.uk	1
706	frontpage.ga@gmail.com	55	14938208	2024-10-24 11:29:10.091308	britishkick.co.uk	1
707	frontpage.ga@gmail.com	55	14938212	2024-10-24 11:29:18.367388	karinaholmes.co.uk	1
708	frontpage.ga@gmail.com	54	14938216	2024-10-24 11:29:27.378568	justgoinsurance.co.uk	8
709	frontpage.ga@gmail.com	54	14938220	2024-10-24 11:29:38.693241	redpaper.co.uk	7
710	frontpage.ga@gmail.com	55	14938224	2024-10-24 11:29:45.998415	methuenbookshop.co.uk	7
711	frontpage.ga@gmail.com	55	14938228	2024-10-24 11:29:53.684785	boatsandjetskis.co.uk	4
712	frontpage.ga@gmail.com	54	14938233	2024-10-24 11:30:00.458032	joyinnbelfast.co.uk	3
713	frontpage.ga@gmail.com	55	14938236	2024-10-24 11:30:10.561897	mrlawyer.co.uk	3
714	frontpage.ga@gmail.com	54	14938240	2024-10-24 11:30:18.942149	fashionholics.co.uk	2
715	frontpage.ga@gmail.com	55	14938244	2024-10-24 11:30:25.523457	liveinfashion.co.uk	2
716	frontpage.ga@gmail.com	54	14938248	2024-10-24 11:30:34.320771	fashionqueens.co.uk	1
717	frontpage.ga@gmail.com	54	14938252	2024-10-24 11:30:41.695689	gofindfashion.co.uk	1
718	frontpage.ga@gmail.com	54	14938256	2024-10-24 11:30:49.872453	pickmefashion.co.uk	1
719	frontpage.ga@gmail.com	54	14938260	2024-10-24 11:30:59.826745	funcitybrean.co.uk	7
720	frontpage.ga@gmail.com	53	14938264	2024-10-24 11:31:07.934412	actonsolar.co.uk	6
721	frontpage.ga@gmail.com	54	14938268	2024-10-24 11:31:23.704922	londonversity.co.uk	5
722	frontpage.ga@gmail.com	53	14938272	2024-10-24 11:31:30.221189	reddiary.co.uk	5
723	frontpage.ga@gmail.com	54	14938276	2024-10-24 11:31:39.550081	reddistrict.co.uk	5
724	frontpage.ga@gmail.com	54	14938280	2024-10-24 11:31:48.062833	cleaningclerkenwell.co.uk	5
725	frontpage.ga@gmail.com	54	14938284	2024-10-24 11:31:56.784119	thebestwatch.co.uk	5
726	frontpage.ga@gmail.com	53	14938288	2024-10-24 11:32:04.383868	londonpaper.co.uk	4
727	frontpage.ga@gmail.com	54	14938292	2024-10-24 11:32:10.387488	assignmentbrief.co.uk	4
728	frontpage.ga@gmail.com	53	14938296	2024-10-24 11:32:19.699033	healthpaper.co.uk	3
729	frontpage.ga@gmail.com	54	14938300	2024-10-24 11:32:31.291868	redpharmacy.co.uk	3
730	frontpage.ga@gmail.com	53	14938304	2024-10-24 11:32:39.44635	redseason.co.uk	3
731	frontpage.ga@gmail.com	53	14938310	2024-10-24 11:32:48.000766	flagshipfones.co.uk	3
732	frontpage.ga@gmail.com	53	14938314	2024-10-24 11:32:55.852936	daveharley.co.uk	3
733	frontpage.ga@gmail.com	54	14938318	2024-10-24 11:33:03.379514	satoriweb.co.uk	1
734	frontpage.ga@gmail.com	53	14938322	2024-10-24 11:33:12.553129	ramneeksidhu.co.uk	1
735	frontpage.ga@gmail.com	54	14938326	2024-10-24 11:33:21.141005	puppylovepets.co.uk	1
736	frontpage.ga@gmail.com	52	14938330	2024-10-24 11:33:29.973255	techmystery.co.uk	9
737	frontpage.ga@gmail.com	52	14938334	2024-10-24 11:34:41.594918	techpaper.co.uk	5
738	frontpage.ga@gmail.com	52	14938338	2024-10-24 11:34:52.903723	technologybook.co.uk	5
739	frontpage.ga@gmail.com	52	14938342	2024-10-24 11:35:44.058988	ilogi.co.uk	4
740	frontpage.ga@gmail.com	50	14938346	2024-10-24 11:35:52.949156	answerdiaries.co.uk	4
741	frontpage.ga@gmail.com	44	14938350	2024-10-24 11:36:10.626327	allnewshub.co.uk	1
742	frontpage.ga@gmail.com	37	14938354	2024-10-24 11:36:26.027056	dknews.co.uk	8
743	frontpage.ga@gmail.com	37	14938363	2024-10-24 11:37:14.935229	birminghamlisting.co.uk	1
744	frontpage.ga@gmail.com	37	14938367	2024-10-24 11:37:28.743819	bristollisting.co.uk	1
745	frontpage.ga@gmail.com	37	14938371	2024-10-24 11:37:36.646524	britanniabloom.co.uk	1
746	frontpage.ga@gmail.com	37	14938375	2024-10-24 11:37:45.146756	glasgowlisting.co.uk	1
747	frontpage.ga@gmail.com	37	14938379	2024-10-24 11:37:52.358481	hnmag.co.uk	1
748	frontpage.ga@gmail.com	37	14938383	2024-10-24 11:38:03.267897	leedslisting.co.uk	1
749	frontpage.ga@gmail.com	37	14938387	2024-10-24 11:38:11.009422	liverpoollisting.co.uk	1
750	frontpage.ga@gmail.com	37	14938391	2024-10-24 11:38:18.220337	londonlisting.co.uk	1
751	frontpage.ga@gmail.com	37	14938395	2024-10-24 11:38:28.529961	manchesterlisting.co.uk	1
752	frontpage.ga@gmail.com	37	14938399	2024-10-24 11:38:37.936682	newcastlelisting.co.uk	1
753	frontpage.ga@gmail.com	37	14938403	2024-10-24 11:38:47.299092	sheffieldlisting.co.uk	1
754	frontpage.ga@gmail.com	37	14938407	2024-10-24 11:38:59.857839	britishvista.co.uk	-1
755	frontpage.ga@gmail.com	37	14938411	2024-10-24 11:39:07.718094	englandecho.co.uk	-1
756	frontpage.ga@gmail.com	37	14938415	2024-10-24 11:39:16.597883	ukhorizon.co.uk	-1
802	frontpage.ga@gmail.com	43	14938750	2024-10-30 13:57:20.308759	idobusiness.co.uk	1
803	frontpage.ga@gmail.com	37	14938797	2024-10-30 14:05:18.250574	mudsweatandtears.co.uk	2
804	frontpage.ga@gmail.com	36	14938810	2024-10-30 14:06:44.042266	theanamumdiary.co.uk	1
805	chris.p@frontpageadvantage.com	52	14939317	2024-11-05 08:56:12.949171	bmtimes.co.uk	-1
806	chris.p@frontpageadvantage.com	57	14939326	2024-11-05 08:58:28.459112	baddiehub.org.uk	2
807	james.p@frontpageadvantage.com	75	14941392	2024-11-21 12:02:32.111552	mytoptweets.net	10
808	james.p@frontpageadvantage.com	74	14941395	2024-11-21 12:02:39.523715	amolife.co	8
809	james.p@frontpageadvantage.com	54	14941399	2024-11-21 12:02:51.758435	hindiyaro.org	4
810	james.p@frontpageadvantage.com	41	14941403	2024-11-21 12:02:59.977426	invetinglifestyle.com	-1
811	james.p@frontpageadvantage.com	42	14941407	2024-11-21 12:03:10.921435	ienglishstatus.com	6
852	james.p@frontpageadvantage.com	35	14957668	2025-04-02 12:05:11.602385	lucha-libre.co.uk	1
853	james.p@frontpageadvantage.com	37	14957671	2025-04-02 12:05:20.013382	under5s.co.uk	2
854	james.p@frontpageadvantage.com	35	14957675	2025-04-02 12:05:33.504407	ohthebooks.com	1
855	james.p@frontpageadvantage.com	37	14957817	2025-04-03 07:51:39.234532	deutschland-startet.de	2
856	james.p@frontpageadvantage.com	57	14957886	2025-04-03 11:11:40.081721	homerenovationshows.com	3
857	james.p@frontpageadvantage.com	25	14959995	2025-04-22 07:47:47.256216	fitcoding.com	8
858	james.p@frontpageadvantage.com	30	14959998	2025-04-22 07:48:12.051092	stromberry.com	9
859	james.p@frontpageadvantage.com	36	14960002	2025-04-22 07:48:19.33312	neonjs.com	12
860	james.p@frontpageadvantage.com	51	14960006	2025-04-22 07:48:27.532612	25pr.com	8
861	james.p@frontpageadvantage.com	47	14960559	2025-04-22 12:00:20.590505	indianeagle.com	1
862	chris.p@frontpageadvantage.com	1	14961388	2025-04-29 12:54:35.992942	traveloway.com	2
863	chris.p@frontpageadvantage.com	3	14961395	2025-04-29 12:59:24.058596	brownbag.co.uk	9
864	james.p@frontpageadvantage.com	58	14962345	2025-05-13 08:24:07.681582	riproar.com	1
865	chris.p@frontpageadvantage.com	62	14963307	2025-05-19 06:56:27.758554	ibusinesstalk.co.uk	2
866	millie.t@frontpageadvantage.com	36	14964080	2025-05-21 14:16:58.337874	wellnessforce.com	-1
867	millie.t@frontpageadvantage.com	25	14964096	2025-05-21 14:22:05.013873	greenheal.net	13
868	millie.t@frontpageadvantage.com	54	14964099	2025-05-21 14:22:52.267099	noobpreneur.com	1
869	james.p@frontpageadvantage.com	60	14964593	2025-05-29 07:42:18.796947	thearches.co.uk	7
870	james.p@frontpageadvantage.com	17	14964596	2025-05-29 07:42:57.437156	thesolostove.co.uk	11
871	james.p@frontpageadvantage.com	4	14965100	2025-06-03 09:22:33.351323	botanicvista.com	-1
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.category (id, name, created_by, disabled, updated_by, version) FROM stdin;
52	Architecture	historical	f	\N	0
53	Automotive	historical	f	\N	0
54	Beauty	historical	f	\N	0
55	Business	historical	f	\N	0
56	Construction	historical	f	\N	0
57	Cryptocurrency	historical	f	\N	0
58	DIY	historical	f	\N	0
59	Education	historical	f	\N	0
60	Entertainment	historical	f	\N	0
61	Events	historical	f	\N	0
62	Family	historical	f	\N	0
63	Fashion	historical	f	\N	0
64	Food and Drink	historical	f	\N	0
65	Gambling	historical	f	\N	0
66	General	historical	f	\N	0
67	Health and Wellness	historical	f	\N	0
68	Home Decor	historical	f	\N	0
69	IT	historical	f	\N	0
70	Lifestyle	historical	f	\N	0
71	Local News	historical	f	\N	0
72	Marketing	historical	f	\N	0
73	Money Saving	historical	f	\N	0
74	Music	historical	f	\N	0
75	News	historical	f	\N	0
76	Parenting	historical	f	\N	0
77	Personal Development	historical	f	\N	0
78	Personal Finance	historical	f	\N	0
79	Pets	historical	f	\N	0
80	Photography	historical	f	\N	0
81	Products	historical	f	\N	0
82	Sustainability	historical	f	\N	0
83	Tech	historical	f	\N	0
84	Travel	historical	f	\N	0
85	Weddings	historical	f	\N	0
\.


--
-- Data for Name: category_aud; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.category_aud (id, rev, revtype, created_by, disabled, name, updated_by) FROM stdin;
52	1	0	historical	f	Architecture	\N
53	1	0	historical	f	Automotive	\N
54	1	0	historical	f	Beauty	\N
55	1	0	historical	f	Business	\N
56	1	0	historical	f	Construction	\N
57	1	0	historical	f	Cryptocurrency	\N
58	1	0	historical	f	DIY	\N
59	1	0	historical	f	Education	\N
60	1	0	historical	f	Entertainment	\N
61	1	0	historical	f	Events	\N
62	1	0	historical	f	Family	\N
63	1	0	historical	f	Fashion	\N
64	1	0	historical	f	Food and Drink	\N
65	1	0	historical	f	Gambling	\N
66	1	0	historical	f	General	\N
67	1	0	historical	f	Health and Wellness	\N
68	1	0	historical	f	Home Decor	\N
69	1	0	historical	f	IT	\N
70	1	0	historical	f	Lifestyle	\N
71	1	0	historical	f	Local News	\N
72	1	0	historical	f	Marketing	\N
73	1	0	historical	f	Money Saving	\N
74	1	0	historical	f	Music	\N
75	1	0	historical	f	News	\N
76	1	0	historical	f	Parenting	\N
77	1	0	historical	f	Personal Development	\N
78	1	0	historical	f	Personal Finance	\N
79	1	0	historical	f	Pets	\N
80	1	0	historical	f	Photography	\N
81	1	0	historical	f	Products	\N
82	1	0	historical	f	Sustainability	\N
83	1	0	historical	f	Tech	\N
84	1	0	historical	f	Travel	\N
85	1	0	historical	f	Weddings	\N
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.supplier (id, created_by, da, disabled, domain, email, name, third_party, updated_by, we_write_fee, we_write_fee_currency, website, source, created_date, modified_date, version) FROM stdin;
364	historical	21	t	loveemblog.com	loveem.blog@gmail.com	Emily	f	chris.p@frontpageadvantage.com	45	£	https://www.loveemblog.com/	Fatjoe	0	0	0
772	chris.p@frontpageadvantage.com	56	t	thetecheducation.com	ela690000@gmail.com	Ela	f	chris.p@frontpageadvantage.com	100	£	https://thetecheducation.com/	inbound	1709027922451	1718366946757	3
779	chris.p@frontpageadvantage.com	24	t	travelworldfashion.com	travelworldwithfashion@gmail.com	Team	f	james.p@frontpageadvantage.com	72	£	https://travelworldfashion.com/	inbound	1709032988565	1745919387139	8
1088	sam.b@frontpageadvantage.com	35	t	family-budgeting.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	120	£	family-budgeting.co.uk	Inbound	1719320465060	1745919400681	5
786	chris.p@frontpageadvantage.com	60	t	stylesrant.com	infopediapros@gmail.com	Ricardo	f	chris.p@frontpageadvantage.com	45	£	https://www.stylesrant.com/	inbound	1709035655140	1718366953398	2
785	chris.p@frontpageadvantage.com	58	t	theassistant.io	infopediapros@gmail.com	Ricardo	f	chris.p@frontpageadvantage.com	45	£	theassistant.io	inbound	1709035573894	1718366956751	3
1111	sam.b@frontpageadvantage.com	59	t	paisley.org.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	112	£	https://www.paisley.org.uk/	Inbound	1719408626312	1722930102541	2
1112	sam.b@frontpageadvantage.com	41	t	atidymind.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.atidymind.co.uk/	Inbound	1719408687174	1722930108850	4
1612	millie.t@frontpageadvantage.com	41	f	hearthomemag.co.uk	advertise@mintymarketing.co.uk	Minty	f	system	100	£	https://hearthomemag.co.uk/	Tanya	1754379974064	1754379977355	1
1613	millie.t@frontpageadvantage.com	0	f	\N	\N	Click Intelligence	t	\N	0	\N	\N	\N	1754383774862	1754383774862	0
436	historical	65	t	scoopearth.com	minalkh124@gmail.com	Maryam bibi	f	michael.l@frontpageadvantage.com	20	£	https://www.scoopearth.com/	Inbound email	0	1710248464364	2
783	chris.p@frontpageadvantage.com	45	t	corporatelivewire.com	sukhenseoconsultant@gmail.com	Sukhen	f	james.p@frontpageadvantage.com	150	£	https://corporatelivewire.com/	inbound	1709034374081	1745919824559	6
1153	james.p@frontpageadvantage.com	35	t	forbesradar.co.uk	teamforbesradar@gmail.com	Forbes Radar	f	james.p@frontpageadvantage.com	62	£	https://forbesradar.co.uk/	James	1723644250691	1745919838482	5
323	historical	27	t	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	Claire	f	james.p@frontpageadvantage.com	80	£	clairemorandesigns.co.uk	Fatjoe	0	1745919987779	8
782	chris.p@frontpageadvantage.com	17	t	spokenenglishtips.com	spokenenglishtips@gmail.com	Edu Place	f	james.p@frontpageadvantage.com	30	£	https://spokenenglishtips.com/	inbound	1709033531454	1745920481682	10
1082	sam.b@frontpageadvantage.com	29	t	theowlet.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	100	£	theowlet.co.uk	Inbound	1719319867176	1745920611176	7
803	chris.p@frontpageadvantage.com	48	t	smihub.co.uk	sophiadaniel.co.uk@gmail.com	Sophia	f	chris.p@frontpageadvantage.com	60	£	https://smihub.co.uk/	Inbound	1709123162304	1741259620949	7
752	chris.p@frontpageadvantage.com	59	t	outdoorproject.com	sophiadaniel.co.uk@gmail.com	sophia daniel	f	chris.p@frontpageadvantage.com	50	£	https://www.outdoorproject.com/	Inbound	1708082585011	1741259639331	12
1254	frontpage.ga@gmail.com	24	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	Laureny Loves	f	system	50	£	https://www.laurenyloves.co.uk/category/money/	Hannah	1726736911853	1761966002970	5
491	historical	54	t	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.theexeterdaily.co.uk	Inbound Sam	0	1745921471026	5
534	historical	42	t	saddind.co.uk	natalilacanario@gmail.com	Natalila	f	james.p@frontpageadvantage.com	175	£	saddind.co.uk	Inbound Sam	0	1745921478834	6
471	historical	22	t	realparent.co.uk	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	60	£	https://www.realparent.co.uk	inbound email	0	1745921804498	7
1302	rdomloge@gmail.com	98	t	whatsapp.com	ramsay.domloge@bca.com	Ramsay test	f	james.p@frontpageadvantage.com	10	£	www.whatsapp.com	Testing	1727196482040	1745923307185	6
1092	sam.b@frontpageadvantage.com	41	f	fabukmagazine.com	katherine@orangeoutreach.com	Katherine Williams	f	system	120	£	fabukmagazine.com	Inbound	1719320789605	1751338815399	4
1055	michael.l@frontpageadvantage.com	20	f	lindyloves.co.uk	Hello@lindyloves.co.uk	Lindy	f	system	50	£	https://www.lindyloves.co.uk/	Outbound Facebook	1716452047818	1761966003576	9
1169	james.p@frontpageadvantage.com	57	f	knowledgewap.org	sofiakahn06@gmail.com	Sofia	f	system	60	$	knowledgewap.org	James	1726065501892	1726065504953	1
1252	frontpage.ga@gmail.com	55	f	thelifestylebloggeruk.com	thelifestylebloggeruk@aol.com	The Lifestyle blogger UK	f	system	85	£	https://thelifestylebloggeruk.com/category/money/	Hannah	1726736545268	1726736548655	1
1156	james.p@frontpageadvantage.com	30	f	cuddlefairy.com	hello@cuddlefairy.com	Becky	f	system	45	£	https://www.cuddlefairy.com/	James	1725624962664	1761966004374	5
1002	michael.l@frontpageadvantage.com	46	f	todaynews.co.uk	david@todaynews.co.uk	David	f	system	65	£	https://todaynews.co.uk/	Inbound Michael	1713341748907	1743476413661	9
1089	sam.b@frontpageadvantage.com	33	f	crummymummy.co.uk	crummymummy@live.co.uk	Natalie	f	system	60	£	crummymummy.co.uk	James	1719320544130	1761966013567	7
316	historical	31	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	Karl	f	system	50	£	www.newvalleynews.co.uk	Fatjoe	0	1746154801153	11
1425	frontpage.ga@gmail.com	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	lobsterdigitalmarketing.co.uk	inbound	1730297780739	1751338801369	5
483	historical	30	f	packthepjs.com	tracey@packthepjs.com	Tracey	f	system	80	£	http://www.packthepjs.com/	Fatjoe	0	1751338806740	9
1090	sam.b@frontpageadvantage.com	70	f	markmeets.com	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	markmeets.com	Inbound	1719320639079	1754017204165	6
652	chris.p@frontpageadvantage.com	30	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	Gemma	f	system	80	£	https://gemmalouise.co.uk/	inbound email	0	1754017211069	8
1157	james.p@frontpageadvantage.com	33	t	englishlush.com	david.linkedbuilders@gmail.com	David	f	chris.p@frontpageadvantage.com	10	$	http://englishlush.com/	James	1725966904913	1727789891750	2
356	historical	45	t	sorry-about-the-mess.co.uk	chloebridge@gmail.com	Chloe Bridge	f	chris.p@frontpageadvantage.com	60	£	https://sorry-about-the-mess.co.uk	Fatjoe	0	1708424380177	2
439	historical	66	t	timebusinessnews.com	minalkh124@gmail.com	Maryam bibi	f	michael.l@frontpageadvantage.com	25	£	timebusinessnews.com	Inbound email	0	1708596721953	2
763	sam.b@frontpageadvantage.com	88	t	benzinga.com	falcobliek@gmail.com	Falco	f	james.p@frontpageadvantage.com	130	£	https://www.benzinga.com/	Inbound	1708616008102	1745919843705	3
1113	sam.b@frontpageadvantage.com	57	t	henley.ac.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	48	£	https://www.henley.ac.uk/	Inbound	1719409558251	1722930113454	2
1304	james.p@frontpageadvantage.com	0	f	\N	\N	Click Intelligence	t	\N	0	\N	\N	\N	1727789913477	1727789913477	0
485	historical	59	t	gudstory.com	sophiadaniel.co.uk@gmail.com	Sophia	f	chris.p@frontpageadvantage.com	150	£	www.gudstory.com	Inbound Sam	0	1718366938880	2
1114	sam.b@frontpageadvantage.com	63	t	musicglue.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	68	£	https://www.musicglue.com/	Inbound	1719409631888	1722930121015	2
374	historical	66	t	simslife.co.uk	sim@simslife.co.uk	Sim Riches	f	james.p@frontpageadvantage.com	130	£	https://simslife.co.uk	Fatjoe	0	1745924762311	6
773	chris.p@frontpageadvantage.com	44	t	digitalgpoint.com	bhaiahsan799@gmail.com	Ahsan	f	michael.l@frontpageadvantage.com	35	£	digitalgpoint.com	inbound	1709029278940	1710248485505	3
784	chris.p@frontpageadvantage.com	37	t	okaybliss.com	infopediapros@gmail.com	Ricardo	f	james.p@frontpageadvantage.com	80	£	https://www.okaybliss.com/	inbound	1709035290025	1745919304305	10
754	michael.l@frontpageadvantage.com	63	t	techsslash.com	sophiadaniel.co.uk@gmail.com	Sophia Daniel 	f	chris.p@frontpageadvantage.com	150	£	https://techsslash.com	Inbound Email	1708084929950	1718366942750	2
787	sam.b@frontpageadvantage.com	39	t	netizensreport.com	premium@rabbiitfirm.com	Mojammel	f	james.p@frontpageadvantage.com	120	£	netizensreport.com	Inbound	1709041586393	1745919320554	7
1152	james.p@frontpageadvantage.com	19	t	rosemaryhelenxo.com	info@rosemaryhelenxo.com	Rose	f	james.p@frontpageadvantage.com	20	£	www.RosemaryHelenXO.com	Contact Form	1721314820107	1745919405796	6
1064	chris.p@frontpageadvantage.com	31	t	enterpriseleague.com	info@enterpriseleague.com	Irina	f	james.p@frontpageadvantage.com	280	£	https://enterpriseleague.com/	outbound	1717491149032	1745919841088	2
1421	frontpage.ga@gmail.com	34	t	propertydivision.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	131	£	propertydivision.co.uk	inbound	1730297627872	1745919865863	2
653	chris.p@frontpageadvantage.com	40	t	thatdrop.com	info@morningbusinesschat.com	Brett Napoli	f	james.p@frontpageadvantage.com	83	£	https://thatdrop.com/	Inbound	0	1745920605845	3
355	historical	36	t	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	Rebecca	f	james.p@frontpageadvantage.com	100	£	www.ialwaysbelievedinfutures.com	Fatjoe	0	1745921769108	4
359	historical	28	t	beccafarrelly.co.uk	hello@beccafarrelly.co.uk	Becca	f	james.p@frontpageadvantage.com	100	£	beccafarrelly.co.uk	Fatjoe	0	1745921771549	3
324	historical	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	Chrissy	f	system	20	£	itsmechrissyj.co.uk	Fatjoe	0	1759287621697	13
1093	sam.b@frontpageadvantage.com	56	f	westwaleschronicle.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	westwaleschronicle.co.uk	Inbound	1719320939526	1719320942505	1
952	michael.l@frontpageadvantage.com	53	t	kemotech.co.uk	sophiadaniel.co.uk@gmail.com	sophia daniel 	f	chris.p@frontpageadvantage.com	250	£	https://kemotech.co.uk/	Inbound Michael	1710423264423	1741259529593	2
496	historical	28	t	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	144	£	enjoytheadventure.co.uk	Inbound Sam	0	1745921811253	7
1303	chris.p@frontpageadvantage.com	37	t	nyweekly.co.uk	sophiadaniel.co.uk@gmail.com	sophia daniel 	f	chris.p@frontpageadvantage.com	55	£	https://nyweekly.co.uk/	inbound	1727252702565	1741259546236	3
1170	james.p@frontpageadvantage.com	51	f	nerdbot.com	sofiakahn06@gmail.com	Sofia	f	system	150	$	nerdbot.com	James	1726065836927	1761966020021	6
1053	michael.l@frontpageadvantage.com	29	t	emmareed.net	admin@emmareed.net	Emma Reed	f	james.p@frontpageadvantage.com	100	£	https://emmareed.net/	Outbound Facebook	1716451545373	1745921818989	8
1076	sam.b@frontpageadvantage.com	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	wellbeingmagazine.com	Inbound	1719318364944	1761966020510	6
1077	sam.b@frontpageadvantage.com	50	t	algarvedailynews.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	175	£	algarvedailynews.com	Inbound	1719318416922	1745923141215	4
852	sam.b@frontpageadvantage.com	37	t	golfnews.co.uk	kenditoys.com@gmail.com	David warner	f	james.p@frontpageadvantage.com	125	£	https://golfnews.co.uk/	Outbound	1709645596330	1745923529030	2
1154	james.p@frontpageadvantage.com	33	f	fabcelebbio.com	support@linksposting.com	Links Posting	f	system	40	$	https://fabcelebbio.com/	James	1723728287666	1746068418457	4
1075	sam.b@frontpageadvantage.com	37	f	tobyandroo.com	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	tobyandroo.com	Inbound	1719318317308	1748746818193	4
1074	sam.b@frontpageadvantage.com	38	f	fivelittledoves.com	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	fivelittledoves.com	Inbound	1719318261939	1751338816814	4
1054	michael.l@frontpageadvantage.com	27	f	flydriveexplore.com	Hello@flydrivexexplore.com	Marcus Williams 	f	system	80	£	https://www.flydriveexplore.com/	Outbound Facebook	1716451807667	1751338821127	6
1069	sam.b@frontpageadvantage.com	32	f	caranalytics.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	caranalytics.co.uk	Inbound	1719317784130	1754017219912	8
1115	sam.b@frontpageadvantage.com	71	t	voice-online.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	140	£	https://www.voice-online.co.uk/	Inbound	1719409732096	1722930126980	2
802	chris.p@frontpageadvantage.com	53	t	wegmans.co.uk	sophiadaniel.co.uk@gmail.com	Sophia	f	chris.p@frontpageadvantage.com	80	£	https://wegmans.co.uk/	outbound	1709122990978	1715245661562	2
1171	james.p@frontpageadvantage.com	41	t	shibleysmiles.com	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	150	$	shibleysmiles.com	James	1726066685680	1745919317781	4
774	chris.p@frontpageadvantage.com	32	t	voiceofaction.org	webmaster@redhatmedia.net	Vivek	f	james.p@frontpageadvantage.com	65	£	http://voiceofaction.org/	outbound	1709030265171	1745919390140	5
1094	sam.b@frontpageadvantage.com	27	t	coffeecakekids.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	100	£	coffeecakekids.com	Inbound	1719322155330	1745919408512	7
1096	sam.b@frontpageadvantage.com	34	t	businesslancashire.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	140	£	businesslancashire.co.uk	Inbound	1719322406613	1745919871353	5
1423	frontpage.ga@gmail.com	35	t	planetveggie.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	145	£	planetveggie.co.uk	inbound	1730297707203	1745922801832	4
1065	chris.p@frontpageadvantage.com	33	t	cocktailswithmom.com	deebat@cocktailswithmom.com	Dee Marie	t	james.p@frontpageadvantage.com	118	£	https://cocktailswithmom.com	Fatjoe	1718109354711	1745922836723	5
756	chris.p@frontpageadvantage.com	36	f	internetvibes.net	\N	Fatjoe	t	chris.p@frontpageadvantage.com	120	£	https://www.internetvibes.net	\N	1708088271090	1708941218464	1
953	michael.l@frontpageadvantage.com	41	t	thecricketpaper.com	sam.emery@greenwayspublishing.com	Sam	f	james.p@frontpageadvantage.com	100	£	https://www.thecricketpaper.com/	Outbound Chris	1711012683237	1745922862693	6
1452	james.p@frontpageadvantage.com	31	f	lifeloveanddirtydishes.com	claire_ruan@hotmail.com	Claire	f	james.p@frontpageadvantage.com	55	£	https://lifeloveanddirtydishes.com/	James	1738749807697	1738840177899	2
1066	chris.p@frontpageadvantage.com	28	f	timesinternational.net	\N	Fatjoe	t	chris.p@frontpageadvantage.com	130	£	https://timesinternational.net	\N	1718109368739	1718356477146	1
1307	james.p@frontpageadvantage.com	42	f	b31.org.uk	\N	Click Intelligence	t	james.p@frontpageadvantage.com	180	£	https://b31.org.uk	\N	1727789991606	1728378370976	1
1523	frontpage.ga@gmail.com	36	f	ventstimes.co.uk	ventstimesofficial@gmail.com	Vents Times	f	system	80	£	Ventstimes.co.uk	inboud	1742853030124	1759287631122	3
1305	james.p@frontpageadvantage.com	56	f	budgetsavvydiva.com	\N	Rhino Rank	t	james.p@frontpageadvantage.com	0	\N	https://www.budgetsavvydiva.com	\N	1727789968431	1728563534667	3
1354	frontpage.ga@gmail.com	55	t	couponfollow.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	chris.p@frontpageadvantage.com	25	£	https://couponfollow.co.uk/	inbound	1729769295496	1729855125410	2
1353	frontpage.ga@gmail.com	63	t	uvenco.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	chris.p@frontpageadvantage.com	25	£	uvenco.co.uk	inbound	1729768339748	1729855146460	2
1422	frontpage.ga@gmail.com	30	t	taketotheroad.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	139	£	taketotheroad.co.uk	inbound	1730297665873	1745923325473	4
1614	millie.t@frontpageadvantage.com	74	f	manilatimes.net	advertise@mintymarketing.co.uk	Minty	f	system	80	$	https://www.manilatimes.net/	Tanya	1754479907265	1761966025596	2
1512	frontpage.ga@gmail.com	33	f	techranker.co.uk	 agencystarseo@gmail.com	TRK	f	system	80	£	TechRanker.co.uk	inbound	1742851181353	1761966027318	2
1427	frontpage.ga@gmail.com	26	f	shelllouise.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	shelllouise.co.uk	inbound	1730297857266	1761966028530	6
1256	frontpage.ga@gmail.com	34	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	The Everyday Man	f	system	150	£	https://theeverydayman.co.uk/	Hannah	1726827443560	1761966028869	5
1155	james.p@frontpageadvantage.com	38	t	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	Forbes Network	f	chris.p@frontpageadvantage.com	70	£	https://forbesnetwork.co.uk/	James	1724849151681	1741259564248	4
1416	frontpage.ga@gmail.com	33	f	smallcapnews.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	158	£	Smallcapnews.co.uk	inbound	1730297416645	1754017221567	3
1417	frontpage.ga@gmail.com	33	t	journaloftradingstandards.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	103	£	journaloftradingstandards.co.uk	inbound	1730297448496	1749133969274	4
764	sam.b@frontpageadvantage.com	94	t	yahoo.com	ela690000@gmail.com	Ella	f	james.p@frontpageadvantage.com	125	£	https://news.yahoo.com/	Inbound	1708616228406	1727187207276	2
1520	frontpage.ga@gmail.com	33	f	exclusivetoday.co.uk	onikawallerson.ot@gmail.com	Exclusive Today	f	system	80	£	exclusivetoday.co.uk	inboud	1742852390702	1748746821350	2
1426	frontpage.ga@gmail.com	31	t	joannedewberry.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	122	£	joannedewberry.co.uk	inbound	1730297811663	1745923331524	3
903	sam.b@frontpageadvantage.com	52	t	therugbypaper.co.uk	backlinsprovider@gmail.com	David Smith 	f	james.p@frontpageadvantage.com	115	£	www.therugbypaper.co.uk	Inbound	1709718136681	1745923533754	6
1057	michael.l@frontpageadvantage.com	49	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	Elaine Wilson 	f	system	150	£	https://eccentricengland.co.uk/	Outbound Facebook	1716452525532	1746068419097	3
1087	sam.b@frontpageadvantage.com	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	140	£	dailybusinessgroup.co.uk	Inbound	1719320401710	1748746823745	5
1507	frontpage.ga@gmail.com	40	t	interview-coach.co.uk	margaret@interview-coach.co.uk	MargaretBUJ	f	james.p@frontpageadvantage.com	75	£	interview-coach.co.uk	inbound	1741271187248	1749133907234	2
1506	frontpage.ga@gmail.com	51	f	techktimes.co.uk	Techktimes.official@gmail.com	Teck k times	f	james.p@frontpageadvantage.com	75	£	techktimes.co.uk	inbound	1741271054422	1749198395339	2
1518	frontpage.ga@gmail.com	30	f	guestmagazines.co.uk	megazines04@gmail.com	guest magazines	f	system	80	£	Guestmagazines.co.uk	inbound	1742852067954	1754017226855	4
1067	chris.p@frontpageadvantage.com	0	f	\N	\N	test	t	\N	0	\N	\N	\N	1718272062687	1718272062687	0
1097	sam.b@frontpageadvantage.com	31	t	strikeapose.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.strikeapose.co.uk/	Inbound	1719396496757	1722930132941	2
1306	james.p@frontpageadvantage.com	47	f	phoenixfm.com	\N	Click Intelligence	t	james.p@frontpageadvantage.com	180	£	https://www.phoenixfm.com	\N	1727789980135	1728378333390	1
1099	sam.b@frontpageadvantage.com	36	t	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	140	£	https://www.seriousaboutrl.com/	Inbound	1719396643226	1722930140795	3
459	historical	56	t	digitalengineland.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	120	£	digitalengineland.com	Inbound email	0	1718366902112	3
1100	sam.b@frontpageadvantage.com	36	t	pharmacy.biz	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	104	£	https://www.pharmacy.biz/	Inbound	1719396696751	1722930147855	2
757	chris.p@frontpageadvantage.com	27	f	respawning.co.uk	\N	Fatjoe	t	chris.p@frontpageadvantage.com	80	£	https://respawning.co.uk	\N	1708088289766	1709287346849	1
1101	sam.b@frontpageadvantage.com	67	t	pitchero.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	48	£	https://www.pitchero.com/	Inbound	1719396748047	1722930153401	2
1061	michael.l@frontpageadvantage.com	58	t	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	Sarah Dixon 	f	james.p@frontpageadvantage.com	100	£	https://www.minimeandluxury.co.uk/	Outbound Facebook	1716453125082	1745921823275	4
1102	sam.b@frontpageadvantage.com	47	t	yourthurrock.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	120	£	https://www.yourthurrock.com/	Inbound	1719396805201	1722930162387	2
1103	sam.b@frontpageadvantage.com	34	t	mummyfever.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://mummyfever.co.uk/	Inbound	1719396859158	1722930178715	2
902	sam.b@frontpageadvantage.com	32	t	trainingexpress.org.uk	kenditoys.com@gmail.com	David warner	f	james.p@frontpageadvantage.com	150	£	https://trainingexpress.org.uk/	Inbound	1709717920944	1745919833481	8
1104	sam.b@frontpageadvantage.com	66	t	wlv.ac.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	48	£	https://www.wlv.ac.uk/	Inbound	1719396923079	1722930184406	2
1418	frontpage.ga@gmail.com	34	f	thisisbrighton.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	140	£	thisisbrighton.co.uk	inbound	1730297487047	1730297490100	1
1073	sam.b@frontpageadvantage.com	76	f	deadlinenews.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	deadlinenews.co.uk	Inbound	1719318221869	1740798048818	4
1072	sam.b@frontpageadvantage.com	45	f	warrington-worldwide.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	warrington-worldwide.co.uk	Inbound	1719318118234	1740798049382	3
655	chris.p@frontpageadvantage.com	29	t	forgetfulmomma.com	info@morningbusinesschat.com	Brett Napoli	f	james.p@frontpageadvantage.com	225	£	https://www.forgetfulmomma.com/	Inbound	0	1745919384368	8
775	chris.p@frontpageadvantage.com	30	t	followthefashion.org	bhaiahsan799@gmail.com	Ashan	f	james.p@frontpageadvantage.com	55	£	https://www.followthefashion.org/	inbound	1709031235193	1745919414480	9
1105	sam.b@frontpageadvantage.com	43	t	findtheneedle.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	120	£	https://findtheneedle.co.uk/	Inbound	1719397018040	1722930193790	2
1116	sam.b@frontpageadvantage.com	58	t	houseofspells.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	104	£	https://houseofspells.co.uk/	Inbound	1719409875972	1722930203677	2
1098	sam.b@frontpageadvantage.com	37	t	yourharlow.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	120	£	https://www.yourharlow.com/	Inbound	1719396580592	1722930215468	3
1091	sam.b@frontpageadvantage.com	74	t	businesscasestudies.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	220	£	businesscasestudies.co.uk	Inbound	1719320713419	1745919835983	4
1524	frontpage.ga@gmail.com	57	t	starmusiq.audio	Contact@guestpost.cc	Star Musiq	f	james.p@frontpageadvantage.com	30	£	https://starmusiq.audio/	inboud	1744278617976	1745920608470	2
956	michael.l@frontpageadvantage.com	25	t	racingahead.net	sam.emery@greenwayspublishing.com	Sam	f	james.p@frontpageadvantage.com	100	£	https://www.racingahead.net/	Outbound Chris	1711013035726	1745922871688	6
1424	frontpage.ga@gmail.com	35	t	mummyinatutu.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	98	£	mummyinatutu.co.uk	inbound	1730297739559	1745923328810	4
1257	frontpage.ga@gmail.com	40	t	vevivos.com	vickywelton@hotmail.com	Verily Victoria Vocalises	f	james.p@frontpageadvantage.com	175	£	vevivos.com	Hannah	1727080175363	1745924336605	3
1616	millie.t@frontpageadvantage.com	84	f	zerohedge.com	calahlane3@gmail.com	Zero Hedge	f	system	90	£	https://www.zerohedge.com/	Millie	1754566343999	1754566346960	1
357	historical	56	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	Becky Freeman	f	system	50	£	www.spiritedpuddlejumper.com	Fatjoe	0	1759287634708	5
362	historical	38	f	hausmanmarketingletter.com	angie@hausmanmarketingletter.com	Angela Hausman	f	system	150	£	https://hausmanmarketingletter.com	Fatjoe	0	1738378880937	5
959	chris.p@frontpageadvantage.com	47	f	talk-business.co.uk	backlinsprovider@gmail.com	David Smith	f	system	115	£	https://www.talk-business.co.uk/	Inbound	1711533031802	1761966034819	11
1161	james.p@frontpageadvantage.com	77	f	oddee.com	sofiakahn06@gmail.com	Sofia	f	system	150	$	oddee.com	James	1726058268387	1761966035501	4
1056	michael.l@frontpageadvantage.com	27	f	flyingfluskey.com	rosie@flyingfluskey.com	Rosie Fluskey 	f	system	250	£	https://www.flyingfluskey.com	Outbound Facebook	1716452285003	1751338832057	9
1070	sam.b@frontpageadvantage.com	21	f	theautoexperts.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	125	£	theautoexperts.co.uk	Inbound	1719317894569	1754017231372	9
438	historical	76	t	merchantcircle.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	25	£	merchantcircle.com	Inbound email	0	1708096205767	1
804	sam.b@frontpageadvantage.com	79	t	e-architect.com	isabelle@e-architect.com	Isabelle Lomholt	f	chris.p@frontpageadvantage.com	100	£	https://www.e-architect.com/	Outbound Sam	1709213279175	1727944328867	4
1068	chris.p@frontpageadvantage.com	11	f	theuselessweb.com	\N	Fatjoe test	t	chris.p@frontpageadvantage.com	23	£	https://theuselessweb.com	\N	1718281427105	1718281490906	1
776	chris.p@frontpageadvantage.com	60	t	petdogplanet.com	bhaiahsan799@gmail.com	Ashan	f	chris.p@frontpageadvantage.com	60	£	www.petdogplanet.com	inbound	1709032440217	1718282119986	4
654	chris.p@frontpageadvantage.com	38	f	acraftedpassion.com	info@morningbusinesschat.com	Brett Napoli	f	system	100	£	https://acraftedpassion.com/	Inbound	0	1738378854588	7
1615	millie.t@frontpageadvantage.com	27	f	ucantwearthat.com	ucantwearthattoo@gmail.com	Lucia	f	system	60	£	http://www.ucantwearthat.com/	Millie	1754559255202	1754559258439	1
777	chris.p@frontpageadvantage.com	31	f	yourpetplanet.com	info@yourpetplanet.com	Your Pet Planet	f	system	42	£	https://yourpetplanet.com/	inbound	1709032527056	1759287639387	6
1117	sam.b@frontpageadvantage.com	50	t	neconnected.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	88	£	https://neconnected.co.uk/	Inbound	1719496409778	1722930233297	3
1079	sam.b@frontpageadvantage.com	42	t	bdcmagazine.com	katherine@orangeoutreach.com	Katherine Williams	f	system	280	£	bdcmagazine.com	Inbound	1719319485667	1719319488589	1
778	chris.p@frontpageadvantage.com	25	t	suntrics.com	suntrics4u@gmail.com	Suntrics	f	james.p@frontpageadvantage.com	40	£	https://suntrics.com/	outbound	1709032760082	1745919829944	8
1120	sam.b@frontpageadvantage.com	52	t	constructionreviewonline.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://constructionreviewonline.com/	Inbound	1719496627284	1722930243417	3
1119	sam.b@frontpageadvantage.com	43	t	thestudentpocketguide.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	88	£	https://www.thestudentpocketguide.com/	Inbound	1719496578123	1722930259956	3
1106	sam.b@frontpageadvantage.com	41	t	tqsmagazine.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	140	£	https://tqsmagazine.co.uk/	Inbound	1719408285725	1722930270089	2
1308	james.p@frontpageadvantage.com	50	f	savedelete.com	\N	Rhino Rank	t	james.p@frontpageadvantage.com	192	£	https://savedelete.com	\N	1727790152208	1728378625735	3
1118	sam.b@frontpageadvantage.com	44	t	moshville.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.moshville.co.uk/	Inbound	1719496491688	1722930278878	2
761	sam.b@frontpageadvantage.com	36	t	holyroodpr.co.uk	falcobliek@gmail.com	Falco	f	james.p@frontpageadvantage.com	130	£	https://www.holyroodpr.co.uk/	Inbound	1708615661584	1745919846393	9
1258	james.p@frontpageadvantage.com	35	t	eruditemeetup.co.uk	teamforbesradar@gmail.com	Forbes Radar	f	james.p@frontpageadvantage.com	120	$	http://eruditemeetup.co.uk/	James	1727177065841	1745919301219	3
1533	frontpage.ga@gmail.com	37	t	tuambia.org	contacts@tuambia.org	Tuambia	f	james.p@frontpageadvantage.com	40	£	tuambia.org	inboud	1744280737429	1745923333899	2
1160	james.p@frontpageadvantage.com	45	f	epodcastnetwork.com	sofiakahn06@gmail.com	Sofia	f	system	60	$	epodcastnetwork.com		1726058131710	1738378895448	4
333	historical	15	t	learndeveloplive.com	chris@learndeveloplive.com	Chris Jaggs	f	james.p@frontpageadvantage.com	25	£	www.learndeveloplive.com	Fatjoe	0	1745919815881	5
1078	sam.b@frontpageadvantage.com	22	t	redkitedays.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	160	£	redkitedays.co.uk	Inbound	1719319469273	1745919993184	6
904	sam.b@frontpageadvantage.com	38	t	theleaguepaper.com	sam.emery@greenwayspublishing.com	Sam	f	james.p@frontpageadvantage.com	100	£	www.theleaguepaper.com	Outbound Chris	1709718289226	1745922866038	6
1357	chris.p@frontpageadvantage.com	66	t	dailysquib.co.uk	arianna@timewomenflag.com	Arianna Volkova	f	james.p@frontpageadvantage.com	141	£	dailysquib.co.uk	inbound	1730196590897	1745918928355	2
1453	james.p@frontpageadvantage.com	59	t	houzz.co.uk	sophiadaniel.co.uk@gmail.com	sophia	f	chris.p@frontpageadvantage.com	30	£	https://www.houzz.co.uk/	James	1739457701377	1741259580610	2
1107	sam.b@frontpageadvantage.com	54	t	businesscheshire.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	140	£	https://www.businesscheshire.co.uk/	Inbound	1719408355968	1745919826898	2
1420	frontpage.ga@gmail.com	32	t	clickdo.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	118	£	business.clickdo.co.uk	inbound	1730297564122	1745919863587	2
1429	frontpage.ga@gmail.com	26	t	simpleparenting.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	139	£	simpleparenting.co.uk	inbound	1730297923475	1745921827808	2
1525	frontpage.ga@gmail.com	37	t	hentai20.pro	 technexitspace@gmail.com	Hentai 20 	f	james.p@frontpageadvantage.com	30	£	hentai20.pro	inboud	1744278836662	1745923180890	2
1534	frontpage.ga@gmail.com	37	t	dreamchaserhub.com	support@extremebacklink.com 	Dream Chaser Hub 	f	james.p@frontpageadvantage.com	40	£	dreamchaserhub.com	inboud	1744280863821	1745923336368	2
1419	frontpage.ga@gmail.com	33	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	familyfriendlyworking.co.uk	inbound	1730297531326	1746068439307	3
1203	james.p@frontpageadvantage.com	36	t	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	Fiona	f	james.p@frontpageadvantage.com	70	£	http://www.dollydowsie.com/	James	1726241391467	1749134022625	3
1162	james.p@frontpageadvantage.com	72	t	cyprus-mail.com	sofiakahn06@gmail.com	Sofia	f	chris.p@frontpageadvantage.com	270	$	cyprus-mail.com	James	1726058412889	1749198071570	2
369	historical	36	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	Mellissa Williams	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/	Inbound email	0	1754017234190	6
489	historical	70	f	abcmoney.co.uk	advertise@abcmoney.co.uk	Claire James	f	system	60	£	www.abcmoney.co.uk	Inbound Sam	0	1754017236080	8
1527	frontpage.ga@gmail.com	56	t	ceocolumn.com	Support@gposting.com	Ceo Column	f	james.p@frontpageadvantage.com	40	£	CeoColumn.com	inboud	1744279699951	1745923189771	2
336	historical	41	t	midwifeandlife.com	Jenny@midwifeandlife.com	Jenny Lord	f	chris.p@frontpageadvantage.com	70	£	midwifeandlife.com	Fatjoe	0	1708424366153	2
302	historical	8	t	poocrazy.com	paul@moneytipsblog.co.uk	Paul	f	chris.p@frontpageadvantage.com	10	£	www.poocrazy.com	Inbound email	0	1708693689221	2
1412	frontpage.ga@gmail.com	39	t	kettlemag.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	130	£	kettlemag.co.uk	inbound	1730296980153	1745923318797	2
402	historical	58	t	mammaprada.com	mammaprada@gmail.com	Kristie Prada	f	chris.p@frontpageadvantage.com	90	£	https://www.mammaprada.com	Inbound email	0	1727944130012	7
1108	sam.b@frontpageadvantage.com	39	t	thehockeypaper.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.thehockeypaper.co.uk/	Inbound	1719408428460	1722930290668	3
1109	sam.b@frontpageadvantage.com	48	t	thefightingcock.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://thefightingcock.co.uk/	Inbound	1719408484683	1722930303141	2
1110	sam.b@frontpageadvantage.com	44	t	londonforfree.net	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.londonforfree.net/	Inbound	1719408568561	1722930312708	2
1062	sam.b@frontpageadvantage.com	36	t	thebraggingmommy.com	kirangupta.outreach@gmail.com	Kiran Gupta	f	james.p@frontpageadvantage.com	80	£	thebraggingmommy.com	Inbound	1716462238586	1745919392228	7
328	historical	21	f	beemoneysavvy.com	Emma@beemoneysavvy.com	Emma	f	system	70	£	www.beemoneysavvy.com	Fatjoe	0	1761966042625	12
1352	frontpage.ga@gmail.com	63	t	twinsdrycleaners.co.uk	arianna@timewomenflag.com	Arianna Volkova	f	chris.p@frontpageadvantage.com	25	£	twinsdrycleaners.co.uk	inboud	1729768172025	1729855161244	2
451	historical	74	t	marketbusinessnews.com	Imjustwebworld@gmail.com	Harshil	f	james.p@frontpageadvantage.com	99	£	marketbusinessnews.com	Inbound email	0	1745919294738	6
1526	frontpage.ga@gmail.com	57	t	bronwinaurora.com	write@bronwinaurora.com	Bronwin Aurora	f	james.p@frontpageadvantage.com	40	£	bronwinaurora.com	inboud	1744279580858	1745923186998	2
1617	millie.t@frontpageadvantage.com	71	f	hackmd.io	calahlane3@gmail.com	Hack MD	f	system	60	£	https://hackmd.io/	Millie	1754566382919	1759287641542	2
957	chris.p@frontpageadvantage.com	45	f	north.wales	backlinsprovider@gmail.com	David Smith	f	system	95	£	https://north.wales/	Inbound	1711532679719	1759287646420	6
1410	frontpage.ga@gmail.com	37	t	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	141	£	glitzandglamourmakeup.co.uk	inbound	1730296903193	1745919418160	4
1413	frontpage.ga@gmail.com	40	t	businessfirstonline.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	134	£	businessfirstonline.co.uk	inbound	1730297027604	1745919852459	3
1508	frontpage.ga@gmail.com	55	f	megalithic.co.uk	andy@megalithic.co.uk	The Megalithic Portal	f	james.p@frontpageadvantage.com	80	£	megalithic.co.uk	inbound	1741271505305	1749198362568	3
486	historical	88	t	digitaljournal.com	sophiadaniel.co.uk@gmail.com	Sophia	f	james.p@frontpageadvantage.com	130	£	www.digitaljournal.com	Inbound Sam	0	1727187191791	2
1509	james.p@frontpageadvantage.com	31	f	countingtoten.co.uk	countingtotenblog@gmail.com	Kate	f	system	75	£	https://www.countingtoten.co.uk/	James - NEW	1742476076536	1742476079406	1
1529	frontpage.ga@gmail.com	57	f	thebiographywala.com	support@linksposting.com 	The Biography Wala	f	system	40	£	Thebiographywala.com	inboud	1744279970120	1759374002294	2
1510	frontpage.ga@gmail.com	37	f	xatpes.co.uk	 xatpes.official@gmail.com	Xatapes	f	system	80	£	https://xatpes.co.uk/contact-us/	inbound	1742850929074	1742850932205	1
1513	frontpage.ga@gmail.com	38	f	load2learn.org.uk	infopool13@gmail.com	LOAD2LEARN	f	system	80	£	load2learn.org.uk	inbound	1742851433859	1742851436852	1
1411	frontpage.ga@gmail.com	38	t	businessvans.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	129	£	businessvans.co.uk	inbound	1730296950461	1745919855682	3
1081	sam.b@frontpageadvantage.com	38	t	emmysmummy.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	120	£	emmysmummy.com	Inbound	1719319784878	1745919995783	5
1519	frontpage.ga@gmail.com	38	f	myflexbot.co.uk	myflexbot11@gmail.com	My Flex Bot	f	system	80	£	myflexbot.co.uk	inbound	1742852226231	1761966045856	3
765	sam.b@frontpageadvantage.com	47	t	storymirror.com	ela690000@gmail.com	Ella	f	james.p@frontpageadvantage.com	96	£	https://storymirror.com/	Inbound	1708616408925	1745920616912	7
1071	sam.b@frontpageadvantage.com	31	t	makemoneywithoutajob.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	150	£	makemoneywithoutajob.com	Inbound	1719318047364	1745924333662	8
339	historical	26	t	keralpatel.com	keralpatel@gmail.com	Keral Patel	f	james.p@frontpageadvantage.com	35	£	https://www.keralpatel.com	Fatjoe	0	1745923515928	6
1503	frontpage.ga@gmail.com	35	t	latestdash.co.uk	alphaitteamofficial@gmail.com	Latest dash	f	james.p@frontpageadvantage.com	50	£	latestdash.co.uk	inbound	1741269787500	1745923173279	2
905	sam.b@frontpageadvantage.com	50	t	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	David warner 	f	james.p@frontpageadvantage.com	150	£	https://www.luxurylifestylemag.co.uk/	Inbound	1709718547266	1745923536067	6
1409	frontpage.ga@gmail.com	40	t	britishicehockey.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	134	£	britishicehockey.co.uk	inbound	1730296845823	1745923543818	2
1408	frontpage.ga@gmail.com	38	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	134	£	fionaoutdoors.co.uk	inbound	1730296799161	1754017240324	5
1204	james.p@frontpageadvantage.com	37	f	ladyjaney.co.uk	Jane@ladyjaney.co.uk	Jane	f	system	125	£	https://ladyjaney.co.uk/	James contact form	1726564805504	1746068440967	3
1403	frontpage.ga@gmail.com	51	t	aboutmanchester.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	146	£	aboutmanchester.co.uk	inbound	1730296526142	1749198404369	3
306	historical	17	t	testingtimeblog.com	sam@testingtimeblog.com	Sam	f	chris.p@frontpageadvantage.com	75	£	www.testingtimeblog.com	Fatjoe	0	1708424045249	2
310	historical	19	t	rawrhubarb.co.uk	jennasnclr@gmail.com	Jenna	f	chris.p@frontpageadvantage.com	30	£	www.rawrhubarb.co.uk	Fatjoe	0	1708424355198	1
350	historical	35	t	tacklingourdebt.com	vicki@tacklingourdebt.com	Vicki	f	chris.p@frontpageadvantage.com	45	£	Tacklingourdebt.com	Fatjoe	0	1708424369644	1
478	historical	18	t	affectionatelypaws.com	hello@contentmother.com	Becky	f	chris.p@frontpageadvantage.com	45	£	http://affectionatelypaws.com	inbound email	0	1708424428227	2
343	historical	54	t	workingdaddy.co.uk	tom@workingdaddy.co.uk	Thomaz	f	michael.l@frontpageadvantage.com	60	£	https://workingdaddy.co.uk	Fatjoe	0	1710248472725	2
311	historical	16	f	alifeoflovely.com	alifeoflovely@gmail.com	Lu	f	system	25	£	alifeoflovely.com	Fatjoe	0	1759287650195	8
1164	james.p@frontpageadvantage.com	56	t	celebrow.org	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	30	$	celebrow.org	James	1726063207724	1745919310438	4
335	historical	24	t	lillaloves.com	lillaallahiary@gmail.com	Lilla	f	james.p@frontpageadvantage.com	20	£	Www.lillaloves.com	Fatjoe	0	1745919328923	7
344	historical	11	t	hellowanderer.co.uk	hellowandereruk@gmail.com	Chloe	f	chris.p@frontpageadvantage.com	25	£	http://www.hellowanderer.co.uk	Fatjoe	0	0	0
331	historical	32	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	Angela Riches	f	system	40	£	www.hnmagazine.co.uk	Fatjoe	0	1759287652470	9
307	historical	13	t	peterwynmosey.com	contact@peterwynmosey.com	Peter	f	james.p@frontpageadvantage.com	15	£	peterwynmosey.com	Fatjoe	0	1718283964819	3
309	historical	15	t	annabelwrites.com	annabelwrites.blog@gmail.com	Annabel	f	james.p@frontpageadvantage.com	20	£	annabelwrites.com	Fatjoe	0	1718283984529	4
341	historical	17	t	sashashantel.com	contactsashashantel@gmail.com	Sasha Shantel	f	james.p@frontpageadvantage.com	60	£	http://www.sashashantel.com	Fatjoe	0	1745919339703	9
312	historical	30	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	Abbie	f	system	165	£	mmbmagazine.co.uk	Fatjoe	0	1761966047470	13
314	historical	18	f	thejournalix.com	thejournalix@gmail.com	Thomas	f	system	15	£	thejournalix.com	Fatjoe	0	1761966049161	10
346	historical	20	t	carouseldiary.com	Info@carouseldiary.com	Katrina	f	james.p@frontpageadvantage.com	40	£	Carouseldiary.com	Fatjoe	0	1745919342211	3
358	historical	22	t	thisbrilliantday.com	thisbrilliantday@gmail.com	Sophie Harriet	f	james.p@frontpageadvantage.com	50	£	https://thisbrilliantday.com/	Fatjoe	0	1745919349176	10
327	historical	26	t	startsmarter.co.uk	publishing@startsmarter.co.uk	Adam Niazi	f	james.p@frontpageadvantage.com	89	£	www.StartSmarter.co.uk	Fatjoe	0	1745919868182	9
1502	michael.l@frontpageadvantage.com	57	t	londondaily.news	sophiadaniel.co.uk@gmail.com	Sophia Daniel	f	chris.p@frontpageadvantage.com	65	£	https://www.londondaily.news/	Inbound Michael	1740053738291	1741259596936	3
305	historical	21	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	Thirfty Bride	f	system	40	£	https://www.thethriftybride.co.uk	Fatjoe	0	1761966051334	12
351	historical	35	t	mycarheaven.com	Info@mycarheaven.com	Chris	f	james.p@frontpageadvantage.com	150	£	Www.mycarheaven.com	Fatjoe	0	1745921464059	4
318	historical	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	Tanya	f	system	150	£	luckyattitude.co.uk	Fatjoe	0	1761966051976	8
308	historical	13	t	felifamily.com	suzied@felifamily.com	Suzie	f	james.p@frontpageadvantage.com	25	£	felifamily.com	Fatjoe	0	1745921761209	4
445	historical	61	t	networkustad.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	networkustad.com	Inbound email	0	1718366875618	2
321	historical	23	t	peggymay.co.uk	Peggymayyarns@gmail.com	Peggy	f	chris.p@frontpageadvantage.com	20	£	peggymay.co.uk	Fatjoe	0	0	0
325	historical	33	t	thriftychap.com	joeseager@gmail.com	Joe Seager	f	chris.p@frontpageadvantage.com	245	£	thriftychap.com	Fatjoe	0	0	0
329	historical	35	t	wemadethislife.com	wemadethislife@outlook.com	Alina Davies	f	james.p@frontpageadvantage.com	150	£	https://wemadethislife.com	Fatjoe	0	1745921763647	9
345	historical	17	t	threelittlezees.co.uk	lauraroseclubb@hotmail.com	Laura	f	james.p@frontpageadvantage.com	25	£	threelittlezees.co.uk	Fatjoe	0	1745921766786	8
317	historical	29	t	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	Jen	f	james.p@frontpageadvantage.com	30	£	www.jenloumeredith.com	Fatjoe	0	1745922004831	5
337	historical	25	t	thepennypincher.co.uk	howdy@thepennypincher.co.uk	Al Baker	f	james.p@frontpageadvantage.com	40	£	www.thepennypincher.co.uk	Fatjoe	0	1745923750444	6
342	historical	36	t	karlismyunkle.com	karlismyunkle@gmail.com	Nik Thakkar	f	james.p@frontpageadvantage.com	45	£	www.karlismyunkle.com	Fatjoe	0	1745924340021	6
313	historical	19	t	slashercareer.com	tanya@slashercareer.com	Tanya	f	chris.p@frontpageadvantage.com	90	£	slashercareer.com	Fatjoe	0	1726056486057	3
338	historical	19	f	themammafairy.com	themammafairy@gmail.com	Laura Breslin	f	system	45	£	www.themammafairy.com	Fatjoe	0	1754017245787	9
349	historical	24	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	Vicki	f	james.p@frontpageadvantage.com	60	£	Icenimagazine.co.uk	Fatjoe	0	1745924975093	7
1058	michael.l@frontpageadvantage.com	59	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	Rowena Becker	f	system	175	£	https://mybalancingact.co.uk/	Outbound Facebook	1716452780180	1748746841497	5
1609	millie.t@frontpageadvantage.com	40	f	voucherix.co.uk	\N	Click Intelligence	t	millie.t@frontpageadvantage.com	80	£	https://www.voucherix.co.uk	\N	1752139047012	1752742152434	1
334	historical	23	f	lifeloving.co.uk	sally@lifeloving.co.uk	Sally Allsop	f	system	100	£	www.lifeloving.co.uk	Fatjoe	0	1754017248272	11
410	historical	25	t	realgirlswobble.com	rohmankatrina@gmail.com	Katrina Rohman	f	james.p@frontpageadvantage.com	80	£	https://realgirlswobble.com/	Facebook	0	1740562668954	7
370	historical	19	t	retro-vixen.com	hello@retro-vixen.com	Clare McDougall	f	chris.p@frontpageadvantage.com	100	£	https://retro-vixen.com	Inbound email	0	1708424384361	2
376	historical	24	t	wood-create.com	ben@wood-create.com	Ben	f	chris.p@frontpageadvantage.com	180	£	https://www.wood-create.com	Inbound email	0	1708424389251	2
366	historical	46	t	barbaraiweins.com	info@barbaraiweins.com	Jason	f	james.p@frontpageadvantage.com	37	£	Barbaraiweins.com	Inbound email	0	1745919355077	7
363	historical	61	t	justwebworld.com	imjustwebworld@gmail.com	Harshil	f	chris.p@frontpageadvantage.com	99	£	https://justwebworld.com/	Fatjoe	0	1718282155681	2
372	historical	37	t	fashion-mommy.com	fashionmommywm@gmail.com	emma iannarilli	f	james.p@frontpageadvantage.com	85	£	fashion-mommy.com	Inbound email	0	1745919357673	5
456	historical	52	t	urbanmatter.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	110	£	urbanmatter.com	Inbound email	0	1718366893752	3
389	historical	29	f	arthurwears.com	Arthurwears.email@gmail.com	Sarah	f	system	250	£	Https://www.arthurwears.com	Inbound email	0	1751338858860	8
398	historical	25	t	mytunbridgewells.com	mytunbridgewells@gmail.com	Clare Lush-Mansell	f	james.p@frontpageadvantage.com	124	£	https://www.mytunbridgewells.com/	Inbound email	0	1745919710094	7
401	historical	32	t	marketme.co.uk	christopher@marketme.co.uk	Christopher	f	james.p@frontpageadvantage.com	59	£	https://marketme.co.uk/	Inbound email	0	1745919714770	5
360	historical	35	t	rachelbustin.com	rachel@rachelbustin.com	Rachel Bustin	f	james.p@frontpageadvantage.com	85	£	https://rachelbustin.com	Fatjoe	0	1745921773953	5
1634	millie.t@frontpageadvantage.com	21	f	thestrawberryfountain.com	thestrawberryfountain@hotmail.com	Terri Brown	f	system	100	£	http://www.thestrawberryfountain.com/	Millie	1755676747408	1755676750215	1
379	historical	27	t	yeahlifestyle.com	info@yeahlifestyle.com	Asha Carlos	f	james.p@frontpageadvantage.com	120	£	https://www.yeahlifestyle.com	Inbound email	0	1745921782022	8
383	historical	38	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	Fran	f	system	75	£	www.whingewhingewine.co.uk	Inbound email	0	1759287655170	6
388	historical	25	t	misstillyandme.co.uk	beingtillysmummy@gmail.com	vicky Hall-Newman	f	james.p@frontpageadvantage.com	75	£	www.misstillyandme.co.uk	Inbound email	0	1745921786727	9
399	historical	33	t	suburban-mum.com	hello@suburban-mum.com	Maria	f	james.p@frontpageadvantage.com	100	£	www.suburban-mum.com	Inbound email	0	1745921792324	4
378	historical	42	t	healthyvix.com	victoria@healthyvix.com	Victoria	f	james.p@frontpageadvantage.com	170	£	https://www.healthyvix.com	Inbound email	0	1745922807023	9
381	historical	34	t	therarewelshbit.com	kacie@therarewelshbit.com	Kacie Morgan	f	james.p@frontpageadvantage.com	200	£	www.therarewelshbit.com	Inbound email	0	1745922810289	6
385	historical	41	f	motherhoodtherealdeal.com	motherhoodtherealdeal@gmail.com	Taiya	f	system	85	£	Https://www.motherhoodtherealdeal.com	Inbound email	0	1722481467128	3
1528	frontpage.ga@gmail.com	54	t	starmusiqweb.com	admin@gpitfirm.com	Star Musiq Web 	f	james.p@frontpageadvantage.com	40	£	starmusiqweb.com	inboud	1744279857115	1745923242893	2
906	sam.b@frontpageadvantage.com	46	t	liverpoolway.co.uk	kenditoys.com@gmail.com	David warner 	f	james.p@frontpageadvantage.com	142	£	https://www.liverpoolway.co.uk/	Inbound	1709718918993	1745923538797	5
377	historical	43	t	travelvixta.com	victoria@travelvixta.com	Victoria	f	james.p@frontpageadvantage.com	170	£	https://www.travelvixta.com	Inbound email	0	1745924278639	8
395	historical	25	t	missmanypennies.com	hello@missmanypennies.com	Hayley	f	james.p@frontpageadvantage.com	85	£	www.missmanypennies.com	Inbound email	0	1745924291203	6
406	historical	27	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	Ruth Davies Knowles	f	system	116	£	Https://rocknrollerbaby.co.uk	Inbound email	0	1761966055083	9
390	historical	30	f	bay-bee.co.uk	Stephi@bay-bee.co.uk	Steph Moore	f	system	115	£	https://blog.bay-bee.co.uk/	Inbound email	0	1761966058404	9
394	historical	38	f	skinnedcartree.com	corinne@skinnedcartree.com	Corinne	f	system	75	£	https://skinnedcartree.com	Inbound email	0	1740798119517	6
365	historical	40	f	letstalkmommy.com	jenny@letstalkmommy.com	Jenny	f	james.p@frontpageadvantage.com	100	£	https://www.Letstalkmommy.com	Fatjoe	0	1745924997519	9
373	historical	32	f	kateonthinice.com	kateonthinice1@gmail.com	Kate Holmes	f	james.p@frontpageadvantage.com	75	£	kateonthinice.com	Inbound email	0	1745925007497	3
386	historical	52	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	Anna marikar	f	james.p@frontpageadvantage.com	150	£	Intheplayroom.co.uk	Inbound email	0	1745925021805	6
397	historical	59	f	emmaplusthree.com	emmaplusthree@gmail.com	Emma Easton	f	james.p@frontpageadvantage.com	100	£	www.emmaplusthree.com	Inbound email	0	1745925032381	5
408	historical	21	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	Michelle O’Connor	f	system	75	£	Https://www.the-willowtree.com	Inbound email	0	1748746853843	10
1611	millie.t@frontpageadvantage.com	39	f	primmart.com	\N	Click intelligence	t	millie.t@frontpageadvantage.com	80	£	https://primmart.com	\N	1752139081370	1752743306163	1
380	historical	62	f	captainbobcat.com	Eva@captainbobcat.com	Eva Katona	f	system	180	£	Https://www.captainbobcat.com	Inbound email	0	1754017250700	9
347	historical	34	f	diydaddyblog.com	Diynige@yahoo.com	Nigel higgins	f	system	45	£	https://www.diydaddyblog.com/	Fatjoe	0	1754017255306	12
375	historical	27	f	clairemac.co.uk	clairemacblog@gmail.com	Claire Chircop	f	system	60	£	www.clairemac.co.uk	Inbound email	0	1754017258541	10
368	historical	56	f	justeilidh.com	just.eilidhg@gmail.com	Eilidh	f	system	100	£	www.justeilidh.com	Inbound email	0	1754017259138	4
413	historical	24	t	lablogbeaute.co.uk	hello@lablogbeaute.do.uk	Beth Mahoney	f	chris.p@frontpageadvantage.com	100	£	https://lablogbeaute.co.uk/	Facebook	0	1708424393176	2
429	historical	29	t	countryheartandhome.com	Debbie@countryheartandhome.com	Deborah Nicholas	f	chris.p@frontpageadvantage.com	75	£	https://countryheartandhome.com/	Facebook	0	1708424398360	1
431	historical	53	t	lthornberry.co.uk	lauraa_x@hotmail.co.uk	Laura	f	chris.p@frontpageadvantage.com	55	£	www.lthornberry.co.uk	Facebook	0	1708424403270	2
435	historical	46	t	psychtimes.com	info@psychtimes.com	THomas Hlubin	f	chris.p@frontpageadvantage.com	45	£	https://psychtimes.com/	Inbound email	0	1708424407436	1
444	historical	56	t	tastefulspace.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	tastefulspace.com	Inbound email	0	1708424411450	2
462	historical	65	t	azbigmedia.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	170	£	azbigmedia.com	Inbound email	0	1708424418236	2
1428	frontpage.ga@gmail.com	31	f	feast-magazine.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	118	£	feast-magazine.co.uk	inbound	1730297891567	1759287665765	7
419	historical	32	t	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	Ana	f	james.p@frontpageadvantage.com	100	£	https://fadedspring.co.uk/	Facebook	0	1745919364996	4
432	historical	47	t	lyliarose.com	victoria@lyliarose.com	Victoria	f	james.p@frontpageadvantage.com	170	£	https://www.lyliarose.com	Facebook	0	1745919717468	7
425	historical	30	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	Jess Howliston	f	system	75	£	www.tantrumstosmiles.co.uk	Facebook	0	1761966064210	11
441	historical	78	f	newsbreak.com	minalkh124@gmail.com	Maryam bibi	f	james.p@frontpageadvantage.com	55	£	original.newsbreak.com	Inbound email	0	1745925121465	10
433	historical	36	t	bq-magazine.com	hello@contentmother.com	Lucy Clarke	f	james.p@frontpageadvantage.com	80	£	https://www.bq-magazine.com	Facebook	0	1745919719875	4
460	historical	26	f	techacrobat.com	minalkh124@gmail.com	Maryam bibi	f	system	140	£	techacrobat.com	Inbound email	0	1761966065449	6
443	historical	81	t	fooyoh.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	fooyoh.com	Inbound email	0	1718366870997	3
440	historical	63	t	ventsmagazine.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	50	£	ventsmagazine.com	Inbound email	0	1739443665089	7
453	historical	72	f	techbullion.com	angelascottbriggs@techbullion.com	Angela Scott-Briggs 	f	system	100	£	http://techbullion.com	Inbound email	0	1761966066069	7
446	historical	63	t	filmdaily.co	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	filmdaily.co	Inbound email	0	1718366879421	3
450	historical	54	t	zomgcandy.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	90	£	zomgcandy.com	Inbound email	0	1718366882905	2
420	historical	30	t	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	Anna	f	james.p@frontpageadvantage.com	150	£	https://www.dontcrampmystyle.co.uk	Facebook	0	1745919990544	6
411	historical	22	t	bouquetandbells.com	sarah@dreamofhome.co.uk	Sarah Macklin	f	james.p@frontpageadvantage.com	60	£	https://bouquetandbells.com/	Facebook	0	1745921466280	7
421	historical	48	t	glassofbubbly.com	christopher@marketme.co.uk	Christopher	f	james.p@frontpageadvantage.com	125	£	https://glassofbubbly.com/	Inbound email	0	1745921468883	5
417	historical	41	t	globalmousetravels.com	hello@globalmousetravels.com	Nichola West	f	james.p@frontpageadvantage.com	250	£	https://globalmousetravels.com	Facebook	0	1745921799265	7
454	historical	62	t	whatsnew2day.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	100	£	whatsnew2day.com	Inbound email	0	1718366886357	2
416	historical	30	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	Micaela	f	system	100	£	https://www.stylishlondonliving.co.uk/	Facebook	0	1761966067290	12
430	historical	26	t	bizzimummy.com	Bizzimummy@gmail.com	Eva Stretton	f	james.p@frontpageadvantage.com	55	£	https://bizzimummy.com	Facebook	0	1745921802233	5
412	historical	30	t	laurakatelucas.com	laurakatelucas@hotmail.com	Laura Lucas	f	james.p@frontpageadvantage.com	100	£	www.laurakatelucas.com	Facebook	0	1745922007182	8
427	historical	16	t	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	Shallie	f	james.p@frontpageadvantage.com	75	£	Shalliespurplebeehive.com	Facebook	0	1745923524492	4
424	historical	60	t	tipsofbusiness.com	joeseager@gmail.com	Joe Seager	f	chris.p@frontpageadvantage.com	145	£	tipsofbusiness.com	Facebook	0	0	0
461	historical	61	t	deskrush.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	160	£	deskrush.com	Inbound email	0	1718366905922	3
482	historical	55	t	entrepreneursbreak.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	https://entrepreneursbreak.com/	inbound email	0	1718366913949	1
463	historical	44	t	vizaca.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	190	£	vizaca.com	Inbound email	0	1718367461325	3
448	historical	50	t	gisuser.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	Gisuser.com	Inbound email	0	1718975343762	1
428	historical	55	t	modernguy.co.uk	modguyinfo@gmail.com	Modern Guy	f	chris.p@frontpageadvantage.com	103	£	Modernguy.co.uk	Facebook	0	1718975351183	3
1404	frontpage.ga@gmail.com	43	t	pczone.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	114	£	pczone.co.uk	inbound	1730296573812	1745923703562	4
452	historical	66	f	bignewsnetwork.com	minalkh124@gmail.com	Maryam bibi	f	james.p@frontpageadvantage.com	100	£	bignewsnetwork.com	Inbound email	0	1745925093062	3
415	historical	31	f	aaublog.com	allaboutublog@gmail.com	Rebecca Urie	f	system	35	£	https://www.AAUBlog.com	Facebook	0	1754017262711	10
1620	millie.t@frontpageadvantage.com	36	f	thedatascientist.com	calahlane3@gmail.com	Thedatascientist	f	system	120	£	https://thedatascientist.com/	Millie	1754566476971	1759287667143	2
474	historical	22	t	lclarke.co.uk	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	50	£	https://lclarke.co.uk	inbound email	0	1745919371223	8
477	historical	14	t	rocketandrelish.com	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	45	£	https://www.rocketandrelish.com	inbound email	0	1745919373584	7
503	historical	57	t	newsfromwales.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	144	£	newsfromwales.co.uk	Inbound Sam	0	1745921473419	3
475	historical	15	t	quick-house-sales.com	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	45	£	https://www.quick-house-sales.com	inbound email	0	1718284198908	2
481	historical	29	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	Emily	f	system	75	£	https://www.twinmummyanddaddy.com/	another blogger	0	1759287669081	6
499	historical	58	t	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	144	£	www.lifestyledaily.co.uk	Inbound Sam	0	1745919378603	5
494	historical	53	t	mikemyers.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	168	£	mikemyers.co.uk	Inbound Sam	0	1718366918378	2
442	historical	63	t	wheon.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	70	£	wheon.com	Inbound email	0	1718367478662	7
509	historical	71	t	glasgowarchitecture.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	114	£	www.glasgowarchitecture.co.uk	Inbound Sam	0	1718367486663	3
488	historical	59	t	computertechreviews.com	kamransharief@gmail.com	Sophia	f	chris.p@frontpageadvantage.com	100	£	computertechreviews.com	Inbound Sam	0	1718367496112	3
1166	james.p@frontpageadvantage.com	40	f	costumeplayhub.com	sofiakahn06@gmail.com	Sofia	f	system	30	$	costumeplayhub.com	James	1726063406379	1759287671092	7
758	chris.p@frontpageadvantage.com	49	t	beastbeauty.co.uk	falcobliek@gmail.com	Falco	f	chris.p@frontpageadvantage.com	120	£	https://www.beastbeauty.co.uk/	Inbound	1708604143276	1718367499476	4
510	historical	30	t	powderrooms.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	powderrooms.co.uk	Inbound Sam	0	1745919381071	5
1530	frontpage.ga@gmail.com	51	f	sundarbantracking.com	baldriccada@gmail.com	Sundar Barn	f	system	40	£	sundarbantracking.com	inboud	1744280227571	1761966067853	2
1083	sam.b@frontpageadvantage.com	34	f	edinburgers.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	edinburgers.co.uk	Inbound	1719319963927	1761966069131	6
484	historical	89	t	ibtimes.co.uk	i.perez@ibtmedia.co.uk	Inigo	f	james.p@frontpageadvantage.com	379	£	ibtimes.co.uk	inbound email	0	1745919794831	5
505	historical	29	f	talk-retail.co.uk	backlinsprovider@gmail.com	David Smith	f	system	95	£	talk-retail.co.uk	Inbound Sam	0	1761966070792	7
504	historical	29	t	westlondonliving.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	84	£	www.westlondonliving.co.uk	Inbound Sam	0	1745921475598	4
414	historical	20	t	joannavictoria.co.uk	joannabayford@gmail.com	Joanna Bayford	f	james.p@frontpageadvantage.com	50	£	https://www.joannavictoria.co.uk	Facebook	0	1745921795283	6
495	historical	63	t	welshmum.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.welshmum.co.uk	Inbound Sam	0	1745921808996	7
507	historical	34	t	toddleabout.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	toddleabout.co.uk	Inbound Sam	0	1745921813636	3
473	historical	24	t	earthlytaste.com	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	50	£	https://www.earthlytaste.com	inbound email	0	1745922813063	4
387	historical	29	t	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	Anna marikar	f	james.p@frontpageadvantage.com	150	£	Onyourjourney.co.uk	Inbound email	0	1745923519025	7
470	historical	22	t	realwedding.co.uk	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	80	£	https://www.realwedding.co.uk	inbound email	0	1745924301567	8
501	historical	48	t	fashioncapital.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	132	£	www.fashioncapital.co.uk	Inbound Sam	0	1745924304457	3
493	historical	38	t	greenunion.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	www.greenunion.co.uk	Inbound Sam	0	1745924308171	8
487	historical	80	t	thefrisky.com	sophiadaniel.co.uk@gmail.com	Sophia	f	michael.l@frontpageadvantage.com	150	£	thefrisky.com	Inbound Sam	0	1708007305158	1
500	historical	37	f	pat.org.uk	hello@pat.org.uk	Sam	f	james.p@frontpageadvantage.com	30	£	www.pat.org.uk	Inbound Sam	0	1748443732106	9
466	historical	66	t	swaay.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	220	£	swaay.com	Inbound email	0	1708424423842	2
479	historical	17	t	poppyandblush.com	hello@contentmother.com	Becky	f	chris.p@frontpageadvantage.com	45	£	http://poppyandblush.com	inbound email	0	1708424431847	1
480	historical	25	t	the-pudding.com	hello@contentmother.com	Becky	f	chris.p@frontpageadvantage.com	45	£	http://www.the-pudding.com	inbound email	0	1708424437246	2
490	historical	57	t	theedinburghreporter.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	168	£	theedinburghreporter.co.uk	Inbound Sam	0	1708424443094	2
492	historical	27	t	thedevondaily.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	120	£	www.thedevondaily.co.uk	Inbound Sam	0	1708424447248	2
498	historical	17	t	gonetravelling.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	84	£	gonetravelling.co.uk	Inbound Sam	0	1708424450853	2
506	historical	43	t	eagle.co.ug	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	114	£	eagle.co.ug	Inbound Sam	0	1708424454491	2
527	historical	59	f	ourculturemag.com	info@ourculturemag.com	Info	f	system	115	£	ourculturemag.com	Inbound Sam	0	1761966071387	11
958	chris.p@frontpageadvantage.com	48	f	deeside.com	backlinsprovider@gmail.com	David Smith	f	system	95	£	https://www.deeside.com/	inbound	1711532781458	1743476563246	3
531	historical	37	t	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	Sophia Daniel	f	chris.p@frontpageadvantage.com	90	£	www.businessmanchester.co.uk	Inbound Sam	0	1727252122588	8
808	sam.b@frontpageadvantage.com	19	t	myarchitecturesidea.com	travelworldwithfashion@gmail.com	Vijay Chauhan	f	james.p@frontpageadvantage.com	41	£	https://myarchitecturesidea.com/	Outbound	1709637089134	1745918968077	9
1084	sam.b@frontpageadvantage.com	28	t	bouncemagazine.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	100	£	bouncemagazine.co.uk	Inbound	1719320073095	1745919395800	4
540	historical	42	t	otsnews.co.uk	bhaiahsan799@gmail.com	Ashan	f	james.p@frontpageadvantage.com	55	£	www.otsnews.co.uk	Inbound Sam	0	1745919792182	6
535	historical	57	t	ukbusinessforums.co.uk	natalilacanario@gmail.com	Natalila	f	james.p@frontpageadvantage.com	170	£	ukbusinessforums.co.uk	Inbound Sam	0	1745919807947	4
523	historical	36	t	daytradetheworld.com	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	www.daytradetheworld.com	Inbound Sam	0	1745919805208	7
907	sam.b@frontpageadvantage.com	66	t	bmmagazine.co.uk	kenditoys.com@gmail.com	David warner 	f	james.p@frontpageadvantage.com	200	£	https://bmmagazine.co.uk/	Inbound	1709719202025	1745919821775	8
908	sam.b@frontpageadvantage.com	32	t	britainreviews.co.uk	kenditoys.com@gmail.com	David warner 	f	james.p@frontpageadvantage.com	167	£	https://britainreviews.co.uk/	Inbound	1709719594822	1745919849291	4
513	historical	30	t	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.thefoodaholic.co.uk	Inbound Sam	0	1745922815599	6
464	historical	54	t	startup.info	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	200	£	startup.info	Inbound email	0	1718366909767	2
536	historical	55	t	hildenbrewing.com	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	170	£	hildenbrewing.com	Inbound Sam	0	1718366922093	2
537	historical	53	t	technoloss.com	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	155	£	technoloss.com	Inbound Sam	0	1718366925459	3
538	historical	59	t	4howtodo.com	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	170	£	4howtodo.com	Inbound Sam	0	1718366929266	3
781	chris.p@frontpageadvantage.com	47	t	kidsworldfun.com	enquiry@kidsworldfun.com	Limna	f	james.p@frontpageadvantage.com	80	£	https://www.kidsworldfun.com/	outbound	1709033259858	1745920500154	8
469	historical	47	t	retailtechinnovationhub.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	280	£	retailtechinnovationhub.com	Inbound email	0	1718367470158	3
519	historical	23	t	cyclingscot.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	168	£	www.cyclingscot.co.uk	Inbound Sam	0	1708424457655	2
528	historical	32	t	cubeduel.com	backlinsprovider@gmail.com	David	f	chris.p@frontpageadvantage.com	120	£	cubeduel.com	Inbound Sam	0	1708424461527	2
533	historical	46	t	craigmurray.co.uk	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	165	£	craigmurray.co.uk	Inbound Sam	0	1708424464756	2
1085	sam.b@frontpageadvantage.com	36	t	welovebrum.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	140	£	welovebrum.co.uk	Inbound	1719320223488	1745920614572	3
522	historical	54	t	altcoininvestor.com	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	96	£	altcoininvestor.com	Inbound Sam	0	1718367493269	4
520	historical	26	t	davidsavage.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	30	£	www.davidsavage.co.uk	Inbound Sam	0	1745921815757	6
465	historical	82	t	goodmenproject.com	minalkh124@gmail.com	Maryam bibi	f	james.p@frontpageadvantage.com	220	£	http://goodmenproject.com	Inbound email	0	1745923170715	4
514	historical	21	t	tobecomemum.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	www.tobecomemum.co.uk	Inbound Sam	0	1745924310444	6
515	historical	15	t	travel-bugs.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	www.travel-bugs.co.uk	Inbound Sam	0	1745924314997	7
518	historical	21	t	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.ukcaravanrental.co.uk	Inbound Sam	0	1745924317472	4
521	historical	19	t	izzydabbles.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	96	£	izzydabbles.co.uk	Inbound Sam	0	1745924319943	7
524	historical	38	t	travelbeginsat40.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	100	£	www.travelbeginsat40.com	Inbound Sam	0	1745924322601	7
526	historical	46	t	puretravel.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	160	£	www.puretravel.com	Inbound Sam	0	1745924325200	6
532	historical	65	f	varsity.co.uk	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	150	£	www.varsity.co.uk	Inbound Sam	0	1745925100532	3
1168	james.p@frontpageadvantage.com	36	f	birdzpedia.com	sofiakahn06@gmail.com	Sofia	f	system	35	$	birdzpedia.com	James	1726065344402	1754017269626	8
525	historical	59	f	traveldailynews.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	91	£	www.traveldailynews.com	Inbound Sam	0	1745925154271	5
409	historical	33	f	wannabeprincess.co.uk	Debzjs@hotmail.com	Debz	f	system	75	£	www.wannabeprincess.co.uk	Facebook	0	1754017271673	9
1635	millie.t@frontpageadvantage.com	35	f	thefrenchiemummy.com	cecile@thefrenchiemummy.com	Cecile 	f	system	107	£	https://thefrenchiemummy.com/	Millie	1755683084092	1755683087058	1
303	historical	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	This is Owned by Chris :-)	f	system	1	£	www.moneytipsblog.co.uk	Inbound email	0	1756695679387	18
1414	frontpage.ga@gmail.com	38	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	118	£	singleparentsonholiday.co.uk	inbound	1730297056465	1759287680012	4
404	historical	22	t	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	Elizabeth Williams	f	chris.p@frontpageadvantage.com	80	£	www.whererootsandwingsentwine.com	Inbound email	0	1727877493262	4
403	historical	54	f	sparklesandstretchmarks.com	Hayley@sparklesandstretchmarks.com	Hayley Mclean	f	system	100	£	Https://www.sparklesandstretchmarks.com	Inbound email	0	1722481606511	2
467	historical	58	f	underconstructionpage.com	minalkh124@gmail.com	Maryam bibi	f	system	230	£	http://underconstructionpage.com	Inbound email	0	1717211201824	2
437	historical	54	t	techbehindit.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	55	£	techbehindit.com	Inbound email	0	1718366857704	2
418	historical	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	Petra	f	system	100	£	https://amumreviews.co.uk/	Facebook	0	1759287681863	11
497	historical	32	t	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	anythinggoeslifestyle.co.uk	Inbound Sam	0	1745919375611	9
1629	millie.t@frontpageadvantage.com	30	f	rhianwestbury.co.uk	westburyrhian@gmail.com	Rhian	f	system	100	£	http://www.rhianwestbury.co.uk/	Millie	1755610853604	1759287702428	2
1167	james.p@frontpageadvantage.com	60	t	stylesrant.org	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	30	$	stylesrant.org	James	1726063465343	1745919326196	3
322	historical	35	f	5thingstodotoday.com	5thingstodotoday@gmail.com	David	f	system	45	£	5thingstodotoday.com	Fatjoe	0	1761966083088	7
530	historical	36	t	tech-wonders.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	100	£	www.tech-wonders.com	Inbound Sam	0	1745919810648	4
458	historical	72	t	spacecoastdaily.com	minalkh124@gmail.com	Maryam bibi	f	james.p@frontpageadvantage.com	120	£	https://spacecoastdaily.com/	Inbound email	0	1745919818703	6
517	historical	24	t	interestingfacts.org.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	156	£	www.interestingfacts.org.uk	Inbound Sam	0	1745920502937	9
371	historical	23	t	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	Jennie Jordan	f	james.p@frontpageadvantage.com	80	£	www.ricecakesandraisins.co.uk	Inbound email	0	1745921779526	5
809	sam.b@frontpageadvantage.com	57	t	pierdom.com	info@pierdom.com	Junaid	f	james.p@frontpageadvantage.com	25	£	https://pierdom.com/	Outbound	1709637625007	1745921825549	7
541	historical	23	f	simplymotor.co.uk	n/a	Fatjoe	t	\N	60	£	www.simplymotor.co.uk	\N	0	0	0
542	historical	21	f	alfiebsmith.com	n/a	Micaela	t	\N	75	£	www.alfiebsmith.com	\N	0	0	0
354	historical	43	t	businesspartnermagazine.com	info@businesspartnermagazine.com	Sandra Hinshelwood	f	james.p@frontpageadvantage.com	19	£	https://businesspartnermagazine.com/	Fatjoe	0	1718284210838	2
602	historical	0	f	\N	\N	FatJoe	t	\N	0	£	\N	\N	0	0	0
476	historical	11	t	contentmother.com	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	45	£	https://www.contentmother.com	inbound email	0	1745923144176	5
1537	frontpage.ga@gmail.com	42	t	topcelebz.com	support@gposting.com	Top Celebz	f	james.p@frontpageadvantage.com	40	£	Topcelebz.com	inboud	1744282245029	1745923146909	2
393	historical	63	t	reallymissingsleep.com	kareneholloway@hotmail.com	Karen Langridge	f	james.p@frontpageadvantage.com	150	£	https://www.reallymissingsleep.com/	Inbound email	0	1745923521303	7
319	historical	33	t	morningbusinesschat.com	info@morningbusinesschat.com	Brett	f	chris.p@frontpageadvantage.com	83	£	morningbusinesschat.com	Fatjoe	0	1708424361755	1
352	historical	22	t	beautiful-solutions.co.uk	staceykane@outlook.com	Stacey	f	chris.p@frontpageadvantage.com	40	£	https://www.beautiful-solutions.co.uk	Fatjoe	0	1708424373522	1
447	historical	77	t	atlnightspots.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	atlnightspots.com	Inbound email	0	1708424414853	2
455	historical	57	t	programminginsider.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	100	£	programminginsider.com	Inbound email	0	1718366889849	2
457	historical	54	t	techktimes.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	110	£	http://techktimes.com/	Inbound email	0	1718366898669	2
909	sam.b@frontpageadvantage.com	58	t	blogstory.co.uk	kenditoys.com@gmail.com	David warner 	f	chris.p@frontpageadvantage.com	125	£	https://blogstory.co.uk/	Inbound	1709720316064	1726056501919	3
511	historical	73	t	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	132	£	www.edinburgharchitecture.co.uk	Inbound Sam	0	1718367489944	3
449	historical	47	t	urbansplatter.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	85	£	https://www.urbansplatter.com/	Inbound email	0	1718367513245	3
539	historical	58	t	tamilworlds.com	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	150	£	Tamilworlds.com	Inbound Sam	0	1718975358204	3
508	historical	32	t	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	healthylifeessex.co.uk	Inbound Sam	0	1745923531398	7
407	historical	23	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	Rachael Sheehan	f	system	50	£	https://lukeosaurusandme.co.uk	Inbound email	0	1754017276388	10
384	historical	36	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	Jeni	f	system	150	£	Https://chillingwithlucas.com	Inbound email	0	1748746869206	8
543	historical	28	f	magicalpenny.com	n/a	Fatjoe	t	\N	80	£	magicalpenny.com	\N	0	0	0
544	historical	26	f	definecivil.com	n/a	Fatjoe	t	\N	60	£	definecivil.com	\N	0	0	0
545	historical	20	f	vikingwanderer.com	n/a	Fatjoe	t	\N	60	£	vikingwanderer.com	\N	0	0	0
546	historical	32	f	muncievoice.com	n/a	Fatjoe	t	\N	90	£	muncievoice.com	\N	0	0	0
547	historical	39	f	ecommercefastlane.com	n/a	fatjoe	t	\N	90	£	ecommercefastlane.com	\N	0	0	0
548	historical	36	f	beurownlight.com	n/a	Fatjoe	t	\N	100	£	beurownlight.com	\N	0	0	0
549	historical	27	f	adventuremummy.com	n/a	Fatjoe	t	\N	60	£	adventuremummy.com	\N	0	0	0
550	historical	28	f	jennifergilmour.com	n/a	Fatjoe	t	\N	80	£	jennifergilmour.com	\N	0	0	0
551	historical	26	f	bekylou.com	n/a	Fatjoe	t	\N	80	£	www.bekylou.com	\N	0	0	0
552	historical	35	f	dorkface.co.uk	n/a	Micaela	t	\N	100	£	www.dorkface.co.uk	\N	0	0	0
553	historical	22	f	prettykittenlife.com	n/a	Micaela	t	\N	100	£	prettykittenlife.com	\N	0	0	0
554	historical	25	f	isalillo.com	n/a	Fatjoe	t	\N	80	£	www.isalillo.com	\N	0	0	0
555	historical	36	f	homewithaneta.com	n/a	fatjoe	t	\N	90	£	homewithaneta.com	\N	0	0	0
556	historical	31	f	previousmagazine.com	n/a	Fatjoe	t	\N	100	£	www.previousmagazine.com	\N	0	0	0
557	historical	31	f	pinaynomad.com	n/a	fatjoe	t	\N	90	£	pinaynomad.com	\N	0	0	0
558	historical	24	f	freebirdsmagazine.com	n/a	Fatjoe	t	\N	60	£	freebirdsmagazine.com	\N	0	0	0
560	historical	21	f	ginakaydaniel.com	n/a	Fatjoe	t	\N	60	£	www.ginakaydaniel.com	\N	0	0	0
561	historical	28	f	britishstylesociety.uk	n/a	Fatjoe	t	\N	80	£	britishstylesociety.uk	\N	0	0	0
562	historical	21	f	geekedcartree.co.uk	n/a	Micaela	t	\N	50	£	geekedcartree.co.uk	\N	0	0	0
563	historical	28	f	hopezvara.com	n/a	Fatjoe	t	\N	80	£	hopezvara.com	\N	0	0	0
564	historical	30	f	bamni.co.uk	n/a	Fatjoe	t	\N	100	£	bamni.co.uk	\N	0	0	0
565	historical	15	f	unconventionalkira.co.uk	n/a	Micaela	t	\N	50	£	www.unconventionalkira.co.uk	\N	0	0	0
566	historical	27	f	theglossymagazine.com	n/a	Fatjoe	t	\N	80	£	theglossymagazine.com	\N	0	0	0
567	historical	25	f	nishiv.com	n/a	Micaela	t	\N	100	£	www.nishiv.com	\N	0	0	0
568	historical	39	f	thoushaltnotcovet.net	n/a	Fatjoe	t	\N	100	£	thoushaltnotcovet.net	\N	0	0	0
569	historical	21	f	mumsthewurd.com	n/a	Micaela	t	\N	100	£	www.mumsthewurd.com	\N	0	0	0
570	historical	36	f	new-lune.com	n/a	Fatjoe	t	\N	100	£	new-lune.com	\N	0	0	0
571	historical	29	f	thegadgetman.org.uk	n/a	Fatjoe	t	\N	80	£	www.thegadgetman.org.uk	\N	0	0	0
572	historical	29	f	passportjoy.com	n/a	Fatjoe	t	\N	80	£	passportjoy.com	\N	0	0	0
573	historical	26	f	talkingaboutmygeneration.co.uk	n/a	Fatjoe	t	\N	80	£	talkingaboutmygeneration.co.uk	\N	0	0	0
574	historical	17	f	newenglandb2bnetworking.com	n/a	Fatjoe	t	\N	80	£	newenglandb2bnetworking.com	\N	0	0	0
575	historical	24	f	money-mentor.org	n/a	Fatjoe	t	\N	78	£	www.money-mentor.org	\N	0	0	0
576	historical	21	f	curlyandcandid.co.uk	n/a	Fatjoe	t	\N	80	£	www.curlyandcandid.co.uk	\N	0	0	0
577	historical	23	f	krismunro.co.uk	n/a	Fatjoe	t	\N	60	£	krismunro.co.uk	\N	0	0	0
578	historical	34	f	shemightbe.co.uk	n/a	Micaela	t	\N	100	£	shemightbe.co.uk	\N	0	0	0
579	historical	27	f	thelifeofadventure.com	n/a	Micaela	t	\N	100	£	thelifeofadventure.com	\N	0	0	0
580	historical	20	f	websigmas.com	n/a	Fatjoe	t	\N	80	£	www.websigmas.com	\N	0	0	0
581	historical	28	f	mimiroseandme.com	n/a	Fatjoe	t	\N	80	£	www.mimiroseandme.com	\N	0	0	0
582	historical	38	f	kerrylouisenorris.com	n/a	Fatjoe	t	\N	100	£	www.kerrylouisenorris.com	\N	0	0	0
583	historical	20	f	digital-dreamer.net	n/a	Fatjoe	t	\N	80	£	digital-dreamer.net	\N	0	0	0
584	historical	29	f	beingtillysmummy.co.uk	n/a	Micaela	t	\N	50	£	www.beingtillysmummy.co.uk	\N	0	0	0
585	historical	29	f	britonabudget.co.uk	n/a	Fatjoe	t	\N	80	£	britonabudget.co.uk	\N	0	0	0
586	historical	19	f	pradaplanet.com	n/a	Micaela	t	\N	30	£	www.pradaplanet.com	\N	0	0	0
587	historical	33	f	fromcorporatetocareerfreedom.com	n/a	Fatjoe	t	\N	100	£	www.fromcorporatetocareerfreedom.com	\N	0	0	0
588	historical	36	f	lattelindsay.com	n/a	Fatjoe	t	\N	100	£	lattelindsay.com	\N	0	0	0
589	historical	31	f	singledadsguidetolife.com	n/a	Micaela	t	\N	75	£	singledadsguidetolife.com	\N	0	0	0
400	historical	31	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	Christopher	f	system	79	£	https://estateagentnetworking.co.uk/	Inbound email	0	1738378991049	4
315	historical	28	t	allthebeautifulthings.co.uk	helsy.gandy@gmail.com	Helsy	f	chris.p@frontpageadvantage.com	0	£	www.allthebeautifulthings.co.uk	Fatjoe	0	0	0
396	historical	55	t	leedaily.com	dakotachirnside@aol.com	Dakota	f	chris.p@frontpageadvantage.com	0	£	https://leedaily.com/	Inbound email	0	0	0
603	historical	24	f	theislandjournal.com	\N	FatJoe	t	chris.p@frontpageadvantage.com	80	£	https://theislandjournal.com	\N	0	0	0
770	chris.p@frontpageadvantage.com	58	t	valiantceo.com	staff@valiantceo.com	Valiantstaff	f	chris.p@frontpageadvantage.com	70	£	https://valiantceo.com/	outbound	1709027700111	1727876262241	6
559	historical	58	t	thenewsgod.com	n/a	Click Intelligence	t	chris.p@frontpageadvantage.com	1	£	thenewsgod.com	\N	0	1709026464981	1
1080	sam.b@frontpageadvantage.com	47	f	exposedmagazine.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	exposedmagazine.co.uk	Inbound	1719319694584	1740798075146	3
910	chris.p@frontpageadvantage.com	0	f	\N	\N	FatJoe	t	\N	0	\N	\N	\N	1709904731384	1709904731384	0
911	chris.p@frontpageadvantage.com	0	f	\N	\N	FatJoe	t	\N	0	\N	\N	\N	1709904777387	1709904777387	0
304	historical	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	UKNEWS Group	f	system	50	£	https://www.uknewsgroup.co.uk/	Inbound email	0	1754103608770	10
1546	frontpage.ga@gmail.com	45	f	talkssmartly.com	support@seolinkers.com	Talks Smartly	f	system	50	£	talkssmartly.com	inboud	1744287722025	1759287689298	5
1539	frontpage.ga@gmail.com	70	f	anationofmoms.com	PR@anationofmoms.com	A Nation Of Moms	f	system	50	£	anationofmoms.com	inboud	1744282455391	1761966089891	6
1625	millie.t@frontpageadvantage.com	55	f	insequiral.com	hello@insequiral.com	Fiona	f	system	100	£	http://www.insequiral.com/	Millie	1754664916120	1754664919130	1
1514	frontpage.ga@gmail.com	38	f	dailywaffle.co.uk	sarah@dailywaffle.co.uk	DAILY WAFFLE	f	system	80	£	dailywaffle.co.uk	inbound	1742851604179	1742851607247	1
1505	frontpage.ga@gmail.com	38	t	pixwox.co.uk	 pixwoxx@gmail.com	Pixwox	f	james.p@frontpageadvantage.com	75	£	pixwox.co.uk	inbound	1741270951520	1749133683619	2
1623	millie.t@frontpageadvantage.com	34	f	mrsshilts.co.uk	emma.shilton@outlook.com	Emma Shilton	f	system	100	£	http://www.mrsshilts.co.uk/	Millie	1754570606930	1759287686244	2
1706	millie.t@frontpageadvantage.com	42	f	uknewstap.co.uk	calahlane3@gmail.com	Uk News Tap	f	system	55	£	http://uknewstap.co.uk/	Calah	1760967354015	1760967356782	1
1712	millie.t@frontpageadvantage.com	38	f	newsdipper.co.uk	calahlane3@gmail.com	News Dipper	f	system	50	£	https://newsdipper.co.uk/	Calah	1761816876951	1761816879724	1
1517	frontpage.ga@gmail.com	58	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	UK Journal	f	system	80	£	ukjournal.co.uk	inbound	1742852009295	1761966090745	5
330	historical	38	f	robinwaite.com	robin@robinwaite.com	Robin Waite	f	system	42	£	https://www.robinwaite.com	Fatjoe	0	1761966094528	8
1511	frontpage.ga@gmail.com	28	f	msnpro.co.uk	ankit@zestfulloutreach.com	MSN PRO	f	system	80	£	https://msnpro.co.uk/contact-us/	inbound	1742851051403	1761966095679	3
1059	michael.l@frontpageadvantage.com	27	f	flashpackingfamily.com	flashpackingfamily@gmail.com	Jacquie Hale	f	system	150	£	https://flashpackingfamily.com/	Outbound Facebook	1716452853668	1748746873317	8
1521	frontpage.ga@gmail.com	42	f	grobuzz.co.uk	editorial@rankwc.com	GROBUZZ	f	system	80	£	grobuzz.co.uk	inboud	1742852543019	1761966096326	3
1542	frontpage.ga@gmail.com	47	f	prophecynewswatch.com	 Info@ProphecyNewsWatch.com	PNW	f	system	50	£	prophecynewswatch.com	inboud	1744283598194	1762052406585	2
1715	millie.t@frontpageadvantage.com	37	f	whatkatysaid.com	katy@whatkatysaid.com	katy	f	system	75	£	http://www.whatkatysaid.com/	Millie	1762792457787	1762792460729	1
1407	frontpage.ga@gmail.com	41	t	themarketingblog.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	129	£	themarketingblog.co.uk	inbound	1730296672141	1745919858760	3
1543	frontpage.ga@gmail.com	45	t	ameyawdebrah.com	@ameyawdebrah.com. 	Ameyaw Debrah	f	james.p@frontpageadvantage.com	50	£	ameyawdebrah.com	inboud	1744287332432	1745923239296	2
1544	frontpage.ga@gmail.com	44	t	famerize.com	support@seolinkers.com	Fame Rize	f	james.p@frontpageadvantage.com	50	£	famerize.com	inbound 	1744287545928	1745923296483	2
1545	frontpage.ga@gmail.com	43	t	mcdmenumy.com	support@seolinkers.com	MCD Menu	f	james.p@frontpageadvantage.com	50	£	mcdmenumy.com	inboud	1744287627439	1745923299076	2
1547	frontpage.ga@gmail.com	41	t	talkinemoji.com	support@seolinkers.com	Talk in emoji	f	james.p@frontpageadvantage.com	50	£	talkinemoji.com	inboud	1744287848608	1745923301474	2
340	historical	32	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	Jenny Marston	f	system	80	£	http://www.Jennyinneverland.com	Fatjoe	0	1746068499905	11
1548	frontpage.ga@gmail.com	42	t	beumye.com	support@seolinkers.com	beaumye	f	james.p@frontpageadvantage.com	50	£	beumye.com	inboud	1744287951439	1745923304424	2
1402	frontpage.ga@gmail.com	51	t	hrnews.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	122	£	hrnews.co.uk	inbound	1730296493781	1745923323287	4
1355	frontpage.ga@gmail.com	36	t	wrapofthedays.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	james.p@frontpageadvantage.com	25	£	wrapofthedays.co.uk	inbound	1729769821170	1745918894052	3
1356	frontpage.ga@gmail.com	37	t	mealtop.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	james.p@frontpageadvantage.com	25	£	https://mealtop.co.uk/	inbound	1729770014428	1745918916482	5
1358	chris.p@frontpageadvantage.com	64	t	marketoracle.co.uk	arianna@timewomenflag.com	Arianna Volkova	f	james.p@frontpageadvantage.com	94	£	marketoracle.co.uk	inbound	1730196614139	1745918937497	2
1163	james.p@frontpageadvantage.com	51	t	powerhomebiz.com	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	250	$	powerhomebiz.com	James	1726061380233	1745919297677	3
468	historical	92	t	apnews.com	minalkh124@gmail.com	Maryam bibi	f	james.p@frontpageadvantage.com	240	£	apnews.com	Inbound email	0	1745919797158	2
1415	frontpage.ga@gmail.com	35	t	blackeconomics.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	134	£	blackeconomics.co.uk	inbound	1730297155721	1745919861365	3
348	historical	23	t	blossomeducation.co.uk	info@blossomeducation.co.uk	Vicki	f	james.p@frontpageadvantage.com	60	£	blossomeducation.co.uk	Fatjoe	0	1745920486755	6
1516	frontpage.ga@gmail.com	28	t	thecwordmag.co.uk	info@thecwordmag.co.uk	thecwordmag	f	james.p@frontpageadvantage.com	80	£	thecwordmag.co.uk	inbound	1742851851548	1745923176023	3
1541	frontpage.ga@gmail.com	54	t	pantheonuk.org	admin@pantheonuk.org	Pan the on UK	f	james.p@frontpageadvantage.com	50	£	pantheonuk.org	inboud	1744283499452	1745923178708	2
529	historical	38	t	houseofcoco.net	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	150	£	houseofcoco.net	Inbound Sam	0	1745924328485	5
1538	frontpage.ga@gmail.com	86	f	theodysseyonline.com	roy@theodysseyonline.com Create with us	Odyssey	f	james.p@frontpageadvantage.com	50	£	theodysseyonline.com	inboud	1744282332763	1749198328984	2
1532	frontpage.ga@gmail.com	38	t	nameshype.com	 admin@rabbiitfirm.com	Names Hype 	f	james.p@frontpageadvantage.com	40	£	nameshype.com	inboud	1744280534970	1748445192929	2
1522	frontpage.ga@gmail.com	35	f	techimaging.co.uk	contact@techimaging.co.uk	Tech Imaging	f	system	80	£	techimaging.co.uk	inboud	1742852661569	1754017284520	2
702	michael.l@frontpageadvantage.com	38	t	frontpageadvantage.com	chris.p@frontpageadvantage.com	Front Page Advantage	f	james.p@frontpageadvantage.com	10	£	https://frontpageadvantage.com/	Email	1708008300694	1745918966021	7
762	sam.b@frontpageadvantage.com	14	t	flatpackhouses.co.uk	falcobliek@gmail.com	Falco	f	james.p@frontpageadvantage.com	120	£	https://www.flatpackhouses.co.uk/	Inbound	1708615840028	1745918969943	4
353	historical	16	t	lingermagazine.com	info@lingermagazine.com	Tiffany Tate	f	james.p@frontpageadvantage.com	82	£	https://www.lingermagazine.com/	Fatjoe	0	1745919345664	5
769	chris.p@frontpageadvantage.com	60	t	livepositively.com	ela690000@gmail.com	ela	f	james.p@frontpageadvantage.com	1150	£	https://livepositively.com/	inbound	1709027357228	1745919352207	4
405	historical	36	t	prettybigbutterflies.com	prettybigbutterflies@gmail.com	Hollie	f	james.p@frontpageadvantage.com	80	£	www.prettybigbutterflies.com	Inbound email	0	1745919361530	5
472	historical	28	t	pleasureprinciple.net	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	50	£	https://www.pleasureprinciple.net	inbound email	0	1745919368173	3
1636	millie.t@frontpageadvantage.com	25	f	birdsandlilies.com	birdsandlilies@gmail.com	Louise	f	system	100	£	https://www.birdsandlilies.com/	Millie	1755848328859	1755848331794	1
1639	millie.t@frontpageadvantage.com	72	f	thelondoneconomic.com	backlinsprovider@gmail.com	London economic	f	system	370	£	http://thelondoneconomic.com/	David Smith 	1757598163477	1757598166665	1
1638	millie.t@frontpageadvantage.com	44	f	costaprices.co.uk	backlinsprovider@gmail.com	Costa Prices	f	system	85	$	https://costaprices.co.uk/	David Smith 	1757598029993	1759287697548	2
1504	frontpage.ga@gmail.com	26	f	infinityelse.co.uk	 infinityelse1@gmail.com	Infinity else	f	system	65	£	infinityelse.co.uk	inbound	1741270738337	1759287703075	7
1631	millie.t@frontpageadvantage.com	44	f	reelsmedia.co.uk	calahlane3@gmail.com	ReelsMedia	f	system	50	£	http://reelsmedia.co.uk/	Millie	1755675865921	1759287704339	2
771	chris.p@frontpageadvantage.com	42	f	finehomesandliving.com	info@fine-magazine.com	Fine Home Team	f	system	100	£	https://www.finehomesandliving.com/	outbound	1709027801990	1759287704924	8
1652	millie.t@frontpageadvantage.com	42	f	ukstartupmagazine.co.uk	jonathan@ukstartupmagazine.co.uk	Jonathon	f	system	300	£	https://www.ukstartupmagazine.co.uk/	Tanya	1759840271455	1759840274789	1
1653	millie.t@frontpageadvantage.com	16	f	houseandhomeideas.co.uk	info@houseandhomeideas.co.uk	House & Homes	f	system	20	£	https://www.houseandhomeideas.co.uk/	Tanya	1759840429117	1759840432448	1
1654	millie.t@frontpageadvantage.com	42	f	midlandsbusinessnews.co.uk	amlivemanagement@hotmail.co.uk	Midlands Business News	f	system	40	£	https://midlandsbusinessnews.co.uk/contact/	Tanya	1759841564720	1759841567689	1
1703	millie.t@frontpageadvantage.com	33	f	buzblog.co.uk	backlinsprovider@gmail.com	Buzz BLOG	f	system	68	$	https://buzblog.co.uk/	David Smith 	1760711132182	1760711135384	1
1705	millie.t@frontpageadvantage.com	53	f	boho-weddings.com	kelly@boho-weddings.com	Kelly	f	system	199	£	https://www.boho-weddings.com/	Tanya	1760948438416	1760948441367	1
1707	millie.t@frontpageadvantage.com	32	f	imhentai.co.uk	calahlane3@gmail.com	Im hen Tai	f	system	50	£	http://imhentai.co.uk/	Calah	1760967404074	1760967407280	1
1708	millie.t@frontpageadvantage.com	31	f	thestripesblog.co.uk	calahlane3@gmail.com	The Stripes Blog	f	system	55	£	thestripesblog.co.uk	Calah	1760967461561	1760967464189	1
1713	millie.t@frontpageadvantage.com	30	f	accidentalhipstermum.com	accidentalhipstermum@gmail.com	Jenny	f	system	120	£	http://accidentalhipstermum.com/	Millie	1762252583668	1762252586859	1
1710	millie.t@frontpageadvantage.com	51	f	invisioncommunity.co.uk	backlinsprovider@gmail.com	David Invision Community	f	system	65	£	https://invisioncommunity.co.uk/	David Smith 	1761039824470	1761039827326	1
1711	millie.t@frontpageadvantage.com	40	f	racingbetter.co.uk	backlinsprovider@gmail.com	David Racing Better	f	system	60	£	https://racingbetter.co.uk/	David Smith 	1761039859361	1761039861995	1
1624	millie.t@frontpageadvantage.com	37	f	deepinmummymatters.com	mummymatters@gmail.com	Sabina	f	system	130	£	https://deepinmummymatters.com/	Millie	1754660310525	1761966087205	2
1626	millie.t@frontpageadvantage.com	61	f	lifeinabreakdown.com	sarah@lifeinabreakdown.com	Sarah	f	system	250	£	https://www.lifeinabreakdown.com/	Millie	1754665321436	1761966097842	2
1702	millie.t@frontpageadvantage.com	39	f	captionbio.co.uk	backlinsprovider@gmail.com	Captin Bio 	f	system	75	$	https://captionbio.co.uk/	David Smith	1760429536786	1761966103187	2
1622	millie.t@frontpageadvantage.com	35	f	webstosociety.co.uk	calahlane3@gmail.com	websstosociety	f	system	85	£	https://webstosociety.co.uk/	Millie	1754566562692	1761966103837	5
1709	millie.t@frontpageadvantage.com	42	f	businesstask.co.uk	calahlane3@gmail.com	Business Task	f	system	50	£	https://businesstask.co.uk/	Calah	1760967514629	1761966107280	2
422	historical	34	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	Tom	f	system	75	£	https://ukconstructionblog.co.uk/	Google Search	0	1761966123996	7
1633	millie.t@frontpageadvantage.com	38	f	tubegalore.uk	calahlane3@gmail.com	Tube Galore	f	system	50	£	http://tubegalore.uk/	Millie	1755675994853	1761966125774	3
326	historical	19	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	Lisa Ventura MBE	f	system	30	£	https://www.cybergeekgirl.co.uk	Fatjoe	0	1761966126366	11
780	chris.p@frontpageadvantage.com	22	f	travelistia.com	travelistiausa@gmail.com	Ferona	f	system	27	£	https://www.travelistia.com/	outbound	1709033136922	1761966126969	14
1714	millie.t@frontpageadvantage.com	24	f	thetraveldaily.co.uk	backlinsprovider@gmail.com	The Travel Daily David	f	system	85	£	https://www.thetraveldaily.co.uk/	David Smith 	1762790571756	1762790574863	1
1704	millie.t@frontpageadvantage.com	20	f	staceyinthesticks.com	stacey@staceyinthesticks.com	Stacey	f	millie.t@frontpageadvantage.com	40	£	www.staceyinthesticks.com	Millie	1760947883867	1763479614095	2
1202	james.p@frontpageadvantage.com	41	t	shemightbeloved.com	georgina@shemightbeloved.com	Georgina	f	james.p@frontpageadvantage.com	100	£	www.shemightbeloved.com	James	1726139288772	1745919307369	6
1165	james.p@frontpageadvantage.com	57	t	filmik.blog	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	30	$	filmik.blog	James	1726063285389	1745919313961	4
1063	sam.b@frontpageadvantage.com	38	t	grapevinebirmingham.com	kirangupta.outreach@gmail.com	Kiran Gupta	f	james.p@frontpageadvantage.com	80	£	grapevinebirmingham.com	Inbound	1716462449737	1745919403297	3
512	historical	27	t	calculator.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	132	£	www.calculator.co.uk	Inbound Sam	0	1745919799818	2
1540	frontpage.ga@gmail.com	65	t	africanbusinessreview.co.za	GuestPost@GeniusUpdates.com	African Business review 	f	james.p@frontpageadvantage.com	50	£	africanbusinessreview.co.za	inboud	1744282546745	1745919813074	2
367	historical	23	t	cocktailsinteacups.com	cocktailsinteacups@gmail.com	Amy Walsh	f	james.p@frontpageadvantage.com	40	£	cocktailsinteacups.com	Inbound email	0	1745921776702	6
1052	michael.l@frontpageadvantage.com	32	t	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	Louise	f	james.p@frontpageadvantage.com	150	£	https://www.adventuresofayorkshiremum.co.uk/	Outbound Facebook	1716451324696	1745921806636	4
516	historical	29	t	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.thegardeningwebsite.co.uk	Inbound Sam	0	1745922860061	11
955	michael.l@frontpageadvantage.com	27	t	latetacklemagazine.com	sam.emery@greenwayspublishing.com	Sam	f	james.p@frontpageadvantage.com	100	£	https://www.latetacklemagazine.com/	Outbound Chris	1711012971138	1745922869255	4
954	michael.l@frontpageadvantage.com	51	t	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	Sam	f	james.p@frontpageadvantage.com	200	£	https://www.thenonleaguefootballpaper.com/	Outbound Chris	1711012828815	1745922892115	6
1535	frontpage.ga@gmail.com	36	t	hamsafarshayari.com	admin@gpitfirm.com	Hamsafar Shayari	f	james.p@frontpageadvantage.com	40	£	hamsafarshayari.com	inbound 	1744281089499	1745923138440	2
1405	frontpage.ga@gmail.com	38	t	ramzine.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	114	£	ramzine.co.uk	inbound	1730296607431	1745923321115	3
760	sam.b@frontpageadvantage.com	36	t	fiso.co.uk	falcobliek@gmail.com	Falco	f	james.p@frontpageadvantage.com	130	£	https://www.fiso.co.uk/	Inbound	1708613844903	1745923541086	2
320	historical	29	t	practicalfrugality.com	hello@practicalfrugality.com	Magdalena	f	james.p@frontpageadvantage.com	38	£	www.practicalfrugality.com	Fatjoe	0	1745924269632	4
332	historical	30	t	autumnsmummyblog.com	laura@autumnsmummyblog.com	Laura Chesmer	f	james.p@frontpageadvantage.com	75	£	https://www.autumnsmummyblog.com	Fatjoe	0	1745924273424	4
391	historical	40	t	conversanttraveller.com	heather@conversanttraveller.com	Heather	f	james.p@frontpageadvantage.com	180	£	www.conversanttraveller.com	Inbound email	0	1745924286657	5
423	historical	27	t	mymoneycottage.com	hello@mymoneycottage.com	Clare McDougall	f	james.p@frontpageadvantage.com	100	£	https://mymoneycottage.com	Facebook	0	1745924299150	10
1255	frontpage.ga@gmail.com	27	t	katiemeehan.co.uk	hello@katiemeehan.co.uk	Katie Meehan	f	james.p@frontpageadvantage.com	50	£	https://katiemeehan.co.uk/category/lifestyle/	Hannah	1726784781949	1745924331132	4
1095	sam.b@frontpageadvantage.com	34	f	largerfamilylife.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	100	£	largerfamilylife.com	Inbound	1719322290354	1745924967466	3
361	historical	57	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	Erica Hughes	f	james.p@frontpageadvantage.com	125	£	https://alittleluxuryfor.me/	Fatjoe	0	1745924993126	4
392	historical	45	f	midlandstraveller.com	contact@midlandstraveller.com	Simone Ribeiro	f	james.p@frontpageadvantage.com	50	£	www.midlandstraveller.com	Inbound email	0	1745925114742	9
1627	millie.t@frontpageadvantage.com	25	f	infullflavour.com	infullflavour@gmail.com	Sarah	f	system	65	£	http://infullflavour.com/	Millie	1754898182768	1754898185616	1
1628	millie.t@frontpageadvantage.com	34	f	mummyvswork.co.uk	paula@mummyvswork.co.uk	Paula	f	system	150	£	https://mummyvswork.co.uk/	Millie	1755526189848	1755526193177	1
1630	millie.t@frontpageadvantage.com	36	f	omgflix.co.uk	calahlane3@gmail.com	OmgFlix	f	system	50	£	https://www.omgflix.co.uk/author/sky-bloom-inc	Millie	1755675826171	1755675828961	1
1060	michael.l@frontpageadvantage.com	43	f	safarisafricana.com	jacquiehale75@gmail.com	Jacquie Hale	f	system	200	£	https://safarisafricana.com/	Outbound Facebook	1716452913891	1756695632083	6
502	historical	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	Fazal	f	system	108	£	explorersagainstextinction.co.uk	Inbound Sam	0	1756695667173	10
1621	millie.t@frontpageadvantage.com	70	f	portotheme.com	calahlane3@gmail.com	Portotheme	f	system	80	£	https://www.portotheme.com/	Millie	1754566514837	1756695668255	2
1159	james.p@frontpageadvantage.com	43	t	thistradinglife.com	sofiakahn06@gmail.com	Sofia	f	millie.t@frontpageadvantage.com	35	$	thistradinglife.com	James	1726057994078	1756819944805	7
1549	millie.t@frontpageadvantage.com	38	f	thefestivals.uk	sam@thefestivals.uk	Sam	f	system	90	£	https://thefestivals.uk/	Tanya	1747837129945	1747837133370	1
1536	frontpage.ga@gmail.com	18	f	factquotes.com	support@extremebacklink.com 	Fact Quotes	f	system	18	£	factquotes.com	inboud	1744281928677	1754103611856	4
1607	millie.t@frontpageadvantage.com	70	f	homeandgardenlistings.co.uk	\N	Click intelligence	t	chris.p@frontpageadvantage.com	150	£	https://www.homeandgardenlistings.co.uk	\N	1752138697761	1754486250776	4
1552	james.p@frontpageadvantage.com	60	t	blackbud.co.uk	blackbuduk@gmail.com	Black Bud	f	millie.t@frontpageadvantage.com	60	£	https://www.blackbud.co.uk/	Tanya	1748504396998	1748950834065	2
426	historical	35	f	chelseamamma.co.uk	Chelseamamma@gmail.com	Kara Guppy	f	system	75	£	https://www.chelseamamma.co.uk/	Facebook	0	1761966115993	8
1554	james.p@frontpageadvantage.com	54	f	ukfitness.pro	hello@ukfitness.pro	UK fitness pro	f	system	100	£	https://ukfitness.pro/write-for-us	Tanya	1749112026452	1749112029548	1
1551	millie.t@frontpageadvantage.com	55	t	tweakyourbiz.com	editor@tweakyourbiz.com	Editors	f	james.p@frontpageadvantage.com	150	$	https://tweakyourbiz.com/	Tanya	1747837606638	1749117436084	2
1406	frontpage.ga@gmail.com	42	t	madeinshoreditch.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	158	£	madeinshoreditch.co.uk	inbound	1730296630124	1749198378959	5
1608	millie.t@frontpageadvantage.com	48	f	elevatedmagazines.com	\N	Click Intelligence	t	millie.t@frontpageadvantage.com	80	£	https://www.elevatedmagazines.com	\N	1752139005960	1752743511931	3
1610	millie.t@frontpageadvantage.com	33	f	myuniquehome.co.uk	\N	Click Intelligence	t	millie.t@frontpageadvantage.com	80	£	https://www.myuniquehome.co.uk	\N	1752139070886	1752743736848	1
1553	millie.t@frontpageadvantage.com	26	f	thecoachspace.com	gabrielle@thecoachspace.com	Gabrielle	f	system	82	£	https://thecoachspace.com/	Tanya	1749110988493	1759374014550	2
1556	james.p@frontpageadvantage.com	65	t	placeholder.com	millie.t@frontpageadvantage.com	placeholder	f	millie.t@frontpageadvantage.com	100	£	placeholder.com	James	1749199373428	1750864554900	2
1604	millie.t@frontpageadvantage.com	40	f	business-money.com	info@business-money.com	BusinessMoneyTeam	f	system	30	£	https://www.business-money.com/	Tanya	1751885774816	1751885777802	1
1605	millie.t@frontpageadvantage.com	13	f	tibbingtonconsulting.co.uk	info@globelldigital.com	Tibbington Consulting	f	system	25	£	https://www.tibbingtonconsulting.co.uk/	Tanya	1751886706863	1751886709789	1
1606	millie.t@frontpageadvantage.com	23	f	indowapblog.com	contactsiteseo@gmail.com	French Blogger	f	system	25	€	https://indowapblog.com/	contactsiteseo@gmail.com	1751973800624	1751973803623	1
1531	frontpage.ga@gmail.com	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	Every Movie Has A Lesson	f	system	40	£	everymoviehasalesson.com	inboud	1744280420962	1761966116382	5
1619	millie.t@frontpageadvantage.com	56	t	indibloghub.com	calahlane3@gmail.com	Indibloghub	f	millie.t@frontpageadvantage.com	50	£	https://indibloghub.com/	Millie	1754566452647	1756820383164	2
1637	millie.t@frontpageadvantage.com	48	f	financial-news.co.uk	backlinsprovider@gmail.com	Financial News	f	system	110	£	http://financial-news.co.uk/	David Smith 	1757597977070	1757597980036	1
1158	james.p@frontpageadvantage.com	33	f	toptechsinfo.com	david.linkedbuilders@gmail.com	David	f	system	10	$	http://toptechsinfo.com/	James	1725966960853	1759287628170	8
1618	millie.t@frontpageadvantage.com	65	f	coda.io	calahlane3@gmail.com	Coda IO	f	system	90	£	https://coda.io/	Millie	1754566417149	1759287647875	2
382	historical	31	f	stressedmum.co.uk	sam@stressedmum.co.uk	Samantha Donnelly	f	system	80	£	https://stressedmum.co.uk	Inbound email	0	1759287653745	9
1086	sam.b@frontpageadvantage.com	43	f	lovebelfast.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	120	£	lovebelfast.co.uk	Inbound	1719320331730	1759287699650	4
434	historical	19	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	Kara Guppy	f	system	75	£	https://arewenearlythereyet.co.uk/	Facebook	0	1759287701414	9
1602	millie.t@frontpageadvantage.com	44	f	slummysinglemummy.com	jo@slummysinglemummy.com	Jo  	f	system	100	£	https://slummysinglemummy.com/	Millie	1750841059853	1759287709629	3
1603	millie.t@frontpageadvantage.com	42	f	uknip.co.uk	uknewsinpictures@gmail.com	UKnip	f	system	90	£	https://uknip.co.uk/		1751012371517	1761966118048	2
1550	millie.t@frontpageadvantage.com	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	Matt	f	system	75	£	https://www.lifeunexpected.co.uk/	Tanya	1747837279774	1761966119231	4
1515	frontpage.ga@gmail.com	42	f	ranyy.com	aishwaryagaikwad313@gmail.com	Ranyy	f	system	80	£	ranyy.com	inbound	1742851725672	1761966122308	6
1632	millie.t@frontpageadvantage.com	31	f	imagefap.uk	calahlane3@gmail.com	ImageFap	f	system	50	£	http://imagefap.uk/	Millie	1755675953072	1761966124533	3
\.


--
-- Data for Name: supplier_aud; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.supplier_aud (id, rev, revtype, created_by, created_date, da, disabled, domain, email, modified_date, name, source, third_party, updated_by, we_write_fee, we_write_fee_currency, website) FROM stdin;
652	1	0	chris.p@frontpageadvantage.com	0	43	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	0	Gemma	inbound email	f	chris.p@frontpageadvantage.com	80	£	https://gemmalouise.co.uk/
364	1	0	historical	0	21	t	loveemblog.com	loveem.blog@gmail.com	0	Emily	Fatjoe	f	chris.p@frontpageadvantage.com	45	£	https://www.loveemblog.com/
323	1	0	historical	0	36	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	0	Claire	Fatjoe	f	\N	80	£	clairemorandesigns.co.uk
439	1	0	historical	0	65	f	timebusinessnews.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	25	£	timebusinessnews.com
653	1	0	chris.p@frontpageadvantage.com	0	42	f	thatdrop.com	info@morningbusinesschat.com	0	Brett Napoli	Inbound	f	\N	83	£	https://thatdrop.com/
355	1	0	historical	0	33	f	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	0	Rebecca	Fatjoe	f	\N	100	£	www.ialwaysbelievedinfutures.com
356	1	0	historical	0	36	f	sorry-about-the-mess.co.uk	chloebridge@gmail.com	0	Chloe Bridge	Fatjoe	f	\N	60	£	https://sorry-about-the-mess.co.uk
333	1	0	historical	0	17	f	learndeveloplive.com	chris@learndeveloplive.com	0	Chris Jaggs	Fatjoe	f	chris.p@frontpageadvantage.com	25	£	www.learndeveloplive.com
654	1	0	chris.p@frontpageadvantage.com	0	47	f	acraftedpassion.com	info@morningbusinesschat.com	0	Brett Napoli	Inbound	f	\N	83	£	https://acraftedpassion.com/
405	1	0	historical	0	33	f	prettybigbutterflies.com	prettybigbutterflies@gmail.com	0	Hollie	Inbound email	f	\N	80	£	www.prettybigbutterflies.com
655	1	0	chris.p@frontpageadvantage.com	0	46	f	forgetfulmomma.com	info@morningbusinesschat.com	0	Brett Napoli	Inbound	f	\N	83	£	https://www.forgetfulmomma.com/
459	1	0	historical	0	54	f	digitalengineland.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	120	£	digitalengineland.com
302	1	0	historical	0	10	f	poocrazy.com	paul@moneytipsblog.co.uk	0	Paul	Inbound email	f	\N	10	£	www.poocrazy.com
304	1	0	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	0	UKNEWS Group	Inbound email	f	\N	50	£	https://www.uknewsgroup.co.uk/
305	1	0	historical	0	20	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	0	Thirfty Bride	Fatjoe	f	\N	40	£	https://www.thethriftybride.co.uk
306	1	0	historical	0	18	f	testingtimeblog.com	sam@testingtimeblog.com	0	Sam	Fatjoe	f	\N	75	£	www.testingtimeblog.com
307	1	0	historical	0	11	f	peterwynmosey.com	contact@peterwynmosey.com	0	Peter	Fatjoe	f	\N	15	£	peterwynmosey.com
308	1	0	historical	0	16	f	felifamily.com	suzied@felifamily.com	0	Suzie	Fatjoe	f	\N	25	£	felifamily.com
309	1	0	historical	0	12	f	annabelwrites.com	annabelwrites.blog@gmail.com	0	Annabel	Fatjoe	f	\N	20	£	annabelwrites.com
310	1	0	historical	0	19	f	rawrhubarb.co.uk	jennasnclr@gmail.com	0	Jenna	Fatjoe	f	\N	30	£	www.rawrhubarb.co.uk
311	1	0	historical	0	15	f	alifeoflovely.com	alifeoflovely@gmail.com	0	Lu	Fatjoe	f	\N	25	£	alifeoflovely.com
312	1	0	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	0	Abbie	Fatjoe	f	\N	45	£	mmbmagazine.co.uk
313	1	0	historical	0	21	f	slashercareer.com	tanya@slashercareer.com	0	Tanya	Fatjoe	f	\N	90	£	slashercareer.com
314	1	0	historical	0	20	f	thejournalix.com	thejournalix@gmail.com	0	Joni	Fatjoe	f	\N	15	£	thejournalix.com
316	1	0	historical	0	29	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	0	Karl	Fatjoe	f	\N	50	£	www.newvalleynews.co.uk
317	1	0	historical	0	28	f	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	0	Jen	Fatjoe	f	\N	30	£	www.jenloumeredith.com
318	1	0	historical	0	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	0	Tanya	Fatjoe	f	\N	150	£	luckyattitude.co.uk
320	1	0	historical	0	31	f	practicalfrugality.com	hello@practicalfrugality.com	0	Magdalena	Fatjoe	f	\N	38	£	www.practicalfrugality.com
344	1	0	historical	0	11	t	hellowanderer.co.uk	hellowandereruk@gmail.com	0	Chloe	Fatjoe	f	chris.p@frontpageadvantage.com	25	£	http://www.hellowanderer.co.uk
324	1	0	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	0	Chrissy	Fatjoe	f	\N	20	£	itsmechrissyj.co.uk
326	1	0	historical	0	22	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	0	Lisa Ventura MBE	Fatjoe	f	\N	30	£	https://www.cybergeekgirl.co.uk
327	1	0	historical	0	32	f	startsmarter.co.uk	publishing@startsmarter.co.uk	0	Adam Niazi	Fatjoe	f	\N	89	£	www.StartSmarter.co.uk
328	1	0	historical	0	29	f	beemoneysavvy.com	Emma@beemoneysavvy.com	0	Emma	Fatjoe	f	\N	70	£	www.beemoneysavvy.com
329	1	0	historical	0	45	f	wemadethislife.com	wemadethislife@outlook.com	0	Alina Davies	Fatjoe	f	\N	150	£	https://wemadethislife.com
330	1	0	historical	0	34	f	robinwaite.com	robin@robinwaite.com	0	Robin Waite	Fatjoe	f	\N	42	£	https://www.robinwaite.com
331	1	0	historical	0	32	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	0	Angela Riches	Fatjoe	f	\N	40	£	www.hnmagazine.co.uk
334	1	0	historical	0	28	f	lifeloving.co.uk	sally@lifeloving.co.uk	0	Sally Allsop	Fatjoe	f	\N	60	£	www.lifeloving.co.uk
335	1	0	historical	0	20	f	lillaloves.com	lillaallahiary@gmail.com	0	Lilla	Fatjoe	f	\N	20	£	Www.lillaloves.com
336	1	0	historical	0	38	f	midwifeandlife.com	Jenny@midwifeandlife.com	0	Jenny Lord	Fatjoe	f	\N	70	£	midwifeandlife.com
337	1	0	historical	0	26	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	0	Al Baker	Fatjoe	f	\N	40	£	www.thepennypincher.co.uk
338	1	0	historical	0	18	f	themammafairy.com	themammafairy@gmail.com	0	Laura Breslin	Fatjoe	f	\N	45	£	www.themammafairy.com
1306	6870	0	james.p@frontpageadvantage.com	1727789980135	0	f	\N	\N	1727789980135	Click Intelligence	\N	t	\N	0	\N	\N
339	1	0	historical	0	22	f	keralpatel.com	keralpatel@gmail.com	0	Keral Patel	Fatjoe	f	\N	35	£	https://www.keralpatel.com
340	1	0	historical	0	43	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	0	Jenny Marston	Fatjoe	f	\N	80	£	http://www.Jennyinneverland.com
341	1	0	historical	0	13	f	sashashantel.com	contactsashashantel@gmail.com	0	Sasha Shantel	Fatjoe	f	\N	60	£	http://www.sashashantel.com
342	1	0	historical	0	35	f	karlismyunkle.com	karlismyunkle@gmail.com	0	Nik Thakkar	Fatjoe	f	\N	65	£	www.karlismyunkle.com
343	1	0	historical	0	30	f	workingdaddy.co.uk	tom@workingdaddy.co.uk	0	Thomaz	Fatjoe	f	\N	60	£	https://workingdaddy.co.uk
345	1	0	historical	0	14	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	0	Laura	Fatjoe	f	\N	25	£	threelittlezees.co.uk
346	1	0	historical	0	20	f	carouseldiary.com	Info@carouseldiary.com	0	Katrina	Fatjoe	f	\N	40	£	Carouseldiary.com
347	1	0	historical	0	33	f	diydaddyblog.com	Diynige@yahoo.com	0	Nigel higgins	Fatjoe	f	\N	75	£	https://www.diydaddyblog.com/
348	1	0	historical	0	23	f	blossomeducation.co.uk	info@blossomeducation.co.uk	0	Vicki	Fatjoe	f	\N	60	£	blossomeducation.co.uk
349	1	0	historical	0	23	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	0	Vicki	Fatjoe	f	\N	60	£	Icenimagazine.co.uk
350	1	0	historical	0	35	f	tacklingourdebt.com	vicki@tacklingourdebt.com	0	Vicki	Fatjoe	f	\N	45	£	Tacklingourdebt.com
351	1	0	historical	0	34	f	mycarheaven.com	Info@mycarheaven.com	0	Chris	Fatjoe	f	\N	150	£	Www.mycarheaven.com
353	1	0	historical	0	19	f	lingermagazine.com	info@lingermagazine.com	0	Tiffany Tate	Fatjoe	f	\N	82	£	https://www.lingermagazine.com/
456	1	0	historical	0	52	f	urbanmatter.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	110	£	urbanmatter.com
357	1	0	historical	0	55	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	0	Becky Freeman	Fatjoe	f	\N	35	£	www.spiritedpuddlejumper.com
358	1	0	historical	0	30	f	thisbrilliantday.com	thisbrilliantday@gmail.com	0	Sophie Harriet	Fatjoe	f	\N	50	£	https://thisbrilliantday.com/
321	1	0	historical	0	23	t	peggymay.co.uk	Peggymayyarns@gmail.com	0	Peggy	Fatjoe	f	chris.p@frontpageadvantage.com	20	£	peggymay.co.uk
325	1	0	historical	0	33	t	thriftychap.com	joeseager@gmail.com	0	Joe Seager	Fatjoe	f	chris.p@frontpageadvantage.com	245	£	thriftychap.com
359	1	0	historical	0	26	f	beccafarrelly.co.uk	hello@beccafarrelly.co.uk	0	Becca	Fatjoe	f	\N	100	£	beccafarrelly.co.uk
360	1	0	historical	0	45	f	rachelbustin.com	rachel@rachelbustin.com	0	Rachel Bustin	Fatjoe	f	\N	85	£	https://rachelbustin.com
361	1	0	historical	0	57	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	0	Erica Hughes	Fatjoe	f	\N	125	£	https://alittleluxuryfor.me/
362	1	0	historical	0	37	f	hausmanmarketingletter.com	angie@hausmanmarketingletter	0	Angela Hausman	Fatjoe	f	\N	50	£	https://hausmanmarketingletter.com
363	1	0	historical	0	60	f	justwebworld.com	imjustwebworld@gmail.com	0	Harshil	Fatjoe	f	\N	99	£	https://justwebworld.com/
365	1	0	historical	0	43	f	letstalkmommy.com	jenny@letstalkmommy.com	0	Jenny	Fatjoe	f	\N	100	£	https://www.Letstalkmommy.com
366	1	0	historical	0	46	f	barbaraiweins.com	info@barbaraiweins.com	0	Jason	Inbound email	f	\N	37	£	Barbaraiweins.com
367	1	0	historical	0	23	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	0	Amy Walsh	Inbound email	f	\N	40	£	cocktailsinteacups.com
368	1	0	historical	0	55	f	justeilidh.com	just.eilidhg@gmail.com	0	Eilidh	Inbound email	f	\N	100	£	www.justeilidh.com
369	1	0	historical	0	43	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	0	Mellissa Williams	Inbound email	f	\N	60	£	https://www.thediaryofajewellerylover.co.uk/
370	1	0	historical	0	20	f	retro-vixen.com	hello@retro-vixen.com	0	Clare McDougall	Inbound email	f	\N	100	£	https://retro-vixen.com
372	1	0	historical	0	45	f	fashion-mommy.com	fashionmommywm@gmail.com	0	emma iannarilli	Inbound email	f	\N	85	£	fashion-mommy.com
373	1	0	historical	0	32	f	kateonthinice.com	kateonthinice1@gmail.com	0	Kate Holmes	Inbound email	f	\N	75	£	kateonthinice.com
374	1	0	historical	0	66	f	simslife.co.uk	sim@simslife.co.uk	0	Sim Riches	Fatjoe	f	\N	90	£	https://simslife.co.uk
375	1	0	historical	0	23	f	clairemac.co.uk	clairemacblog@gmail.com	0	Claire Chircop	Inbound email	f	\N	60	£	www.clairemac.co.uk
376	1	0	historical	0	21	f	wood-create.com	ben@wood-create.com	0	Ben	Inbound email	f	\N	180	£	https://www.wood-create.com
377	1	0	historical	0	32	f	travelvixta.com	victoria@travelvixta.com	0	Victoria	Inbound email	f	\N	170	£	https://www.travelvixta.com
378	1	0	historical	0	24	f	healthyvix.com	victoria@healthyvix.com	0	Victoria	Inbound email	f	\N	170	£	https://www.healthyvix.com
379	1	0	historical	0	26	f	yeahlifestyle.com	info@yeahlifestyle.com	0	Asha Carlos	Inbound email	f	\N	120	£	https://www.yeahlifestyle.com
380	1	0	historical	0	37	f	captainbobcat.com	Eva@captainbobcat.com	0	Eva Katona	Inbound email	f	\N	180	£	Https://www.captainbobcat.com
381	1	0	historical	0	40	f	therarewelshbit.com	kacie@therarewelshbit.com	0	Kacie Morgan	Inbound email	f	\N	200	£	www.therarewelshbit.com
382	1	0	historical	0	31	f	stressedmum.co.uk	sam@stressedmum.co.uk	0	Samantha Donnelly	Inbound email	f	\N	80	£	https://stressedmum.co.uk
383	1	0	historical	0	45	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	0	Fran	Inbound email	f	\N	75	£	www.whingewhingewine.co.uk
1307	6871	0	james.p@frontpageadvantage.com	1727789991606	0	f	\N	\N	1727789991606	Click Intelligence	\N	t	\N	0	\N	\N
385	1	0	historical	0	46	f	motherhoodtherealdeal.com	motherhoodtherealdeal@gmail.com	0	Taiya	Inbound email	f	\N	85	£	Https://www.motherhoodtherealdeal.com
386	1	0	historical	0	54	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	0	Anna marikar	Inbound email	f	\N	150	£	Intheplayroom.co.uk
387	1	0	historical	0	36	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	0	Anna marikar	Inbound email	f	\N	150	£	Onyourjourney.co.uk
388	1	0	historical	0	23	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	0	vicky Hall-Newman	Inbound email	f	\N	75	£	www.misstillyandme.co.uk
389	1	0	historical	0	40	f	arthurwears.com	Arthurwears.email@gmail.com	0	Sarah	Inbound email	f	\N	250	£	Https://www.arthurwears.com
390	1	0	historical	0	33	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	0	Steph Moore	Inbound email	f	\N	115	£	https://blog.bay-bee.co.uk/
391	1	0	historical	0	49	f	conversanttraveller.com	heather@conversanttraveller.com	0	Heather	Inbound email	f	\N	180	£	www.conversanttraveller.com
392	1	0	historical	0	27	f	midlandstraveller.com	contact@midlandstraveller.com	0	Simone Ribeiro	Inbound email	f	\N	50	£	www.midlandstraveller.com
394	1	0	historical	0	36	f	skinnedcartree.com	corinne@skinnedcartree.com	0	Corinne	Inbound email	f	\N	75	£	https://skinnedcartree.com
395	1	0	historical	0	40	f	missmanypennies.com	hello@missmanypennies.com	0	Hayley	Inbound email	f	\N	85	£	www.missmanypennies.com
397	1	0	historical	0	62	f	emmaplusthree.com	emmaplusthree@gmail.com	0	Emma Easton	Inbound email	f	\N	100	£	www.emmaplusthree.com
398	1	0	historical	0	26	f	mytunbridgewells.com	mytunbridgewells@gmail.com	0	Clare Lush-Mansell	Inbound email	f	\N	124	£	https://www.mytunbridgewells.com/
399	1	0	historical	0	32	f	suburban-mum.com	hello@suburban-mum.com	0	Maria	Inbound email	f	\N	100	£	www.suburban-mum.com
400	1	0	historical	0	31	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	0	Christopher	Inbound email	f	\N	79	£	https://estateagentnetworking.co.uk/
401	1	0	historical	0	32	f	marketme.co.uk	christopher@marketme.co.uk	0	Christopher	Inbound email	f	\N	59	£	https://marketme.co.uk/
402	1	0	historical	0	63	f	mammaprada.com	mammaprada@gmail.com	0	Kristie Prada	Inbound email	f	\N	90	£	https://www.mammaprada.com
406	1	0	historical	0	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	0	Ruth Davies Knowles	Inbound email	f	\N	116	£	Https://rocknrollerbaby.co.uk
408	1	0	historical	0	21	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	0	Michelle O’Connor	Inbound email	f	\N	75	£	Https://www.the-willowtree.com
409	1	0	historical	0	31	f	wannabeprincess.co.uk	Debzjs@hotmail.com	0	Debz	Facebook	f	\N	75	£	www.wannabeprincess.co.uk
410	1	0	historical	0	20	f	realgirlswobble.com	rohmankatrina@gmail.com	0	Katrina Rohman	Facebook	f	\N	50	£	https://realgirlswobble.com/
411	1	0	historical	0	19	f	bouquetandbells.com	sarah@dreamofhome.co.uk	0	Sarah Macklin	Facebook	f	\N	60	£	https://bouquetandbells.com/
412	1	0	historical	0	40	f	laurakatelucas.com	laurakatelucas@hotmail.com	0	Laura Lucas	Facebook	f	\N	100	£	www.laurakatelucas.com
413	1	0	historical	0	23	f	lablogbeaute.co.uk	hello@lablogbeaute.do.uk	0	Beth Mahoney	Facebook	f	\N	100	£	https://lablogbeaute.co.uk/
414	1	0	historical	0	24	f	joannavictoria.co.uk	joannabayford@gmail.com	0	Joanna Bayford	Facebook	f	\N	50	£	https://www.joannavictoria.co.uk
415	1	0	historical	0	29	f	aaublog.com	rebecca@aaublog.com	0	Rebecca Urie	Facebook	f	\N	35	£	https://www.AAUBlog.com
416	1	0	historical	0	34	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	0	Micaela	Facebook	f	\N	75	£	https://www.stylishlondonliving.co.uk/
417	1	0	historical	0	49	f	globalmousetravels.com	hello@globalmousetravels.com	0	Nichola West	Facebook	f	\N	250	£	https://globalmousetravels.com
418	1	0	historical	0	44	f	amumreviews.co.uk	contact@amumreviews.co.uk	0	Petra	Facebook	f	\N	100	£	https://amumreviews.co.uk/
419	1	0	historical	0	32	f	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	0	Ana	Facebook	f	\N	100	£	https://fadedspring.co.uk/
420	1	0	historical	0	40	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	0	Anna	Facebook	f	\N	150	£	https://www.dontcrampmystyle.co.uk
421	1	0	historical	0	46	f	glassofbubbly.com	christopher@marketme.co.uk	0	Christopher	Inbound email	f	\N	125	£	https://glassofbubbly.com/
423	1	0	historical	0	39	f	mymoneycottage.com	hello@mymoneycottage.com	0	Clare McDougall	Facebook	f	\N	100	£	https://mymoneycottage.com
425	1	0	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	0	Jess Howliston	Facebook	f	\N	75	£	www.tantrumstosmiles.co.uk
426	1	0	historical	0	40	f	chelseamamma.co.uk	Chelseamamma@gmail.com	0	Kara Guppy	Facebook	f	\N	75	£	https://www.chelseamamma.co.uk/
427	1	0	historical	0	17	f	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	0	Shallie	Facebook	f	\N	75	£	Shalliespurplebeehive.com
428	1	0	historical	0	55	f	modernguy.co.uk	modguyinfo@gmail.com	0	Modern Guy	Facebook	f	\N	103	£	Modernguy.co.uk
429	1	0	historical	0	29	f	countryheartandhome.com	Debbie@countryheartandhome.com	0	Deborah Nicholas	Facebook	f	\N	75	£	https://countryheartandhome.com/
430	1	0	historical	0	26	f	bizzimummy.com	Bizzimummy@gmail.com	0	Eva Stretton	Facebook	f	\N	55	£	https://bizzimummy.com
431	1	0	historical	0	52	f	lthornberry.co.uk	lauraa_x@hotmail.co.uk	0	Laura	Facebook	f	\N	55	£	www.lthornberry.co.uk
432	1	0	historical	0	38	f	lyliarose.com	victoria@lyliarose.com	0	Victoria	Facebook	f	\N	170	£	https://www.lyliarose.com
433	1	0	historical	0	38	f	bq-magazine.com	hello@contentmother.com	0	Lucy Clarke	Facebook	f	\N	80	£	https://www.bq-magazine.com
434	1	0	historical	0	25	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	0	Kara Guppy	Facebook	f	\N	75	£	https://arewenearlythereyet.co.uk/
435	1	0	historical	0	46	f	psychtimes.com	info@psychtimes.com	0	THomas Hlubin	Inbound email	f	\N	45	£	https://psychtimes.com/
436	1	0	historical	0	60	f	scoopearth.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	20	£	https://www.scoopearth.com/
438	1	0	historical	0	76	f	merchantcircle.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	25	£	merchantcircle.com
440	1	0	historical	0	63	f	ventsmagazine.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	50	£	ventsmagazine.com
441	1	0	historical	0	67	f	original.newsbreak.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	55	£	original.newsbreak.com
442	1	0	historical	0	47	f	wheon.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	70	£	wheon.com
443	1	0	historical	0	60	f	fooyoh.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	fooyoh.com
444	1	0	historical	0	54	f	tastefulspace.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	tastefulspace.com
445	1	0	historical	0	58	f	networkustad.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	networkustad.com
446	1	0	historical	0	63	f	filmdaily.co	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	filmdaily.co
448	1	0	historical	0	50	f	gisuser.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	Gisuser.com
449	1	0	historical	0	44	f	urbansplatter.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	85	£	https://www.urbansplatter.com/
450	1	0	historical	0	55	f	zomgcandy.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	90	£	zomgcandy.com
451	1	0	historical	0	69	f	marketbusinessnews.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	100	£	marketbusinessnews.com
452	1	0	historical	0	67	f	bignewsnetwork.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	100	£	bignewsnetwork.com
453	1	0	historical	0	64	f	techbullion.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	100	£	http://techbullion.com
454	1	0	historical	0	61	f	whatsnew2day.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	100	£	whatsnew2day.com
460	1	0	historical	0	32	f	techacrobat.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	140	£	techacrobat.com
461	1	0	historical	0	32	f	deskrush.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	160	£	deskrush.com
462	1	0	historical	0	64	f	azbigmedia.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	170	£	azbigmedia.com
463	1	0	historical	0	40	f	vizaca.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	190	£	vizaca.com
464	1	0	historical	0	51	f	startup.info	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	200	£	startup.info
424	1	0	historical	0	60	t	tipsofbusiness.com	joeseager@gmail.com	0	Joe Seager	Facebook	f	chris.p@frontpageadvantage.com	145	£	tipsofbusiness.com
465	1	0	historical	0	82	f	goodmenproject.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	220	£	http://goodmenproject.com
466	1	0	historical	0	71	f	swaay.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	220	£	swaay.com
468	1	0	historical	0	92	f	apnews.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	240	£	apnews.com
469	1	0	historical	0	45	f	retailtechinnovationhub.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	280	£	retailtechinnovationhub.com
470	1	0	historical	0	21	f	realwedding.co.uk	hello@contentmother.com	0	Becky	inbound email	f	\N	80	£	https://www.realwedding.co.uk
471	1	0	historical	0	20	f	realparent.co.uk	hello@contentmother.com	0	Becky	inbound email	f	\N	60	£	https://www.realparent.co.uk
472	1	0	historical	0	30	f	pleasureprinciple.net	hello@contentmother.com	0	Becky	inbound email	f	\N	50	£	https://www.pleasureprinciple.net
473	1	0	historical	0	36	f	earthlytaste.com	hello@contentmother.com	0	Becky	inbound email	f	\N	50	£	https://www.earthlytaste.com
474	1	0	historical	0	17	f	lclarke.co.uk	hello@contentmother.com	0	Becky	inbound email	f	\N	50	£	https://lclarke.co.uk
475	1	0	historical	0	17	f	quick-house-sales.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	https://www.quick-house-sales.com
477	1	0	historical	0	17	f	rocketandrelish.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	https://www.rocketandrelish.com
478	1	0	historical	0	17	f	affectionatelypaws.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	http://affectionatelypaws.com
479	1	0	historical	0	17	f	poppyandblush.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	http://poppyandblush.com
480	1	0	historical	0	26	f	the-pudding.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	http://www.the-pudding.com
481	1	0	historical	0	29	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	0	Emily	another blogger	f	\N	75	£	https://www.twinmummyanddaddy.com/
482	1	0	historical	0	55	f	entrepreneursbreak.com	minalkh124@gmail.com	0	Maryam bibi	inbound email	f	\N	80	£	https://entrepreneursbreak.com/
483	1	0	historical	0	34	f	packthepjs.com	tracey@packthepjs.com	0	Tracey	Fatjoe	f	\N	60	£	http://www.packthepjs.com/
484	1	0	historical	0	89	f	ibtimes.co.uk	i.perez@ibtmedia.co.uk	0	Inigo	inbound email	f	\N	379	£	ibtimes.co.uk
485	1	0	historical	0	59	f	gudstory.com	sophiadaniel.co.uk@gmail.com	0	Sophia	Inbound Sam	f	\N	170	£	www.gudstory.com
488	1	0	historical	0	59	f	computertechreviews.com	sophiadaniel.co.uk@gmail.com	0	Sophia	Inbound Sam	f	\N	150	£	computertechreviews.com
489	1	0	historical	0	67	f	abcmoney.co.uk	sophiadaniel.co.uk@gmail.com	0	Sophia	Inbound Sam	f	\N	170	£	www.abcmoney.co.uk
490	1	0	historical	0	56	f	theedinburghreporter.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	theedinburghreporter.co.uk
491	1	0	historical	0	52	f	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.theexeterdaily.co.uk
492	1	0	historical	0	28	f	thedevondaily.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.thedevondaily.co.uk
493	1	0	historical	0	42	f	greenunion.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.greenunion.co.uk
494	1	0	historical	0	52	f	mikemyers.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	mikemyers.co.uk
495	1	0	historical	0	59	f	welshmum.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.welshmum.co.uk
496	1	0	historical	0	28	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	144	£	enjoytheadventure.co.uk
498	1	0	historical	0	18	f	gonetravelling.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	84	£	gonetravelling.co.uk
499	1	0	historical	0	52	f	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	144	£	www.lifestyledaily.co.uk
500	1	0	historical	0	28	f	pat.org.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.pat.org.uk
501	1	0	historical	0	57	f	fashioncapital.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	132	£	www.fashioncapital.co.uk
502	1	0	historical	0	36	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	108	£	explorersagainstextinction.co.uk
503	1	0	historical	0	46	f	newsfromwales.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	144	£	newsfromwales.co.uk
504	1	0	historical	0	32	f	westlondonliving.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	84	£	www.westlondonliving.co.uk
505	1	0	historical	0	26	f	talk-retail.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	talk-retail.co.uk
506	1	0	historical	0	32	f	eagle.co.ug	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	114	£	eagle.co.ug
507	1	0	historical	0	27	f	toddleabout.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	toddleabout.co.uk
509	1	0	historical	0	34	f	glasgowarchitecture.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	114	£	www.glasgowarchitecture.co.uk
510	1	0	historical	0	69	f	powderrooms.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	powderrooms.co.uk
487	1	0	historical	0	80	t	thefrisky.com	sophiadaniel.co.uk@gmail.com	0	Sophia	Inbound Sam	f	chris.p@frontpageadvantage.com	170	£	thefrisky.com
512	1	0	historical	0	74	f	calculator.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	132	£	www.calculator.co.uk
513	1	0	historical	0	26	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.thefoodaholic.co.uk
514	1	0	historical	0	27	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.tobecomemum.co.uk
515	1	0	historical	0	32	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.travel-bugs.co.uk
516	1	0	historical	0	39	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.thegardeningwebsite.co.uk
518	1	0	historical	0	23	f	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.ukcaravanrental.co.uk
519	1	0	historical	0	27	f	cyclingscot.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	www.cyclingscot.co.uk
520	1	0	historical	0	21	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	30	£	www.davidsavage.co.uk
521	1	0	historical	0	22	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	96	£	izzydabbles.co.uk
522	1	0	historical	0	19	f	altcoininvestor.com	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	96	£	altcoininvestor.com
523	1	0	historical	0	25	f	daytradetheworld.com	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	www.daytradetheworld.com
524	1	0	historical	0	54	f	travelbeginsat40.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	100	£	www.travelbeginsat40.com
525	1	0	historical	0	32	f	traveldailynews.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	150	£	www.traveldailynews.com
526	1	0	historical	0	36	f	puretravel.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	160	£	www.puretravel.com
527	1	0	historical	0	61	f	ourculturemag.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	120	£	ourculturemag.com
528	1	0	historical	0	49	f	cubeduel.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	120	£	cubeduel.com
529	1	0	historical	0	52	f	houseofcoco.net	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	150	£	houseofcoco.net
531	1	0	historical	0	35	f	businessmanchester.co.uk	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	130	£	www.businessmanchester.co.uk
532	1	0	historical	0	53	f	varsity.co.uk	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	150	£	www.varsity.co.uk
533	1	0	historical	0	35	f	craigmurray.co.uk	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	165	£	craigmurray.co.uk
534	1	0	historical	0	65	f	saddind.co.uk	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	175	£	saddind.co.uk
535	1	0	historical	0	46	f	ukbusinessforums.co.uk	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	170	£	ukbusinessforums.co.uk
536	1	0	historical	0	57	f	hildenbrewing.com	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	170	£	hildenbrewing.com
537	1	0	historical	0	40	f	technoloss.com	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	155	£	technoloss.com
538	1	0	historical	0	55	f	4howtodo.com	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	170	£	4howtodo.com
540	1	0	historical	0	40	f	otsnews.co.uk	falcobliek@gmail.com	0	Falco	Inbound Sam	f	\N	150	£	www.otsnews.co.uk
303	1	0	historical	0	24	t	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	0	Paul	Inbound email	f	chris.p@frontpageadvantage.com	20	£	www.moneytipsblog.co.uk
319	1	0	historical	0	33	f	morningbusinesschat.com	info@morningbusinesschat.com	0	Brett	Fatjoe	f	\N	83	£	morningbusinesschat.com
332	1	0	historical	0	30	f	autumnsmummyblog.com	laura@autumnsmummyblog.com	0	Laura Chesmer	Fatjoe	f	\N	75	£	https://www.autumnsmummyblog.com
352	1	0	historical	0	22	f	beautiful-solutions.co.uk	staceykane@outlook.com	0	Stacey	Fatjoe	f	\N	40	£	https://www.beautiful-solutions.co.uk
354	1	0	historical	0	43	f	businesspartnermagazine.com	info@businesspartnermagazine.com	0	Sandra Hinshelwood	Fatjoe	f	\N	19	£	https://businesspartnermagazine.com/
371	1	0	historical	0	27	f	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	0	Jennie Jordan	Inbound email	f	\N	80	£	www.ricecakesandraisins.co.uk
384	1	0	historical	0	46	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	0	Jeni	Inbound email	f	\N	150	£	Https://chillingwithlucas.com
393	1	0	historical	0	58	f	reallymissingsleep.com	kareneholloway@hotmail.com	0	Karen Langridge	Inbound email	f	\N	150	£	https://www.reallymissingsleep.com/
403	1	0	historical	0	54	f	sparklesandstretchmarks.com	Hayley@sparklesandstretchmarks.com	0	Hayley Mclean	Inbound email	f	\N	100	£	Https://www.sparklesandstretchmarks.com
404	1	0	historical	0	22	f	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	0	Elizabeth Williams	Inbound email	f	\N	80	£	www.whererootsandwingsentwine.com
407	1	0	historical	0	22	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	0	Rachael Sheehan	Inbound email	f	\N	50	£	https://lukeosaurusandme.co.uk
422	1	0	historical	0	28	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	0	Tom	Google Search	f	\N	75	£	https://ukconstructionblog.co.uk/
437	1	0	historical	0	53	f	techbehindit.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	55	£	techbehindit.com
447	1	0	historical	0	68	f	atlnightspots.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	80	£	atlnightspots.com
455	1	0	historical	0	56	f	programminginsider.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	100	£	programminginsider.com
457	1	0	historical	0	57	f	techktimes.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	110	£	http://techktimes.com/
458	1	0	historical	0	56	f	spacecoastdaily.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	120	£	https://spacecoastdaily.com/
467	1	0	historical	0	60	f	underconstructionpage.com	minalkh124@gmail.com	0	Maryam bibi	Inbound email	f	\N	230	£	http://underconstructionpage.com
476	1	0	historical	0	10	f	contentmother.com	hello@contentmother.com	0	Becky	inbound email	f	\N	45	£	https://www.contentmother.com
486	1	0	historical	0	88	f	digitaljournal.com	sophiadaniel.co.uk@gmail.com	0	Sophia	Inbound Sam	f	\N	150	£	www.digitaljournal.com
497	1	0	historical	0	33	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	168	£	anythinggoeslifestyle.co.uk
508	1	0	historical	0	43	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	120	£	healthylifeessex.co.uk
511	1	0	historical	0	36	f	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	132	£	www.edinburgharchitecture.co.uk
517	1	0	historical	0	28	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	0	Fazal	Inbound Sam	f	\N	156	£	www.interestingfacts.org.uk
530	1	0	historical	0	32	f	tech-wonders.com	backlinsprovider@gmail.com	0	David	Inbound Sam	f	\N	100	£	www.tech-wonders.com
539	1	0	historical	0	67	f	tamilworlds.com	natalilacanario@gmail.com	0	Natalila	Inbound Sam	f	\N	150	£	Tamilworlds.com
541	1	0	historical	0	23	f	simplymotor.co.uk	n/a	0	Fatjoe	\N	t	\N	60	£	www.simplymotor.co.uk
542	1	0	historical	0	21	f	alfiebsmith.com	n/a	0	Micaela	\N	t	\N	75	£	www.alfiebsmith.com
322	1	0	historical	0	27	f	5thingstodotoday.com	5thingstodotoday@gmail.com	0	David	Fatjoe	f	chris.p@frontpageadvantage.com	45	£	5thingstodotoday.com
602	1	0	historical	0	0	f	\N	\N	0	FatJoe	\N	t	\N	0	£	\N
543	1	0	historical	0	28	f	magicalpenny.com	n/a	0	Fatjoe	\N	t	\N	80	£	magicalpenny.com
544	1	0	historical	0	26	f	definecivil.com	n/a	0	Fatjoe	\N	t	\N	60	£	definecivil.com
545	1	0	historical	0	20	f	vikingwanderer.com	n/a	0	Fatjoe	\N	t	\N	60	£	vikingwanderer.com
546	1	0	historical	0	32	f	muncievoice.com	n/a	0	Fatjoe	\N	t	\N	90	£	muncievoice.com
547	1	0	historical	0	39	f	ecommercefastlane.com	n/a	0	fatjoe	\N	t	\N	90	£	ecommercefastlane.com
548	1	0	historical	0	36	f	beurownlight.com	n/a	0	Fatjoe	\N	t	\N	100	£	beurownlight.com
549	1	0	historical	0	27	f	adventuremummy.com	n/a	0	Fatjoe	\N	t	\N	60	£	adventuremummy.com
550	1	0	historical	0	28	f	jennifergilmour.com	n/a	0	Fatjoe	\N	t	\N	80	£	jennifergilmour.com
551	1	0	historical	0	26	f	bekylou.com	n/a	0	Fatjoe	\N	t	\N	80	£	www.bekylou.com
552	1	0	historical	0	35	f	dorkface.co.uk	n/a	0	Micaela	\N	t	\N	100	£	www.dorkface.co.uk
553	1	0	historical	0	22	f	prettykittenlife.com	n/a	0	Micaela	\N	t	\N	100	£	prettykittenlife.com
554	1	0	historical	0	25	f	isalillo.com	n/a	0	Fatjoe	\N	t	\N	80	£	www.isalillo.com
555	1	0	historical	0	36	f	homewithaneta.com	n/a	0	fatjoe	\N	t	\N	90	£	homewithaneta.com
556	1	0	historical	0	31	f	previousmagazine.com	n/a	0	Fatjoe	\N	t	\N	100	£	www.previousmagazine.com
557	1	0	historical	0	31	f	pinaynomad.com	n/a	0	fatjoe	\N	t	\N	90	£	pinaynomad.com
558	1	0	historical	0	24	f	freebirdsmagazine.com	n/a	0	Fatjoe	\N	t	\N	60	£	freebirdsmagazine.com
559	1	0	historical	0	58	f	thenewsgod.com	n/a	0	Click Intelligence	\N	t	\N	1	£	thenewsgod.com
560	1	0	historical	0	21	f	ginakaydaniel.com	n/a	0	Fatjoe	\N	t	\N	60	£	www.ginakaydaniel.com
561	1	0	historical	0	28	f	britishstylesociety.uk	n/a	0	Fatjoe	\N	t	\N	80	£	britishstylesociety.uk
562	1	0	historical	0	21	f	geekedcartree.co.uk	n/a	0	Micaela	\N	t	\N	50	£	geekedcartree.co.uk
563	1	0	historical	0	28	f	hopezvara.com	n/a	0	Fatjoe	\N	t	\N	80	£	hopezvara.com
564	1	0	historical	0	30	f	bamni.co.uk	n/a	0	Fatjoe	\N	t	\N	100	£	bamni.co.uk
565	1	0	historical	0	15	f	unconventionalkira.co.uk	n/a	0	Micaela	\N	t	\N	50	£	www.unconventionalkira.co.uk
566	1	0	historical	0	27	f	theglossymagazine.com	n/a	0	Fatjoe	\N	t	\N	80	£	theglossymagazine.com
567	1	0	historical	0	25	f	nishiv.com	n/a	0	Micaela	\N	t	\N	100	£	www.nishiv.com
568	1	0	historical	0	39	f	thoushaltnotcovet.net	n/a	0	Fatjoe	\N	t	\N	100	£	thoushaltnotcovet.net
569	1	0	historical	0	21	f	mumsthewurd.com	n/a	0	Micaela	\N	t	\N	100	£	www.mumsthewurd.com
570	1	0	historical	0	36	f	new-lune.com	n/a	0	Fatjoe	\N	t	\N	100	£	new-lune.com
571	1	0	historical	0	29	f	thegadgetman.org.uk	n/a	0	Fatjoe	\N	t	\N	80	£	www.thegadgetman.org.uk
572	1	0	historical	0	29	f	passportjoy.com	n/a	0	Fatjoe	\N	t	\N	80	£	passportjoy.com
573	1	0	historical	0	26	f	talkingaboutmygeneration.co.uk	n/a	0	Fatjoe	\N	t	\N	80	£	talkingaboutmygeneration.co.uk
574	1	0	historical	0	17	f	newenglandb2bnetworking.com	n/a	0	Fatjoe	\N	t	\N	80	£	newenglandb2bnetworking.com
575	1	0	historical	0	24	f	money-mentor.org	n/a	0	Fatjoe	\N	t	\N	78	£	www.money-mentor.org
576	1	0	historical	0	21	f	curlyandcandid.co.uk	n/a	0	Fatjoe	\N	t	\N	80	£	www.curlyandcandid.co.uk
577	1	0	historical	0	23	f	krismunro.co.uk	n/a	0	Fatjoe	\N	t	\N	60	£	krismunro.co.uk
578	1	0	historical	0	34	f	shemightbe.co.uk	n/a	0	Micaela	\N	t	\N	100	£	shemightbe.co.uk
579	1	0	historical	0	27	f	thelifeofadventure.com	n/a	0	Micaela	\N	t	\N	100	£	thelifeofadventure.com
580	1	0	historical	0	20	f	websigmas.com	n/a	0	Fatjoe	\N	t	\N	80	£	www.websigmas.com
581	1	0	historical	0	28	f	mimiroseandme.com	n/a	0	Fatjoe	\N	t	\N	80	£	www.mimiroseandme.com
582	1	0	historical	0	38	f	kerrylouisenorris.com	n/a	0	Fatjoe	\N	t	\N	100	£	www.kerrylouisenorris.com
583	1	0	historical	0	20	f	digital-dreamer.net	n/a	0	Fatjoe	\N	t	\N	80	£	digital-dreamer.net
584	1	0	historical	0	29	f	beingtillysmummy.co.uk	n/a	0	Micaela	\N	t	\N	50	£	www.beingtillysmummy.co.uk
585	1	0	historical	0	29	f	britonabudget.co.uk	n/a	0	Fatjoe	\N	t	\N	80	£	britonabudget.co.uk
586	1	0	historical	0	19	f	pradaplanet.com	n/a	0	Micaela	\N	t	\N	30	£	www.pradaplanet.com
587	1	0	historical	0	33	f	fromcorporatetocareerfreedom.com	n/a	0	Fatjoe	\N	t	\N	100	£	www.fromcorporatetocareerfreedom.com
588	1	0	historical	0	36	f	lattelindsay.com	n/a	0	Fatjoe	\N	t	\N	100	£	lattelindsay.com
589	1	0	historical	0	31	f	singledadsguidetolife.com	n/a	0	Micaela	\N	t	\N	75	£	singledadsguidetolife.com
315	1	0	historical	0	28	t	allthebeautifulthings.co.uk	helsy.gandy@gmail.com	0	Helsy	Fatjoe	f	chris.p@frontpageadvantage.com	0	£	www.allthebeautifulthings.co.uk
396	1	0	historical	0	55	t	leedaily.com	dakotachirnside@aol.com	0	Dakota	Inbound email	f	chris.p@frontpageadvantage.com	0	£	https://leedaily.com/
603	1	0	historical	0	24	f	theislandjournal.com	\N	0	FatJoe	\N	t	chris.p@frontpageadvantage.com	80	£	https://theislandjournal.com
323	2	1	historical	0	33	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1707945293698	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
439	3	1	historical	0	66	f	timebusinessnews.com	minalkh124@gmail.com	1707945298560	Maryam bibi	Inbound email	f	system	25	£	timebusinessnews.com
355	4	1	historical	0	34	f	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	1707945307802	Rebecca	Fatjoe	f	system	100	£	www.ialwaysbelievedinfutures.com
356	5	1	historical	0	45	f	sorry-about-the-mess.co.uk	chloebridge@gmail.com	1707945312587	Chloe Bridge	Fatjoe	f	system	60	£	https://sorry-about-the-mess.co.uk
333	6	1	historical	0	16	f	learndeveloplive.com	chris@learndeveloplive.com	1707945317578	Chris Jaggs	Fatjoe	f	system	25	£	www.learndeveloplive.com
306	11	1	historical	0	17	f	testingtimeblog.com	sam@testingtimeblog.com	1707945360408	Sam	Fatjoe	f	system	75	£	www.testingtimeblog.com
314	17	1	historical	0	21	f	thejournalix.com	thejournalix@gmail.com	1707945451678	Joni	Fatjoe	f	system	15	£	thejournalix.com
324	18	1	historical	0	12	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1707945456278	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
340	27	1	historical	0	44	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1707945509651	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
341	28	1	historical	0	15	f	sashashantel.com	contactsashashantel@gmail.com	1707945513904	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
456	40	1	historical	0	55	f	urbanmatter.com	minalkh124@gmail.com	1707945624108	Maryam bibi	Inbound email	f	system	110	£	urbanmatter.com
378	48	1	historical	0	27	f	healthyvix.com	victoria@healthyvix.com	1707945743166	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
459	7	1	historical	0	55	f	digitalengineland.com	minalkh124@gmail.com	1707945341007	Maryam bibi	Inbound email	f	system	120	£	digitalengineland.com
302	8	1	historical	0	8	f	poocrazy.com	paul@moneytipsblog.co.uk	1707945345665	Paul	Inbound email	f	system	10	£	www.poocrazy.com
304	9	1	historical	0	34	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1707945350259	UKNEWS Group	Inbound email	f	system	50	£	https://www.uknewsgroup.co.uk/
305	10	1	historical	0	17	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1707945355826	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
307	12	1	historical	0	12	f	peterwynmosey.com	contact@peterwynmosey.com	1707945364844	Peter	Fatjoe	f	system	15	£	peterwynmosey.com
309	13	1	historical	0	11	f	annabelwrites.com	annabelwrites.blog@gmail.com	1707945374969	Annabel	Fatjoe	f	system	20	£	annabelwrites.com
316	14	1	historical	0	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1707945384659	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
317	15	1	historical	0	27	f	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	1707945389057	Jen	Fatjoe	f	system	30	£	www.jenloumeredith.com
311	16	1	historical	0	16	f	alifeoflovely.com	alifeoflovely@gmail.com	1707945438663	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
326	19	1	historical	0	21	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1707945460546	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
327	20	1	historical	0	27	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1707945464721	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
328	21	1	historical	0	30	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1707945468936	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
329	22	1	historical	0	46	f	wemadethislife.com	wemadethislife@outlook.com	1707945473005	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
334	23	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1707945485611	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
336	24	1	historical	0	41	f	midwifeandlife.com	Jenny@midwifeandlife.com	1707945493692	Jenny Lord	Fatjoe	f	system	70	£	midwifeandlife.com
338	25	1	historical	0	17	f	themammafairy.com	themammafairy@gmail.com	1707945501677	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
339	26	1	historical	0	26	f	keralpatel.com	keralpatel@gmail.com	1707945505579	Keral Patel	Fatjoe	f	system	35	£	https://www.keralpatel.com
342	29	1	historical	0	36	f	karlismyunkle.com	karlismyunkle@gmail.com	1707945517843	Nik Thakkar	Fatjoe	f	system	65	£	www.karlismyunkle.com
343	30	1	historical	0	54	f	workingdaddy.co.uk	tom@workingdaddy.co.uk	1707945521693	Thomaz	Fatjoe	f	system	60	£	https://workingdaddy.co.uk
345	31	1	historical	0	15	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1707945525686	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
346	32	1	historical	0	21	f	carouseldiary.com	Info@carouseldiary.com	1707945529766	Katrina	Fatjoe	f	system	40	£	Carouseldiary.com
318	33	1	historical	0	36	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1707945586556	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
320	34	1	historical	0	37	f	practicalfrugality.com	hello@practicalfrugality.com	1707945591134	Magdalena	Fatjoe	f	system	38	£	www.practicalfrugality.com
347	35	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1707945595519	Nigel higgins	Fatjoe	f	system	75	£	https://www.diydaddyblog.com/
348	36	1	historical	0	22	f	blossomeducation.co.uk	info@blossomeducation.co.uk	1707945599767	Vicki	Fatjoe	f	system	60	£	blossomeducation.co.uk
349	37	1	historical	0	22	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1707945605883	Vicki	Fatjoe	f	system	60	£	Icenimagazine.co.uk
351	38	1	historical	0	35	f	mycarheaven.com	Info@mycarheaven.com	1707945616216	Chris	Fatjoe	f	system	150	£	Www.mycarheaven.com
353	39	1	historical	0	18	f	lingermagazine.com	info@lingermagazine.com	1707945620252	Tiffany Tate	Fatjoe	f	system	82	£	https://www.lingermagazine.com/
362	41	1	historical	0	39	f	hausmanmarketingletter.com	angie@hausmanmarketingletter	1707945639639	Angela Hausman	Fatjoe	f	system	50	£	https://hausmanmarketingletter.com
363	42	1	historical	0	61	f	justwebworld.com	imjustwebworld@gmail.com	1707945643754	Harshil	Fatjoe	f	system	99	£	https://justwebworld.com/
369	43	1	historical	0	35	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1707945663542	Mellissa Williams	Inbound email	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/
370	44	1	historical	0	19	f	retro-vixen.com	hello@retro-vixen.com	1707945667535	Clare McDougall	Inbound email	f	system	100	£	https://retro-vixen.com
373	45	1	historical	0	34	f	kateonthinice.com	kateonthinice1@gmail.com	1707945675538	Kate Holmes	Inbound email	f	system	75	£	kateonthinice.com
375	46	1	historical	0	30	f	clairemac.co.uk	clairemacblog@gmail.com	1707945684018	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
376	47	1	historical	0	24	f	wood-create.com	ben@wood-create.com	1707945688134	Ben	Inbound email	f	system	180	£	https://www.wood-create.com
379	49	1	historical	0	34	f	yeahlifestyle.com	info@yeahlifestyle.com	1707945747591	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
380	50	1	historical	0	59	f	captainbobcat.com	Eva@captainbobcat.com	1707945751784	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
381	51	1	historical	0	43	f	therarewelshbit.com	kacie@therarewelshbit.com	1707945755867	Kacie Morgan	Inbound email	f	system	200	£	www.therarewelshbit.com
382	52	1	historical	0	30	f	stressedmum.co.uk	sam@stressedmum.co.uk	1707945760600	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
383	53	1	historical	0	43	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1707945765597	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
387	54	1	historical	0	37	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1707945778037	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
388	55	1	historical	0	22	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1707945782468	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
399	56	1	historical	0	33	f	suburban-mum.com	hello@suburban-mum.com	1707945790828	Maria	Inbound email	f	system	100	£	www.suburban-mum.com
400	57	1	historical	0	32	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	1707945794869	Christopher	Inbound email	f	system	79	£	https://estateagentnetworking.co.uk/
401	58	1	historical	0	30	f	marketme.co.uk	christopher@marketme.co.uk	1707945799173	Christopher	Inbound email	f	system	59	£	https://marketme.co.uk/
402	59	1	historical	0	62	f	mammaprada.com	mammaprada@gmail.com	1707945803316	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
408	60	1	historical	0	24	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1707945812248	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
409	61	1	historical	0	30	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1707945816306	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
410	62	1	historical	0	23	f	realgirlswobble.com	rohmankatrina@gmail.com	1707945820564	Katrina Rohman	Facebook	f	system	50	£	https://realgirlswobble.com/
411	63	1	historical	0	18	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1707945824798	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
413	64	1	historical	0	24	f	lablogbeaute.co.uk	hello@lablogbeaute.do.uk	1707945832627	Beth Mahoney	Facebook	f	system	100	£	https://lablogbeaute.co.uk/
414	65	1	historical	0	22	f	joannavictoria.co.uk	joannabayford@gmail.com	1707945836820	Joanna Bayford	Facebook	f	system	50	£	https://www.joannavictoria.co.uk
415	66	1	historical	0	30	f	aaublog.com	rebecca@aaublog.com	1707945840862	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
389	67	1	historical	0	38	f	arthurwears.com	Arthurwears.email@gmail.com	1707945891948	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
390	68	1	historical	0	37	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1707945895918	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
391	69	1	historical	0	48	f	conversanttraveller.com	heather@conversanttraveller.com	1707945899772	Heather	Inbound email	f	system	180	£	www.conversanttraveller.com
392	70	1	historical	0	26	f	midlandstraveller.com	contact@midlandstraveller.com	1707945903741	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
394	71	1	historical	0	37	f	skinnedcartree.com	corinne@skinnedcartree.com	1707945907769	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
395	72	1	historical	0	39	f	missmanypennies.com	hello@missmanypennies.com	1707945911777	Hayley	Inbound email	f	system	85	£	www.missmanypennies.com
397	73	1	historical	0	61	f	emmaplusthree.com	emmaplusthree@gmail.com	1707945916032	Emma Easton	Inbound email	f	system	100	£	www.emmaplusthree.com
416	74	1	historical	0	33	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1707945921019	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
417	75	1	historical	0	47	f	globalmousetravels.com	hello@globalmousetravels.com	1707945925134	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
419	76	1	historical	0	30	f	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	1707945933122	Ana	Facebook	f	system	100	£	https://fadedspring.co.uk/
420	77	1	historical	0	41	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1707945937000	Anna	Facebook	f	system	150	£	https://www.dontcrampmystyle.co.uk
421	78	1	historical	0	47	f	glassofbubbly.com	christopher@marketme.co.uk	1707945941121	Christopher	Inbound email	f	system	125	£	https://glassofbubbly.com/
423	79	1	historical	0	32	f	mymoneycottage.com	hello@mymoneycottage.com	1707945945215	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
425	80	1	historical	0	30	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1707945949206	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
426	81	1	historical	0	39	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1707945953254	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
431	82	1	historical	0	53	f	lthornberry.co.uk	lauraa_x@hotmail.co.uk	1707945972982	Laura	Facebook	f	system	55	£	www.lthornberry.co.uk
434	83	1	historical	0	26	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1707945984617	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
449	84	1	historical	0	50	f	urbansplatter.com	minalkh124@gmail.com	1707945992517	Maryam bibi	Inbound email	f	system	85	£	https://www.urbansplatter.com/
436	85	1	historical	0	65	f	scoopearth.com	minalkh124@gmail.com	1707946050944	Maryam bibi	Inbound email	f	system	20	£	https://www.scoopearth.com/
441	86	1	historical	0	72	f	original.newsbreak.com	minalkh124@gmail.com	1707946063187	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
442	87	1	historical	0	64	f	wheon.com	minalkh124@gmail.com	1707946066923	Maryam bibi	Inbound email	f	system	70	£	wheon.com
443	88	1	historical	0	82	f	fooyoh.com	minalkh124@gmail.com	1707946070835	Maryam bibi	Inbound email	f	system	80	£	fooyoh.com
444	89	1	historical	0	56	f	tastefulspace.com	minalkh124@gmail.com	1707946074913	Maryam bibi	Inbound email	f	system	80	£	tastefulspace.com
446	90	1	historical	0	64	f	filmdaily.co	minalkh124@gmail.com	1707946082562	Maryam bibi	Inbound email	f	system	80	£	filmdaily.co
461	91	1	historical	0	62	f	deskrush.com	minalkh124@gmail.com	1707946090813	Maryam bibi	Inbound email	f	system	160	£	deskrush.com
462	92	1	historical	0	65	f	azbigmedia.com	minalkh124@gmail.com	1707946094557	Maryam bibi	Inbound email	f	system	170	£	azbigmedia.com
463	93	1	historical	0	47	f	vizaca.com	minalkh124@gmail.com	1707946098923	Maryam bibi	Inbound email	f	system	190	£	vizaca.com
464	94	1	historical	0	54	f	startup.info	minalkh124@gmail.com	1707946102860	Maryam bibi	Inbound email	f	system	200	£	startup.info
466	95	1	historical	0	66	f	swaay.com	minalkh124@gmail.com	1707946112685	Maryam bibi	Inbound email	f	system	220	£	swaay.com
469	96	1	historical	0	46	f	retailtechinnovationhub.com	minalkh124@gmail.com	1707946120301	Maryam bibi	Inbound email	f	system	280	£	retailtechinnovationhub.com
470	97	1	historical	0	30	f	realwedding.co.uk	hello@contentmother.com	1707946124595	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
474	98	1	historical	0	18	f	lclarke.co.uk	hello@contentmother.com	1707946140685	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
450	99	1	historical	0	54	f	zomgcandy.com	minalkh124@gmail.com	1707946193925	Maryam bibi	Inbound email	f	system	90	£	zomgcandy.com
451	100	1	historical	0	71	f	marketbusinessnews.com	minalkh124@gmail.com	1707946200661	Maryam bibi	Inbound email	f	system	100	£	marketbusinessnews.com
452	101	1	historical	0	66	f	bignewsnetwork.com	minalkh124@gmail.com	1707946207223	Maryam bibi	Inbound email	f	system	100	£	bignewsnetwork.com
453	102	1	historical	0	63	f	techbullion.com	minalkh124@gmail.com	1707946211617	Maryam bibi	Inbound email	f	system	100	£	http://techbullion.com
454	103	1	historical	0	62	f	whatsnew2day.com	minalkh124@gmail.com	1707946215621	Maryam bibi	Inbound email	f	system	100	£	whatsnew2day.com
460	104	1	historical	0	27	f	techacrobat.com	minalkh124@gmail.com	1707946219635	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
477	105	1	historical	0	18	f	rocketandrelish.com	hello@contentmother.com	1707946226383	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
478	106	1	historical	0	18	f	affectionatelypaws.com	hello@contentmother.com	1707946230282	Becky	inbound email	f	system	45	£	http://affectionatelypaws.com
480	107	1	historical	0	25	f	the-pudding.com	hello@contentmother.com	1707946238072	Becky	inbound email	f	system	45	£	http://www.the-pudding.com
483	108	1	historical	0	33	f	packthepjs.com	tracey@packthepjs.com	1707946250419	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
495	109	1	historical	0	58	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1707946274523	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
496	110	1	historical	0	27	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1707946278741	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
498	111	1	historical	0	17	f	gonetravelling.co.uk	fazal.akbar@digitalczars.io	1707946282955	Fazal	Inbound Sam	f	system	84	£	gonetravelling.co.uk
499	112	1	historical	0	57	f	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	1707946286926	Fazal	Inbound Sam	f	system	144	£	www.lifestyledaily.co.uk
500	113	1	historical	0	36	f	pat.org.uk	fazal.akbar@digitalczars.io	1707946290835	Fazal	Inbound Sam	f	system	120	£	www.pat.org.uk
490	114	1	historical	0	57	f	theedinburghreporter.co.uk	fazal.akbar@digitalczars.io	1707946520492	Fazal	Inbound Sam	f	system	168	£	theedinburghreporter.co.uk
491	115	1	historical	0	53	f	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	1707946524494	Fazal	Inbound Sam	f	system	168	£	www.theexeterdaily.co.uk
492	116	1	historical	0	27	f	thedevondaily.co.uk	fazal.akbar@digitalczars.io	1707946528450	Fazal	Inbound Sam	f	system	120	£	www.thedevondaily.co.uk
501	117	1	historical	0	47	f	fashioncapital.co.uk	fazal.akbar@digitalczars.io	1707946535011	Fazal	Inbound Sam	f	system	132	£	www.fashioncapital.co.uk
502	118	1	historical	0	31	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1707946539338	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
503	119	1	historical	0	56	f	newsfromwales.co.uk	fazal.akbar@digitalczars.io	1707946543389	Fazal	Inbound Sam	f	system	144	£	newsfromwales.co.uk
504	120	1	historical	0	27	f	westlondonliving.co.uk	fazal.akbar@digitalczars.io	1707946547439	Fazal	Inbound Sam	f	system	84	£	www.westlondonliving.co.uk
506	121	1	historical	0	43	f	eagle.co.ug	fazal.akbar@digitalczars.io	1707946555285	Fazal	Inbound Sam	f	system	114	£	eagle.co.ug
507	122	1	historical	0	33	f	toddleabout.co.uk	fazal.akbar@digitalczars.io	1707946559337	Fazal	Inbound Sam	f	system	168	£	toddleabout.co.uk
509	123	1	historical	0	70	f	glasgowarchitecture.co.uk	fazal.akbar@digitalczars.io	1707946563164	Fazal	Inbound Sam	f	system	114	£	www.glasgowarchitecture.co.uk
510	124	1	historical	0	29	f	powderrooms.co.uk	fazal.akbar@digitalczars.io	1707946567010	Fazal	Inbound Sam	f	system	120	£	powderrooms.co.uk
512	125	1	historical	0	27	f	calculator.co.uk	fazal.akbar@digitalczars.io	1707946571379	Fazal	Inbound Sam	f	system	132	£	www.calculator.co.uk
513	126	1	historical	0	32	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1707946579566	Fazal	Inbound Sam	f	system	168	£	www.thefoodaholic.co.uk
514	127	1	historical	0	22	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1707946583375	Fazal	Inbound Sam	f	system	120	£	www.tobecomemum.co.uk
515	128	1	historical	0	13	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1707946587187	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
516	129	1	historical	0	42	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1707946591115	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
518	130	1	historical	0	21	f	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	1707946594970	Fazal	Inbound Sam	f	system	168	£	www.ukcaravanrental.co.uk
519	131	1	historical	0	23	f	cyclingscot.co.uk	fazal.akbar@digitalczars.io	1707946598945	Fazal	Inbound Sam	f	system	168	£	www.cyclingscot.co.uk
522	132	1	historical	0	54	f	altcoininvestor.com	fazal.akbar@digitalczars.io	1707946722812	Fazal	Inbound Sam	f	system	96	£	altcoininvestor.com
523	133	1	historical	0	32	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1707946727033	Fazal	Inbound Sam	f	system	120	£	www.daytradetheworld.com
524	134	1	historical	0	37	f	travelbeginsat40.com	backlinsprovider@gmail.com	1707946731248	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
525	135	1	historical	0	61	f	traveldailynews.com	backlinsprovider@gmail.com	1707946735467	David	Inbound Sam	f	system	150	£	www.traveldailynews.com
526	136	1	historical	0	48	f	puretravel.com	backlinsprovider@gmail.com	1707946739401	David	Inbound Sam	f	system	160	£	www.puretravel.com
527	137	1	historical	0	54	f	ourculturemag.com	backlinsprovider@gmail.com	1707946743313	David	Inbound Sam	f	system	120	£	ourculturemag.com
528	138	1	historical	0	32	f	cubeduel.com	backlinsprovider@gmail.com	1707946747115	David	Inbound Sam	f	system	120	£	cubeduel.com
529	139	1	historical	0	37	f	houseofcoco.net	backlinsprovider@gmail.com	1707946751019	David	Inbound Sam	f	system	150	£	houseofcoco.net
531	140	1	historical	0	36	f	businessmanchester.co.uk	backlinsprovider@gmail.com	1707946755075	David	Inbound Sam	f	system	130	£	www.businessmanchester.co.uk
532	141	1	historical	0	64	f	varsity.co.uk	backlinsprovider@gmail.com	1707946759100	David	Inbound Sam	f	system	150	£	www.varsity.co.uk
533	142	1	historical	0	46	f	craigmurray.co.uk	natalilacanario@gmail.com	1707946763316	Natalila	Inbound Sam	f	system	165	£	craigmurray.co.uk
535	144	1	historical	0	55	f	ukbusinessforums.co.uk	natalilacanario@gmail.com	1707946771731	Natalila	Inbound Sam	f	system	170	£	ukbusinessforums.co.uk
536	145	1	historical	0	55	f	hildenbrewing.com	natalilacanario@gmail.com	1707946775839	Natalila	Inbound Sam	f	system	170	£	hildenbrewing.com
537	146	1	historical	0	52	f	technoloss.com	natalilacanario@gmail.com	1707946779769	Natalila	Inbound Sam	f	system	155	£	technoloss.com
538	147	1	historical	0	58	f	4howtodo.com	natalilacanario@gmail.com	1707946783841	Natalila	Inbound Sam	f	system	170	£	4howtodo.com
332	148	1	historical	0	28	f	autumnsmummyblog.com	laura@autumnsmummyblog.com	1707946796645	Laura Chesmer	Fatjoe	f	system	75	£	https://www.autumnsmummyblog.com
371	149	1	historical	0	25	f	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	1707946810334	Jennie Jordan	Inbound email	f	system	80	£	www.ricecakesandraisins.co.uk
384	150	1	historical	0	44	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1707946814262	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
393	151	1	historical	0	60	f	reallymissingsleep.com	kareneholloway@hotmail.com	1707946874162	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
403	152	1	historical	0	55	f	sparklesandstretchmarks.com	Hayley@sparklesandstretchmarks.com	1707946879137	Hayley Mclean	Inbound email	f	system	100	£	Https://www.sparklesandstretchmarks.com
407	153	1	historical	0	29	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1707946887585	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
437	154	1	historical	0	54	f	techbehindit.com	minalkh124@gmail.com	1707946895511	Maryam bibi	Inbound email	f	system	55	£	techbehindit.com
447	155	1	historical	0	77	f	atlnightspots.com	minalkh124@gmail.com	1707946899315	Maryam bibi	Inbound email	f	system	80	£	atlnightspots.com
455	156	1	historical	0	57	f	programminginsider.com	minalkh124@gmail.com	1707946905172	Maryam bibi	Inbound email	f	system	100	£	programminginsider.com
457	157	1	historical	0	54	f	techktimes.com	minalkh124@gmail.com	1707946909044	Maryam bibi	Inbound email	f	system	110	£	http://techktimes.com/
458	158	1	historical	0	75	f	spacecoastdaily.com	minalkh124@gmail.com	1707946912976	Maryam bibi	Inbound email	f	system	120	£	https://spacecoastdaily.com/
467	159	1	historical	0	57	f	underconstructionpage.com	minalkh124@gmail.com	1707946916708	Maryam bibi	Inbound email	f	system	230	£	http://underconstructionpage.com
476	160	1	historical	0	12	f	contentmother.com	hello@contentmother.com	1707946920640	Becky	inbound email	f	system	45	£	https://www.contentmother.com
497	161	1	historical	0	42	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1707946928514	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
508	162	1	historical	0	31	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1707946932414	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
511	163	1	historical	0	74	f	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	1707946936325	Fazal	Inbound Sam	f	system	132	£	www.edinburgharchitecture.co.uk
517	164	1	historical	0	24	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1707946940422	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
530	165	1	historical	0	36	f	tech-wonders.com	backlinsprovider@gmail.com	1707946944021	David	Inbound Sam	f	system	100	£	www.tech-wonders.com
322	167	1	historical	0	30	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1707946951563	David	Fatjoe	f	system	45	£	5thingstodotoday.com
534	143	1	historical	0	40	f	saddind.co.uk	natalilacanario@gmail.com	1707946767902	Natalila	Inbound Sam	f	system	175	£	saddind.co.uk
539	166	1	historical	0	57	f	tamilworlds.com	natalilacanario@gmail.com	1707946947532	Natalila	Inbound Sam	f	system	150	£	Tamilworlds.com
485	234	1	historical	0	59	f	gudstory.com	sophiadaniel.co.uk@gmail.com	1708007233225	Sophia	Inbound Sam	f	michael.l@frontpageadvantage.com	150	£	www.gudstory.com
486	235	1	historical	0	88	f	digitaljournal.com	sophiadaniel.co.uk@gmail.com	1708007276233	Sophia	Inbound Sam	f	michael.l@frontpageadvantage.com	130	£	www.digitaljournal.com
487	236	1	historical	0	80	t	thefrisky.com	sophiadaniel.co.uk@gmail.com	1708007305158	Sophia	Inbound Sam	f	michael.l@frontpageadvantage.com	150	£	thefrisky.com
488	237	1	historical	0	59	f	computertechreviews.com	sophiadaniel.co.uk@gmail.com	1708007335489	Sophia	Inbound Sam	f	michael.l@frontpageadvantage.com	130	£	computertechreviews.com
489	238	1	historical	0	67	f	abcmoney.co.uk	sophiadaniel.co.uk@gmail.com	1708007359233	Sophia	Inbound Sam	f	michael.l@frontpageadvantage.com	150	£	www.abcmoney.co.uk
702	239	0	michael.l@frontpageadvantage.com	1708008300694	80	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1708008300694	Front Page Advantage	Email	f	\N	10	£	https://frontpageadvantage.com/
702	240	1	michael.l@frontpageadvantage.com	1708008300694	36	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1708008306577	Front Page Advantage	Email	f	system	10	£	https://frontpageadvantage.com/
752	260	0	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1708082585011	sophia daniel	Inbound	f	\N	120	£	https://www.outdoorproject.com/
752	261	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1708082591878	sophia daniel	Inbound	f	system	120	£	https://www.outdoorproject.com/
754	262	0	michael.l@frontpageadvantage.com	1708084929950	63	f	techsslash.com	sophiadaniel.co.uk@gmail.com	1708084929950	Sophia Daniel 	Inbound Email	f	\N	150	£	https://techsslash.com
754	263	1	michael.l@frontpageadvantage.com	1708084929950	63	f	techsslash.com	sophiadaniel.co.uk@gmail.com	1708084934319	Sophia Daniel 	Inbound Email	f	system	150	£	https://techsslash.com
756	264	0	chris.p@frontpageadvantage.com	1708088271090	0	f	\N	\N	1708088271090	Fatjoe	\N	t	\N	0	\N	\N
757	265	0	chris.p@frontpageadvantage.com	1708088289766	0	f	\N	\N	1708088289766	Fatjoe	\N	t	\N	0	\N	\N
654	299	1	chris.p@frontpageadvantage.com	0	47	f	acraftedpassion.com	info@morningbusinesschat.com	1708094706042	Brett Napoli	Inbound	f	michael.l@frontpageadvantage.com	83	£	https://acraftedpassion.com/
438	304	1	historical	0	76	t	merchantcircle.com	minalkh124@gmail.com	1708096205767	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	25	£	merchantcircle.com
306	316	1	historical	0	17	t	testingtimeblog.com	sam@testingtimeblog.com	1708424045249	Sam	Fatjoe	f	chris.p@frontpageadvantage.com	75	£	www.testingtimeblog.com
310	317	1	historical	0	19	t	rawrhubarb.co.uk	jennasnclr@gmail.com	1708424355198	Jenna	Fatjoe	f	chris.p@frontpageadvantage.com	30	£	www.rawrhubarb.co.uk
319	318	1	historical	0	33	t	morningbusinesschat.com	info@morningbusinesschat.com	1708424361755	Brett	Fatjoe	f	chris.p@frontpageadvantage.com	83	£	morningbusinesschat.com
336	319	1	historical	0	41	t	midwifeandlife.com	Jenny@midwifeandlife.com	1708424366153	Jenny Lord	Fatjoe	f	chris.p@frontpageadvantage.com	70	£	midwifeandlife.com
350	320	1	historical	0	35	t	tacklingourdebt.com	vicki@tacklingourdebt.com	1708424369644	Vicki	Fatjoe	f	chris.p@frontpageadvantage.com	45	£	Tacklingourdebt.com
352	321	1	historical	0	22	t	beautiful-solutions.co.uk	staceykane@outlook.com	1708424373522	Stacey	Fatjoe	f	chris.p@frontpageadvantage.com	40	£	https://www.beautiful-solutions.co.uk
356	322	1	historical	0	45	t	sorry-about-the-mess.co.uk	chloebridge@gmail.com	1708424380177	Chloe Bridge	Fatjoe	f	chris.p@frontpageadvantage.com	60	£	https://sorry-about-the-mess.co.uk
370	323	1	historical	0	19	t	retro-vixen.com	hello@retro-vixen.com	1708424384361	Clare McDougall	Inbound email	f	chris.p@frontpageadvantage.com	100	£	https://retro-vixen.com
376	324	1	historical	0	24	t	wood-create.com	ben@wood-create.com	1708424389251	Ben	Inbound email	f	chris.p@frontpageadvantage.com	180	£	https://www.wood-create.com
413	325	1	historical	0	24	t	lablogbeaute.co.uk	hello@lablogbeaute.do.uk	1708424393176	Beth Mahoney	Facebook	f	chris.p@frontpageadvantage.com	100	£	https://lablogbeaute.co.uk/
429	326	1	historical	0	29	t	countryheartandhome.com	Debbie@countryheartandhome.com	1708424398360	Deborah Nicholas	Facebook	f	chris.p@frontpageadvantage.com	75	£	https://countryheartandhome.com/
431	327	1	historical	0	53	t	lthornberry.co.uk	lauraa_x@hotmail.co.uk	1708424403270	Laura	Facebook	f	chris.p@frontpageadvantage.com	55	£	www.lthornberry.co.uk
435	328	1	historical	0	46	t	psychtimes.com	info@psychtimes.com	1708424407436	THomas Hlubin	Inbound email	f	chris.p@frontpageadvantage.com	45	£	https://psychtimes.com/
444	329	1	historical	0	56	t	tastefulspace.com	minalkh124@gmail.com	1708424411450	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	tastefulspace.com
447	330	1	historical	0	77	t	atlnightspots.com	minalkh124@gmail.com	1708424414853	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	atlnightspots.com
462	331	1	historical	0	65	t	azbigmedia.com	minalkh124@gmail.com	1708424418236	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	170	£	azbigmedia.com
466	332	1	historical	0	66	t	swaay.com	minalkh124@gmail.com	1708424423842	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	220	£	swaay.com
478	333	1	historical	0	18	t	affectionatelypaws.com	hello@contentmother.com	1708424428227	Becky	inbound email	f	chris.p@frontpageadvantage.com	45	£	http://affectionatelypaws.com
479	334	1	historical	0	17	t	poppyandblush.com	hello@contentmother.com	1708424431847	Becky	inbound email	f	chris.p@frontpageadvantage.com	45	£	http://poppyandblush.com
480	335	1	historical	0	25	t	the-pudding.com	hello@contentmother.com	1708424437246	Becky	inbound email	f	chris.p@frontpageadvantage.com	45	£	http://www.the-pudding.com
490	336	1	historical	0	57	t	theedinburghreporter.co.uk	fazal.akbar@digitalczars.io	1708424443094	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	168	£	theedinburghreporter.co.uk
492	337	1	historical	0	27	t	thedevondaily.co.uk	fazal.akbar@digitalczars.io	1708424447248	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	120	£	www.thedevondaily.co.uk
498	338	1	historical	0	17	t	gonetravelling.co.uk	fazal.akbar@digitalczars.io	1708424450853	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	84	£	gonetravelling.co.uk
528	341	1	historical	0	32	t	cubeduel.com	backlinsprovider@gmail.com	1708424461527	David	Inbound Sam	f	chris.p@frontpageadvantage.com	120	£	cubeduel.com
506	339	1	historical	0	43	t	eagle.co.ug	fazal.akbar@digitalczars.io	1708424454491	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	114	£	eagle.co.ug
519	340	1	historical	0	23	t	cyclingscot.co.uk	fazal.akbar@digitalczars.io	1708424457655	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	168	£	www.cyclingscot.co.uk
533	342	1	historical	0	46	t	craigmurray.co.uk	natalilacanario@gmail.com	1708424464756	Natalila	Inbound Sam	f	chris.p@frontpageadvantage.com	165	£	craigmurray.co.uk
654	505	1	chris.p@frontpageadvantage.com	0	47	f	acraftedpassion.com	info@morningbusinesschat.com	1708596308257	Brett Napoli	Inbound	f	chris.p@frontpageadvantage.com	100	£	https://acraftedpassion.com/
439	506	1	historical	0	66	t	timebusinessnews.com	minalkh124@gmail.com	1708596721953	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	25	£	timebusinessnews.com
488	583	1	historical	0	59	f	computertechreviews.com	kamransharief@gmail.com	1708603519657	Sophia	Inbound Sam	f	chris.p@frontpageadvantage.com	100	£	computertechreviews.com
489	584	1	historical	0	67	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1708603553484	Sophia	Inbound Sam	f	chris.p@frontpageadvantage.com	60	£	www.abcmoney.co.uk
500	585	1	historical	0	36	f	pat.org.uk	hello@pat.org.uk	1708603617676	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	30	£	www.pat.org.uk
527	586	1	historical	0	54	f	ourculturemag.com	info@ourculturemag.com	1708603693277	Info	Inbound Sam	f	chris.p@frontpageadvantage.com	115	£	ourculturemag.com
758	587	0	chris.p@frontpageadvantage.com	1708604143276	49	f	beastbeauty.co.uk	falcobliek@gmail.com	1708604143276	Falco	Inbound	f	\N	120	£	https://www.beastbeauty.co.uk/
758	588	1	chris.p@frontpageadvantage.com	1708604143276	49	f	beastbeauty.co.uk	falcobliek@gmail.com	1708604151846	Falco	Inbound	f	system	120	£	https://www.beastbeauty.co.uk/
760	599	0	sam.b@frontpageadvantage.com	1708613844903	36	f	fiso.co.uk	falcobliek@gmail.com	1708613844903	Falco	Inbound	f	\N	130	£	https://www.fiso.co.uk/
760	600	1	sam.b@frontpageadvantage.com	1708613844903	36	f	fiso.co.uk	falcobliek@gmail.com	1708613848855	Falco	Inbound	f	system	130	£	https://www.fiso.co.uk/
761	601	0	sam.b@frontpageadvantage.com	1708615661584	35	f	holyroodpr.co.uk	falcobliek@gmail.com	1708615661584	Falco	Inbound	f	\N	130	£	https://www.holyroodpr.co.uk/
761	602	1	sam.b@frontpageadvantage.com	1708615661584	35	f	holyroodpr.co.uk	falcobliek@gmail.com	1708615666481	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
762	603	0	sam.b@frontpageadvantage.com	1708615840028	18	f	flatpackhouses.co.uk	falcobliek@gmail.com	1708615840028	Falco	Inbound	f	\N	120	£	https://www.flatpackhouses.co.uk/
762	604	1	sam.b@frontpageadvantage.com	1708615840028	18	f	flatpackhouses.co.uk	falcobliek@gmail.com	1708615846234	Falco	Inbound	f	system	120	£	https://www.flatpackhouses.co.uk/
763	606	0	sam.b@frontpageadvantage.com	1708616008102	89	f	benzinga.com	falcobliek@gmail.com	1708616008102	Falco	Inbound	f	\N	130	£	https://www.benzinga.com/
763	607	1	sam.b@frontpageadvantage.com	1708616008102	89	f	benzinga.com	falcobliek@gmail.com	1708616012783	Falco	Inbound	f	system	130	£	https://www.benzinga.com/
764	608	0	sam.b@frontpageadvantage.com	1708616228406	94	f	news.yahoo.com	ela690000@gmail.com	1708616228406	Ella	Inbound	f	\N	125	£	https://news.yahoo.com/
764	609	1	sam.b@frontpageadvantage.com	1708616228406	94	f	news.yahoo.com	ela690000@gmail.com	1708616236143	Ella	Inbound	f	system	125	£	https://news.yahoo.com/
765	610	0	sam.b@frontpageadvantage.com	1708616408925	46	f	storymirror.com	ela690000@gmail.com	1708616408925	Ella	Inbound	f	\N	96	£	https://storymirror.com/
765	611	1	sam.b@frontpageadvantage.com	1708616408925	46	f	storymirror.com	ela690000@gmail.com	1708616415838	Ella	Inbound	f	system	96	£	https://storymirror.com/
362	658	1	historical	0	39	f	hausmanmarketingletter.com	angie@hausmanmarketingletter	1708680723486	Angela Hausman	Fatjoe	f	chris.p@frontpageadvantage.com	150	£	https://hausmanmarketingletter.com
362	659	1	historical	0	39	f	hausmanmarketingletter.com	angie@hausmanmarketingletter	1708680791672	Angela Hausman	Fatjoe	f	chris.p@frontpageadvantage.com	150	£	https://hausmanmarketingletter.com
303	680	1	historical	0	24	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1708693659673	This is Owned by Chris :-)	Inbound email	f	chris.p@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
302	681	1	historical	0	8	t	poocrazy.com	paul@moneytipsblog.co.uk	1708693689221	Paul	Inbound email	f	chris.p@frontpageadvantage.com	10	£	www.poocrazy.com
303	682	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1708693808895	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
451	691	1	historical	0	71	f	marketbusinessnews.com	Imjustwebworld@gmail.com	1708940228327	Harshil	Inbound email	f	michael.l@frontpageadvantage.com	99	£	marketbusinessnews.com
756	702	1	chris.p@frontpageadvantage.com	1708088271090	36	f	internetvibes.net	\N	1708941218464	Fatjoe	\N	t	chris.p@frontpageadvantage.com	120	£	https://www.internetvibes.net
559	705	1	historical	0	58	t	thenewsgod.com	n/a	1709026464981	Click Intelligence	\N	t	chris.p@frontpageadvantage.com	1	£	thenewsgod.com
769	706	0	chris.p@frontpageadvantage.com	1709027357228	59	f	livepositively.com	ela690000@gmail.com	1709027357228	ela	inbound	f	\N	1150	£	https://livepositively.com/
769	707	1	chris.p@frontpageadvantage.com	1709027357228	59	f	livepositively.com	ela690000@gmail.com	1709027361825	ela	inbound	f	system	1150	£	https://livepositively.com/
770	708	0	chris.p@frontpageadvantage.com	1709027700111	56	f	valiantceo.com	ela690000@gmail.com	1709027700111	Ela	inbound	f	\N	100	£	https://valiantceo.com/
770	709	1	chris.p@frontpageadvantage.com	1709027700111	56	f	valiantceo.com	ela690000@gmail.com	1709027705355	Ela	inbound	f	system	100	£	https://valiantceo.com/
771	710	0	chris.p@frontpageadvantage.com	1709027801990	45	f	finehomesandliving.com	ela690000@gmail.com	1709027801990	Ela	inbound	f	\N	100	£	https://www.finehomesandliving.com/
771	711	1	chris.p@frontpageadvantage.com	1709027801990	45	f	finehomesandliving.com	ela690000@gmail.com	1709027807167	Ela	inbound	f	system	100	£	https://www.finehomesandliving.com/
772	712	0	chris.p@frontpageadvantage.com	1709027922451	56	f	thetecheducation.com	ela690000@gmail.com	1709027922451	Ela	inbound	f	\N	100	£	https://thetecheducation.com/
772	713	1	chris.p@frontpageadvantage.com	1709027922451	56	f	thetecheducation.com	ela690000@gmail.com	1709027926877	Ela	inbound	f	system	100	£	https://thetecheducation.com/
772	714	1	chris.p@frontpageadvantage.com	1709027922451	56	f	thetecheducation.com	ela690000@gmail.com	1709028309814	Ela	inbound	f	chris.p@frontpageadvantage.com	100	£	https://thetecheducation.com/
773	715	0	chris.p@frontpageadvantage.com	1709029278940	44	f	digitalgpoint.com	bhaiahsan799@gmail.com	1709029278940	Ahsan	inbound	f	\N	35	£	digitalgpoint.com
773	716	1	chris.p@frontpageadvantage.com	1709029278940	44	f	digitalgpoint.com	bhaiahsan799@gmail.com	1709029288599	Ahsan	inbound	f	system	35	£	digitalgpoint.com
773	717	1	chris.p@frontpageadvantage.com	1709029278940	44	f	digitalgpoint.com	bhaiahsan799@gmail.com	1709029308367	Ahsan	inbound	f	chris.p@frontpageadvantage.com	35	£	digitalgpoint.com
540	718	1	historical	0	40	f	otsnews.co.uk	bhaiahsan799@gmail.com	1709030103670	Ashan	Inbound Sam	f	chris.p@frontpageadvantage.com	55	£	www.otsnews.co.uk
774	719	0	chris.p@frontpageadvantage.com	1709030265171	32	f	voiceofaction.org	bhaiahsan799@gmail.com	1709030265171	Ashan	inbound	f	\N	80	£	http://voiceofaction.org/
774	720	1	chris.p@frontpageadvantage.com	1709030265171	32	f	voiceofaction.org	bhaiahsan799@gmail.com	1709030269493	Ashan	inbound	f	system	80	£	http://voiceofaction.org/
775	721	0	chris.p@frontpageadvantage.com	1709031235193	26	f	followthefashion.org	bhaiahsan799@gmail.com	1709031235193	Ashan	inbound	f	\N	55	£	https://www.followthefashion.org/
775	722	1	chris.p@frontpageadvantage.com	1709031235193	26	f	followthefashion.org	bhaiahsan799@gmail.com	1709031239910	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
775	723	1	chris.p@frontpageadvantage.com	1709031235193	26	f	followthefashion.org	bhaiahsan799@gmail.com	1709031283780	Ashan	inbound	f	chris.p@frontpageadvantage.com	55	£	https://www.followthefashion.org/
776	724	0	chris.p@frontpageadvantage.com	1709032440217	65	f	petdogplanet.com	bhaiahsan799@gmail.com	1709032440217	Ashan	inbound	f	\N	60	£	www.petdogplanet.com
776	725	1	chris.p@frontpageadvantage.com	1709032440217	65	f	petdogplanet.com	bhaiahsan799@gmail.com	1709032444357	Ashan	inbound	f	system	60	£	www.petdogplanet.com
777	726	0	chris.p@frontpageadvantage.com	1709032527056	28	f	yourpetplanet.com	bhaiahsan799@gmail.com	1709032527056	Ashan	inbound	f	\N	115	£	https://yourpetplanet.com/
777	727	1	chris.p@frontpageadvantage.com	1709032527056	28	f	yourpetplanet.com	bhaiahsan799@gmail.com	1709032531000	Ashan	inbound	f	system	115	£	https://yourpetplanet.com/
777	728	1	chris.p@frontpageadvantage.com	1709032527056	28	f	yourpetplanet.com	bhaiahsan799@gmail.com	1709032575878	Ashan	inbound	f	chris.p@frontpageadvantage.com	115	£	https://yourpetplanet.com/
778	729	0	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	bhaiahsan799@gmail.com	1709032760082	Ashan	inbound	f	\N	55	£	https://suntrics.com/
778	730	1	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	bhaiahsan799@gmail.com	1709032764512	Ashan	inbound	f	system	55	£	https://suntrics.com/
779	731	0	chris.p@frontpageadvantage.com	1709032988565	19	f	travelworldfashion.com	bhaiahsan799@gmail.com	1709032988565	Ashan	inbound	f	\N	80	£	https://travelworldfashion.com/
779	732	1	chris.p@frontpageadvantage.com	1709032988565	19	f	travelworldfashion.com	bhaiahsan799@gmail.com	1709032992831	Ashan	inbound	f	system	80	£	https://travelworldfashion.com/
780	733	0	chris.p@frontpageadvantage.com	1709033136922	30	f	travelistia.com	bhaiahsan799@gmail.com	1709033136922	Ashan	inbound	f	\N	40	£	https://www.travelistia.com/
780	734	1	chris.p@frontpageadvantage.com	1709033136922	30	f	travelistia.com	bhaiahsan799@gmail.com	1709033141140	Ashan	inbound	f	system	40	£	https://www.travelistia.com/
781	735	0	chris.p@frontpageadvantage.com	1709033259858	53	f	kidsworldfun.com	bhaiahsan799@gmail.com	1709033259858	Ashan	inbound	f	\N	95	£	https://www.kidsworldfun.com/
781	736	1	chris.p@frontpageadvantage.com	1709033259858	53	f	kidsworldfun.com	bhaiahsan799@gmail.com	1709033263978	Ashan	inbound	f	system	95	£	https://www.kidsworldfun.com/
782	737	0	chris.p@frontpageadvantage.com	1709033531454	33	f	spokenenglishtips.com	bhaiahsan799@gmail.com	1709033531454	Ashan	inbound	f	\N	30	£	https://spokenenglishtips.com/
782	738	1	chris.p@frontpageadvantage.com	1709033531454	33	f	spokenenglishtips.com	bhaiahsan799@gmail.com	1709033535574	Ashan	inbound	f	system	30	£	https://spokenenglishtips.com/
783	739	0	chris.p@frontpageadvantage.com	1709034374081	43	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1709034374081	Sukhen	inbound	f	\N	150	£	https://corporatelivewire.com/
783	740	1	chris.p@frontpageadvantage.com	1709034374081	43	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1709034378089	Sukhen	inbound	f	system	150	£	https://corporatelivewire.com/
783	741	1	chris.p@frontpageadvantage.com	1709034374081	43	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1709034475410	Sukhen	inbound	f	chris.p@frontpageadvantage.com	150	£	https://corporatelivewire.com/
783	742	1	chris.p@frontpageadvantage.com	1709034374081	43	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1709034833119	Sukhen	inbound	f	chris.p@frontpageadvantage.com	150	£	https://corporatelivewire.com/
780	743	1	chris.p@frontpageadvantage.com	1709033136922	30	f	travelistia.com	travelistiausa@gmail.com	1709034951534	Ferona	outbound	f	chris.p@frontpageadvantage.com	40	£	https://www.travelistia.com/
784	744	0	chris.p@frontpageadvantage.com	1709035290025	33	f	okaybliss.com	infopediapros@gmail.com	1709035290025	Ricardo	inbound	f	\N	80	£	https://www.okaybliss.com/
784	745	1	chris.p@frontpageadvantage.com	1709035290025	33	f	okaybliss.com	infopediapros@gmail.com	1709035294047	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
784	746	1	chris.p@frontpageadvantage.com	1709035290025	33	f	okaybliss.com	infopediapros@gmail.com	1709035348464	Ricardo	inbound	f	chris.p@frontpageadvantage.com	80	£	https://www.okaybliss.com/
785	747	0	chris.p@frontpageadvantage.com	1709035573894	57	f	theassistant.io	infopediapros@gmail.com	1709035573894	Ricardo	inbound	f	\N	45	£	theassistant.io
785	748	1	chris.p@frontpageadvantage.com	1709035573894	57	f	theassistant.io	infopediapros@gmail.com	1709035578113	Ricardo	inbound	f	system	45	£	theassistant.io
786	749	0	chris.p@frontpageadvantage.com	1709035655140	60	f	stylesrant.com	infopediapros@gmail.com	1709035655140	Ricardo	inbound	f	\N	45	£	https://www.stylesrant.com/
786	750	1	chris.p@frontpageadvantage.com	1709035655140	60	f	stylesrant.com	infopediapros@gmail.com	1709035659377	Ricardo	inbound	f	system	45	£	https://www.stylesrant.com/
782	751	1	chris.p@frontpageadvantage.com	1709033531454	33	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1709035731157	Edu Place	inbound	f	chris.p@frontpageadvantage.com	30	£	https://spokenenglishtips.com/
781	752	1	chris.p@frontpageadvantage.com	1709033259858	53	f	kidsworldfun.com	enquiry@kidsworldfun.com	1709038030453	Limna	outbound	f	chris.p@frontpageadvantage.com	80	£	https://www.kidsworldfun.com/
787	753	0	sam.b@frontpageadvantage.com	1709041586393	20	f	netizensreport.com	premium@rabbiitfirm.com	1709041586393	Mojammel	Inbound	f	\N	40	£	netizensreport.com
787	754	1	sam.b@frontpageadvantage.com	1709041586393	20	f	netizensreport.com	premium@rabbiitfirm.com	1709041590378	Mojammel	Inbound	f	system	40	£	netizensreport.com
770	755	1	chris.p@frontpageadvantage.com	1709027700111	56	f	valiantceo.com	staff@valiantceo.com	1709042535004	Valiantstaff	outbound	f	sam.b@frontpageadvantage.com	70	£	https://valiantceo.com/
303	802	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1709058212468	This is Owned by Chris :-)	Inbound email	f	chris.p@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
774	807	1	chris.p@frontpageadvantage.com	1709030265171	32	f	voiceofaction.org	webmaster@redhatmedia.net	1709111886175	Vivek	outbound	f	chris.p@frontpageadvantage.com	65	£	http://voiceofaction.org/
778	808	1	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	suntrics4u@gmail.com	1709112067061	Suntrics	outbound	f	chris.p@frontpageadvantage.com	40	£	https://suntrics.com/
778	809	1	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	suntrics4u@gmail.com	1709112113815	Suntrics	outbound	f	chris.p@frontpageadvantage.com	40	£	https://suntrics.com/
771	810	1	chris.p@frontpageadvantage.com	1709027801990	45	f	finehomesandliving.com	info@fine-magazine.com	1709113453401	Fine Home Team	outbound	f	chris.p@frontpageadvantage.com	100	£	https://www.finehomesandliving.com/
802	811	0	chris.p@frontpageadvantage.com	1709122990978	53	f	wegmans.co.uk	sophiadaniel.co.uk@gmail.com	1709122990978	Sophia	outbound	f	\N	80	£	https://wegmans.co.uk/
802	812	1	chris.p@frontpageadvantage.com	1709122990978	53	f	wegmans.co.uk	sophiadaniel.co.uk@gmail.com	1709122995389	Sophia	outbound	f	system	80	£	https://wegmans.co.uk/
803	813	0	chris.p@frontpageadvantage.com	1709123162304	45	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1709123162304	Sophia		f	\N	60	£	https://smihub.co.uk/
803	814	1	chris.p@frontpageadvantage.com	1709123162304	45	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1709123166051	Sophia		f	system	60	£	https://smihub.co.uk/
803	815	1	chris.p@frontpageadvantage.com	1709123162304	45	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1709123167678	Sophia	Inbound	f	chris.p@frontpageadvantage.com	60	£	https://smihub.co.uk/
804	816	0	sam.b@frontpageadvantage.com	1709213279175	81	f	e-architect.com	isabelle@e-architect.com	1709213279175	Isabelle Lomholt	Outbound Sam	f	\N	100	£	https://www.e-architect.com/
804	817	1	sam.b@frontpageadvantage.com	1709213279175	81	f	e-architect.com	isabelle@e-architect.com	1709213283598	Isabelle Lomholt	Outbound Sam	f	system	100	£	https://www.e-architect.com/
777	818	1	chris.p@frontpageadvantage.com	1709032527056	28	f	yourpetplanet.com	info@yourpetplanet.com	1709284413915	Your Pet Planet	inbound	f	chris.p@frontpageadvantage.com	42	£	https://yourpetplanet.com/
757	820	1	chris.p@frontpageadvantage.com	1708088289766	27	f	respawning.co.uk	\N	1709287346849	Fatjoe	\N	t	chris.p@frontpageadvantage.com	80	£	https://respawning.co.uk
779	821	1	chris.p@frontpageadvantage.com	1709032988565	19	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1709629853656	Team	inbound	f	chris.p@frontpageadvantage.com	72	£	https://travelworldfashion.com/
808	822	0	sam.b@frontpageadvantage.com	1709637089134	25	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1709637089134	Vijay Chauhan	Outbound	f	\N	41	£	https://myarchitecturesidea.com/
808	823	1	sam.b@frontpageadvantage.com	1709637089134	25	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1709637093886	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
809	824	0	sam.b@frontpageadvantage.com	1709637625007	54	f	pierdom.com	info@pierdom.com	1709637625007	Junaid	Outbound	f	\N	25	£	https://pierdom.com/
809	825	1	sam.b@frontpageadvantage.com	1709637625007	54	f	pierdom.com	info@pierdom.com	1709637629478	Junaid	Outbound	f	system	25	£	https://pierdom.com/
347	852	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1709644011122	Nigel higgins	Fatjoe	f	chris.p@frontpageadvantage.com	75	£	https://www.diydaddyblog.com/
347	853	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1709644469130	Nigel higgins	Fatjoe	f	chris.p@frontpageadvantage.com	50	£	https://www.diydaddyblog.com/
347	854	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1709644525549	Nigel higgins	Fatjoe	f	chris.p@frontpageadvantage.com	50	£	https://www.diydaddyblog.com/
852	855	0	sam.b@frontpageadvantage.com	1709645596330	37	f	golfnews.co.uk	kenditoys.com@gmail.com	1709645596330	David warner	Outbound	f	\N	125	£	https://golfnews.co.uk/
852	856	1	sam.b@frontpageadvantage.com	1709645596330	37	f	golfnews.co.uk	kenditoys.com@gmail.com	1709645600976	David warner	Outbound	f	system	125	£	https://golfnews.co.uk/
489	909	1	historical	0	67	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1709717563308	Claire James	Inbound Sam	f	sam.b@frontpageadvantage.com	60	£	www.abcmoney.co.uk
902	910	0	sam.b@frontpageadvantage.com	1709717920944	41	f	trainingexpress.org.uk	mailto:kenditoys.com@gmail.com	1709717920944	David warner	Inbound	f	\N	150	£	https://trainingexpress.org.uk/
903	911	0	sam.b@frontpageadvantage.com	1709718136681	51	f	therugbypaper.co.uk	mailto:kenditoys.com@gmail.com	1709718136681	David warner 	Inbound	f	\N	142	£	www.therugbypaper.co.uk
904	912	0	sam.b@frontpageadvantage.com	1709718289226	37	f	theleaguepaper.com	mailto:kenditoys.com@gmail.com	1709718289226	David warner 	Inbound	f	\N	100	£	www.theleaguepaper.com
905	913	0	sam.b@frontpageadvantage.com	1709718547266	47	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1709718547266	David warner 	Inbound	f	\N	150	£	https://www.luxurylifestylemag.co.uk/
903	914	1	sam.b@frontpageadvantage.com	1709718136681	51	f	therugbypaper.co.uk	kenditoys.com@gmail.com	1709718585848	David warner 	Inbound	f	sam.b@frontpageadvantage.com	142	£	www.therugbypaper.co.uk
902	915	1	sam.b@frontpageadvantage.com	1709717920944	41	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1709718597168	David warner	Inbound	f	sam.b@frontpageadvantage.com	150	£	https://trainingexpress.org.uk/
904	916	1	sam.b@frontpageadvantage.com	1709718289226	37	f	theleaguepaper.com	kenditoys.com@gmail.com	1709718613874	David warner 	Inbound	f	sam.b@frontpageadvantage.com	100	£	www.theleaguepaper.com
906	917	0	sam.b@frontpageadvantage.com	1709718918993	44	f	liverpoolway.co.uk	kenditoys.com@gmail.com	1709718918993	David warner 	Inbound	f	\N	142	£	https://www.liverpoolway.co.uk/
907	918	0	sam.b@frontpageadvantage.com	1709719202025	61	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1709719202025	David warner 	Inbound	f	\N	84	£	https://bmmagazine.co.uk/
908	919	0	sam.b@frontpageadvantage.com	1709719594822	33	f	britainreviews.co.uk	kenditoys.com@gmail.com	1709719594822	David warner 	Inbound	f	\N	167	£	https://britainreviews.co.uk/
1308	6883	0	james.p@frontpageadvantage.com	1727790152208	0	f	\N	\N	1727790152208	Rhino Rank	\N	t	\N	0	\N	\N
909	920	0	sam.b@frontpageadvantage.com	1709720316064	60	f	blogstory.co.uk	kenditoys.com@gmail.com	1709720316064	David warner 	Inbound	f	\N	125	£	https://blogstory.co.uk/
910	968	0	chris.p@frontpageadvantage.com	1709904731384	0	f	\N	\N	1709904731384	FatJoe	\N	t	\N	0	\N	\N
911	970	0	chris.p@frontpageadvantage.com	1709904777387	0	f	\N	\N	1709904777387	FatJoe	\N	t	\N	0	\N	\N
303	982	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1709909122334	This is Owned by Chris :-)	Inbound email	f	michael.l@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
702	983	1	michael.l@frontpageadvantage.com	1708008300694	36	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1709909159183	Front Page Advantage	Email	f	michael.l@frontpageadvantage.com	10	£	https://frontpageadvantage.com/
303	1037	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1710154014811	This is Owned by Chris :-)	Inbound email	f	michael.l@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
436	1273	1	historical	0	65	t	scoopearth.com	minalkh124@gmail.com	1710248464364	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	20	£	https://www.scoopearth.com/
343	1274	1	historical	0	54	t	workingdaddy.co.uk	tom@workingdaddy.co.uk	1710248472725	Thomaz	Fatjoe	f	michael.l@frontpageadvantage.com	60	£	https://workingdaddy.co.uk
773	1275	1	chris.p@frontpageadvantage.com	1709029278940	44	t	digitalgpoint.com	bhaiahsan799@gmail.com	1710248485505	Ahsan	inbound	f	michael.l@frontpageadvantage.com	35	£	digitalgpoint.com
787	1342	1	sam.b@frontpageadvantage.com	1709041586393	20	f	netizensreport.com	premium@rabbiitfirm.com	1710260199803	Mojammel	Inbound	f	michael.l@frontpageadvantage.com	120	£	netizensreport.com
655	1353	1	chris.p@frontpageadvantage.com	0	46	f	forgetfulmomma.com	info@morningbusinesschat.com	1710319277752	Brett Napoli	Inbound	f	michael.l@frontpageadvantage.com	300	£	https://www.forgetfulmomma.com/
453	1437	1	historical	0	63	f	techbullion.com	angelascottbriggs@techbullion.com	1710346382379	Angela Scott-Briggs 	Inbound email	f	michael.l@frontpageadvantage.com	100	£	http://techbullion.com
952	1530	0	michael.l@frontpageadvantage.com	1710423264423	52	f	kemotech.co.uk	sophiadaniel.co.uk@gmail.com	1710423264423	sophia daniel 	Inbound Michael	f	\N	250	£	https://kemotech.co.uk/
655	1548	1	chris.p@frontpageadvantage.com	0	46	f	forgetfulmomma.com	info@morningbusinesschat.com	1710493096195	Brett Napoli	Inbound	f	michael.l@frontpageadvantage.com	225	£	https://www.forgetfulmomma.com/
903	1595	1	sam.b@frontpageadvantage.com	1709718136681	51	f	therugbypaper.co.uk	backlinsprovider@gmail.com	1710926241366	David Smith 	Inbound	f	michael.l@frontpageadvantage.com	115	£	www.therugbypaper.co.uk
953	1597	0	michael.l@frontpageadvantage.com	1711012683237	40	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1711012683237	Sam	Outbound Chris	f	\N	100	£	https://www.thecricketpaper.com/
904	1598	1	sam.b@frontpageadvantage.com	1709718289226	37	f	theleaguepaper.com	sam.emery@greenwayspublishing.com	1711012766490	Sam	Outbound Chris	f	michael.l@frontpageadvantage.com	100	£	www.theleaguepaper.com
954	1599	0	michael.l@frontpageadvantage.com	1711012828815	49	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1711012828815	Sam	Outbound Chris	f	\N	100	£	https://www.thenonleaguefootballpaper.com/
955	1600	0	michael.l@frontpageadvantage.com	1711012971138	28	f	latetacklemagazine.com	sam.emery@greenwayspublishing.com	1711012971138	Sam	Outbound Chris	f	\N	100	£	https://www.latetacklemagazine.com/
956	1601	0	michael.l@frontpageadvantage.com	1711013035726	27	f	racingahead.net	sam.emery@greenwayspublishing.com	1711013035726	Sam	Outbound Chris	f	\N	100	£	https://www.racingahead.net/
957	1608	0	chris.p@frontpageadvantage.com	1711532679719	45	f	north.wales	backlinsprovider@gmail.com	1711532679719	David Smith	Inbound	f	\N	95	£	https://north.wales/
958	1609	0	chris.p@frontpageadvantage.com	1711532781458	47	f	deeside.com	backlinsprovider@gmail.com	1711532781458	David Smith	inbound	f	\N	95	£	https://www.deeside.com/
505	1610	1	historical	0	26	f	talk-retail.co.uk	backlinsprovider@gmail.com	1711532951630	David Smith	Inbound Sam	f	chris.p@frontpageadvantage.com	95	£	talk-retail.co.uk
959	1611	0	chris.p@frontpageadvantage.com	1711533031802	46	f	talk-business.co.uk	backlinsprovider@gmail.com	1711533031802	David Smith	Inbound	f	\N	115	£	https://www.talk-business.co.uk/
354	2058	1	historical	0	43	t	businesspartnermagazine.com	info@businesspartnermagazine.com	1712672503496	Sandra Hinshelwood	Fatjoe	f	chris.p@frontpageadvantage.com	19	£	https://businesspartnermagazine.com/
540	2107	1	historical	0	40	f	otsnews.co.uk	bhaiahsan799@gmail.com	1712756143101	Ashan	Inbound Sam	f	michael.l@frontpageadvantage.com	55	£	www.otsnews.co.uk
778	2154	1	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	suntrics4u@gmail.com	1712849215866	Suntrics	outbound	f	michael.l@frontpageadvantage.com	40	£	https://suntrics.com/
442	2163	1	historical	0	64	f	wheon.com	minalkh124@gmail.com	1712907952741	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	70	£	wheon.com
442	2168	1	historical	0	64	f	wheon.com	minalkh124@gmail.com	1712908198481	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	70	£	wheon.com
442	2169	1	historical	0	64	f	wheon.com	minalkh124@gmail.com	1712908232861	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	70	£	wheon.com
531	2248	1	historical	0	36	f	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1713340297490	Sophia Daniel	Inbound Michael	f	michael.l@frontpageadvantage.com	55	£	www.businessmanchester.co.uk
1002	2250	0	michael.l@frontpageadvantage.com	1713341748907	0	f	todaynews.co.uk	sophiadaniel.co.uk@gmail.com	1713341748907	Sophia	Inbound Michael	f	\N	65	£	https://todaynews.co.uk/
323	2252	1	historical	0	32	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1714532402797	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
491	2253	1	historical	0	52	f	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	1714532403536	Fazal	Inbound Sam	f	system	168	£	www.theexeterdaily.co.uk
752	2254	1	chris.p@frontpageadvantage.com	1708082585011	60	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1714532404555	sophia daniel	Inbound	f	system	120	£	https://www.outdoorproject.com/
653	2255	1	chris.p@frontpageadvantage.com	0	41	f	thatdrop.com	info@morningbusinesschat.com	1714546823895	Brett Napoli	Inbound	f	system	83	£	https://thatdrop.com/
787	2256	1	sam.b@frontpageadvantage.com	1709041586393	21	f	netizensreport.com	premium@rabbiitfirm.com	1714546828710	Mojammel	Inbound	f	system	120	£	netizensreport.com
405	2257	1	historical	0	34	f	prettybigbutterflies.com	prettybigbutterflies@gmail.com	1714546851957	Hollie	Inbound email	f	system	80	£	www.prettybigbutterflies.com
803	2258	1	chris.p@frontpageadvantage.com	1709123162304	46	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1714546869717	Sophia	Inbound	f	system	60	£	https://smihub.co.uk/
324	2259	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1714546878961	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
776	2260	1	chris.p@frontpageadvantage.com	1709032440217	58	f	petdogplanet.com	bhaiahsan799@gmail.com	1714546880086	Ashan	inbound	f	system	60	£	www.petdogplanet.com
804	2261	1	sam.b@frontpageadvantage.com	1709213279175	80	f	e-architect.com	isabelle@e-architect.com	1714546880949	Isabelle Lomholt	Outbound Sam	f	system	100	£	https://www.e-architect.com/
778	2262	1	chris.p@frontpageadvantage.com	1709032760082	26	f	suntrics.com	suntrics4u@gmail.com	1714546886263	Suntrics	outbound	f	system	40	£	https://suntrics.com/
339	2263	1	historical	0	25	f	keralpatel.com	keralpatel@gmail.com	1714546890860	Keral Patel	Fatjoe	f	system	35	£	https://www.keralpatel.com
451	2264	1	historical	0	72	f	marketbusinessnews.com	Imjustwebworld@gmail.com	1714546897044	Harshil	Inbound email	f	system	99	£	marketbusinessnews.com
330	2265	1	historical	0	35	f	robinwaite.com	robin@robinwaite.com	1714546909000	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
331	2266	1	historical	0	33	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1714546910062	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
335	2267	1	historical	0	19	f	lillaloves.com	lillaallahiary@gmail.com	1714546911119	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
358	2268	1	historical	0	31	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1714546917612	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
305	2269	1	historical	0	16	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1714546918131	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
309	2270	1	historical	0	13	f	annabelwrites.com	annabelwrites.blog@gmail.com	1714546928196	Annabel	Fatjoe	f	system	20	£	annabelwrites.com
316	2271	1	historical	0	31	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1714546928803	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
326	2272	1	historical	0	20	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1714546934486	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
328	2273	1	historical	0	24	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1714546935601	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
329	2274	1	historical	0	44	f	wemadethislife.com	wemadethislife@outlook.com	1714546937370	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
334	2275	1	historical	0	25	f	lifeloving.co.uk	sally@lifeloving.co.uk	1714546941251	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
338	2276	1	historical	0	18	f	themammafairy.com	themammafairy@gmail.com	1714546942950	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
359	2277	1	historical	0	27	f	beccafarrelly.co.uk	hello@beccafarrelly.co.uk	1714546964885	Becca	Fatjoe	f	system	100	£	beccafarrelly.co.uk
361	2278	1	historical	0	56	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	1714546970621	Erica Hughes	Fatjoe	f	system	125	£	https://alittleluxuryfor.me/
365	2279	1	historical	0	40	f	letstalkmommy.com	jenny@letstalkmommy.com	1714546971877	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
372	2280	1	historical	0	44	f	fashion-mommy.com	fashionmommywm@gmail.com	1714546983976	emma iannarilli	Inbound email	f	system	85	£	fashion-mommy.com
377	2281	1	historical	0	31	f	travelvixta.com	victoria@travelvixta.com	1714546985780	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
385	2282	1	historical	0	43	f	motherhoodtherealdeal.com	motherhoodtherealdeal@gmail.com	1714546988782	Taiya	Inbound email	f	system	85	£	Https://www.motherhoodtherealdeal.com
398	2283	1	historical	0	23	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1714546994567	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
379	2284	1	historical	0	32	f	yeahlifestyle.com	info@yeahlifestyle.com	1714547001106	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
380	2285	1	historical	0	61	f	captainbobcat.com	Eva@captainbobcat.com	1714547002040	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
383	2286	1	historical	0	42	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1714547003908	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
388	2287	1	historical	0	23	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1714547004385	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
402	2288	1	historical	0	61	f	mammaprada.com	mammaprada@gmail.com	1714547008051	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
409	2289	1	historical	0	29	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1714547009189	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
392	2290	1	historical	0	38	f	midlandstraveller.com	contact@midlandstraveller.com	1714547022043	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
394	2291	1	historical	0	36	f	skinnedcartree.com	corinne@skinnedcartree.com	1714547022643	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
397	2292	1	historical	0	62	f	emmaplusthree.com	emmaplusthree@gmail.com	1714547024529	Emma Easton	Inbound email	f	system	100	£	www.emmaplusthree.com
412	2293	1	historical	0	37	f	laurakatelucas.com	laurakatelucas@hotmail.com	1714547027984	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
418	2294	1	historical	0	40	f	amumreviews.co.uk	contact@amumreviews.co.uk	1714547029060	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
428	2295	1	historical	0	56	f	modernguy.co.uk	modguyinfo@gmail.com	1714547036680	Modern Guy	Facebook	f	system	103	£	Modernguy.co.uk
430	2296	1	historical	0	27	f	bizzimummy.com	Bizzimummy@gmail.com	1714547037623	Eva Stretton	Facebook	f	system	55	£	https://bizzimummy.com
411	2297	1	historical	0	20	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1714547044074	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
416	2298	1	historical	0	31	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1714547046650	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
420	2299	1	historical	0	40	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1714547049457	Anna	Facebook	f	system	150	£	https://www.dontcrampmystyle.co.uk
421	2300	1	historical	0	46	f	glassofbubbly.com	christopher@marketme.co.uk	1714547050051	Christopher	Inbound email	f	system	125	£	https://glassofbubbly.com/
423	2301	1	historical	0	31	f	mymoneycottage.com	hello@mymoneycottage.com	1714547053146	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
425	2302	1	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1714547053850	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
426	2303	1	historical	0	38	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1714547054361	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
441	2304	1	historical	0	73	f	original.newsbreak.com	minalkh124@gmail.com	1714547055677	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
446	2305	1	historical	0	63	f	filmdaily.co	minalkh124@gmail.com	1714547060856	Maryam bibi	Inbound email	f	system	80	£	filmdaily.co
461	2306	1	historical	0	61	f	deskrush.com	minalkh124@gmail.com	1714547063238	Maryam bibi	Inbound email	f	system	160	£	deskrush.com
496	2307	1	historical	0	26	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1714547076849	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
471	2308	1	historical	0	21	f	realparent.co.uk	hello@contentmother.com	1714547077505	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
484	2309	1	historical	0	90	f	ibtimes.co.uk	i.perez@ibtmedia.co.uk	1714547090490	Inigo	inbound email	f	system	379	£	ibtimes.co.uk
493	2310	1	historical	0	39	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1714547091105	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
414	2311	1	historical	0	20	f	joannavictoria.co.uk	joannabayford@gmail.com	1714547093147	Joanna Bayford	Facebook	f	system	50	£	https://www.joannavictoria.co.uk
470	2312	1	historical	0	28	f	realwedding.co.uk	hello@contentmother.com	1714547095937	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
474	2313	1	historical	0	20	f	lclarke.co.uk	hello@contentmother.com	1714547097273	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
483	2314	1	historical	0	31	f	packthepjs.com	tracey@packthepjs.com	1714547099348	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
502	2315	1	historical	0	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1714547100013	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
758	2316	1	chris.p@frontpageadvantage.com	1708604143276	48	f	beastbeauty.co.uk	falcobliek@gmail.com	1714547108131	Falco	Inbound	f	system	120	£	https://www.beastbeauty.co.uk/
516	2317	1	historical	0	40	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1714547115014	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
522	2318	1	historical	0	53	f	altcoininvestor.com	fazal.akbar@digitalczars.io	1714547118720	Fazal	Inbound Sam	f	system	96	£	altcoininvestor.com
523	2319	1	historical	0	33	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1714547120103	Fazal	Inbound Sam	f	system	120	£	www.daytradetheworld.com
524	2320	1	historical	0	38	f	travelbeginsat40.com	backlinsprovider@gmail.com	1714547120967	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
526	2321	1	historical	0	46	f	puretravel.com	backlinsprovider@gmail.com	1714547122570	David	Inbound Sam	f	system	160	£	www.puretravel.com
781	2322	1	chris.p@frontpageadvantage.com	1709033259858	52	f	kidsworldfun.com	enquiry@kidsworldfun.com	1714547124531	Limna	outbound	f	system	80	£	https://www.kidsworldfun.com/
535	2323	1	historical	0	56	f	ukbusinessforums.co.uk	natalilacanario@gmail.com	1714547136690	Natalila	Inbound Sam	f	system	170	£	ukbusinessforums.co.uk
538	2324	1	historical	0	59	f	4howtodo.com	natalilacanario@gmail.com	1714547140603	Natalila	Inbound Sam	f	system	170	£	4howtodo.com
371	2325	1	historical	0	26	f	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	1714547147078	Jennie Jordan	Inbound email	f	system	80	£	www.ricecakesandraisins.co.uk
384	2326	1	historical	0	42	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1714547150395	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
393	2327	1	historical	0	58	f	reallymissingsleep.com	kareneholloway@hotmail.com	1714547150990	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
407	2328	1	historical	0	27	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1714547153037	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
497	2329	1	historical	0	40	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1714547161971	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
303	2330	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1714547164588	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
517	2331	1	historical	0	25	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1714547170868	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
761	2332	1	sam.b@frontpageadvantage.com	1708615661584	36	f	holyroodpr.co.uk	falcobliek@gmail.com	1714547180302	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
763	2333	1	sam.b@frontpageadvantage.com	1708616008102	88	f	benzinga.com	falcobliek@gmail.com	1714550422970	Falco	Inbound	f	system	130	£	https://www.benzinga.com/
529	2334	1	historical	0	38	f	houseofcoco.net	backlinsprovider@gmail.com	1714550625991	David	Inbound Sam	f	system	150	£	houseofcoco.net
534	2335	1	historical	0	39	f	saddind.co.uk	natalilacanario@gmail.com	1714550629423	Natalila	Inbound Sam	f	system	175	£	saddind.co.uk
531	2352	1	historical	0	36	f	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1714584455449	Sophia Daniel	Inbound Sam	f	michael.l@frontpageadvantage.com	55	£	www.businessmanchester.co.uk
303	2425	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1715078095901	This is Owned by Chris :-)	Inbound email	f	michael.l@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
540	2664	1	historical	0	40	f	otsnews.co.uk	bhaiahsan799@gmail.com	1715170693353	Ashan	Inbound Sam	f	michael.l@frontpageadvantage.com	55	£	www.otsnews.co.uk
303	2672	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1715170839095	This is Owned by Chris :-)	Inbound email	f	michael.l@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
316	2685	1	historical	0	31	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1715171380277	Karl	Fatjoe	f	michael.l@frontpageadvantage.com	50	£	www.newvalleynews.co.uk
802	2713	1	chris.p@frontpageadvantage.com	1709122990978	53	t	wegmans.co.uk	sophiadaniel.co.uk@gmail.com	1715245661562	Sophia	outbound	f	chris.p@frontpageadvantage.com	80	£	https://wegmans.co.uk/
441	2736	1	historical	0	73	f	newsbreak.com	minalkh124@gmail.com	1715250997993	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	55	£	original.newsbreak.com
441	2742	1	historical	0	73	f	newsbreak.com	minalkh124@gmail.com	1715251181030	Maryam bibi	Inbound email	f	michael.l@frontpageadvantage.com	55	£	original.newsbreak.com
316	2743	1	historical	0	31	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1715251271311	Karl	Fatjoe	f	michael.l@frontpageadvantage.com	50	£	www.newvalleynews.co.uk
531	2744	1	historical	0	36	f	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1715251412324	Sophia Daniel	Inbound Sam	f	michael.l@frontpageadvantage.com	55	£	www.businessmanchester.co.uk
500	2745	1	historical	0	36	f	pat.org.uk	hello@pat.org.uk	1715251750738	Fazal	Inbound Sam	f	michael.l@frontpageadvantage.com	30	£	www.pat.org.uk
500	2746	1	historical	0	36	f	pat.org.uk	hello@pat.org.uk	1715251777857	Fazal	Inbound Sam	f	michael.l@frontpageadvantage.com	30	£	www.pat.org.uk
959	2836	1	chris.p@frontpageadvantage.com	1711533031802	46	f	talk-business.co.uk	backlinsprovider@gmail.com	1715255979258	David Smith	Inbound	f	michael.l@frontpageadvantage.com	115	£	https://www.talk-business.co.uk/
531	2871	1	historical	0	36	f	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1715328870609	Sophia Daniel	Inbound Sam	f	michael.l@frontpageadvantage.com	155	£	www.businessmanchester.co.uk
500	2872	1	historical	0	36	f	pat.org.uk	hello@pat.org.uk	1715328923713	Fazal	Inbound Sam	f	michael.l@frontpageadvantage.com	30	£	www.pat.org.uk
907	2877	1	sam.b@frontpageadvantage.com	1709719202025	61	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1715329631200	David warner 	Inbound	f	michael.l@frontpageadvantage.com	200	£	https://bmmagazine.co.uk/
357	3037	1	historical	0	55	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	1715871071541	Becky Freeman	Fatjoe	f	michael.l@frontpageadvantage.com	35	£	www.spiritedpuddlejumper.com
752	3080	1	chris.p@frontpageadvantage.com	1708082585011	60	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1715941075182	sophia daniel	Inbound	f	michael.l@frontpageadvantage.com	120	£	https://www.outdoorproject.com/
1052	3129	0	michael.l@frontpageadvantage.com	1716451324696	32	f	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	1716451324696	Louise	Outbound Facebook	f	\N	150	£	https://www.adventuresofayorkshiremum.co.uk/
1053	3130	0	michael.l@frontpageadvantage.com	1716451545373	38	f	emmareed.net	admin@emmareed.net	1716451545373	Emma Reed	Outbound Facebook	f	\N	100	£	https://emmareed.net/
1054	3131	0	michael.l@frontpageadvantage.com	1716451807667	27	f	flydriveexplore.com	Hello@flydrivexexplore.com	1716451807667	Marcus Williams 	Outbound Facebook	f	\N	80	£	https://www.flydriveexplore.com/
1055	3132	0	michael.l@frontpageadvantage.com	1716452047818	22	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1716452047818	Lindy	Outbound Facebook	f	\N	50	£	https://www.lindyloves.co.uk/
1056	3133	0	michael.l@frontpageadvantage.com	1716452285003	26	f	flyingfluskey.com	rosie@flyingfluskey.com	1716452285003	Rosie Fluskey 	Outbound Facebook	f	\N	250	£	https://www.flyingfluskey.com
1057	3134	0	michael.l@frontpageadvantage.com	1716452525532	48	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	1716452525532	Elaine Wilson 	Outbound Facebook	f	\N	150	£	https://eccentricengland.co.uk/
1058	3135	0	michael.l@frontpageadvantage.com	1716452780180	57	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1716452780180	Rowena Becker	Outbound Facebook	f	\N	175	£	https://mybalancingact.co.uk/
1059	3136	0	michael.l@frontpageadvantage.com	1716452853668	33	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1716452853668	Jacquie Hale	Outbound Facebook	f	\N	150	£	https://flashpackingfamily.com/
1060	3137	0	michael.l@frontpageadvantage.com	1716452913891	42	f	safarisafricana.com	jacquiehale75@gmail.com	1716452913891	Jacquie Hale	Outbound Facebook	f	\N	200	£	https://safarisafricana.com/
1061	3138	0	michael.l@frontpageadvantage.com	1716453125082	58	f	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	1716453125082	Sarah Dixon 	Outbound Facebook	f	\N	100	£	https://www.minimeandluxury.co.uk/
1062	3139	0	sam.b@frontpageadvantage.com	1716462238586	36	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1716462238586	Kiran Gupta	Inbound	f	\N	80	£	thebraggingmommy.com
1063	3140	0	sam.b@frontpageadvantage.com	1716462449737	37	f	grapevinebirmingham.com	kirangupta.outreach@gmail.com	1716462449737	Kiran Gupta	Inbound	f	\N	80	£	grapevinebirmingham.com
1060	3141	1	michael.l@frontpageadvantage.com	1716452913891	42	f	safarisafricana.com	jacquiehale75@gmail.com	1716568580180	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
1058	3142	1	michael.l@frontpageadvantage.com	1716452780180	57	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1716568580593	Rowena Becker	Outbound Facebook	f	system	175	£	https://mybalancingact.co.uk/
1054	3143	1	michael.l@frontpageadvantage.com	1716451807667	27	f	flydriveexplore.com	Hello@flydrivexexplore.com	1716568580888	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1052	3144	1	michael.l@frontpageadvantage.com	1716451324696	32	f	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	1716568581173	Louise	Outbound Facebook	f	system	150	£	https://www.adventuresofayorkshiremum.co.uk/
1061	3145	1	michael.l@frontpageadvantage.com	1716453125082	58	f	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	1716568581573	Sarah Dixon 	Outbound Facebook	f	system	100	£	https://www.minimeandluxury.co.uk/
1053	3146	1	michael.l@frontpageadvantage.com	1716451545373	38	f	emmareed.net	admin@emmareed.net	1716568581911	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
1056	3147	1	michael.l@frontpageadvantage.com	1716452285003	26	f	flyingfluskey.com	rosie@flyingfluskey.com	1716568582606	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
1059	3148	1	michael.l@frontpageadvantage.com	1716452853668	33	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1716568582877	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
1062	3149	1	sam.b@frontpageadvantage.com	1716462238586	36	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1716568583128	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
1055	3150	1	michael.l@frontpageadvantage.com	1716452047818	22	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1716568583359	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1057	3151	1	michael.l@frontpageadvantage.com	1716452525532	48	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	1716568583593	Elaine Wilson 	Outbound Facebook	f	system	150	£	https://eccentricengland.co.uk/
1063	3152	1	sam.b@frontpageadvantage.com	1716462449737	37	f	grapevinebirmingham.com	kirangupta.outreach@gmail.com	1716568583844	Kiran Gupta	Inbound	f	system	80	£	grapevinebirmingham.com
1002	3153	1	michael.l@frontpageadvantage.com	1713341748907	44	f	todaynews.co.uk	sophiadaniel.co.uk@gmail.com	1716578059914	Sophia	Inbound Michael	f	system	65	£	https://todaynews.co.uk/
952	3154	1	michael.l@frontpageadvantage.com	1710423264423	53	f	kemotech.co.uk	sophiadaniel.co.uk@gmail.com	1716578071733	sophia daniel 	Inbound Michael	f	system	250	£	https://kemotech.co.uk/
903	3155	1	sam.b@frontpageadvantage.com	1709718136681	50	f	therugbypaper.co.uk	backlinsprovider@gmail.com	1716578093632	David Smith 	Inbound	f	system	115	£	www.therugbypaper.co.uk
953	3156	1	michael.l@frontpageadvantage.com	1711012683237	41	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1716578094701	Sam	Outbound Chris	f	system	100	£	https://www.thecricketpaper.com/
902	3157	1	sam.b@frontpageadvantage.com	1709717920944	35	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1716578117705	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
954	3158	1	michael.l@frontpageadvantage.com	1711012828815	50	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1716578119475	Sam	Outbound Chris	f	system	100	£	https://www.thenonleaguefootballpaper.com/
955	3159	1	michael.l@frontpageadvantage.com	1711012971138	27	f	latetacklemagazine.com	sam.emery@greenwayspublishing.com	1716578120870	Sam	Outbound Chris	f	system	100	£	https://www.latetacklemagazine.com/
904	3160	1	sam.b@frontpageadvantage.com	1709718289226	38	f	theleaguepaper.com	sam.emery@greenwayspublishing.com	1716578128354	Sam	Outbound Chris	f	system	100	£	www.theleaguepaper.com
905	3161	1	sam.b@frontpageadvantage.com	1709718547266	48	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1716578142609	David warner 	Inbound	f	system	150	£	https://www.luxurylifestylemag.co.uk/
906	3162	1	sam.b@frontpageadvantage.com	1709718918993	45	f	liverpoolway.co.uk	kenditoys.com@gmail.com	1716578184930	David warner 	Inbound	f	system	142	£	https://www.liverpoolway.co.uk/
441	3163	1	historical	0	74	f	newsbreak.com	minalkh124@gmail.com	1716578217154	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
907	3164	1	sam.b@frontpageadvantage.com	1709719202025	62	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1716578302249	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
808	3165	1	sam.b@frontpageadvantage.com	1709637089134	21	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1716578304139	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
959	3166	1	chris.p@frontpageadvantage.com	1711533031802	47	f	talk-business.co.uk	backlinsprovider@gmail.com	1716578324866	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
909	3167	1	sam.b@frontpageadvantage.com	1709720316064	59	f	blogstory.co.uk	kenditoys.com@gmail.com	1716578340448	David warner 	Inbound	f	system	125	£	https://blogstory.co.uk/
652	3168	1	chris.p@frontpageadvantage.com	0	40	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1717210801968	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
316	3169	1	historical	0	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1717210803050	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
752	3170	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1717210804453	sophia daniel	Inbound	f	system	120	£	https://www.outdoorproject.com/
785	3171	1	chris.p@frontpageadvantage.com	1709035573894	58	f	theassistant.io	infopediapros@gmail.com	1717210808902	Ricardo	inbound	f	system	45	£	theassistant.io
323	3172	1	historical	0	28	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1717210823482	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
1002	3173	1	michael.l@frontpageadvantage.com	1713341748907	43	f	todaynews.co.uk	sophiadaniel.co.uk@gmail.com	1717210828778	Sophia	Inbound Michael	f	system	65	£	https://todaynews.co.uk/
784	3174	1	chris.p@frontpageadvantage.com	1709035290025	34	f	okaybliss.com	infopediapros@gmail.com	1717210839126	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
787	3175	1	sam.b@frontpageadvantage.com	1709041586393	38	f	netizensreport.com	premium@rabbiitfirm.com	1717210845052	Mojammel	Inbound	f	system	120	£	netizensreport.com
765	3176	1	sam.b@frontpageadvantage.com	1708616408925	45	f	storymirror.com	ela690000@gmail.com	1717210863230	Ella	Inbound	f	system	96	£	https://storymirror.com/
489	3177	1	historical	0	71	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1717210864093	Claire James	Inbound Sam	f	system	60	£	www.abcmoney.co.uk
953	3178	1	michael.l@frontpageadvantage.com	1711012683237	40	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1717210866056	Sam	Outbound Chris	f	system	100	£	https://www.thecricketpaper.com/
702	3179	1	michael.l@frontpageadvantage.com	1708008300694	37	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1717210867418	Front Page Advantage	Email	f	system	10	£	https://frontpageadvantage.com/
405	3180	1	historical	0	36	f	prettybigbutterflies.com	prettybigbutterflies@gmail.com	1717210868406	Hollie	Inbound email	f	system	80	£	www.prettybigbutterflies.com
459	3181	1	historical	0	56	f	digitalengineland.com	minalkh124@gmail.com	1717210873101	Maryam bibi	Inbound email	f	system	120	£	digitalengineland.com
775	3182	1	chris.p@frontpageadvantage.com	1709031235193	27	f	followthefashion.org	bhaiahsan799@gmail.com	1717210881209	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
655	3183	1	chris.p@frontpageadvantage.com	0	43	f	forgetfulmomma.com	info@morningbusinesschat.com	1717210891239	Brett Napoli	Inbound	f	system	225	£	https://www.forgetfulmomma.com/
803	3184	1	chris.p@frontpageadvantage.com	1709123162304	47	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1717210895690	Sophia	Inbound	f	system	60	£	https://smihub.co.uk/
902	3185	1	sam.b@frontpageadvantage.com	1709717920944	36	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1717210896286	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
904	3186	1	sam.b@frontpageadvantage.com	1709718289226	37	f	theleaguepaper.com	sam.emery@greenwayspublishing.com	1717210903339	Sam	Outbound Chris	f	system	100	£	www.theleaguepaper.com
324	3187	1	historical	0	13	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1717210906745	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
776	3188	1	chris.p@frontpageadvantage.com	1709032440217	60	f	petdogplanet.com	bhaiahsan799@gmail.com	1717210908311	Ashan	inbound	f	system	60	£	www.petdogplanet.com
778	3189	1	chris.p@frontpageadvantage.com	1709032760082	25	f	suntrics.com	suntrics4u@gmail.com	1717210911438	Suntrics	outbound	f	system	40	£	https://suntrics.com/
304	3190	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1717210914087	UKNEWS Group	Inbound email	f	system	50	£	https://www.uknewsgroup.co.uk/
780	3191	1	chris.p@frontpageadvantage.com	1709033136922	24	f	travelistia.com	travelistiausa@gmail.com	1717210924914	Ferona	outbound	f	system	40	£	https://www.travelistia.com/
957	3192	1	chris.p@frontpageadvantage.com	1711532679719	46	f	north.wales	backlinsprovider@gmail.com	1717210925905	David Smith	Inbound	f	system	95	£	https://north.wales/
313	3193	1	historical	0	20	f	slashercareer.com	tanya@slashercareer.com	1717210932148	Tanya	Fatjoe	f	system	90	£	slashercareer.com
330	3194	1	historical	0	36	f	robinwaite.com	robin@robinwaite.com	1717210932996	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
335	3195	1	historical	0	20	f	lillaloves.com	lillaallahiary@gmail.com	1717210935559	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
358	3196	1	historical	0	32	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1717210937172	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
309	3197	1	historical	0	15	f	annabelwrites.com	annabelwrites.blog@gmail.com	1717210942741	Annabel	Fatjoe	f	system	20	£	annabelwrites.com
326	3198	1	historical	0	22	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1717210946282	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
329	3199	1	historical	0	41	f	wemadethislife.com	wemadethislife@outlook.com	1717210949551	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
307	3200	1	historical	0	13	f	peterwynmosey.com	contact@peterwynmosey.com	1717210956991	Peter	Fatjoe	f	system	15	£	peterwynmosey.com
340	3201	1	historical	0	35	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1717210962239	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
342	3202	1	historical	0	35	f	karlismyunkle.com	karlismyunkle@gmail.com	1717210966748	Nik Thakkar	Fatjoe	f	system	65	£	www.karlismyunkle.com
345	3203	1	historical	0	16	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1717210968968	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
320	3204	1	historical	0	30	f	practicalfrugality.com	hello@practicalfrugality.com	1717210975048	Magdalena	Fatjoe	f	system	38	£	www.practicalfrugality.com
353	3205	1	historical	0	17	f	lingermagazine.com	info@lingermagazine.com	1717210981304	Tiffany Tate	Fatjoe	f	system	82	£	https://www.lingermagazine.com/
456	3206	1	historical	0	52	f	urbanmatter.com	minalkh124@gmail.com	1717210983293	Maryam bibi	Inbound email	f	system	110	£	urbanmatter.com
360	3207	1	historical	0	40	f	rachelbustin.com	rachel@rachelbustin.com	1717210985915	Rachel Bustin	Fatjoe	f	system	85	£	https://rachelbustin.com
366	3208	1	historical	0	47	f	barbaraiweins.com	info@barbaraiweins.com	1717210989253	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
367	3209	1	historical	0	22	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1717210992594	Amy Walsh	Inbound email	f	system	40	£	cocktailsinteacups.com
368	3210	1	historical	0	56	f	justeilidh.com	just.eilidhg@gmail.com	1717210994531	Eilidh	Inbound email	f	system	100	£	www.justeilidh.com
361	3211	1	historical	0	58	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	1717210995344	Erica Hughes	Fatjoe	f	system	125	£	https://alittleluxuryfor.me/
365	3212	1	historical	0	38	f	letstalkmommy.com	jenny@letstalkmommy.com	1717210996384	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
374	3213	1	historical	0	67	f	simslife.co.uk	sim@simslife.co.uk	1717210997501	Sim Riches	Fatjoe	f	system	90	£	https://simslife.co.uk
372	3214	1	historical	0	37	f	fashion-mommy.com	fashionmommywm@gmail.com	1717210998456	emma iannarilli	Inbound email	f	system	85	£	fashion-mommy.com
377	3215	1	historical	0	28	f	travelvixta.com	victoria@travelvixta.com	1717210999374	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
385	3216	1	historical	0	42	f	motherhoodtherealdeal.com	motherhoodtherealdeal@gmail.com	1717211000493	Taiya	Inbound email	f	system	85	£	Https://www.motherhoodtherealdeal.com
398	3217	1	historical	0	24	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1717211004406	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
379	3218	1	historical	0	27	f	yeahlifestyle.com	info@yeahlifestyle.com	1717211005193	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
383	3219	1	historical	0	40	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1717211007219	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
406	3220	1	historical	0	29	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1717211010814	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
373	3221	1	historical	0	32	f	kateonthinice.com	kateonthinice1@gmail.com	1717211012620	Kate Holmes	Inbound email	f	system	75	£	kateonthinice.com
375	3222	1	historical	0	23	f	clairemac.co.uk	clairemacblog@gmail.com	1717211013525	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
378	3223	1	historical	0	26	f	healthyvix.com	victoria@healthyvix.com	1717211014635	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
381	3224	1	historical	0	36	f	therarewelshbit.com	kacie@therarewelshbit.com	1717211015494	Kacie Morgan	Inbound email	f	system	200	£	www.therarewelshbit.com
382	3225	1	historical	0	31	f	stressedmum.co.uk	sam@stressedmum.co.uk	1717211016515	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
400	3226	1	historical	0	33	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	1717211025534	Christopher	Inbound email	f	system	79	£	https://estateagentnetworking.co.uk/
401	3227	1	historical	0	31	f	marketme.co.uk	christopher@marketme.co.uk	1717211026524	Christopher	Inbound email	f	system	59	£	https://marketme.co.uk/
408	3228	1	historical	0	20	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1717211027576	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
410	3229	1	historical	0	24	f	realgirlswobble.com	rohmankatrina@gmail.com	1717211031995	Katrina Rohman	Facebook	f	system	50	£	https://realgirlswobble.com/
389	3230	1	historical	0	32	f	arthurwears.com	Arthurwears.email@gmail.com	1717211032985	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
390	3231	1	historical	0	35	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1717211039932	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
395	3232	1	historical	0	33	f	missmanypennies.com	hello@missmanypennies.com	1717211041043	Hayley	Inbound email	f	system	85	£	www.missmanypennies.com
453	3233	1	historical	0	66	f	techbullion.com	angelascottbriggs@techbullion.com	1717211045571	Angela Scott-Briggs 	Inbound email	f	system	100	£	http://techbullion.com
442	3234	1	historical	0	63	f	wheon.com	minalkh124@gmail.com	1717211048087	Maryam bibi	Inbound email	f	system	70	£	wheon.com
412	3235	1	historical	0	29	f	laurakatelucas.com	laurakatelucas@hotmail.com	1717211051419	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
418	3236	1	historical	0	39	f	amumreviews.co.uk	contact@amumreviews.co.uk	1717211052796	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
428	3237	1	historical	0	55	f	modernguy.co.uk	modguyinfo@gmail.com	1717211056149	Modern Guy	Facebook	f	system	103	£	Modernguy.co.uk
441	3238	1	historical	0	68	f	newsbreak.com	minalkh124@gmail.com	1717211059127	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
432	3239	1	historical	0	39	f	lyliarose.com	victoria@lyliarose.com	1717211060838	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
420	3240	1	historical	0	32	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1717211069452	Anna	Facebook	f	system	150	£	https://www.dontcrampmystyle.co.uk
421	3241	1	historical	0	47	f	glassofbubbly.com	christopher@marketme.co.uk	1717211070335	Christopher	Inbound email	f	system	125	£	https://glassofbubbly.com/
415	3242	1	historical	0	31	f	aaublog.com	rebecca@aaublog.com	1717211078884	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
417	3243	1	historical	0	45	f	globalmousetravels.com	hello@globalmousetravels.com	1717211079705	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
419	3244	1	historical	0	31	f	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	1717211080647	Ana	Facebook	f	system	100	£	https://fadedspring.co.uk/
449	3245	1	historical	0	47	f	urbansplatter.com	minalkh124@gmail.com	1717211081763	Maryam bibi	Inbound email	f	system	85	£	https://www.urbansplatter.com/
443	3246	1	historical	0	81	f	fooyoh.com	minalkh124@gmail.com	1717211088626	Maryam bibi	Inbound email	f	system	80	£	fooyoh.com
463	3247	1	historical	0	44	f	vizaca.com	minalkh124@gmail.com	1717211090366	Maryam bibi	Inbound email	f	system	190	£	vizaca.com
460	3248	1	historical	0	28	f	techacrobat.com	minalkh124@gmail.com	1717211098119	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
465	3249	1	historical	0	81	f	goodmenproject.com	minalkh124@gmail.com	1717211100164	Maryam bibi	Inbound email	f	system	220	£	http://goodmenproject.com
500	3250	1	historical	0	37	f	pat.org.uk	hello@pat.org.uk	1717211102211	Fazal	Inbound Sam	f	system	30	£	www.pat.org.uk
499	3251	1	historical	0	58	f	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	1717211109572	Fazal	Inbound Sam	f	system	144	£	www.lifestyledaily.co.uk
475	3252	1	historical	0	15	f	quick-house-sales.com	hello@contentmother.com	1717211111369	Becky	inbound email	f	system	45	£	https://www.quick-house-sales.com
505	3253	1	historical	0	28	f	talk-retail.co.uk	backlinsprovider@gmail.com	1717211112584	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
484	3254	1	historical	0	89	f	ibtimes.co.uk	i.perez@ibtmedia.co.uk	1717211119267	Inigo	inbound email	f	system	379	£	ibtimes.co.uk
493	3255	1	historical	0	37	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1717211120241	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
470	3256	1	historical	0	23	f	realwedding.co.uk	hello@contentmother.com	1717211122624	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
474	3257	1	historical	0	21	f	lclarke.co.uk	hello@contentmother.com	1717211123964	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
494	3258	1	historical	0	53	f	mikemyers.co.uk	fazal.akbar@digitalczars.io	1717211125738	Fazal	Inbound Sam	f	system	168	£	mikemyers.co.uk
502	3259	1	historical	0	31	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1717211130812	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
391	3260	1	historical	0	45	f	conversanttraveller.com	heather@conversanttraveller.com	1717211132191	Heather	Inbound email	f	system	180	£	www.conversanttraveller.com
469	3261	1	historical	0	47	f	retailtechinnovationhub.com	minalkh124@gmail.com	1717211133441	Maryam bibi	Inbound email	f	system	280	£	retailtechinnovationhub.com
477	3262	1	historical	0	17	f	rocketandrelish.com	hello@contentmother.com	1717211135309	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
509	3263	1	historical	0	71	f	glasgowarchitecture.co.uk	fazal.akbar@digitalczars.io	1717211139443	Fazal	Inbound Sam	f	system	114	£	www.glasgowarchitecture.co.uk
434	3264	1	historical	0	24	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1717211143799	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
540	3265	1	historical	0	41	f	otsnews.co.uk	bhaiahsan799@gmail.com	1717211155149	Ashan	Inbound Sam	f	system	55	£	www.otsnews.co.uk
525	3266	1	historical	0	60	f	traveldailynews.com	backlinsprovider@gmail.com	1717211156214	David	Inbound Sam	f	system	150	£	www.traveldailynews.com
808	3267	1	sam.b@frontpageadvantage.com	1709637089134	22	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1717211157495	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
531	3268	1	historical	0	37	f	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1717211158264	Sophia Daniel	Inbound Sam	f	system	155	£	www.businessmanchester.co.uk
521	3269	1	historical	0	21	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1717211165312	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
516	3270	1	historical	0	34	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1717211166330	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
522	3271	1	historical	0	54	f	altcoininvestor.com	fazal.akbar@digitalczars.io	1717211169834	Fazal	Inbound Sam	f	system	96	£	altcoininvestor.com
523	3272	1	historical	0	36	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1717211171878	Fazal	Inbound Sam	f	system	120	£	www.daytradetheworld.com
524	3273	1	historical	0	37	f	travelbeginsat40.com	backlinsprovider@gmail.com	1717211173000	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
526	3274	1	historical	0	45	f	puretravel.com	backlinsprovider@gmail.com	1717211174646	David	Inbound Sam	f	system	160	£	www.puretravel.com
781	3275	1	chris.p@frontpageadvantage.com	1709033259858	48	f	kidsworldfun.com	enquiry@kidsworldfun.com	1717211176842	Limna	outbound	f	system	80	£	https://www.kidsworldfun.com/
537	3276	1	historical	0	53	f	technoloss.com	natalilacanario@gmail.com	1717211182513	Natalila	Inbound Sam	f	system	155	£	technoloss.com
527	3277	1	historical	0	52	f	ourculturemag.com	info@ourculturemag.com	1717211183463	Info	Inbound Sam	f	system	115	£	ourculturemag.com
782	3278	1	chris.p@frontpageadvantage.com	1709033531454	30	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1717211186327	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
959	3279	1	chris.p@frontpageadvantage.com	1711533031802	46	f	talk-business.co.uk	backlinsprovider@gmail.com	1717211192390	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
458	3280	1	historical	0	74	f	spacecoastdaily.com	minalkh124@gmail.com	1717211200388	Maryam bibi	Inbound email	f	system	120	£	https://spacecoastdaily.com/
467	3281	1	historical	0	58	f	underconstructionpage.com	minalkh124@gmail.com	1717211201824	Maryam bibi	Inbound email	f	system	230	£	http://underconstructionpage.com
476	3282	1	historical	0	13	f	contentmother.com	hello@contentmother.com	1717211203595	Becky	inbound email	f	system	45	£	https://www.contentmother.com
517	3283	1	historical	0	23	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1717211206358	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
511	3284	1	historical	0	73	f	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	1717211207169	Fazal	Inbound Sam	f	system	132	£	www.edinburgharchitecture.co.uk
809	3285	1	sam.b@frontpageadvantage.com	1709637625007	52	f	pierdom.com	info@pierdom.com	1717211209357	Junaid	Outbound	f	system	25	£	https://pierdom.com/
384	3286	1	historical	0	39	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1717211213804	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
407	3287	1	historical	0	22	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1717211216275	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
497	3288	1	historical	0	33	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1717211217185	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
539	3289	1	historical	0	58	f	tamilworlds.com	natalilacanario@gmail.com	1717211222719	Natalila	Inbound Sam	f	system	150	£	Tamilworlds.com
322	3290	1	historical	0	31	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1717211225293	David	Fatjoe	f	system	45	£	5thingstodotoday.com
771	3291	1	chris.p@frontpageadvantage.com	1709027801990	44	f	finehomesandliving.com	info@fine-magazine.com	1717211231120	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
770	3292	1	chris.p@frontpageadvantage.com	1709027700111	58	f	valiantceo.com	staff@valiantceo.com	1717211237392	Valiantstaff	outbound	f	system	70	£	https://valiantceo.com/
451	3293	1	historical	0	74	f	marketbusinessnews.com	Imjustwebworld@gmail.com	1717297290114	Harshil	Inbound email	f	system	99	£	marketbusinessnews.com
334	3294	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1717297299323	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
337	3295	1	historical	0	25	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1717297306702	Al Baker	Fatjoe	f	system	40	£	www.thepennypincher.co.uk
402	3296	1	historical	0	59	f	mammaprada.com	mammaprada@gmail.com	1717297347001	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
409	3297	1	historical	0	30	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1717297347825	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
392	3298	1	historical	0	40	f	midlandstraveller.com	contact@midlandstraveller.com	1717297348734	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
397	3299	1	historical	0	60	f	emmaplusthree.com	emmaplusthree@gmail.com	1717297353469	Emma Easton	Inbound email	f	system	100	£	www.emmaplusthree.com
440	3300	1	historical	0	64	f	ventsmagazine.com	minalkh124@gmail.com	1717297393246	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
423	3301	1	historical	0	28	f	mymoneycottage.com	hello@mymoneycottage.com	1717297394247	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
425	3302	1	historical	0	32	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1717297395254	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
426	3303	1	historical	0	35	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1717297396361	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
445	3304	1	historical	0	61	f	networkustad.com	minalkh124@gmail.com	1717297398426	Maryam bibi	Inbound email	f	system	80	£	networkustad.com
495	3305	1	historical	0	59	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1717297431433	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
758	3306	1	chris.p@frontpageadvantage.com	1708604143276	49	f	beastbeauty.co.uk	falcobliek@gmail.com	1717297451555	Falco	Inbound	f	system	120	£	https://www.beastbeauty.co.uk/
1064	3307	0	chris.p@frontpageadvantage.com	1717491149032	31	f	enterpriseleague.com	info@enterpriseleague.com	1717491149032	Irina	outbound	f	\N	280	£	https://enterpriseleague.com/
1064	3308	1	chris.p@frontpageadvantage.com	1717491149032	31	f	enterpriseleague.com	info@enterpriseleague.com	1717491153322	Irina	outbound	f	system	280	£	https://enterpriseleague.com/
461	3929	1	historical	0	61	t	deskrush.com	minalkh124@gmail.com	1718366905922	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	160	£	deskrush.com
803	3320	1	chris.p@frontpageadvantage.com	1709123162304	47	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1717749806690	Sophia	Inbound	f	michael.l@frontpageadvantage.com	60	£	https://smihub.co.uk/
326	3380	1	historical	0	22	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1717758448046	Lisa Ventura MBE	Fatjoe	f	michael.l@frontpageadvantage.com	30	£	https://www.cybergeekgirl.co.uk
1065	3399	0	chris.p@frontpageadvantage.com	1718109354711	0	f	\N	\N	1718109354711	Fatjoe	\N	t	\N	0	\N	\N
1066	3400	0	chris.p@frontpageadvantage.com	1718109368739	0	f	\N	\N	1718109368739	Fatjoe	\N	t	\N	0	\N	\N
1002	3465	1	michael.l@frontpageadvantage.com	1713341748907	43	f	todaynews.co.uk	sophiadaniel.co.uk@gmail.com	1718179236285	Sophia	Inbound Michael	f	michael.l@frontpageadvantage.com	65	£	https://todaynews.co.uk/
1002	3557	1	michael.l@frontpageadvantage.com	1713341748907	43	f	todaynews.co.uk	sophiadaniel.co.uk@gmail.com	1718194142394	Sophia	Inbound Michael	f	michael.l@frontpageadvantage.com	85	£	https://todaynews.co.uk/
1067	3655	0	chris.p@frontpageadvantage.com	1718272062687	0	f	\N	\N	1718272062687	test	\N	t	\N	0	\N	\N
392	3667	1	historical	0	40	f	midlandstraveller.com	contact@midlandstraveller.com	1718273140910	Simone Ribeiro	Inbound email	f	michael.l@frontpageadvantage.com	50	£	www.midlandstraveller.com
392	3671	1	historical	0	40	f	midlandstraveller.com	contact@midlandstraveller.com	1718273286868	Simone Ribeiro	Inbound email	f	michael.l@frontpageadvantage.com	50	£	www.midlandstraveller.com
312	3672	1	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1718273354681	Abbie	Fatjoe	f	michael.l@frontpageadvantage.com	45	£	mmbmagazine.co.uk
312	3673	1	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1718273397496	Abbie	Fatjoe	f	michael.l@frontpageadvantage.com	45	£	mmbmagazine.co.uk
331	3678	1	historical	0	33	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1718273534542	Angela Riches	Fatjoe	f	michael.l@frontpageadvantage.com	40	£	www.hnmagazine.co.uk
1068	3717	0	chris.p@frontpageadvantage.com	1718281427105	0	f	\N	\N	1718281427105	Fatjoe test	\N	t	\N	0	\N	\N
1068	3720	1	chris.p@frontpageadvantage.com	1718281427105	11	f	theuselessweb.com	\N	1718281490906	Fatjoe test	\N	t	chris.p@frontpageadvantage.com	23	£	https://theuselessweb.com
776	3723	1	chris.p@frontpageadvantage.com	1709032440217	60	t	petdogplanet.com	bhaiahsan799@gmail.com	1718282119986	Ashan	inbound	f	chris.p@frontpageadvantage.com	60	£	www.petdogplanet.com
363	3724	1	historical	0	61	t	justwebworld.com	imjustwebworld@gmail.com	1718282155681	Harshil	Fatjoe	f	chris.p@frontpageadvantage.com	99	£	https://justwebworld.com/
489	3725	1	historical	0	71	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1718282426526	Claire James	Inbound Sam	f	james.p@frontpageadvantage.com	60	£	www.abcmoney.co.uk
452	3729	1	historical	0	66	f	bignewsnetwork.com	minalkh124@gmail.com	1718282827381	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	100	£	bignewsnetwork.com
468	3730	1	historical	0	92	f	apnews.com	minalkh124@gmail.com	1718282970612	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	240	£	apnews.com
465	3735	1	historical	0	81	f	goodmenproject.com	minalkh124@gmail.com	1718283029024	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	220	£	http://goodmenproject.com
458	3740	1	historical	0	74	f	spacecoastdaily.com	minalkh124@gmail.com	1718283131912	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	120	£	https://spacecoastdaily.com/
304	3754	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1718283919632	UKNEWS Group	Inbound email	f	michael.l@frontpageadvantage.com	50	£	https://www.uknewsgroup.co.uk/
307	3755	1	historical	0	13	t	peterwynmosey.com	contact@peterwynmosey.com	1718283964819	Peter	Fatjoe	f	james.p@frontpageadvantage.com	15	£	peterwynmosey.com
309	3756	1	historical	0	15	t	annabelwrites.com	annabelwrites.blog@gmail.com	1718283984529	Annabel	Fatjoe	f	james.p@frontpageadvantage.com	20	£	annabelwrites.com
328	3757	1	historical	0	24	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1718284010360	Emma	Fatjoe	f	michael.l@frontpageadvantage.com	70	£	www.beemoneysavvy.com
475	3759	1	historical	0	15	t	quick-house-sales.com	hello@contentmother.com	1718284198908	Becky	inbound email	f	james.p@frontpageadvantage.com	45	£	https://www.quick-house-sales.com
354	3760	1	historical	0	43	t	businesspartnermagazine.com	info@businesspartnermagazine.com	1718284210838	Sandra Hinshelwood	Fatjoe	f	james.p@frontpageadvantage.com	19	£	https://businesspartnermagazine.com/
787	3767	1	sam.b@frontpageadvantage.com	1709041586393	38	f	netizensreport.com	premium@rabbiitfirm.com	1718284759060	Mojammel	Inbound	f	james.p@frontpageadvantage.com	120	£	netizensreport.com
334	3770	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1718284938422	Sally Allsop	Fatjoe	f	james.p@frontpageadvantage.com	60	£	www.lifeloving.co.uk
1065	3881	1	chris.p@frontpageadvantage.com	1718109354711	33	f	cocktailswithmom.com	\N	1718356436096	Fatjoe	\N	t	chris.p@frontpageadvantage.com	130	£	https://cocktailswithmom.com
1066	3883	1	chris.p@frontpageadvantage.com	1718109368739	28	f	timesinternational.net	\N	1718356477146	Fatjoe	\N	t	chris.p@frontpageadvantage.com	130	£	https://timesinternational.net
437	3919	1	historical	0	54	t	techbehindit.com	minalkh124@gmail.com	1718366857704	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	55	£	techbehindit.com
443	3920	1	historical	0	81	t	fooyoh.com	minalkh124@gmail.com	1718366870997	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	fooyoh.com
445	3921	1	historical	0	61	t	networkustad.com	minalkh124@gmail.com	1718366875618	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	networkustad.com
446	3922	1	historical	0	63	t	filmdaily.co	minalkh124@gmail.com	1718366879421	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	filmdaily.co
450	3923	1	historical	0	54	t	zomgcandy.com	minalkh124@gmail.com	1718366882905	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	90	£	zomgcandy.com
454	3924	1	historical	0	62	t	whatsnew2day.com	minalkh124@gmail.com	1718366886357	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	100	£	whatsnew2day.com
455	3925	1	historical	0	57	t	programminginsider.com	minalkh124@gmail.com	1718366889849	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	100	£	programminginsider.com
456	3926	1	historical	0	52	t	urbanmatter.com	minalkh124@gmail.com	1718366893752	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	110	£	urbanmatter.com
457	3927	1	historical	0	54	t	techktimes.com	minalkh124@gmail.com	1718366898669	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	110	£	http://techktimes.com/
459	3928	1	historical	0	56	t	digitalengineland.com	minalkh124@gmail.com	1718366902112	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	120	£	digitalengineland.com
536	3933	1	historical	0	55	t	hildenbrewing.com	natalilacanario@gmail.com	1718366922093	Natalila	Inbound Sam	f	chris.p@frontpageadvantage.com	170	£	hildenbrewing.com
537	3934	1	historical	0	53	t	technoloss.com	natalilacanario@gmail.com	1718366925459	Natalila	Inbound Sam	f	chris.p@frontpageadvantage.com	155	£	technoloss.com
538	3935	1	historical	0	59	t	4howtodo.com	natalilacanario@gmail.com	1718366929266	Natalila	Inbound Sam	f	chris.p@frontpageadvantage.com	170	£	4howtodo.com
485	3936	1	historical	0	59	t	gudstory.com	sophiadaniel.co.uk@gmail.com	1718366938880	Sophia	Inbound Sam	f	chris.p@frontpageadvantage.com	150	£	www.gudstory.com
464	3930	1	historical	0	54	t	startup.info	minalkh124@gmail.com	1718366909767	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	200	£	startup.info
482	3931	1	historical	0	55	t	entrepreneursbreak.com	minalkh124@gmail.com	1718366913949	Maryam bibi	inbound email	f	chris.p@frontpageadvantage.com	80	£	https://entrepreneursbreak.com/
494	3932	1	historical	0	53	t	mikemyers.co.uk	fazal.akbar@digitalczars.io	1718366918378	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	168	£	mikemyers.co.uk
754	3937	1	michael.l@frontpageadvantage.com	1708084929950	63	t	techsslash.com	sophiadaniel.co.uk@gmail.com	1718366942750	Sophia Daniel 	Inbound Email	f	chris.p@frontpageadvantage.com	150	£	https://techsslash.com
772	3938	1	chris.p@frontpageadvantage.com	1709027922451	56	t	thetecheducation.com	ela690000@gmail.com	1718366946757	Ela	inbound	f	chris.p@frontpageadvantage.com	100	£	https://thetecheducation.com/
442	3939	1	historical	0	63	t	wheon.com	minalkh124@gmail.com	1718366950144	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	70	£	wheon.com
786	3940	1	chris.p@frontpageadvantage.com	1709035655140	60	t	stylesrant.com	infopediapros@gmail.com	1718366953398	Ricardo	inbound	f	chris.p@frontpageadvantage.com	45	£	https://www.stylesrant.com/
785	3941	1	chris.p@frontpageadvantage.com	1709035573894	58	t	theassistant.io	infopediapros@gmail.com	1718366956751	Ricardo	inbound	f	chris.p@frontpageadvantage.com	45	£	theassistant.io
463	3942	1	historical	0	44	t	vizaca.com	minalkh124@gmail.com	1718367461325	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	190	£	vizaca.com
469	3943	1	historical	0	47	t	retailtechinnovationhub.com	minalkh124@gmail.com	1718367470158	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	280	£	retailtechinnovationhub.com
442	3944	1	historical	0	63	t	wheon.com	minalkh124@gmail.com	1718367478662	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	70	£	wheon.com
509	3945	1	historical	0	71	t	glasgowarchitecture.co.uk	fazal.akbar@digitalczars.io	1718367486663	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	114	£	www.glasgowarchitecture.co.uk
511	3946	1	historical	0	73	t	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	1718367489944	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	132	£	www.edinburgharchitecture.co.uk
522	3947	1	historical	0	54	t	altcoininvestor.com	fazal.akbar@digitalczars.io	1718367493269	Fazal	Inbound Sam	f	chris.p@frontpageadvantage.com	96	£	altcoininvestor.com
488	3948	1	historical	0	59	t	computertechreviews.com	kamransharief@gmail.com	1718367496112	Sophia	Inbound Sam	f	chris.p@frontpageadvantage.com	100	£	computertechreviews.com
758	3949	1	chris.p@frontpageadvantage.com	1708604143276	49	t	beastbeauty.co.uk	falcobliek@gmail.com	1718367499476	Falco	Inbound	f	chris.p@frontpageadvantage.com	120	£	https://www.beastbeauty.co.uk/
449	3950	1	historical	0	47	t	urbansplatter.com	minalkh124@gmail.com	1718367513245	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	85	£	https://www.urbansplatter.com/
1065	3951	1	chris.p@frontpageadvantage.com	1718109354711	33	t	cocktailswithmom.com	\N	1718368716021	Fatjoe	\N	t	james.p@frontpageadvantage.com	130	£	https://cocktailswithmom.com
1065	3952	1	chris.p@frontpageadvantage.com	1718109354711	33	f	cocktailswithmom.com	\N	1718368732105	Fatjoe	\N	t	james.p@frontpageadvantage.com	130	£	https://cocktailswithmom.com
1065	3953	1	chris.p@frontpageadvantage.com	1718109354711	33	f	cocktailswithmom.com	deebat@cocktailswithmom.com	1718368801740	Dee Marie	Fatjoe	t	james.p@frontpageadvantage.com	118	£	https://cocktailswithmom.com
1002	3959	1	michael.l@frontpageadvantage.com	1713341748907	43	f	todaynews.co.uk	david@todaynews.co.uk	1718376438692	Sophia	Inbound Michael	f	michael.l@frontpageadvantage.com	65	£	https://todaynews.co.uk/
1002	3960	1	michael.l@frontpageadvantage.com	1713341748907	43	f	todaynews.co.uk	david@todaynews.co.uk	1718376728856	David	Inbound Michael	f	michael.l@frontpageadvantage.com	65	£	https://todaynews.co.uk/
368	4021	1	historical	0	56	f	justeilidh.com	just.eilidhg@gmail.com	1718631499731	Eilidh	Inbound email	f	michael.l@frontpageadvantage.com	100	£	www.justeilidh.com
374	4044	1	historical	0	67	f	simslife.co.uk	sim@simslife.co.uk	1718896115043	Sim Riches	Fatjoe	f	michael.l@frontpageadvantage.com	130	£	https://simslife.co.uk
451	4045	1	historical	0	74	f	marketbusinessnews.com	Imjustwebworld@gmail.com	1718896145465	Harshil	Inbound email	f	michael.l@frontpageadvantage.com	99	£	marketbusinessnews.com
448	4067	1	historical	0	50	t	gisuser.com	minalkh124@gmail.com	1718975343762	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	80	£	Gisuser.com
428	4068	1	historical	0	55	t	modernguy.co.uk	modguyinfo@gmail.com	1718975351183	Modern Guy	Facebook	f	chris.p@frontpageadvantage.com	103	£	Modernguy.co.uk
539	4069	1	historical	0	58	t	tamilworlds.com	natalilacanario@gmail.com	1718975358204	Natalila	Inbound Sam	f	chris.p@frontpageadvantage.com	150	£	Tamilworlds.com
1069	4077	0	sam.b@frontpageadvantage.com	1719317784130	28	f	caranalytics.co.uk	katherine@orangeoutreach.com	1719317784130	Katherine Williams	Inbound	f	\N	150	£	caranalytics.co.uk
1069	4078	1	sam.b@frontpageadvantage.com	1719317784130	28	f	caranalytics.co.uk	katherine@orangeoutreach.com	1719317787092	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1070	4079	0	sam.b@frontpageadvantage.com	1719317894569	20	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1719317894569	Katherine Williams	Inbound	f	\N	125	£	theautoexperts.co.uk
1070	4080	1	sam.b@frontpageadvantage.com	1719317894569	20	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1719317897357	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1071	4081	0	sam.b@frontpageadvantage.com	1719318047364	31	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1719318047364	Katherine Williams	Inbound	f	\N	150	£	makemoneywithoutajob.com
1071	4082	1	sam.b@frontpageadvantage.com	1719318047364	31	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1719318051318	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1072	4083	0	sam.b@frontpageadvantage.com	1719318118234	45	f	warrington-worldwide.co.uk	katherine@orangeoutreach.com	1719318118234	Katherine Williams	Inbound	f	\N	150	£	warrington-worldwide.co.uk
1072	4084	1	sam.b@frontpageadvantage.com	1719318118234	45	f	warrington-worldwide.co.uk	katherine@orangeoutreach.com	1719318121169	Katherine Williams	Inbound	f	system	150	£	warrington-worldwide.co.uk
1073	4085	0	sam.b@frontpageadvantage.com	1719318221869	75	f	deadlinenews.co.uk	katherine@orangeoutreach.com	1719318221869	Katherine Williams	Inbound	f	\N	150	£	deadlinenews.co.uk
1073	4086	1	sam.b@frontpageadvantage.com	1719318221869	75	f	deadlinenews.co.uk	katherine@orangeoutreach.com	1719318224592	Katherine Williams	Inbound	f	system	150	£	deadlinenews.co.uk
1074	4087	0	sam.b@frontpageadvantage.com	1719318261939	37	f	fivelittledoves.com	katherine@orangeoutreach.com	1719318261939	Katherine Williams	Inbound	f	\N	150	£	fivelittledoves.com
1074	4088	1	sam.b@frontpageadvantage.com	1719318261939	37	f	fivelittledoves.com	katherine@orangeoutreach.com	1719318264682	Katherine Williams	Inbound	f	system	150	£	fivelittledoves.com
1075	4089	0	sam.b@frontpageadvantage.com	1719318317308	39	f	tobyandroo.com	katherine@orangeoutreach.com	1719318317308	Katherine Williams	Inbound	f	\N	150	£	tobyandroo.com
1075	4090	1	sam.b@frontpageadvantage.com	1719318317308	39	f	tobyandroo.com	katherine@orangeoutreach.com	1719318320012	Katherine Williams	Inbound	f	system	150	£	tobyandroo.com
1076	4091	0	sam.b@frontpageadvantage.com	1719318364944	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1719318364944	Katherine Williams	Inbound	f	\N	100	£	wellbeingmagazine.com
1076	4092	1	sam.b@frontpageadvantage.com	1719318364944	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1719318367653	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
1077	4093	0	sam.b@frontpageadvantage.com	1719318416922	50	f	algarvedailynews.com	katherine@orangeoutreach.com	1719318416922	Katherine Williams	Inbound	f	\N	175	£	algarvedailynews.com
1077	4094	1	sam.b@frontpageadvantage.com	1719318416922	50	f	algarvedailynews.com	katherine@orangeoutreach.com	1719318419606	Katherine Williams	Inbound	f	system	175	£	algarvedailynews.com
1078	4095	0	sam.b@frontpageadvantage.com	1719319469273	24	f	redkitedays.co.uk	katherine@orangeoutreach.com	1719319469273	Katherine Williams	Inbound	f	\N	160	£	redkitedays.co.uk
1078	4096	1	sam.b@frontpageadvantage.com	1719319469273	24	f	redkitedays.co.uk	katherine@orangeoutreach.com	1719319472302	Katherine Williams	Inbound	f	system	160	£	redkitedays.co.uk
1079	4097	0	sam.b@frontpageadvantage.com	1719319485667	0	t	bdcmagazine.com	katherine@orangeoutreach.com	1719319485667	Katherine Williams	Inbound	f	\N	280	£	bdcmagazine.com
1079	4098	1	sam.b@frontpageadvantage.com	1719319485667	42	t	bdcmagazine.com	katherine@orangeoutreach.com	1719319488589	Katherine Williams	Inbound	f	system	280	£	bdcmagazine.com
1080	4099	0	sam.b@frontpageadvantage.com	1719319694584	47	f	exposedmagazine.co.uk	katherine@orangeoutreach.com	1719319694584	Katherine Williams	Inbound	f	\N	100	£	exposedmagazine.co.uk
1080	4100	1	sam.b@frontpageadvantage.com	1719319694584	47	f	exposedmagazine.co.uk	katherine@orangeoutreach.com	1719319697536	Katherine Williams	Inbound	f	system	100	£	exposedmagazine.co.uk
1081	4101	0	sam.b@frontpageadvantage.com	1719319784878	38	f	emmysmummy.com	katherine@orangeoutreach.com	1719319784878	Katherine Williams	Inbound	f	\N	120	£	emmysmummy.com
1081	4102	1	sam.b@frontpageadvantage.com	1719319784878	38	f	emmysmummy.com	katherine@orangeoutreach.com	1719319789060	Katherine Williams	Inbound	f	system	120	£	emmysmummy.com
1082	4103	0	sam.b@frontpageadvantage.com	1719319867176	27	f	theowlet.co.uk	katherine@orangeoutreach.com	1719319867176	Katherine Williams	Inbound	f	\N	100	£	theowlet.co.uk
1082	4104	1	sam.b@frontpageadvantage.com	1719319867176	27	f	theowlet.co.uk	katherine@orangeoutreach.com	1719319870877	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
1083	4105	0	sam.b@frontpageadvantage.com	1719319963927	35	f	edinburgers.co.uk	katherine@orangeoutreach.com	1719319963927	Katherine Williams	Inbound	f	\N	100	£	edinburgers.co.uk
1083	4106	1	sam.b@frontpageadvantage.com	1719319963927	35	f	edinburgers.co.uk	katherine@orangeoutreach.com	1719319966804	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
1084	4107	0	sam.b@frontpageadvantage.com	1719320073095	28	f	bouncemagazine.co.uk	katherine@orangeoutreach.com	1719320073095	Katherine Williams	Inbound	f	\N	100	£	bouncemagazine.co.uk
1084	4108	1	sam.b@frontpageadvantage.com	1719320073095	28	f	bouncemagazine.co.uk	katherine@orangeoutreach.com	1719320075865	Katherine Williams	Inbound	f	system	100	£	bouncemagazine.co.uk
1085	4109	0	sam.b@frontpageadvantage.com	1719320223488	35	f	welovebrum.co.uk	katherine@orangeoutreach.com	1719320223488	Katherine Williams	Inbound	f	\N	140	£	welovebrum.co.uk
1085	4110	1	sam.b@frontpageadvantage.com	1719320223488	35	f	welovebrum.co.uk	katherine@orangeoutreach.com	1719320226303	Katherine Williams	Inbound	f	system	140	£	welovebrum.co.uk
1086	4111	0	sam.b@frontpageadvantage.com	1719320331730	41	f	lovebelfast.co.uk	katherine@orangeoutreach.com	1719320331730	Katherine Williams	Inbound	f	\N	120	£	lovebelfast.co.uk
1086	4112	1	sam.b@frontpageadvantage.com	1719320331730	41	f	lovebelfast.co.uk	katherine@orangeoutreach.com	1719320334836	Katherine Williams	Inbound	f	system	120	£	lovebelfast.co.uk
1087	4113	0	sam.b@frontpageadvantage.com	1719320401710	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1719320401710	Katherine Williams	Inbound	f	\N	140	£	dailybusinessgroup.co.uk
1087	4114	1	sam.b@frontpageadvantage.com	1719320401710	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1719320404745	Katherine Williams	Inbound	f	system	140	£	dailybusinessgroup.co.uk
1088	4115	0	sam.b@frontpageadvantage.com	1719320465060	38	f	family-budgeting.co.uk	katherine@orangeoutreach.com	1719320465060	Katherine Williams	Inbound	f	\N	120	£	family-budgeting.co.uk
1088	4116	1	sam.b@frontpageadvantage.com	1719320465060	38	f	family-budgeting.co.uk	katherine@orangeoutreach.com	1719320469008	Katherine Williams	Inbound	f	system	120	£	family-budgeting.co.uk
1089	4117	0	sam.b@frontpageadvantage.com	1719320544130	32	f	crummymummy.co.uk	katherine@orangeoutreach.com	1719320544130	Katherine Williams	Inbound	f	\N	100	£	crummymummy.co.uk
1089	4118	1	sam.b@frontpageadvantage.com	1719320544130	32	f	crummymummy.co.uk	katherine@orangeoutreach.com	1719320547118	Katherine Williams	Inbound	f	system	100	£	crummymummy.co.uk
1090	4119	0	sam.b@frontpageadvantage.com	1719320639079	67	f	markmeets.com	katherine@orangeoutreach.com	1719320639079	Katherine Williams	Inbound	f	\N	100	£	markmeets.com
1090	4120	1	sam.b@frontpageadvantage.com	1719320639079	67	f	markmeets.com	katherine@orangeoutreach.com	1719320642527	Katherine Williams	Inbound	f	system	100	£	markmeets.com
1091	4121	0	sam.b@frontpageadvantage.com	1719320713419	74	f	businesscasestudies.co.uk	katherine@orangeoutreach.com	1719320713419	Katherine Williams	Inbound	f	\N	220	£	businesscasestudies.co.uk
1091	4122	1	sam.b@frontpageadvantage.com	1719320713419	74	f	businesscasestudies.co.uk	katherine@orangeoutreach.com	1719320716135	Katherine Williams	Inbound	f	system	220	£	businesscasestudies.co.uk
1092	4123	0	sam.b@frontpageadvantage.com	1719320789605	44	f	fabukmagazine.com	katherine@orangeoutreach.com	1719320789605	Katherine Williams	Inbound	f	\N	120	£	fabukmagazine.com
1092	4124	1	sam.b@frontpageadvantage.com	1719320789605	44	f	fabukmagazine.com	katherine@orangeoutreach.com	1719320792841	Katherine Williams	Inbound	f	system	120	£	fabukmagazine.com
1093	4125	0	sam.b@frontpageadvantage.com	1719320939526	56	f	westwaleschronicle.co.uk	katherine@orangeoutreach.com	1719320939526	Katherine Williams	Inbound	f	\N	100	£	westwaleschronicle.co.uk
1093	4126	1	sam.b@frontpageadvantage.com	1719320939526	56	f	westwaleschronicle.co.uk	katherine@orangeoutreach.com	1719320942505	Katherine Williams	Inbound	f	system	100	£	westwaleschronicle.co.uk
1094	4127	0	sam.b@frontpageadvantage.com	1719322155330	28	f	coffeecakekids.com	katherine@orangeoutreach.com	1719322155330	Katherine Williams	Inbound	f	\N	100	£	coffeecakekids.com
1094	4128	1	sam.b@frontpageadvantage.com	1719322155330	28	f	coffeecakekids.com	katherine@orangeoutreach.com	1719322158324	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
1095	4129	0	sam.b@frontpageadvantage.com	1719322290354	33	f	largerfamilylife.com	katherine@orangeoutreach.com	1719322290354	Katherine Williams	Inbound	f	\N	100	£	largerfamilylife.com
1095	4130	1	sam.b@frontpageadvantage.com	1719322290354	33	f	largerfamilylife.com	katherine@orangeoutreach.com	1719322293043	Katherine Williams	Inbound	f	system	100	£	largerfamilylife.com
1096	4131	0	sam.b@frontpageadvantage.com	1719322406613	35	f	businesslancashire.co.uk	katherine@orangeoutreach.com	1719322406613	Katherine Williams	Inbound	f	\N	140	£	businesslancashire.co.uk
1096	4132	1	sam.b@frontpageadvantage.com	1719322406613	35	f	businesslancashire.co.uk	katherine@orangeoutreach.com	1719322409548	Katherine Williams	Inbound	f	system	140	£	businesslancashire.co.uk
1097	4133	0	sam.b@frontpageadvantage.com	1719396496757	31	f	strikeapose.co.uk	jagdish.linkbuilder@gmail.com	1719396496757	Jagdish Patel	Inbound	f	\N	160	£	https://www.strikeapose.co.uk/
1097	4134	1	sam.b@frontpageadvantage.com	1719396496757	31	f	strikeapose.co.uk	jagdish.linkbuilder@gmail.com	1719396499667	Jagdish Patel	Inbound	f	system	160	£	https://www.strikeapose.co.uk/
1098	4135	0	sam.b@frontpageadvantage.com	1719396580592	38	f	yourharlow.com	jagdish.linkbuilder@gmail.com	1719396580592	Jagdish Patel	Inbound	f	\N	120	£	https://www.yourharlow.com/
1098	4136	1	sam.b@frontpageadvantage.com	1719396580592	38	f	yourharlow.com	jagdish.linkbuilder@gmail.com	1719396583702	Jagdish Patel	Inbound	f	system	120	£	https://www.yourharlow.com/
1099	4137	0	sam.b@frontpageadvantage.com	1719396643226	37	f	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	1719396643226	Jagdish Patel	Inbound	f	\N	140	£	https://www.seriousaboutrl.com/
1099	4138	1	sam.b@frontpageadvantage.com	1719396643226	37	f	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	1719396646406	Jagdish Patel	Inbound	f	system	140	£	https://www.seriousaboutrl.com/
1100	4139	0	sam.b@frontpageadvantage.com	1719396696751	36	f	pharmacy.biz	jagdish.linkbuilder@gmail.com	1719396696751	Jagdish Patel	Inbound	f	\N	104	£	https://www.pharmacy.biz/
1100	4140	1	sam.b@frontpageadvantage.com	1719396696751	36	f	pharmacy.biz	jagdish.linkbuilder@gmail.com	1719396699971	Jagdish Patel	Inbound	f	system	104	£	https://www.pharmacy.biz/
1101	4141	0	sam.b@frontpageadvantage.com	1719396748047	67	f	pitchero.com	jagdish.linkbuilder@gmail.com	1719396748047	Jagdish Patel	Inbound	f	\N	48	£	https://www.pitchero.com/
1101	4142	1	sam.b@frontpageadvantage.com	1719396748047	67	f	pitchero.com	jagdish.linkbuilder@gmail.com	1719396752920	Jagdish Patel	Inbound	f	system	48	£	https://www.pitchero.com/
1102	4143	0	sam.b@frontpageadvantage.com	1719396805201	47	f	yourthurrock.com	jagdish.linkbuilder@gmail.com	1719396805201	Jagdish Patel	Inbound	f	\N	120	£	https://www.yourthurrock.com/
1102	4144	1	sam.b@frontpageadvantage.com	1719396805201	47	f	yourthurrock.com	jagdish.linkbuilder@gmail.com	1719396808049	Jagdish Patel	Inbound	f	system	120	£	https://www.yourthurrock.com/
1103	4145	0	sam.b@frontpageadvantage.com	1719396859158	34	f	mummyfever.co.uk	jagdish.linkbuilder@gmail.com	1719396859158	Jagdish Patel	Inbound	f	\N	160	£	https://mummyfever.co.uk/
1103	4146	1	sam.b@frontpageadvantage.com	1719396859158	34	f	mummyfever.co.uk	jagdish.linkbuilder@gmail.com	1719396861912	Jagdish Patel	Inbound	f	system	160	£	https://mummyfever.co.uk/
1104	4147	0	sam.b@frontpageadvantage.com	1719396923079	66	f	wlv.ac.uk	jagdish.linkbuilder@gmail.com	1719396923079	Jagdish Patel	Inbound	f	\N	48	£	https://www.wlv.ac.uk/
1104	4148	1	sam.b@frontpageadvantage.com	1719396923079	66	f	wlv.ac.uk	jagdish.linkbuilder@gmail.com	1719396926926	Jagdish Patel	Inbound	f	system	48	£	https://www.wlv.ac.uk/
1105	4149	0	sam.b@frontpageadvantage.com	1719397018040	43	f	findtheneedle.co.uk	jagdish.linkbuilder@gmail.com	1719397018040	Jagdish Patel	Inbound	f	\N	120	£	https://findtheneedle.co.uk/
1105	4150	1	sam.b@frontpageadvantage.com	1719397018040	43	f	findtheneedle.co.uk	jagdish.linkbuilder@gmail.com	1719397021352	Jagdish Patel	Inbound	f	system	120	£	https://findtheneedle.co.uk/
1106	4151	0	sam.b@frontpageadvantage.com	1719408285725	41	f	tqsmagazine.co.uk	jagdish.linkbuilder@gmail.com	1719408285725	Jagdish Patel	Inbound	f	\N	140	£	https://tqsmagazine.co.uk/
1106	4152	1	sam.b@frontpageadvantage.com	1719408285725	41	f	tqsmagazine.co.uk	jagdish.linkbuilder@gmail.com	1719408288675	Jagdish Patel	Inbound	f	system	140	£	https://tqsmagazine.co.uk/
1107	4153	0	sam.b@frontpageadvantage.com	1719408355968	54	f	businesscheshire.co.uk	jagdish.linkbuilder@gmail.com	1719408355968	Jagdish Patel	Inbound	f	\N	140	£	https://www.businesscheshire.co.uk/
1107	4154	1	sam.b@frontpageadvantage.com	1719408355968	54	f	businesscheshire.co.uk	jagdish.linkbuilder@gmail.com	1719408358920	Jagdish Patel	Inbound	f	system	140	£	https://www.businesscheshire.co.uk/
1108	4155	0	sam.b@frontpageadvantage.com	1719408428460	38	f	thehockeypaper.co.uk	jagdish.linkbuilder@gmail.com	1719408428460	Jagdish Patel	Inbound	f	\N	160	£	https://www.thehockeypaper.co.uk/
1108	4156	1	sam.b@frontpageadvantage.com	1719408428460	38	f	thehockeypaper.co.uk	jagdish.linkbuilder@gmail.com	1719408431370	Jagdish Patel	Inbound	f	system	160	£	https://www.thehockeypaper.co.uk/
1109	4157	0	sam.b@frontpageadvantage.com	1719408484683	48	f	thefightingcock.co.uk	jagdish.linkbuilder@gmail.com	1719408484683	Jagdish Patel	Inbound	f	\N	160	£	https://thefightingcock.co.uk/
1109	4158	1	sam.b@frontpageadvantage.com	1719408484683	48	f	thefightingcock.co.uk	jagdish.linkbuilder@gmail.com	1719408487736	Jagdish Patel	Inbound	f	system	160	£	https://thefightingcock.co.uk/
1110	4159	0	sam.b@frontpageadvantage.com	1719408568561	44	f	londonforfree.net	jagdish.linkbuilder@gmail.com	1719408568561	Jagdish Patel	Inbound	f	\N	160	£	https://www.londonforfree.net/
1110	4160	1	sam.b@frontpageadvantage.com	1719408568561	44	f	londonforfree.net	jagdish.linkbuilder@gmail.com	1719408571398	Jagdish Patel	Inbound	f	system	160	£	https://www.londonforfree.net/
1111	4161	0	sam.b@frontpageadvantage.com	1719408626312	59	f	paisley.org.uk	jagdish.linkbuilder@gmail.com	1719408626312	Jagdish Patel	Inbound	f	\N	112	£	https://www.paisley.org.uk/
1111	4162	1	sam.b@frontpageadvantage.com	1719408626312	59	f	paisley.org.uk	jagdish.linkbuilder@gmail.com	1719408631253	Jagdish Patel	Inbound	f	system	112	£	https://www.paisley.org.uk/
1112	4163	0	sam.b@frontpageadvantage.com	1719408687174	41	f	atidymind.co.uk	jagdish.linkbuilder@gmail.com	1719408687174	Jagdish Patel	Inbound	f	\N	160	£	https://www.atidymind.co.uk/
1112	4164	1	sam.b@frontpageadvantage.com	1719408687174	41	f	atidymind.co.uk	jagdish.linkbuilder@gmail.com	1719408689778	Jagdish Patel	Inbound	f	system	160	£	https://www.atidymind.co.uk/
1113	4165	0	sam.b@frontpageadvantage.com	1719409558251	57	f	henley.ac.uk	jagdish.linkbuilder@gmail.com	1719409558251	Jagdish Patel	Inbound	f	\N	48	£	https://www.henley.ac.uk/
1113	4166	1	sam.b@frontpageadvantage.com	1719409558251	57	f	henley.ac.uk	jagdish.linkbuilder@gmail.com	1719409561648	Jagdish Patel	Inbound	f	system	48	£	https://www.henley.ac.uk/
1114	4167	0	sam.b@frontpageadvantage.com	1719409631888	63	f	musicglue.com	jagdish.linkbuilder@gmail.com	1719409631888	Jagdish Patel	Inbound	f	\N	68	£	https://www.musicglue.com/
1114	4168	1	sam.b@frontpageadvantage.com	1719409631888	63	f	musicglue.com	jagdish.linkbuilder@gmail.com	1719409634658	Jagdish Patel	Inbound	f	system	68	£	https://www.musicglue.com/
1115	4169	0	sam.b@frontpageadvantage.com	1719409732096	71	f	voice-online.co.uk	jagdish.linkbuilder@gmail.com	1719409732096	Jagdish Patel	Inbound	f	\N	140	£	https://www.voice-online.co.uk/
1115	4170	1	sam.b@frontpageadvantage.com	1719409732096	71	f	voice-online.co.uk	jagdish.linkbuilder@gmail.com	1719409734942	Jagdish Patel	Inbound	f	system	140	£	https://www.voice-online.co.uk/
1116	4171	0	sam.b@frontpageadvantage.com	1719409875972	58	f	houseofspells.co.uk	jagdish.linkbuilder@gmail.com	1719409875972	Jagdish Patel	Inbound	f	\N	104	£	https://houseofspells.co.uk/
1116	4172	1	sam.b@frontpageadvantage.com	1719409875972	58	f	houseofspells.co.uk	jagdish.linkbuilder@gmail.com	1719409878819	Jagdish Patel	Inbound	f	system	104	£	https://houseofspells.co.uk/
1117	4173	0	sam.b@frontpageadvantage.com	1719496409778	49	f	neconnected.co.uk	jagdish.linkbuilder@gmail.com	1719496409778	Jagdish Patel	Inbound	f	\N	88	£	https://neconnected.co.uk/
1117	4174	1	sam.b@frontpageadvantage.com	1719496409778	49	f	neconnected.co.uk	jagdish.linkbuilder@gmail.com	1719496412775	Jagdish Patel	Inbound	f	system	88	£	https://neconnected.co.uk/
1118	4175	0	sam.b@frontpageadvantage.com	1719496491688	44	f	moshville.co.uk	jagdish.linkbuilder@gmail.com	1719496491688	Jagdish Patel	Inbound	f	\N	160	£	https://www.moshville.co.uk/
1118	4176	1	sam.b@frontpageadvantage.com	1719496491688	44	f	moshville.co.uk	jagdish.linkbuilder@gmail.com	1719496494519	Jagdish Patel	Inbound	f	system	160	£	https://www.moshville.co.uk/
1119	4177	0	sam.b@frontpageadvantage.com	1719496578123	42	f	thestudentpocketguide.com	jagdish.linkbuilder@gmail.com	1719496578123	Jagdish Patel	Inbound	f	\N	88	£	https://www.thestudentpocketguide.com/
1119	4178	1	sam.b@frontpageadvantage.com	1719496578123	42	f	thestudentpocketguide.com	jagdish.linkbuilder@gmail.com	1719496581145	Jagdish Patel	Inbound	f	system	88	£	https://www.thestudentpocketguide.com/
1120	4179	0	sam.b@frontpageadvantage.com	1719496627284	53	f	constructionreviewonline.com	jagdish.linkbuilder@gmail.com	1719496627284	Jagdish Patel	Inbound	f	\N	160	£	https://constructionreviewonline.com/
1120	4180	1	sam.b@frontpageadvantage.com	1719496627284	53	f	constructionreviewonline.com	jagdish.linkbuilder@gmail.com	1719496630140	Jagdish Patel	Inbound	f	system	160	£	https://constructionreviewonline.com/
783	4181	1	chris.p@frontpageadvantage.com	1709034374081	44	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1719802810075	Sukhen	inbound	f	system	150	£	https://corporatelivewire.com/
1002	4182	1	michael.l@frontpageadvantage.com	1713341748907	44	f	todaynews.co.uk	david@todaynews.co.uk	1719802814301	David	Inbound Michael	f	system	65	£	https://todaynews.co.uk/
491	4183	1	historical	0	53	f	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	1719802815349	Fazal	Inbound Sam	f	system	168	£	www.theexeterdaily.co.uk
1055	4184	1	michael.l@frontpageadvantage.com	1716452047818	21	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1719802823810	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
652	4185	1	chris.p@frontpageadvantage.com	0	37	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1719802824903	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
316	4186	1	historical	0	29	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1719802825874	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
1053	4187	1	michael.l@frontpageadvantage.com	1716451545373	33	f	emmareed.net	admin@emmareed.net	1719802837859	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
496	4188	1	historical	0	27	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1719802843423	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
1075	4189	1	sam.b@frontpageadvantage.com	1719318317308	38	f	tobyandroo.com	katherine@orangeoutreach.com	1719802849969	Katherine Williams	Inbound	f	system	150	£	tobyandroo.com
333	4190	1	historical	0	17	f	learndeveloplive.com	chris@learndeveloplive.com	1719802871956	Chris Jaggs	Fatjoe	f	system	25	£	www.learndeveloplive.com
654	4191	1	chris.p@frontpageadvantage.com	0	43	f	acraftedpassion.com	info@morningbusinesschat.com	1719802872834	Brett Napoli	Inbound	f	system	100	£	https://acraftedpassion.com/
1071	4192	1	sam.b@frontpageadvantage.com	1719318047364	30	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1719802884891	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
765	4193	1	sam.b@frontpageadvantage.com	1708616408925	46	f	storymirror.com	ela690000@gmail.com	1719802889264	Ella	Inbound	f	system	96	£	https://storymirror.com/
953	4194	1	michael.l@frontpageadvantage.com	1711012683237	41	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1719802890725	Sam	Outbound Chris	f	system	100	£	https://www.thecricketpaper.com/
702	4195	1	michael.l@frontpageadvantage.com	1708008300694	38	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1719802891853	Front Page Advantage	Email	f	system	10	£	https://frontpageadvantage.com/
956	4196	1	michael.l@frontpageadvantage.com	1711013035726	28	f	racingahead.net	sam.emery@greenwayspublishing.com	1719802913248	Sam	Outbound Chris	f	system	100	£	https://www.racingahead.net/
955	4197	1	michael.l@frontpageadvantage.com	1711012971138	26	f	latetacklemagazine.com	sam.emery@greenwayspublishing.com	1719802916924	Sam	Outbound Chris	f	system	100	£	https://www.latetacklemagazine.com/
775	4198	1	chris.p@frontpageadvantage.com	1709031235193	28	f	followthefashion.org	bhaiahsan799@gmail.com	1719802918609	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
655	4199	1	chris.p@frontpageadvantage.com	0	37	f	forgetfulmomma.com	info@morningbusinesschat.com	1719802920160	Brett Napoli	Inbound	f	system	225	£	https://www.forgetfulmomma.com/
902	4200	1	sam.b@frontpageadvantage.com	1709717920944	34	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1719802921189	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
1098	4201	1	sam.b@frontpageadvantage.com	1719396580592	37	f	yourharlow.com	jagdish.linkbuilder@gmail.com	1719802922100	Jagdish Patel	Inbound	f	system	120	£	https://www.yourharlow.com/
1059	4202	1	michael.l@frontpageadvantage.com	1716452853668	30	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1719802930579	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
904	4203	1	sam.b@frontpageadvantage.com	1709718289226	38	f	theleaguepaper.com	sam.emery@greenwayspublishing.com	1719802931583	Sam	Outbound Chris	f	system	100	£	www.theleaguepaper.com
324	4204	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1719802932746	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
804	4205	1	sam.b@frontpageadvantage.com	1709213279175	79	f	e-architect.com	isabelle@e-architect.com	1719802941921	Isabelle Lomholt	Outbound Sam	f	system	100	£	https://www.e-architect.com/
387	4206	1	historical	0	34	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1719802949839	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
1062	4207	1	sam.b@frontpageadvantage.com	1716462238586	34	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1719802952048	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
779	4208	1	chris.p@frontpageadvantage.com	1709032988565	20	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1719802956626	Team	inbound	f	system	72	£	https://travelworldfashion.com/
339	4209	1	historical	0	26	f	keralpatel.com	keralpatel@gmail.com	1719802962560	Keral Patel	Fatjoe	f	system	35	£	https://www.keralpatel.com
957	4210	1	chris.p@frontpageadvantage.com	1711532679719	45	f	north.wales	backlinsprovider@gmail.com	1719802965020	David Smith	Inbound	f	system	95	£	https://north.wales/
337	4211	1	historical	0	24	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1719802971934	Al Baker	Fatjoe	f	system	40	£	www.thepennypincher.co.uk
312	4212	1	historical	0	29	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1719802977834	Abbie	Fatjoe	f	system	45	£	mmbmagazine.co.uk
338	4213	1	historical	0	19	f	themammafairy.com	themammafairy@gmail.com	1719802989062	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
358	4214	1	historical	0	26	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1719802992239	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
329	4215	1	historical	0	40	f	wemadethislife.com	wemadethislife@outlook.com	1719802994321	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
340	4216	1	historical	0	34	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1719802995277	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
317	4217	1	historical	0	29	f	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	1719803003080	Jen	Fatjoe	f	system	30	£	www.jenloumeredith.com
311	4218	1	historical	0	17	f	alifeoflovely.com	alifeoflovely@gmail.com	1719803003978	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
327	4219	1	historical	0	28	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1719803006123	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
341	4220	1	historical	0	16	f	sashashantel.com	contactsashashantel@gmail.com	1719803006959	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
402	4221	1	historical	0	58	f	mammaprada.com	mammaprada@gmail.com	1719803018945	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
906	4222	1	sam.b@frontpageadvantage.com	1709718918993	46	f	liverpoolway.co.uk	kenditoys.com@gmail.com	1719803020584	David warner 	Inbound	f	system	142	£	https://www.liverpoolway.co.uk/
360	4223	1	historical	0	39	f	rachelbustin.com	rachel@rachelbustin.com	1719803024312	Rachel Bustin	Fatjoe	f	system	85	£	https://rachelbustin.com
380	4224	1	historical	0	60	f	captainbobcat.com	Eva@captainbobcat.com	1719803031574	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
388	4225	1	historical	0	24	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1719803032431	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
386	4226	1	historical	0	53	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1719803036089	Anna marikar	Inbound email	f	system	150	£	Intheplayroom.co.uk
365	4227	1	historical	0	37	f	letstalkmommy.com	jenny@letstalkmommy.com	1719803040431	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
375	4228	1	historical	0	24	f	clairemac.co.uk	clairemacblog@gmail.com	1719803053658	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
381	4229	1	historical	0	35	f	therarewelshbit.com	kacie@therarewelshbit.com	1719803055554	Kacie Morgan	Inbound email	f	system	200	£	www.therarewelshbit.com
382	4230	1	historical	0	30	f	stressedmum.co.uk	sam@stressedmum.co.uk	1719803056591	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
408	4231	1	historical	0	18	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1719803058328	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
399	4232	1	historical	0	32	f	suburban-mum.com	hello@suburban-mum.com	1719803061258	Maria	Inbound email	f	system	100	£	www.suburban-mum.com
390	4233	1	historical	0	34	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1719803066083	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
395	4234	1	historical	0	29	f	missmanypennies.com	hello@missmanypennies.com	1719803067250	Hayley	Inbound email	f	system	85	£	www.missmanypennies.com
440	4235	1	historical	0	63	f	ventsmagazine.com	minalkh124@gmail.com	1719803068861	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
412	4236	1	historical	0	30	f	laurakatelucas.com	laurakatelucas@hotmail.com	1719803077713	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
411	4237	1	historical	0	19	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1719803085691	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
418	4238	1	historical	0	38	f	amumreviews.co.uk	contact@amumreviews.co.uk	1719803091734	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
441	4239	1	historical	0	73	f	newsbreak.com	minalkh124@gmail.com	1719803093595	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
420	4240	1	historical	0	31	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1719803096480	Anna	Facebook	f	system	150	£	https://www.dontcrampmystyle.co.uk
471	4241	1	historical	0	20	f	realparent.co.uk	hello@contentmother.com	1719803121869	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
483	4242	1	historical	0	30	f	packthepjs.com	tracey@packthepjs.com	1719803123706	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
484	4243	1	historical	0	90	f	ibtimes.co.uk	i.perez@ibtmedia.co.uk	1719803125658	Inigo	inbound email	f	system	379	£	ibtimes.co.uk
470	4244	1	historical	0	19	f	realwedding.co.uk	hello@contentmother.com	1719803127747	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
391	4245	1	historical	0	42	f	conversanttraveller.com	heather@conversanttraveller.com	1719803130771	Heather	Inbound email	f	system	180	£	www.conversanttraveller.com
507	4246	1	historical	0	34	f	toddleabout.co.uk	fazal.akbar@digitalczars.io	1719803136299	Fazal	Inbound Sam	f	system	168	£	toddleabout.co.uk
515	4247	1	historical	0	15	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1719803144370	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
529	4248	1	historical	0	37	f	houseofcoco.net	backlinsprovider@gmail.com	1719803146420	David	Inbound Sam	f	system	150	£	houseofcoco.net
518	4249	1	historical	0	20	f	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	1719803151079	Fazal	Inbound Sam	f	system	168	£	www.ukcaravanrental.co.uk
434	4250	1	historical	0	25	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1719803155730	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
808	4251	1	sam.b@frontpageadvantage.com	1709637089134	20	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1719803158949	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
516	4252	1	historical	0	33	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1719803160886	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
523	4253	1	historical	0	37	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1719803162794	Fazal	Inbound Sam	f	system	120	£	www.daytradetheworld.com
524	4254	1	historical	0	38	f	travelbeginsat40.com	backlinsprovider@gmail.com	1719803170418	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
526	4255	1	historical	0	44	f	puretravel.com	backlinsprovider@gmail.com	1719803171819	David	Inbound Sam	f	system	160	£	www.puretravel.com
527	4256	1	historical	0	51	f	ourculturemag.com	info@ourculturemag.com	1719803174824	Info	Inbound Sam	f	system	115	£	ourculturemag.com
782	4257	1	chris.p@frontpageadvantage.com	1709033531454	27	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1719803192796	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
959	4258	1	chris.p@frontpageadvantage.com	1711533031802	47	f	talk-business.co.uk	backlinsprovider@gmail.com	1719803193524	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
508	4259	1	historical	0	32	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1719803194624	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
384	4260	1	historical	0	38	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1719803198809	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
404	4261	1	historical	0	21	f	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	1719803203053	Elizabeth Williams	Inbound email	f	system	80	£	www.whererootsandwingsentwine.com
517	4262	1	historical	0	24	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1719803207972	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
809	4263	1	sam.b@frontpageadvantage.com	1709637625007	54	f	pierdom.com	info@pierdom.com	1719803209460	Junaid	Outbound	f	system	25	£	https://pierdom.com/
497	4264	1	historical	0	32	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1719803211877	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
322	4265	1	historical	0	32	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1719803214261	David	Fatjoe	f	system	45	£	5thingstodotoday.com
1090	4302	1	sam.b@frontpageadvantage.com	1719320639079	68	f	markmeets.com	katherine@orangeoutreach.com	1719889221995	Katherine Williams	Inbound	f	system	100	£	markmeets.com
1112	4303	1	sam.b@frontpageadvantage.com	1719408687174	40	f	atidymind.co.uk	jagdish.linkbuilder@gmail.com	1719889223888	Jagdish Patel	Inbound	f	system	160	£	https://www.atidymind.co.uk/
1056	4304	1	michael.l@frontpageadvantage.com	1716452285003	27	f	flyingfluskey.com	rosie@flyingfluskey.com	1719889238398	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
903	4305	1	sam.b@frontpageadvantage.com	1709718136681	51	f	therugbypaper.co.uk	backlinsprovider@gmail.com	1719889261760	David Smith 	Inbound	f	system	115	£	www.therugbypaper.co.uk
453	4306	1	historical	0	65	f	techbullion.com	angelascottbriggs@techbullion.com	1719889382543	Angela Scott-Briggs 	Inbound email	f	system	100	£	http://techbullion.com
417	4307	1	historical	0	46	f	globalmousetravels.com	hello@globalmousetravels.com	1719889392898	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
304	4498	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1720522952572	UKNEWS Group	Inbound email	f	james.p@frontpageadvantage.com	40	£	https://www.uknewsgroup.co.uk/
1152	4858	0	james.p@frontpageadvantage.com	1721314820107	7	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1721314820107	Rose	Contact Form	f	\N	20	£	www.RosemaryHelenXO.com
1152	4859	1	james.p@frontpageadvantage.com	1721314820107	12	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1721314827545	Rose	Contact Form	f	system	20	£	www.RosemaryHelenXO.com
334	4943	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1721722227234	Sally Allsop	Fatjoe	f	michael.l@frontpageadvantage.com	60	£	www.lifeloving.co.uk
349	4945	1	historical	0	22	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1721722464822	Vicki	Fatjoe	f	michael.l@frontpageadvantage.com	60	£	Icenimagazine.co.uk
1092	5043	1	sam.b@frontpageadvantage.com	1719320789605	43	f	fabukmagazine.com	katherine@orangeoutreach.com	1722481203548	Katherine Williams	Inbound	f	system	120	£	fabukmagazine.com
782	5044	1	chris.p@frontpageadvantage.com	1709033531454	26	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1722481212674	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
347	5045	1	historical	0	31	f	diydaddyblog.com	Diynige@yahoo.com	1722481222890	Nigel higgins	Fatjoe	f	system	50	£	https://www.diydaddyblog.com/
1112	5046	1	sam.b@frontpageadvantage.com	1719408687174	41	f	atidymind.co.uk	jagdish.linkbuilder@gmail.com	1722481223753	Jagdish Patel	Inbound	f	system	160	£	https://www.atidymind.co.uk/
323	5047	1	historical	0	27	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1722481228482	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
1088	5048	1	sam.b@frontpageadvantage.com	1719320465060	37	f	family-budgeting.co.uk	katherine@orangeoutreach.com	1722481230391	Katherine Williams	Inbound	f	system	120	£	family-budgeting.co.uk
1056	5049	1	michael.l@frontpageadvantage.com	1716452285003	25	f	flyingfluskey.com	rosie@flyingfluskey.com	1722481252695	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
784	5050	1	chris.p@frontpageadvantage.com	1709035290025	35	f	okaybliss.com	infopediapros@gmail.com	1722481259355	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
1069	5051	1	sam.b@frontpageadvantage.com	1719317784130	29	f	caranalytics.co.uk	katherine@orangeoutreach.com	1722481260008	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1070	5052	1	sam.b@frontpageadvantage.com	1719317894569	21	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1722481260718	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1074	5053	1	sam.b@frontpageadvantage.com	1719318261939	36	f	fivelittledoves.com	katherine@orangeoutreach.com	1722481264691	Katherine Williams	Inbound	f	system	150	£	fivelittledoves.com
1076	5054	1	sam.b@frontpageadvantage.com	1719318364944	33	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1722481268935	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
1077	5055	1	sam.b@frontpageadvantage.com	1719318416922	51	f	algarvedailynews.com	katherine@orangeoutreach.com	1722481274814	Katherine Williams	Inbound	f	system	175	£	algarvedailynews.com
1053	5056	1	michael.l@frontpageadvantage.com	1716451545373	32	f	emmareed.net	admin@emmareed.net	1722481279318	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
496	5057	1	historical	0	28	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1722481282606	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
774	5058	1	chris.p@frontpageadvantage.com	1709030265171	33	f	voiceofaction.org	webmaster@redhatmedia.net	1722481286190	Vivek	outbound	f	system	65	£	http://voiceofaction.org/
1057	5059	1	michael.l@frontpageadvantage.com	1716452525532	50	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	1722481294932	Elaine Wilson 	Outbound Facebook	f	system	150	£	https://eccentricengland.co.uk/
761	5060	1	sam.b@frontpageadvantage.com	1708615661584	35	f	holyroodpr.co.uk	falcobliek@gmail.com	1722481299946	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
1096	5061	1	sam.b@frontpageadvantage.com	1719322406613	34	f	businesslancashire.co.uk	katherine@orangeoutreach.com	1722481306646	Katherine Williams	Inbound	f	system	140	£	businesslancashire.co.uk
654	5062	1	chris.p@frontpageadvantage.com	0	44	f	acraftedpassion.com	info@morningbusinesschat.com	1722481312097	Brett Napoli	Inbound	f	system	100	£	https://acraftedpassion.com/
1071	5063	1	sam.b@frontpageadvantage.com	1719318047364	31	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1722481316319	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1060	5064	1	michael.l@frontpageadvantage.com	1716452913891	43	f	safarisafricana.com	jacquiehale75@gmail.com	1722481321799	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
1058	5065	1	michael.l@frontpageadvantage.com	1716452780180	58	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1722481324300	Rowena Becker	Outbound Facebook	f	system	175	£	https://mybalancingact.co.uk/
1073	5066	1	sam.b@frontpageadvantage.com	1719318221869	76	f	deadlinenews.co.uk	katherine@orangeoutreach.com	1722481326197	Katherine Williams	Inbound	f	system	150	£	deadlinenews.co.uk
1099	5067	1	sam.b@frontpageadvantage.com	1719396643226	36	f	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	1722481328464	Jagdish Patel	Inbound	f	system	140	£	https://www.seriousaboutrl.com/
956	5068	1	michael.l@frontpageadvantage.com	1711013035726	26	f	racingahead.net	sam.emery@greenwayspublishing.com	1722481335535	Sam	Outbound Chris	f	system	100	£	https://www.racingahead.net/
655	5069	1	chris.p@frontpageadvantage.com	0	35	f	forgetfulmomma.com	info@morningbusinesschat.com	1722481340042	Brett Napoli	Inbound	f	system	225	£	https://www.forgetfulmomma.com/
902	5070	1	sam.b@frontpageadvantage.com	1709717920944	33	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1722481340729	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
1117	5071	1	sam.b@frontpageadvantage.com	1719496409778	50	f	neconnected.co.uk	jagdish.linkbuilder@gmail.com	1722481351213	Jagdish Patel	Inbound	f	system	88	£	https://neconnected.co.uk/
1119	5072	1	sam.b@frontpageadvantage.com	1719496578123	43	f	thestudentpocketguide.com	jagdish.linkbuilder@gmail.com	1722481352490	Jagdish Patel	Inbound	f	system	88	£	https://www.thestudentpocketguide.com/
1120	5073	1	sam.b@frontpageadvantage.com	1719496627284	52	f	constructionreviewonline.com	jagdish.linkbuilder@gmail.com	1722481354795	Jagdish Patel	Inbound	f	system	160	£	https://constructionreviewonline.com/
1059	5074	1	michael.l@frontpageadvantage.com	1716452853668	26	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1722481355604	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
324	5075	1	historical	0	13	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1722481358941	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
780	5076	1	chris.p@frontpageadvantage.com	1709033136922	23	f	travelistia.com	travelistiausa@gmail.com	1722481368498	Ferona	outbound	f	system	40	£	https://www.travelistia.com/
328	5077	1	historical	0	23	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1722481369361	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1081	5078	1	sam.b@frontpageadvantage.com	1719319784878	36	f	emmysmummy.com	katherine@orangeoutreach.com	1722481371495	Katherine Williams	Inbound	f	system	120	£	emmysmummy.com
1108	5079	1	sam.b@frontpageadvantage.com	1719408428460	39	f	thehockeypaper.co.uk	jagdish.linkbuilder@gmail.com	1722481372274	Jagdish Patel	Inbound	f	system	160	£	https://www.thehockeypaper.co.uk/
387	5080	1	historical	0	32	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1722481375341	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
430	5122	1	historical	0	26	f	bizzimummy.com	Bizzimummy@gmail.com	1722481503604	Eva Stretton	Facebook	f	system	55	£	https://bizzimummy.com
779	5081	1	chris.p@frontpageadvantage.com	1709032988565	19	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1722481379264	Team	inbound	f	system	72	£	https://travelworldfashion.com/
402	5082	1	historical	0	59	f	mammaprada.com	mammaprada@gmail.com	1722481382579	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
334	5083	1	historical	0	23	f	lifeloving.co.uk	sally@lifeloving.co.uk	1722481384787	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
349	5084	1	historical	0	23	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1722481386803	Vicki	Fatjoe	f	system	60	£	Icenimagazine.co.uk
305	5085	1	historical	0	14	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1722481391385	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
338	5086	1	historical	0	20	f	themammafairy.com	themammafairy@gmail.com	1722481395864	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
313	5087	1	historical	0	19	f	slashercareer.com	tanya@slashercareer.com	1722481401514	Tanya	Fatjoe	f	system	90	£	slashercareer.com
345	5088	1	historical	0	17	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1722481408777	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
337	5089	1	historical	0	23	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1722481418932	Al Baker	Fatjoe	f	system	40	£	www.thepennypincher.co.uk
358	5090	1	historical	0	25	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1722481421922	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
329	5091	1	historical	0	39	f	wemadethislife.com	wemadethislife@outlook.com	1722481423740	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
340	5092	1	historical	0	33	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1722481424640	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
317	5093	1	historical	0	28	f	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	1722481425572	Jen	Fatjoe	f	system	30	£	www.jenloumeredith.com
314	5094	1	historical	0	20	f	thejournalix.com	thejournalix@gmail.com	1722481426590	Joni	Fatjoe	f	system	15	£	thejournalix.com
327	5095	1	historical	0	27	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1722481430420	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
341	5096	1	historical	0	14	f	sashashantel.com	contactsashashantel@gmail.com	1722481431641	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
409	5097	1	historical	0	31	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1722481439241	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
366	5098	1	historical	0	46	f	barbaraiweins.com	info@barbaraiweins.com	1722481441946	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
367	5099	1	historical	0	21	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1722481446455	Amy Walsh	Inbound email	f	system	40	£	cocktailsinteacups.com
906	5100	1	sam.b@frontpageadvantage.com	1709718918993	45	f	liverpoolway.co.uk	kenditoys.com@gmail.com	1722481450487	David warner 	Inbound	f	system	142	£	https://www.liverpoolway.co.uk/
360	5101	1	historical	0	37	f	rachelbustin.com	rachel@rachelbustin.com	1722481454154	Rachel Bustin	Fatjoe	f	system	85	£	https://rachelbustin.com
380	5102	1	historical	0	61	f	captainbobcat.com	Eva@captainbobcat.com	1722481454995	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
388	5103	1	historical	0	23	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1722481455691	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
386	5104	1	historical	0	52	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1722481456340	Anna marikar	Inbound email	f	system	150	£	Intheplayroom.co.uk
365	5105	1	historical	0	38	f	letstalkmommy.com	jenny@letstalkmommy.com	1722481456904	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
394	5106	1	historical	0	37	f	skinnedcartree.com	corinne@skinnedcartree.com	1722481463558	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
377	5107	1	historical	0	26	f	travelvixta.com	victoria@travelvixta.com	1722481465952	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
385	5108	1	historical	0	41	f	motherhoodtherealdeal.com	motherhoodtherealdeal@gmail.com	1722481467128	Taiya	Inbound email	f	system	85	£	Https://www.motherhoodtherealdeal.com
379	5109	1	historical	0	26	f	yeahlifestyle.com	info@yeahlifestyle.com	1722481470614	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
383	5110	1	historical	0	38	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1722481471402	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
375	5111	1	historical	0	23	f	clairemac.co.uk	clairemacblog@gmail.com	1722481472806	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
378	5112	1	historical	0	27	f	healthyvix.com	victoria@healthyvix.com	1722481475163	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
408	5113	1	historical	0	17	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1722481477767	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
390	5114	1	historical	0	32	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1722481484554	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
395	5115	1	historical	0	28	f	missmanypennies.com	hello@missmanypennies.com	1722481488678	Hayley	Inbound email	f	system	85	£	www.missmanypennies.com
389	5116	1	historical	0	31	f	arthurwears.com	Arthurwears.email@gmail.com	1722481489711	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
453	5117	1	historical	0	66	f	techbullion.com	angelascottbriggs@techbullion.com	1722481490846	Angela Scott-Briggs 	Inbound email	f	system	100	£	http://techbullion.com
423	5118	1	historical	0	27	f	mymoneycottage.com	hello@mymoneycottage.com	1722481498589	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
417	5119	1	historical	0	44	f	globalmousetravels.com	hello@globalmousetravels.com	1722481499133	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
425	5120	1	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1722481500031	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
427	5121	1	historical	0	16	f	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	1722481502120	Shallie	Facebook	f	system	75	£	Shalliespurplebeehive.com
416	5123	1	historical	0	29	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1722481509021	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
432	5124	1	historical	0	38	f	lyliarose.com	victoria@lyliarose.com	1722481509647	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
460	5125	1	historical	0	27	f	techacrobat.com	minalkh124@gmail.com	1722481514551	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
440	5126	1	historical	0	64	f	ventsmagazine.com	minalkh124@gmail.com	1722481515827	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
412	5127	1	historical	0	28	f	laurakatelucas.com	laurakatelucas@hotmail.com	1722481519489	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
411	5128	1	historical	0	20	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1722481520804	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
418	5129	1	historical	0	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	1722481522212	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
441	5130	1	historical	0	74	f	newsbreak.com	minalkh124@gmail.com	1722481524131	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
473	5131	1	historical	0	37	f	earthlytaste.com	hello@contentmother.com	1722481537068	Becky	inbound email	f	system	50	£	https://www.earthlytaste.com
505	5132	1	historical	0	27	f	talk-retail.co.uk	backlinsprovider@gmail.com	1722481546442	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
493	5133	1	historical	0	36	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1722481547382	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
474	5134	1	historical	0	19	f	lclarke.co.uk	hello@contentmother.com	1722481549022	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
477	5135	1	historical	0	18	f	rocketandrelish.com	hello@contentmother.com	1722481552639	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
503	5136	1	historical	0	57	f	newsfromwales.co.uk	fazal.akbar@digitalczars.io	1722481556089	Fazal	Inbound Sam	f	system	144	£	newsfromwales.co.uk
513	5137	1	historical	0	31	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1722481562714	Fazal	Inbound Sam	f	system	168	£	www.thefoodaholic.co.uk
514	5138	1	historical	0	20	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1722481563307	Fazal	Inbound Sam	f	system	120	£	www.tobecomemum.co.uk
532	5139	1	historical	0	65	f	varsity.co.uk	backlinsprovider@gmail.com	1722481567312	David	Inbound Sam	f	system	150	£	www.varsity.co.uk
521	5140	1	historical	0	19	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1722481568016	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
958	5141	1	chris.p@frontpageadvantage.com	1711532781458	48	f	deeside.com	backlinsprovider@gmail.com	1722481569744	David Smith	inbound	f	system	95	£	https://www.deeside.com/
518	5142	1	historical	0	21	f	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	1722481572511	Fazal	Inbound Sam	f	system	168	£	www.ukcaravanrental.co.uk
520	5143	1	historical	0	20	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	1722481573963	Fazal	Inbound Sam	f	system	30	£	www.davidsavage.co.uk
808	5144	1	sam.b@frontpageadvantage.com	1709637089134	18	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1722481577509	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
516	5145	1	historical	0	31	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1722481578461	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
523	5146	1	historical	0	36	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1722481580225	Fazal	Inbound Sam	f	system	120	£	www.daytradetheworld.com
527	5147	1	historical	0	60	f	ourculturemag.com	info@ourculturemag.com	1722481583501	Info	Inbound Sam	f	system	115	£	ourculturemag.com
535	5148	1	historical	0	57	f	ukbusinessforums.co.uk	natalilacanario@gmail.com	1722481584471	Natalila	Inbound Sam	f	system	170	£	ukbusinessforums.co.uk
303	5149	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1722481604006	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
508	5150	1	historical	0	31	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1722481605543	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
403	5151	1	historical	0	54	f	sparklesandstretchmarks.com	Hayley@sparklesandstretchmarks.com	1722481606511	Hayley Mclean	Inbound email	f	system	100	£	Https://www.sparklesandstretchmarks.com
384	5152	1	historical	0	35	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1722481608761	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
404	5153	1	historical	0	23	f	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	1722481609705	Elizabeth Williams	Inbound email	f	system	80	£	www.whererootsandwingsentwine.com
517	5154	1	historical	0	23	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1722481610645	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
476	5155	1	historical	0	12	f	contentmother.com	hello@contentmother.com	1722481615694	Becky	inbound email	f	system	45	£	https://www.contentmother.com
371	5156	1	historical	0	25	f	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	1722481616646	Jennie Jordan	Inbound email	f	system	80	£	www.ricecakesandraisins.co.uk
393	5157	1	historical	0	59	f	reallymissingsleep.com	kareneholloway@hotmail.com	1722481618709	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
770	5158	1	chris.p@frontpageadvantage.com	1709027700111	59	f	valiantceo.com	staff@valiantceo.com	1722481632283	Valiantstaff	outbound	f	system	70	£	https://valiantceo.com/
497	5171	1	historical	0	30	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1722567895031	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
1111	5228	1	sam.b@frontpageadvantage.com	1719408626312	59	t	paisley.org.uk	jagdish.linkbuilder@gmail.com	1722930102541	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	112	£	https://www.paisley.org.uk/
1112	5229	1	sam.b@frontpageadvantage.com	1719408687174	41	t	atidymind.co.uk	jagdish.linkbuilder@gmail.com	1722930108850	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://www.atidymind.co.uk/
1113	5230	1	sam.b@frontpageadvantage.com	1719409558251	57	t	henley.ac.uk	jagdish.linkbuilder@gmail.com	1722930113454	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	48	£	https://www.henley.ac.uk/
1114	5231	1	sam.b@frontpageadvantage.com	1719409631888	63	t	musicglue.com	jagdish.linkbuilder@gmail.com	1722930121015	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	68	£	https://www.musicglue.com/
1115	5232	1	sam.b@frontpageadvantage.com	1719409732096	71	t	voice-online.co.uk	jagdish.linkbuilder@gmail.com	1722930126980	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	140	£	https://www.voice-online.co.uk/
1097	5233	1	sam.b@frontpageadvantage.com	1719396496757	31	t	strikeapose.co.uk	jagdish.linkbuilder@gmail.com	1722930132941	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://www.strikeapose.co.uk/
1099	5234	1	sam.b@frontpageadvantage.com	1719396643226	36	t	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	1722930140795	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	140	£	https://www.seriousaboutrl.com/
1100	5235	1	sam.b@frontpageadvantage.com	1719396696751	36	t	pharmacy.biz	jagdish.linkbuilder@gmail.com	1722930147855	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	104	£	https://www.pharmacy.biz/
1101	5236	1	sam.b@frontpageadvantage.com	1719396748047	67	t	pitchero.com	jagdish.linkbuilder@gmail.com	1722930153401	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	48	£	https://www.pitchero.com/
1102	5237	1	sam.b@frontpageadvantage.com	1719396805201	47	t	yourthurrock.com	jagdish.linkbuilder@gmail.com	1722930162387	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	120	£	https://www.yourthurrock.com/
1103	5238	1	sam.b@frontpageadvantage.com	1719396859158	34	t	mummyfever.co.uk	jagdish.linkbuilder@gmail.com	1722930178715	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://mummyfever.co.uk/
1104	5239	1	sam.b@frontpageadvantage.com	1719396923079	66	t	wlv.ac.uk	jagdish.linkbuilder@gmail.com	1722930184406	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	48	£	https://www.wlv.ac.uk/
1105	5240	1	sam.b@frontpageadvantage.com	1719397018040	43	t	findtheneedle.co.uk	jagdish.linkbuilder@gmail.com	1722930193790	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	120	£	https://findtheneedle.co.uk/
1116	5241	1	sam.b@frontpageadvantage.com	1719409875972	58	t	houseofspells.co.uk	jagdish.linkbuilder@gmail.com	1722930203677	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	104	£	https://houseofspells.co.uk/
1098	5242	1	sam.b@frontpageadvantage.com	1719396580592	37	t	yourharlow.com	jagdish.linkbuilder@gmail.com	1722930215468	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	120	£	https://www.yourharlow.com/
1117	5243	1	sam.b@frontpageadvantage.com	1719496409778	50	t	neconnected.co.uk	jagdish.linkbuilder@gmail.com	1722930233297	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	88	£	https://neconnected.co.uk/
1120	5244	1	sam.b@frontpageadvantage.com	1719496627284	52	t	constructionreviewonline.com	jagdish.linkbuilder@gmail.com	1722930243417	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://constructionreviewonline.com/
1119	5245	1	sam.b@frontpageadvantage.com	1719496578123	43	t	thestudentpocketguide.com	jagdish.linkbuilder@gmail.com	1722930259956	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	88	£	https://www.thestudentpocketguide.com/
1106	5246	1	sam.b@frontpageadvantage.com	1719408285725	41	t	tqsmagazine.co.uk	jagdish.linkbuilder@gmail.com	1722930270089	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	140	£	https://tqsmagazine.co.uk/
1118	5247	1	sam.b@frontpageadvantage.com	1719496491688	44	t	moshville.co.uk	jagdish.linkbuilder@gmail.com	1722930278878	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://www.moshville.co.uk/
1108	5248	1	sam.b@frontpageadvantage.com	1719408428460	39	t	thehockeypaper.co.uk	jagdish.linkbuilder@gmail.com	1722930290668	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://www.thehockeypaper.co.uk/
1109	5249	1	sam.b@frontpageadvantage.com	1719408484683	48	t	thefightingcock.co.uk	jagdish.linkbuilder@gmail.com	1722930303141	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://thefightingcock.co.uk/
1110	5250	1	sam.b@frontpageadvantage.com	1719408568561	44	t	londonforfree.net	jagdish.linkbuilder@gmail.com	1722930312708	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	160	£	https://www.londonforfree.net/
303	5303	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1722934845529	This is Owned by Chris :-)	Inbound email	f	james.p@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
778	5826	1	chris.p@frontpageadvantage.com	1709032760082	25	t	suntrics.com	suntrics4u@gmail.com	1723634932081	Suntrics	outbound	f	michael.l@frontpageadvantage.com	40	£	https://suntrics.com/
1153	5848	0	james.p@frontpageadvantage.com	1723644250691	37	f	forbesradar.co.uk	teamforbesradar@gmail.com	1723644250691	Forbes Radar	James	f	\N	62	£	https://forbesradar.co.uk/
1153	5849	1	james.p@frontpageadvantage.com	1723644250691	37	f	forbesradar.co.uk	teamforbesradar@gmail.com	1723644254240	Forbes Radar	James	f	system	62	£	https://forbesradar.co.uk/
1154	5899	0	james.p@frontpageadvantage.com	1723728287666	36	f	fabcelebbio.com	support@linksposting.com	1723728287666	Links Posting	James	f	\N	40	$	https://fabcelebbio.com/
1154	5900	1	james.p@frontpageadvantage.com	1723728287666	36	f	fabcelebbio.com	support@linksposting.com	1723728290394	Links Posting	James	f	system	40	$	https://fabcelebbio.com/
1155	5939	0	james.p@frontpageadvantage.com	1724849151681	38	f	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	1724849151681	Forbes Network	James	f	\N	70	£	https://forbesnetwork.co.uk/
1155	5940	1	james.p@frontpageadvantage.com	1724849151681	38	f	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	1724849154768	Forbes Network	James	f	system	70	£	https://forbesnetwork.co.uk/
1088	5951	1	sam.b@frontpageadvantage.com	1719320465060	36	f	family-budgeting.co.uk	katherine@orangeoutreach.com	1725332404986	Katherine Williams	Inbound	f	system	120	£	family-budgeting.co.uk
471	5952	1	historical	0	19	f	realparent.co.uk	hello@contentmother.com	1725332406146	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
782	5953	1	chris.p@frontpageadvantage.com	1709033531454	23	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1725332414595	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
1052	5954	1	michael.l@frontpageadvantage.com	1716451324696	31	f	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	1725332416122	Louise	Outbound Facebook	f	system	150	£	https://www.adventuresofayorkshiremum.co.uk/
347	5955	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1725332418705	Nigel higgins	Fatjoe	f	system	50	£	https://www.diydaddyblog.com/
323	5956	1	historical	0	25	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1725332420282	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
1002	5957	1	michael.l@frontpageadvantage.com	1713341748907	45	f	todaynews.co.uk	david@todaynews.co.uk	1725332427009	David	Inbound Michael	f	system	65	£	https://todaynews.co.uk/
652	5958	1	chris.p@frontpageadvantage.com	0	36	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1725332429611	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
355	5959	1	historical	0	35	f	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	1725332432081	Rebecca	Fatjoe	f	system	100	£	www.ialwaysbelievedinfutures.com
787	5960	1	sam.b@frontpageadvantage.com	1709041586393	39	f	netizensreport.com	premium@rabbiitfirm.com	1725332434842	Mojammel	Inbound	f	system	120	£	netizensreport.com
1054	5961	1	michael.l@frontpageadvantage.com	1716451807667	28	f	flydriveexplore.com	Hello@flydrivexexplore.com	1725332435556	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1152	5962	1	james.p@frontpageadvantage.com	1721314820107	14	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1725332441991	Rose	Contact Form	f	system	20	£	www.RosemaryHelenXO.com
1056	5963	1	michael.l@frontpageadvantage.com	1716452285003	26	f	flyingfluskey.com	rosie@flyingfluskey.com	1725332458732	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
1070	5964	1	sam.b@frontpageadvantage.com	1719317894569	22	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1725332464268	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1053	5965	1	michael.l@frontpageadvantage.com	1716451545373	28	f	emmareed.net	admin@emmareed.net	1725332465620	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
654	5966	1	chris.p@frontpageadvantage.com	0	43	f	acraftedpassion.com	info@morningbusinesschat.com	1725332495094	Brett Napoli	Inbound	f	system	100	£	https://acraftedpassion.com/
1094	5967	1	sam.b@frontpageadvantage.com	1719322155330	24	f	coffeecakekids.com	katherine@orangeoutreach.com	1725332502449	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
1072	5968	1	sam.b@frontpageadvantage.com	1719318118234	46	f	warrington-worldwide.co.uk	katherine@orangeoutreach.com	1725332511985	Katherine Williams	Inbound	f	system	150	£	warrington-worldwide.co.uk
956	5969	1	michael.l@frontpageadvantage.com	1711013035726	25	f	racingahead.net	sam.emery@greenwayspublishing.com	1725332517792	Sam	Outbound Chris	f	system	100	£	https://www.racingahead.net/
655	5970	1	chris.p@frontpageadvantage.com	0	31	f	forgetfulmomma.com	info@morningbusinesschat.com	1725332519114	Brett Napoli	Inbound	f	system	225	£	https://www.forgetfulmomma.com/
902	5971	1	sam.b@frontpageadvantage.com	1709717920944	31	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1725332520118	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
324	5972	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1725332526586	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1078	5973	1	sam.b@frontpageadvantage.com	1719319469273	23	f	redkitedays.co.uk	katherine@orangeoutreach.com	1725332528031	Katherine Williams	Inbound	f	system	160	£	redkitedays.co.uk
348	5974	1	historical	0	21	f	blossomeducation.co.uk	info@blossomeducation.co.uk	1725332536655	Vicki	Fatjoe	f	system	60	£	blossomeducation.co.uk
780	5975	1	chris.p@frontpageadvantage.com	1709033136922	19	f	travelistia.com	travelistiausa@gmail.com	1725332539244	Ferona	outbound	f	system	40	£	https://www.travelistia.com/
328	5976	1	historical	0	24	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1725332540141	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
387	5977	1	historical	0	31	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1725332544829	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
1062	5978	1	sam.b@frontpageadvantage.com	1716462238586	35	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1725332550197	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
339	5979	1	historical	0	27	f	keralpatel.com	keralpatel@gmail.com	1725332551351	Keral Patel	Fatjoe	f	system	35	£	https://www.keralpatel.com
326	5980	1	historical	0	20	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1725332560502	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
331	5981	1	historical	0	31	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1725332561601	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
334	5982	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1725332565518	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
335	5983	1	historical	0	19	f	lillaloves.com	lillaallahiary@gmail.com	1725332579632	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
337	5984	1	historical	0	24	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1725332580528	Al Baker	Fatjoe	f	system	40	£	www.thepennypincher.co.uk
358	5985	1	historical	0	23	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1725332582232	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
329	5986	1	historical	0	38	f	wemadethislife.com	wemadethislife@outlook.com	1725332584854	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
340	5987	1	historical	0	31	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1725332585818	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
342	5988	1	historical	0	34	f	karlismyunkle.com	karlismyunkle@gmail.com	1725332588627	Nik Thakkar	Fatjoe	f	system	65	£	www.karlismyunkle.com
312	5989	1	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1725332594841	Abbie	Fatjoe	f	system	45	£	mmbmagazine.co.uk
327	5990	1	historical	0	24	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1725332595753	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
341	5991	1	historical	0	15	f	sashashantel.com	contactsashashantel@gmail.com	1725332596791	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
311	5992	1	historical	0	16	f	alifeoflovely.com	alifeoflovely@gmail.com	1725332600588	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
318	5993	1	historical	0	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1725332605164	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
366	5994	1	historical	0	47	f	barbaraiweins.com	info@barbaraiweins.com	1725332610685	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
1082	5995	1	sam.b@frontpageadvantage.com	1719319867176	26	f	theowlet.co.uk	katherine@orangeoutreach.com	1725332620267	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
906	5996	1	sam.b@frontpageadvantage.com	1709718918993	46	f	liverpoolway.co.uk	kenditoys.com@gmail.com	1725332621078	David warner 	Inbound	f	system	142	£	https://www.liverpoolway.co.uk/
360	5997	1	historical	0	35	f	rachelbustin.com	rachel@rachelbustin.com	1725332623253	Rachel Bustin	Fatjoe	f	system	85	£	https://rachelbustin.com
388	5998	1	historical	0	24	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1725332625781	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
386	5999	1	historical	0	51	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1725332626617	Anna marikar	Inbound email	f	system	150	£	Intheplayroom.co.uk
365	6000	1	historical	0	37	f	letstalkmommy.com	jenny@letstalkmommy.com	1725332627401	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
377	6001	1	historical	0	38	f	travelvixta.com	victoria@travelvixta.com	1725332629247	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
398	6002	1	historical	0	25	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1725332634279	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
406	6003	1	historical	0	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1725332635179	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
379	6004	1	historical	0	27	f	yeahlifestyle.com	info@yeahlifestyle.com	1725332636966	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
381	6005	1	historical	0	33	f	therarewelshbit.com	kacie@therarewelshbit.com	1725332638652	Kacie Morgan	Inbound email	f	system	200	£	www.therarewelshbit.com
378	6006	1	historical	0	39	f	healthyvix.com	victoria@healthyvix.com	1725332642652	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
410	6007	1	historical	0	25	f	realgirlswobble.com	rohmankatrina@gmail.com	1725332646159	Katrina Rohman	Facebook	f	system	50	£	https://realgirlswobble.com/
395	6008	1	historical	0	25	f	missmanypennies.com	hello@missmanypennies.com	1725332654662	Hayley	Inbound email	f	system	85	£	www.missmanypennies.com
389	6009	1	historical	0	29	f	arthurwears.com	Arthurwears.email@gmail.com	1725332655630	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
1063	6010	1	sam.b@frontpageadvantage.com	1716462449737	38	f	grapevinebirmingham.com	kirangupta.outreach@gmail.com	1725332659602	Kiran Gupta	Inbound	f	system	80	£	grapevinebirmingham.com
423	6011	1	historical	0	28	f	mymoneycottage.com	hello@mymoneycottage.com	1725332663258	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
433	6012	1	historical	0	39	f	bq-magazine.com	hello@contentmother.com	1725332665059	Lucy Clarke	Facebook	f	system	80	£	https://www.bq-magazine.com
417	6013	1	historical	0	42	f	globalmousetravels.com	hello@globalmousetravels.com	1725332665938	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
425	6014	1	historical	0	30	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1725332667038	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
416	6015	1	historical	0	31	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1725332672760	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
440	6016	1	historical	0	63	f	ventsmagazine.com	minalkh124@gmail.com	1725332676400	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
415	6017	1	historical	0	30	f	aaublog.com	rebecca@aaublog.com	1725332682111	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
495	6018	1	historical	0	60	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1725332691010	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
499	6019	1	historical	0	59	f	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	1725332692622	Fazal	Inbound Sam	f	system	144	£	www.lifestyledaily.co.uk
391	6020	1	historical	0	40	f	conversanttraveller.com	heather@conversanttraveller.com	1725332704301	Heather	Inbound email	f	system	180	£	www.conversanttraveller.com
1083	6021	1	sam.b@frontpageadvantage.com	1719319963927	34	f	edinburgers.co.uk	katherine@orangeoutreach.com	1725332705110	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
493	6022	1	historical	0	37	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1725332711763	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
504	6023	1	historical	0	28	f	westlondonliving.co.uk	fazal.akbar@digitalczars.io	1725332717240	Fazal	Inbound Sam	f	system	84	£	www.westlondonliving.co.uk
907	6024	1	sam.b@frontpageadvantage.com	1709719202025	61	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1725332722324	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
515	6025	1	historical	0	14	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1725332724114	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
908	6026	1	sam.b@frontpageadvantage.com	1709719594822	32	f	britainreviews.co.uk	kenditoys.com@gmail.com	1725332727810	David warner 	Inbound	f	system	167	£	https://britainreviews.co.uk/
513	6027	1	historical	0	32	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1725332736888	Fazal	Inbound Sam	f	system	168	£	www.thefoodaholic.co.uk
520	6028	1	historical	0	21	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	1725332749236	Fazal	Inbound Sam	f	system	30	£	www.davidsavage.co.uk
516	6029	1	historical	0	29	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1725332751979	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
909	6030	1	sam.b@frontpageadvantage.com	1709720316064	58	f	blogstory.co.uk	kenditoys.com@gmail.com	1725332759892	David warner 	Inbound	f	system	125	£	https://blogstory.co.uk/
809	6031	1	sam.b@frontpageadvantage.com	1709637625007	55	f	pierdom.com	info@pierdom.com	1725332765875	Junaid	Outbound	f	system	25	£	https://pierdom.com/
422	6032	1	historical	0	29	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1725332769855	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
303	6033	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1725332776861	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
407	6034	1	historical	0	19	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1725332777934	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
769	6035	1	chris.p@frontpageadvantage.com	1709027357228	60	f	livepositively.com	ela690000@gmail.com	1725332789093	ela	inbound	f	system	1150	£	https://livepositively.com/
770	6036	1	chris.p@frontpageadvantage.com	1709027700111	58	f	valiantceo.com	staff@valiantceo.com	1725332792636	Valiantstaff	outbound	f	system	70	£	https://valiantceo.com/
1156	6040	0	james.p@frontpageadvantage.com	1725624962664	27	f	cuddlefairy.com	hello@cuddlefairy.com	1725624962664	Becky	James	f	\N	0	£	https://www.cuddlefairy.com/
1156	6041	1	james.p@frontpageadvantage.com	1725624962664	27	f	cuddlefairy.com	hello@cuddlefairy.com	1725624965883	Becky	James	f	system	0	£	https://www.cuddlefairy.com/
1156	6047	1	james.p@frontpageadvantage.com	1725624962664	27	f	cuddlefairy.com	hello@cuddlefairy.com	1725635039544	Becky	James	f	james.p@frontpageadvantage.com	75	£	https://www.cuddlefairy.com/
1157	6118	0	james.p@frontpageadvantage.com	1725966904913	33	f	englishlush.com	david.linkedbuilders@gmail.com	1725966904913	David	James	f	\N	10	$	http://englishlush.com/
1157	6119	1	james.p@frontpageadvantage.com	1725966904913	33	f	englishlush.com	david.linkedbuilders@gmail.com	1725966908071	David	James	f	system	10	$	http://englishlush.com/
1158	6120	0	james.p@frontpageadvantage.com	1725966960853	36	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1725966960853	David	James	f	\N	10	$	http://toptechsinfo.com/
1158	6121	1	james.p@frontpageadvantage.com	1725966960853	36	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1725966963510	David	James	f	system	10	$	http://toptechsinfo.com/
313	6180	1	historical	0	19	t	slashercareer.com	tanya@slashercareer.com	1726056486057	Tanya	Fatjoe	f	chris.p@frontpageadvantage.com	90	£	slashercareer.com
909	6181	1	sam.b@frontpageadvantage.com	1709720316064	58	t	blogstory.co.uk	kenditoys.com@gmail.com	1726056501919	David warner 	Inbound	f	chris.p@frontpageadvantage.com	125	£	https://blogstory.co.uk/
1159	6186	0	james.p@frontpageadvantage.com	1726057994078	30	f	thistradinglife.com	sofiakahn06@gmail.com	1726057994078	Sofia	James	f	\N	35	$	thistradinglife.com
1159	6187	1	james.p@frontpageadvantage.com	1726057994078	30	f	thistradinglife.com	sofiakahn06@gmail.com	1726057997126	Sofia	James	f	system	35	$	thistradinglife.com
1160	6188	0	james.p@frontpageadvantage.com	1726058131710	46	f	epodcastnetwork.com	sofiakahn06@gmail.com	1726058131710	Sofia		f	\N	60	$	epodcastnetwork.com
1160	6189	1	james.p@frontpageadvantage.com	1726058131710	46	f	epodcastnetwork.com	sofiakahn06@gmail.com	1726058134430	Sofia		f	system	60	$	epodcastnetwork.com
1161	6190	0	james.p@frontpageadvantage.com	1726058268387	74	f	oddee.com	sofiakahn06@gmail.com	1726058268387	Sofia	James	f	\N	150	$	oddee.com
1161	6191	1	james.p@frontpageadvantage.com	1726058268387	74	f	oddee.com	sofiakahn06@gmail.com	1726058271068	Sofia	James	f	system	150	$	oddee.com
1162	6192	0	james.p@frontpageadvantage.com	1726058412889	72	f	cyprus-mail.com	sofiakahn06@gmail.com	1726058412889	Sofia	James	f	\N	270	$	cyprus-mail.com
1162	6193	1	james.p@frontpageadvantage.com	1726058412889	72	f	cyprus-mail.com	sofiakahn06@gmail.com	1726058415885	Sofia	James	f	system	270	$	cyprus-mail.com
1163	6194	0	james.p@frontpageadvantage.com	1726061380233	50	f	powerhomebiz.com	sofiakahn06@gmail.com	1726061380233	Sofia	James	f	\N	250	$	powerhomebiz.com
1163	6195	1	james.p@frontpageadvantage.com	1726061380233	50	f	powerhomebiz.com	sofiakahn06@gmail.com	1726061382986	Sofia	James	f	system	250	$	powerhomebiz.com
1164	6196	0	james.p@frontpageadvantage.com	1726063207724	57	f	celebrow.org	sofiakahn06@gmail.com	1726063207724	Sofia	James	f	\N	30	$	celebrow.org
1164	6197	1	james.p@frontpageadvantage.com	1726063207724	57	f	celebrow.org	sofiakahn06@gmail.com	1726063210319	Sofia	James	f	system	30	$	celebrow.org
1165	6198	0	james.p@frontpageadvantage.com	1726063285389	55	f	filmik.blog	sofiakahn06@gmail.com	1726063285389	Sofia	James	f	\N	30	$	filmik.blog
1165	6199	1	james.p@frontpageadvantage.com	1726063285389	55	f	filmik.blog	sofiakahn06@gmail.com	1726063288476	Sofia	James	f	system	30	$	filmik.blog
1166	6200	0	james.p@frontpageadvantage.com	1726063406379	38	f	costumeplayhub.com	sofiakahn06@gmail.com	1726063406379	Sofia	James	f	\N	30	$	costumeplayhub.com
1166	6201	1	james.p@frontpageadvantage.com	1726063406379	38	f	costumeplayhub.com	sofiakahn06@gmail.com	1726063409396	Sofia	James	f	system	30	$	costumeplayhub.com
1167	6202	0	james.p@frontpageadvantage.com	1726063465343	59	f	stylesrant.org	sofiakahn06@gmail.com	1726063465343	Sofia	James	f	\N	30	$	stylesrant.org
1167	6203	1	james.p@frontpageadvantage.com	1726063465343	59	f	stylesrant.org	sofiakahn06@gmail.com	1726063468530	Sofia	James	f	system	30	$	stylesrant.org
1168	6204	0	james.p@frontpageadvantage.com	1726065344402	35	f	birdzpedia.com	sofiakahn06@gmail.com	1726065344402	Sofia	James	f	\N	35	$	birdzpedia.com
1168	6205	1	james.p@frontpageadvantage.com	1726065344402	35	f	birdzpedia.com	sofiakahn06@gmail.com	1726065347020	Sofia	James	f	system	35	$	birdzpedia.com
1169	6206	0	james.p@frontpageadvantage.com	1726065501892	57	f	knowledgewap.org	sofiakahn06@gmail.com	1726065501892	Sofia	James	f	\N	60	$	knowledgewap.org
1169	6207	1	james.p@frontpageadvantage.com	1726065501892	57	f	knowledgewap.org	sofiakahn06@gmail.com	1726065504953	Sofia	James	f	system	60	$	knowledgewap.org
1170	6208	0	james.p@frontpageadvantage.com	1726065836927	50	f	nerdbot.com	sofiakahn06@gmail.com	1726065836927	Sofia	James	f	\N	150	$	nerdbot.com
1170	6209	1	james.p@frontpageadvantage.com	1726065836927	50	f	nerdbot.com	sofiakahn06@gmail.com	1726065839768	Sofia	James	f	system	150	$	nerdbot.com
1171	6210	0	james.p@frontpageadvantage.com	1726066685680	38	f	shibleysmiles.com	sofiakahn06@gmail.com	1726066685680	Sofia	James	f	\N	150	$	shibleysmiles.com
1171	6211	1	james.p@frontpageadvantage.com	1726066685680	38	f	shibleysmiles.com	sofiakahn06@gmail.com	1726066688640	Sofia	James	f	system	150	$	shibleysmiles.com
1202	6288	0	james.p@frontpageadvantage.com	1726139288772	39	f	shemightbeloved.com	georgina@shemightbeloved.com	1726139288772	Georgina	James	f	\N	200	£	www.shemightbeloved.com
1202	6289	1	james.p@frontpageadvantage.com	1726139288772	39	f	shemightbeloved.com	georgina@shemightbeloved.com	1726139292302	Georgina	James	f	system	200	£	www.shemightbeloved.com
1203	6433	0	james.p@frontpageadvantage.com	1726241391467	37	f	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	1726241391467	Fiona	James	f	\N	70	£	http://www.dollydowsie.com/
1203	6434	1	james.p@frontpageadvantage.com	1726241391467	37	f	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	1726241394521	Fiona	James	f	system	70	£	http://www.dollydowsie.com/
1204	6530	0	james.p@frontpageadvantage.com	1726564805504	37	f	ladyjaney.co.uk	Jane@ladyjaney.co.uk	1726564805504	Jane	James contact form	f	\N	125	£	https://ladyjaney.co.uk/
1204	6531	1	james.p@frontpageadvantage.com	1726564805504	37	f	ladyjaney.co.uk	Jane@ladyjaney.co.uk	1726564808953	Jane	James contact form	f	system	125	£	https://ladyjaney.co.uk/
525	6534	1	historical	0	60	f	traveldailynews.com	backlinsprovider@gmail.com	1726578838856	David	Inbound Sam	f	james.p@frontpageadvantage.com	91	£	www.traveldailynews.com
1071	6808	1	sam.b@frontpageadvantage.com	1719318047364	30	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1727751711443	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1252	6577	0	frontpage.ga@gmail.com	1726736545268	55	f	thelifestylebloggeruk.com	thelifestylebloggeruk@aol.com	1726736545268	The Lifestyle blogger UK	Hannah	f	\N	85	£	https://thelifestylebloggeruk.com/category/money/
1252	6578	1	frontpage.ga@gmail.com	1726736545268	55	f	thelifestylebloggeruk.com	thelifestylebloggeruk@aol.com	1726736548655	The Lifestyle blogger UK	Hannah	f	system	85	£	https://thelifestylebloggeruk.com/category/money/
1254	6579	0	frontpage.ga@gmail.com	1726736911853	28	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1726736911853	Laureny Loves	Hannah	f	\N	50	£	https://www.laurenyloves.co.uk/category/money/
1254	6580	1	frontpage.ga@gmail.com	1726736911853	28	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1726736915445	Laureny Loves	Hannah	f	system	50	£	https://www.laurenyloves.co.uk/category/money/
1255	6581	0	frontpage.ga@gmail.com	1726784781949	27	f	katiemeehan.co.uk	hello@katiemeehan.co.uk	1726784781949	Katie Meehan	Hannah	f	\N	50	£	https://katiemeehan.co.uk/category/lifestyle/
1255	6582	1	frontpage.ga@gmail.com	1726784781949	27	f	katiemeehan.co.uk	hello@katiemeehan.co.uk	1726784785087	Katie Meehan	Hannah	f	system	50	£	https://katiemeehan.co.uk/category/lifestyle/
1256	6587	0	frontpage.ga@gmail.com	1726827443560	37	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1726827443560	The Everyday Man	Hannah	f	\N	150	£	https://theeverydayman.co.uk/
1256	6588	1	frontpage.ga@gmail.com	1726827443560	37	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1726827446662	The Everyday Man	Hannah	f	system	150	£	https://theeverydayman.co.uk/
1257	6592	0	frontpage.ga@gmail.com	1727080175363	41	f	vevivos.com	vickywelton@hotmail.com	1727080175363	Verily Victoria Vocalises	Hannah	f	\N	175	£	vevivos.com
1257	6593	1	frontpage.ga@gmail.com	1727080175363	41	f	vevivos.com	vickywelton@hotmail.com	1727080178818	Verily Victoria Vocalises	Hannah	f	system	175	£	vevivos.com
1258	6608	0	james.p@frontpageadvantage.com	1727177065841	37	f	eruditemeetup.co.uk	teamforbesradar@gmail.com	1727177065841	Forbes Radar	James	f	\N	120	$	http://eruditemeetup.co.uk/
1258	6609	1	james.p@frontpageadvantage.com	1727177065841	37	f	eruditemeetup.co.uk	teamforbesradar@gmail.com	1727177068897	Forbes Radar	James	f	system	120	$	http://eruditemeetup.co.uk/
1156	6611	1	james.p@frontpageadvantage.com	1725624962664	27	f	cuddlefairy.com	hello@cuddlefairy.com	1727187092920	Becky	James	f	james.p@frontpageadvantage.com	45	£	https://www.cuddlefairy.com/
752	6612	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1727187160379	sophia daniel	Inbound	f	james.p@frontpageadvantage.com	70	£	https://www.outdoorproject.com/
486	6613	1	historical	0	88	t	digitaljournal.com	sophiadaniel.co.uk@gmail.com	1727187191791	Sophia	Inbound Sam	f	james.p@frontpageadvantage.com	130	£	www.digitaljournal.com
764	6614	1	sam.b@frontpageadvantage.com	1708616228406	94	t	yahoo.com	ela690000@gmail.com	1727187207276	Ella	Inbound	f	james.p@frontpageadvantage.com	125	£	https://news.yahoo.com/
531	6615	1	historical	0	37	t	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1727187221664	Sophia Daniel	Inbound Sam	f	james.p@frontpageadvantage.com	155	£	www.businessmanchester.co.uk
1302	6652	0	rdomloge@gmail.com	1727196482040	50	f	github.com	rdomloge@hotmail.com	1727196482040	Ramsay test	Testing	f	\N	10	£	www.github.com
1302	6653	1	rdomloge@gmail.com	1727196482040	96	f	github.com	rdomloge@hotmail.com	1727196485103	Ramsay test	Testing	f	system	10	£	www.github.com
1302	6654	1	rdomloge@gmail.com	1727196482040	96	f	github.com	rdomloge@hotmail.com	1727196506431	Ramsay test	Testing	f	rdomloge@gmail.com	10	£	www.github.com
1302	6655	1	rdomloge@gmail.com	1727196482040	96	f	whatsapp.com	rdomloge@hotmail.com	1727196613138	Ramsay test	Testing	f	rdomloge@gmail.com	10	£	www.whatsapp.com
1302	6663	1	rdomloge@gmail.com	1727196482040	98	f	whatsapp.com	rdomloge@hotmail.com	1727233237617	Ramsay test	Testing	f	system	10	£	www.whatsapp.com
752	6672	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1727252093809	sophia daniel	Inbound	f	chris.p@frontpageadvantage.com	50	£	https://www.outdoorproject.com/
531	6673	1	historical	0	37	t	businessmanchester.co.uk	sophiadaniel.co.uk@gmail.com	1727252122588	Sophia Daniel	Inbound Sam	f	chris.p@frontpageadvantage.com	90	£	www.businessmanchester.co.uk
1303	6674	0	chris.p@frontpageadvantage.com	1727252702565	38	f	nyweekly.co.uk	sophiadaniel.co.uk@gmail.com	1727252702565	sophia daniel 	inbound	f	\N	55	£	https://nyweekly.co.uk/
1303	6675	1	chris.p@frontpageadvantage.com	1727252702565	38	f	nyweekly.co.uk	sophiadaniel.co.uk@gmail.com	1727252705898	sophia daniel 	inbound	f	system	55	£	https://nyweekly.co.uk/
1089	6782	1	sam.b@frontpageadvantage.com	1719320544130	32	f	crummymummy.co.uk	crummymummy@live.co.uk	1727340841361	Natalie	James	f	james.p@frontpageadvantage.com	60	£	crummymummy.co.uk
362	6798	1	historical	0	39	f	hausmanmarketingletter.com	angie@hausmanmarketingletter.com	1727354893023	Angela Hausman	Fatjoe	f	chris.p@frontpageadvantage.com	150	£	https://hausmanmarketingletter.com
762	6799	1	sam.b@frontpageadvantage.com	1708615840028	17	f	flatpackhouses.co.uk	falcobliek@gmail.com	1727751604553	Falco	Inbound	f	system	120	£	https://www.flatpackhouses.co.uk/
1090	6800	1	sam.b@frontpageadvantage.com	1719320639079	69	f	markmeets.com	katherine@orangeoutreach.com	1727751607773	Katherine Williams	Inbound	f	system	100	£	markmeets.com
1153	6801	1	james.p@frontpageadvantage.com	1723644250691	38	f	forbesradar.co.uk	teamforbesradar@gmail.com	1727751610084	Forbes Radar	James	f	system	62	£	https://forbesradar.co.uk/
1055	6802	1	michael.l@frontpageadvantage.com	1716452047818	22	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1727751628331	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
752	6803	1	chris.p@frontpageadvantage.com	1708082585011	58	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1727751643553	sophia daniel	Inbound	f	system	50	£	https://www.outdoorproject.com/
784	6804	1	chris.p@frontpageadvantage.com	1709035290025	36	f	okaybliss.com	infopediapros@gmail.com	1727751674489	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
761	6805	1	sam.b@frontpageadvantage.com	1708615661584	36	f	holyroodpr.co.uk	falcobliek@gmail.com	1727751697303	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
654	6806	1	chris.p@frontpageadvantage.com	0	39	f	acraftedpassion.com	info@morningbusinesschat.com	1727751704102	Brett Napoli	Inbound	f	system	100	£	https://acraftedpassion.com/
953	6807	1	michael.l@frontpageadvantage.com	1711012683237	42	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1727751706044	Sam	Outbound Chris	f	system	100	£	https://www.thecricketpaper.com/
1305	6869	0	james.p@frontpageadvantage.com	1727789968431	0	f	\N	\N	1727789968431	Rhino Rank	\N	t	\N	0	\N	\N
1094	6809	1	sam.b@frontpageadvantage.com	1719322155330	25	f	coffeecakekids.com	katherine@orangeoutreach.com	1727751712684	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
1158	6810	1	james.p@frontpageadvantage.com	1725966960853	37	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1727751714147	David	James	f	system	10	$	http://toptechsinfo.com/
1171	6811	1	james.p@frontpageadvantage.com	1726066685680	39	f	shibleysmiles.com	sofiakahn06@gmail.com	1727751720206	Sofia	James	f	system	150	$	shibleysmiles.com
1060	6812	1	michael.l@frontpageadvantage.com	1716452913891	44	f	safarisafricana.com	jacquiehale75@gmail.com	1727751730729	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
349	6822	1	historical	0	24	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1727751788031	Vicki	Fatjoe	f	system	60	£	Icenimagazine.co.uk
305	6823	1	historical	0	15	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1727751791785	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
345	6826	1	historical	0	16	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1727751801814	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
329	6827	1	historical	0	36	f	wemadethislife.com	wemadethislife@outlook.com	1727751806653	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
317	6828	1	historical	0	29	f	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	1727751810048	Jen	Fatjoe	f	system	30	£	www.jenloumeredith.com
340	6829	1	historical	0	32	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1727751811905	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
956	6813	1	michael.l@frontpageadvantage.com	1711013035726	26	f	racingahead.net	sam.emery@greenwayspublishing.com	1727751732066	Sam	Outbound Chris	f	system	100	£	https://www.racingahead.net/
954	6814	1	michael.l@frontpageadvantage.com	1711012828815	51	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1727751733957	Sam	Outbound Chris	f	system	100	£	https://www.thenonleaguefootballpaper.com/
1059	6815	1	michael.l@frontpageadvantage.com	1716452853668	25	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1727751746174	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
777	6816	1	chris.p@frontpageadvantage.com	1709032527056	29	f	yourpetplanet.com	info@yourpetplanet.com	1727751748297	Your Pet Planet	inbound	f	system	42	£	https://yourpetplanet.com/
1160	6817	1	james.p@frontpageadvantage.com	1726058131710	47	f	epodcastnetwork.com	sofiakahn06@gmail.com	1727751756185	Sofia		f	system	60	$	epodcastnetwork.com
905	6818	1	sam.b@frontpageadvantage.com	1709718547266	49	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1727751766118	David warner 	Inbound	f	system	150	£	https://www.luxurylifestylemag.co.uk/
348	6819	1	historical	0	22	f	blossomeducation.co.uk	info@blossomeducation.co.uk	1727751775000	Vicki	Fatjoe	f	system	60	£	blossomeducation.co.uk
328	6820	1	historical	0	23	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1727751777473	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1062	6821	1	sam.b@frontpageadvantage.com	1716462238586	34	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1727751779901	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
335	6824	1	historical	0	20	f	lillaloves.com	lillaallahiary@gmail.com	1727751795594	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
358	6825	1	historical	0	21	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1727751800007	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
366	6830	1	historical	0	46	f	barbaraiweins.com	info@barbaraiweins.com	1727751837145	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
1082	6831	1	sam.b@frontpageadvantage.com	1719319867176	27	f	theowlet.co.uk	katherine@orangeoutreach.com	1727751839850	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
365	6832	1	historical	0	38	f	letstalkmommy.com	jenny@letstalkmommy.com	1727751852093	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
377	6833	1	historical	0	39	f	travelvixta.com	victoria@travelvixta.com	1727751853773	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
379	6834	1	historical	0	26	f	yeahlifestyle.com	info@yeahlifestyle.com	1727751865625	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
378	6835	1	historical	0	40	f	healthyvix.com	victoria@healthyvix.com	1727751867836	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
410	6836	1	historical	0	24	f	realgirlswobble.com	rohmankatrina@gmail.com	1727751871458	Katrina Rohman	Facebook	f	system	50	£	https://realgirlswobble.com/
390	6837	1	historical	0	31	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1727751884352	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
483	6838	1	historical	0	31	f	packthepjs.com	tracey@packthepjs.com	1727751927428	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
400	6839	1	historical	0	32	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	1727751929101	Christopher	Inbound email	f	system	79	£	https://estateagentnetworking.co.uk/
472	6840	1	historical	0	29	f	pleasureprinciple.net	hello@contentmother.com	1727751930919	Becky	inbound email	f	system	50	£	https://www.pleasureprinciple.net
414	6841	1	historical	0	21	f	joannavictoria.co.uk	joannabayford@gmail.com	1727751942276	Joanna Bayford	Facebook	f	system	50	£	https://www.joannavictoria.co.uk
474	6842	1	historical	0	18	f	lclarke.co.uk	hello@contentmother.com	1727751953340	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
907	6843	1	sam.b@frontpageadvantage.com	1709719202025	62	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1727751959816	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
515	6844	1	historical	0	15	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1727751960483	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
534	6845	1	historical	0	40	f	saddind.co.uk	natalilacanario@gmail.com	1727751966864	Natalila	Inbound Sam	f	system	175	£	saddind.co.uk
524	6846	1	historical	0	37	f	travelbeginsat40.com	backlinsprovider@gmail.com	1727751972646	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
781	6847	1	chris.p@frontpageadvantage.com	1709033259858	47	f	kidsworldfun.com	enquiry@kidsworldfun.com	1727751975874	Limna	outbound	f	system	80	£	https://www.kidsworldfun.com/
1084	6848	1	sam.b@frontpageadvantage.com	1719320073095	29	f	bouncemagazine.co.uk	katherine@orangeoutreach.com	1727751979481	Katherine Williams	Inbound	f	system	100	£	bouncemagazine.co.uk
521	6849	1	historical	0	18	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1727751984078	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
808	6850	1	sam.b@frontpageadvantage.com	1709637089134	19	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1727751989428	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
384	6851	1	historical	0	36	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1727752000407	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
404	6852	1	historical	0	22	f	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	1727752002141	Elizabeth Williams	Inbound email	f	system	80	£	www.whererootsandwingsentwine.com
517	6853	1	historical	0	22	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1727752004603	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
497	6854	1	historical	0	29	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1727752009169	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
303	6855	1	historical	0	22	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1727752018355	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
1168	6856	1	james.p@frontpageadvantage.com	1726065344402	34	f	birdzpedia.com	sofiakahn06@gmail.com	1727752029587	Sofia	James	f	system	35	$	birdzpedia.com
1157	6867	1	james.p@frontpageadvantage.com	1725966904913	33	t	englishlush.com	david.linkedbuilders@gmail.com	1727789891750	David	James	f	chris.p@frontpageadvantage.com	10	$	http://englishlush.com/
1304	6868	0	james.p@frontpageadvantage.com	1727789913477	0	f	\N	\N	1727789913477	Click Intelligence	\N	t	\N	0	\N	\N
652	6902	1	chris.p@frontpageadvantage.com	0	32	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1727838019050	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
957	6903	1	chris.p@frontpageadvantage.com	1711532679719	46	f	north.wales	backlinsprovider@gmail.com	1727838139942	David Smith	Inbound	f	system	95	£	https://north.wales/
402	6904	1	historical	0	58	f	mammaprada.com	mammaprada@gmail.com	1727838140842	Kristie Prada	Inbound email	f	system	90	£	https://www.mammaprada.com
770	6905	1	chris.p@frontpageadvantage.com	1709027700111	58	t	valiantceo.com	staff@valiantceo.com	1727876262241	Valiantstaff	outbound	f	chris.p@frontpageadvantage.com	70	£	https://valiantceo.com/
404	6906	1	historical	0	22	t	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	1727877493262	Elizabeth Williams	Inbound email	f	chris.p@frontpageadvantage.com	80	£	www.whererootsandwingsentwine.com
342	6907	1	historical	0	34	f	karlismyunkle.com	karlismyunkle@gmail.com	1727877543538	Nik Thakkar	Fatjoe	f	chris.p@frontpageadvantage.com	45	£	www.karlismyunkle.com
780	6908	1	chris.p@frontpageadvantage.com	1709033136922	19	f	travelistia.com	travelistiausa@gmail.com	1727943737440	Ferona	outbound	f	chris.p@frontpageadvantage.com	27	£	https://www.travelistia.com/
402	6909	1	historical	0	58	t	mammaprada.com	mammaprada@gmail.com	1727944130012	Kristie Prada	Inbound email	f	chris.p@frontpageadvantage.com	90	£	https://www.mammaprada.com
804	6910	1	sam.b@frontpageadvantage.com	1709213279175	79	t	e-architect.com	isabelle@e-architect.com	1727944328867	Isabelle Lomholt	Outbound Sam	f	chris.p@frontpageadvantage.com	100	£	https://www.e-architect.com/
418	6911	1	historical	0	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	1727945876466	Petra	Facebook	f	chris.p@frontpageadvantage.com	40	£	https://amumreviews.co.uk/
1306	6918	1	james.p@frontpageadvantage.com	1727789980135	47	f	phoenixfm.com	\N	1728378333390	Click Intelligence	\N	t	james.p@frontpageadvantage.com	180	£	https://www.phoenixfm.com
1307	6922	1	james.p@frontpageadvantage.com	1727789991606	42	f	b31.org.uk	\N	1728378370976	Click Intelligence	\N	t	james.p@frontpageadvantage.com	180	£	https://b31.org.uk
1308	6926	1	james.p@frontpageadvantage.com	1727790152208	50	f	savedelete.com	\N	1728378597650	Rhino Rank	\N	t	james.p@frontpageadvantage.com	192	£	https://savedelete.com
1308	6928	1	james.p@frontpageadvantage.com	1727790152208	0	f	\N	\N	1728378602313	Rhino Rank	\N	t	james.p@frontpageadvantage.com	0	\N	\N
1308	6930	1	james.p@frontpageadvantage.com	1727790152208	50	f	savedelete.com	\N	1728378625735	Rhino Rank	\N	t	james.p@frontpageadvantage.com	192	£	https://savedelete.com
1305	6934	1	james.p@frontpageadvantage.com	1727789968431	58	f	onyamagazine.com	\N	1728378702283	Rhino Rank	\N	t	james.p@frontpageadvantage.com	192	£	https://www.onyamagazine.com
1305	6953	1	james.p@frontpageadvantage.com	1727789968431	0	f	\N	\N	1728563475202	Rhino Rank	\N	t	james.p@frontpageadvantage.com	0	\N	\N
1305	6955	1	james.p@frontpageadvantage.com	1727789968431	56	f	budgetsavvydiva.com	\N	1728563534667	Rhino Rank	\N	t	james.p@frontpageadvantage.com	0	\N	https://www.budgetsavvydiva.com
1302	7021	1	rdomloge@gmail.com	1727196482040	98	f	whatsapp.com	ramsay.domloge@bca.com	1728979511773	Ramsay test	Testing	f	rdomloge@gmail.com	10	£	www.whatsapp.com
752	7274	1	chris.p@frontpageadvantage.com	1708082585011	58	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1729585654047	sophia daniel	Inbound	f	james.p@frontpageadvantage.com	50	£	https://www.outdoorproject.com/
1352	7326	0	frontpage.ga@gmail.com	1729768172025	63	f	twinsdrycleaners.co.uk	arianna@timewomenflag.com	1729768172025	Arianna Volkova	inboud	f	\N	25	£	twinsdrycleaners.co.uk
1352	7327	1	frontpage.ga@gmail.com	1729768172025	63	f	twinsdrycleaners.co.uk	arianna@timewomenflag.com	1729768175252	Arianna Volkova	inboud	f	system	25	£	twinsdrycleaners.co.uk
1353	7328	0	frontpage.ga@gmail.com	1729768339748	63	f	uvenco.co.uk	arianne@timewomenflag.com	1729768339748	Arianna Volkova	inbound	f	\N	25	£	uvenco.co.uk
1353	7329	1	frontpage.ga@gmail.com	1729768339748	63	f	uvenco.co.uk	arianne@timewomenflag.com	1729768342825	Arianna Volkova	inbound	f	system	25	£	uvenco.co.uk
1354	7330	0	frontpage.ga@gmail.com	1729769295496	56	f	couponfollow.co.uk	arianne@timewomenflag.com	1729769295496	Arianna Volkova	inbound	f	\N	25	£	https://couponfollow.co.uk/
1354	7331	1	frontpage.ga@gmail.com	1729769295496	55	f	couponfollow.co.uk	arianne@timewomenflag.com	1729769298606	Arianna Volkova	inbound	f	system	25	£	https://couponfollow.co.uk/
1355	7332	0	frontpage.ga@gmail.com	1729769821170	37	f	wrapofthedays.co.uk	arianne@timewomenflag.com	1729769821170	Arianna Volkova	inbound	f	\N	25	£	wrapofthedays.co.uk
1355	7333	1	frontpage.ga@gmail.com	1729769821170	37	f	wrapofthedays.co.uk	arianne@timewomenflag.com	1729769824046	Arianna Volkova	inbound	f	system	25	£	wrapofthedays.co.uk
1356	7334	0	frontpage.ga@gmail.com	1729770014428	37	f	mealtop.co.uk	arianne@timewomenflag.com	1729770014428	Arianna Volkova	inbound	f	\N	25	£	https://mealtop.co.uk/
1356	7335	1	frontpage.ga@gmail.com	1729770014428	37	f	mealtop.co.uk	arianne@timewomenflag.com	1729770017317	Arianna Volkova	inbound	f	system	25	£	https://mealtop.co.uk/
1354	7336	1	frontpage.ga@gmail.com	1729769295496	55	t	couponfollow.co.uk	arianne@timewomenflag.com	1729855125410	Arianna Volkova	inbound	f	chris.p@frontpageadvantage.com	25	£	https://couponfollow.co.uk/
1353	7337	1	frontpage.ga@gmail.com	1729768339748	63	t	uvenco.co.uk	arianne@timewomenflag.com	1729855146460	Arianna Volkova	inbound	f	chris.p@frontpageadvantage.com	25	£	uvenco.co.uk
1352	7338	1	frontpage.ga@gmail.com	1729768172025	63	t	twinsdrycleaners.co.uk	arianna@timewomenflag.com	1729855161244	Arianna Volkova	inboud	f	chris.p@frontpageadvantage.com	25	£	twinsdrycleaners.co.uk
1356	7339	1	frontpage.ga@gmail.com	1729770014428	37	f	mealtop.co.uk	arianne@timewomenflag.com	1729855575392	Arianna Volkova	inbound	f	chris.p@frontpageadvantage.com	25	£	https://mealtop.co.uk/
357	7353	1	historical	0	55	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	1730195776853	Becky Freeman	Fatjoe	f	chris.p@frontpageadvantage.com	50	£	www.spiritedpuddlejumper.com
1357	7354	0	chris.p@frontpageadvantage.com	1730196590897	66	f	dailysquib.co.uk	arianna@timewomenflag.com	1730196590897	Arianna Volkova	inbound	f	\N	141	£	dailysquib.co.uk
1357	7355	1	chris.p@frontpageadvantage.com	1730196590897	66	f	dailysquib.co.uk	arianna@timewomenflag.com	1730196593886	Arianna Volkova	inbound	f	system	141	£	dailysquib.co.uk
1358	7356	0	chris.p@frontpageadvantage.com	1730196614139	64	f	marketoracle.co.uk	arianna@timewomenflag.com	1730196614139	Arianna Volkova	inbound	f	\N	94	£	marketoracle.co.uk
1358	7357	1	chris.p@frontpageadvantage.com	1730196614139	64	f	marketoracle.co.uk	arianna@timewomenflag.com	1730196617166	Arianna Volkova	inbound	f	system	94	£	marketoracle.co.uk
1402	7503	0	frontpage.ga@gmail.com	1730296493781	53	f	hrnews.co.uk	arianne@timewomenflag.com	1730296493781	Arianne Volkova	inbound	f	\N	122	£	hrnews.co.uk
1402	7504	1	frontpage.ga@gmail.com	1730296493781	53	f	hrnews.co.uk	arianne@timewomenflag.com	1730296496987	Arianne Volkova	inbound	f	system	122	£	hrnews.co.uk
1403	7505	0	frontpage.ga@gmail.com	1730296526142	52	f	aboutmanchester.co.uk	arianne@timewomenflag.com	1730296526142	Arianne Volkova	inbound	f	\N	146	£	aboutmanchester.co.uk
1403	7506	1	frontpage.ga@gmail.com	1730296526142	52	f	aboutmanchester.co.uk	arianne@timewomenflag.com	1730296529019	Arianne Volkova	inbound	f	system	146	£	aboutmanchester.co.uk
1404	7507	0	frontpage.ga@gmail.com	1730296573812	45	f	pczone.co.uk	arianne@timewomenflag.com	1730296573812	Arianne Volkova	inbound	f	\N	114	£	pczone.co.uk
1404	7508	1	frontpage.ga@gmail.com	1730296573812	45	f	pczone.co.uk	arianne@timewomenflag.com	1730296577075	Arianne Volkova	inbound	f	system	114	£	pczone.co.uk
1405	7509	0	frontpage.ga@gmail.com	1730296607431	40	f	ramzine.co.uk	arianne@timewomenflag.com	1730296607431	Arianne Volkova	inbound	f	\N	114	£	ramzine.co.uk
1405	7510	1	frontpage.ga@gmail.com	1730296607431	40	f	ramzine.co.uk	arianne@timewomenflag.com	1730296610538	Arianne Volkova	inbound	f	system	114	£	ramzine.co.uk
1406	7511	0	frontpage.ga@gmail.com	1730296630124	43	f	madeinshoreditch.co.uk	arianne@timewomenflag.com	1730296630124	Arianne Volkova	inbound	f	\N	158	£	madeinshoreditch.co.uk
1406	7512	1	frontpage.ga@gmail.com	1730296630124	43	f	madeinshoreditch.co.uk	arianne@timewomenflag.com	1730296632863	Arianne Volkova	inbound	f	system	158	£	madeinshoreditch.co.uk
1407	7513	0	frontpage.ga@gmail.com	1730296672141	42	f	themarketingblog.co.uk	arianne@timewomenflag.com	1730296672141	Arianne Volkova	inbound	f	\N	129	£	themarketingblog.co.uk
1407	7514	1	frontpage.ga@gmail.com	1730296672141	42	f	themarketingblog.co.uk	arianne@timewomenflag.com	1730296674922	Arianne Volkova	inbound	f	system	129	£	themarketingblog.co.uk
1408	7515	0	frontpage.ga@gmail.com	1730296799161	41	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1730296799161	Arianne Volkova	inbound	f	\N	134	£	fionaoutdoors.co.uk
1408	7516	1	frontpage.ga@gmail.com	1730296799161	41	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1730296802595	Arianne Volkova	inbound	f	system	134	£	fionaoutdoors.co.uk
1409	7517	0	frontpage.ga@gmail.com	1730296845823	40	f	britishicehockey.co.uk	arianne@timewomenflag.com	1730296845823	Arianne Volkova	inbound	f	\N	134	£	britishicehockey.co.uk
1409	7518	1	frontpage.ga@gmail.com	1730296845823	40	f	britishicehockey.co.uk	arianne@timewomenflag.com	1730296848773	Arianne Volkova	inbound	f	system	134	£	britishicehockey.co.uk
1410	7519	0	frontpage.ga@gmail.com	1730296903193	37	f	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	1730296903193	Arianne Volkova	inbound	f	\N	141	£	glitzandglamourmakeup.co.uk
1410	7520	1	frontpage.ga@gmail.com	1730296903193	37	f	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	1730296906303	Arianne Volkova	inbound	f	system	141	£	glitzandglamourmakeup.co.uk
1411	7521	0	frontpage.ga@gmail.com	1730296950461	39	f	businessvans.co.uk	arianne@timewomenflag.com	1730296950461	Arianne Volkova	inbound	f	\N	129	£	businessvans.co.uk
1411	7522	1	frontpage.ga@gmail.com	1730296950461	39	f	businessvans.co.uk	arianne@timewomenflag.com	1730296953472	Arianne Volkova	inbound	f	system	129	£	businessvans.co.uk
1412	7523	0	frontpage.ga@gmail.com	1730296980153	39	f	kettlemag.co.uk	arianne@timewomenflag.com	1730296980153	Arianne Volkova	inbound	f	\N	130	£	kettlemag.co.uk
1412	7524	1	frontpage.ga@gmail.com	1730296980153	39	f	kettlemag.co.uk	arianne@timewomenflag.com	1730296983007	Arianne Volkova	inbound	f	system	130	£	kettlemag.co.uk
1413	7525	0	frontpage.ga@gmail.com	1730297027604	39	f	businessfirstonline.co.uk	arianne@timewomenflag.com	1730297027604	Arianne Volkova	inbound	f	\N	134	£	businessfirstonline.co.uk
1413	7526	1	frontpage.ga@gmail.com	1730297027604	39	f	businessfirstonline.co.uk	arianne@timewomenflag.com	1730297030533	Arianne Volkova	inbound	f	system	134	£	businessfirstonline.co.uk
1414	7527	0	frontpage.ga@gmail.com	1730297056465	37	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	1730297056465	Arianne Volkova	inbound	f	\N	118	£	singleparentsonholiday.co.uk
1414	7528	1	frontpage.ga@gmail.com	1730297056465	37	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	1730297059292	Arianne Volkova	inbound	f	system	118	£	singleparentsonholiday.co.uk
1415	7529	0	frontpage.ga@gmail.com	1730297155721	36	f	blackeconomics.co.uk	arianne@timewomenflag.com	1730297155721	Arianne Volkova	inbound	f	\N	134	£	blackeconomics.co.uk
1415	7530	1	frontpage.ga@gmail.com	1730297155721	36	f	blackeconomics.co.uk	arianne@timewomenflag.com	1730297158927	Arianne Volkova	inbound	f	system	134	£	blackeconomics.co.uk
1416	7531	0	frontpage.ga@gmail.com	1730297416645	35	f	smallcapnews.co.uk	arianne@timewomenflag.com	1730297416645	Arianne Volkova	inbound	f	\N	158	£	Smallcapnews.co.uk
1416	7532	1	frontpage.ga@gmail.com	1730297416645	35	f	smallcapnews.co.uk	arianne@timewomenflag.com	1730297419484	Arianne Volkova	inbound	f	system	158	£	Smallcapnews.co.uk
1417	7533	0	frontpage.ga@gmail.com	1730297448496	33	f	journaloftradingstandards.co.uk	arianne@timewomenflag.com	1730297448496	Arianne Volkova	inbound	f	\N	103	£	journaloftradingstandards.co.uk
1417	7534	1	frontpage.ga@gmail.com	1730297448496	33	f	journaloftradingstandards.co.uk	arianne@timewomenflag.com	1730297451902	Arianne Volkova	inbound	f	system	103	£	journaloftradingstandards.co.uk
1418	7535	0	frontpage.ga@gmail.com	1730297487047	34	f	thisisbrighton.co.uk	arianne@timewomenflag.com	1730297487047	Arianne Volkova	inbound	f	\N	140	£	thisisbrighton.co.uk
1418	7536	1	frontpage.ga@gmail.com	1730297487047	34	f	thisisbrighton.co.uk	arianne@timewomenflag.com	1730297490100	Arianne Volkova	inbound	f	system	140	£	thisisbrighton.co.uk
1419	7537	0	frontpage.ga@gmail.com	1730297531326	33	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	1730297531326	Arianne Volkova	inbound	f	\N	106	£	familyfriendlyworking.co.uk
1419	7538	1	frontpage.ga@gmail.com	1730297531326	33	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	1730297534215	Arianne Volkova	inbound	f	system	106	£	familyfriendlyworking.co.uk
1420	7539	0	frontpage.ga@gmail.com	1730297564122	32	f	clickdo.co.uk	arianne@timewomenflag.com	1730297564122	Arianne Volkova	inbound	f	\N	118	£	business.clickdo.co.uk
1420	7540	1	frontpage.ga@gmail.com	1730297564122	32	f	clickdo.co.uk	arianne@timewomenflag.com	1730297566885	Arianne Volkova	inbound	f	system	118	£	business.clickdo.co.uk
1421	7541	0	frontpage.ga@gmail.com	1730297627872	34	f	propertydivision.co.uk	arianne@timewomenflag.com	1730297627872	Arianne Volkova	inbound	f	\N	131	£	propertydivision.co.uk
1421	7542	1	frontpage.ga@gmail.com	1730297627872	34	f	propertydivision.co.uk	arianne@timewomenflag.com	1730297631893	Arianne Volkova	inbound	f	system	131	£	propertydivision.co.uk
1422	7543	0	frontpage.ga@gmail.com	1730297665873	33	f	taketotheroad.co.uk	arianne@timewomenflag.com	1730297665873	Arianne Volkova	inbound	f	\N	139	£	taketotheroad.co.uk
1422	7544	1	frontpage.ga@gmail.com	1730297665873	33	f	taketotheroad.co.uk	arianne@timewomenflag.com	1730297668737	Arianne Volkova	inbound	f	system	139	£	taketotheroad.co.uk
1423	7545	0	frontpage.ga@gmail.com	1730297707203	34	f	planetveggie.co.uk	arianne@timewomenflag.com	1730297707203	Arianne Volkova	inbound	f	\N	145	£	planetveggie.co.uk
1423	7546	1	frontpage.ga@gmail.com	1730297707203	34	f	planetveggie.co.uk	arianne@timewomenflag.com	1730297710073	Arianne Volkova	inbound	f	system	145	£	planetveggie.co.uk
1424	7547	0	frontpage.ga@gmail.com	1730297739559	33	f	mummyinatutu.co.uk	arianne@timewomenflag.com	1730297739559	Arianne Volkova	inbound	f	\N	98	£	mummyinatutu.co.uk
1424	7548	1	frontpage.ga@gmail.com	1730297739559	33	f	mummyinatutu.co.uk	arianne@timewomenflag.com	1730297742464	Arianne Volkova	inbound	f	system	98	£	mummyinatutu.co.uk
1425	7549	0	frontpage.ga@gmail.com	1730297780739	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1730297780739	Arianne Volkova	inbound	f	\N	106	£	lobsterdigitalmarketing.co.uk
1425	7550	1	frontpage.ga@gmail.com	1730297780739	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1730297783656	Arianne Volkova	inbound	f	system	106	£	lobsterdigitalmarketing.co.uk
1426	7551	0	frontpage.ga@gmail.com	1730297811663	32	f	joannedewberry.co.uk	arianne@timewomenflag.com	1730297811663	Arianne Volkova	inbound	f	\N	122	£	joannedewberry.co.uk
1426	7552	1	frontpage.ga@gmail.com	1730297811663	32	f	joannedewberry.co.uk	arianne@timewomenflag.com	1730297814808	Arianne Volkova	inbound	f	system	122	£	joannedewberry.co.uk
1427	7553	0	frontpage.ga@gmail.com	1730297857266	27	f	shelllouise.co.uk	arianne@timewomenflag.com	1730297857266	Arianne Volkova	inbound	f	\N	106	£	shelllouise.co.uk
1427	7554	1	frontpage.ga@gmail.com	1730297857266	27	f	shelllouise.co.uk	arianne@timewomenflag.com	1730297860165	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
1428	7555	0	frontpage.ga@gmail.com	1730297891567	0	f	feast-magazine.co.uk	arianne@timewomenflag.com	1730297891567	Arianne Volkova	inbound	f	\N	118	£	feast-magazine.co.uk
1428	7556	1	frontpage.ga@gmail.com	1730297891567	29	f	feast-magazine.co.uk	arianne@timewomenflag.com	1730297894246	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
1429	7557	0	frontpage.ga@gmail.com	1730297923475	26	f	simpleparenting.co.uk	arianne@timewomenflag.com	1730297923475	Arianne Volkova	inbound	f	\N	139	£	simpleparenting.co.uk
1429	7558	1	frontpage.ga@gmail.com	1730297923475	26	f	simpleparenting.co.uk	arianne@timewomenflag.com	1730297926291	Arianne Volkova	inbound	f	system	139	£	simpleparenting.co.uk
771	7561	1	chris.p@frontpageadvantage.com	1709027801990	42	f	finehomesandliving.com	info@fine-magazine.com	1730430001087	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
752	7562	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1730430008403	sophia daniel	Inbound	f	system	50	£	https://www.outdoorproject.com/
1055	7563	1	michael.l@frontpageadvantage.com	1716452047818	21	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1730430009589	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
374	7564	1	historical	0	66	f	simslife.co.uk	sim@simslife.co.uk	1730430011512	Sim Riches	Fatjoe	f	system	130	£	https://simslife.co.uk
782	7565	1	chris.p@frontpageadvantage.com	1709033531454	21	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1730430012205	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
347	7566	1	historical	0	31	f	diydaddyblog.com	Diynige@yahoo.com	1730430012693	Nigel higgins	Fatjoe	f	system	50	£	https://www.diydaddyblog.com/
491	7567	1	historical	0	54	f	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	1730430016312	Fazal	Inbound Sam	f	system	168	£	www.theexeterdaily.co.uk
316	7568	1	historical	0	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1730430016851	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
1070	7569	1	sam.b@frontpageadvantage.com	1719317894569	23	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1730430031485	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1069	7570	1	sam.b@frontpageadvantage.com	1719317784130	28	f	caranalytics.co.uk	katherine@orangeoutreach.com	1730430034951	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
784	7571	1	chris.p@frontpageadvantage.com	1709035290025	38	f	okaybliss.com	infopediapros@gmail.com	1730430037523	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
953	7572	1	michael.l@frontpageadvantage.com	1711012683237	41	f	thecricketpaper.com	sam.emery@greenwayspublishing.com	1730430044063	Sam	Outbound Chris	f	system	100	£	https://www.thecricketpaper.com/
1095	7573	1	sam.b@frontpageadvantage.com	1719322290354	34	f	largerfamilylife.com	katherine@orangeoutreach.com	1730430044640	Katherine Williams	Inbound	f	system	100	£	largerfamilylife.com
1071	7574	1	sam.b@frontpageadvantage.com	1719318047364	31	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1730430045833	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1159	7575	1	james.p@frontpageadvantage.com	1726057994078	31	f	thistradinglife.com	sofiakahn06@gmail.com	1730430058320	Sofia	James	f	system	35	$	thistradinglife.com
955	7576	1	michael.l@frontpageadvantage.com	1711012971138	27	f	latetacklemagazine.com	sam.emery@greenwayspublishing.com	1730430059607	Sam	Outbound Chris	f	system	100	£	https://www.latetacklemagazine.com/
1160	7577	1	james.p@frontpageadvantage.com	1726058131710	46	f	epodcastnetwork.com	sofiakahn06@gmail.com	1730430064111	Sofia		f	system	60	$	epodcastnetwork.com
324	7578	1	historical	0	13	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1730430065602	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1078	7579	1	sam.b@frontpageadvantage.com	1719319469273	22	f	redkitedays.co.uk	katherine@orangeoutreach.com	1730430066128	Katherine Williams	Inbound	f	system	160	£	redkitedays.co.uk
1081	7580	1	sam.b@frontpageadvantage.com	1719319784878	37	f	emmysmummy.com	katherine@orangeoutreach.com	1730430076345	Katherine Williams	Inbound	f	system	120	£	emmysmummy.com
328	7581	1	historical	0	21	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1730430081734	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
905	7582	1	sam.b@frontpageadvantage.com	1709718547266	50	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1730430085232	David warner 	Inbound	f	system	150	£	https://www.luxurylifestylemag.co.uk/
1062	7583	1	sam.b@frontpageadvantage.com	1716462238586	35	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1730430085912	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
308	7584	1	historical	0	17	f	felifamily.com	suzied@felifamily.com	1730430091849	Suzie	Fatjoe	f	system	25	£	felifamily.com
342	7585	1	historical	0	36	f	karlismyunkle.com	karlismyunkle@gmail.com	1730430092742	Nik Thakkar	Fatjoe	f	system	45	£	www.karlismyunkle.com
326	7586	1	historical	0	19	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1730430093454	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
330	7587	1	historical	0	37	f	robinwaite.com	robin@robinwaite.com	1730430097300	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
353	7588	1	historical	0	15	f	lingermagazine.com	info@lingermagazine.com	1730430098683	Tiffany Tate	Fatjoe	f	system	82	£	https://www.lingermagazine.com/
314	7589	1	historical	0	18	f	thejournalix.com	thejournalix@gmail.com	1730430099325	Joni	Fatjoe	f	system	15	£	thejournalix.com
341	7590	1	historical	0	14	f	sashashantel.com	contactsashashantel@gmail.com	1730430101377	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
1164	7591	1	james.p@frontpageadvantage.com	1726063207724	55	f	celebrow.org	sofiakahn06@gmail.com	1730430103151	Sofia	James	f	system	30	$	celebrow.org
349	7592	1	historical	0	23	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1730430103782	Vicki	Fatjoe	f	system	60	£	Icenimagazine.co.uk
305	7593	1	historical	0	14	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1730430104544	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
345	7594	1	historical	0	17	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1730430106497	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
340	7595	1	historical	0	31	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1730430108808	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
397	7596	1	historical	0	59	f	emmaplusthree.com	emmaplusthree@gmail.com	1730430112036	Emma Easton	Inbound email	f	system	100	£	www.emmaplusthree.com
380	7597	1	historical	0	59	f	captainbobcat.com	Eva@captainbobcat.com	1730430118929	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
394	7598	1	historical	0	36	f	skinnedcartree.com	corinne@skinnedcartree.com	1730430121730	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
383	7599	1	historical	0	37	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1730430126357	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
433	7600	1	historical	0	38	f	bq-magazine.com	hello@contentmother.com	1730430132049	Lucy Clarke	Facebook	f	system	80	£	https://www.bq-magazine.com
425	7601	1	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1730430133450	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
432	7602	1	historical	0	37	f	lyliarose.com	victoria@lyliarose.com	1730430138835	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
412	7603	1	historical	0	29	f	laurakatelucas.com	laurakatelucas@hotmail.com	1730430140198	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
411	7604	1	historical	0	21	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1730430142493	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
1083	7605	1	sam.b@frontpageadvantage.com	1719319963927	35	f	edinburgers.co.uk	katherine@orangeoutreach.com	1730430152074	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
502	7606	1	historical	0	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1730430154608	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
505	7607	1	historical	0	28	f	talk-retail.co.uk	backlinsprovider@gmail.com	1730430157227	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
781	7608	1	chris.p@frontpageadvantage.com	1709033259858	46	f	kidsworldfun.com	enquiry@kidsworldfun.com	1730430167791	Limna	outbound	f	system	80	£	https://www.kidsworldfun.com/
1084	7609	1	sam.b@frontpageadvantage.com	1719320073095	28	f	bouncemagazine.co.uk	katherine@orangeoutreach.com	1730430168477	Katherine Williams	Inbound	f	system	100	£	bouncemagazine.co.uk
521	7610	1	historical	0	17	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1730430169235	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
958	7611	1	chris.p@frontpageadvantage.com	1711532781458	47	f	deeside.com	backlinsprovider@gmail.com	1730430174555	David Smith	inbound	f	system	95	£	https://www.deeside.com/
332	7612	1	historical	0	29	f	autumnsmummyblog.com	laura@autumnsmummyblog.com	1730430178510	Laura Chesmer	Fatjoe	f	system	75	£	https://www.autumnsmummyblog.com
508	7613	1	historical	0	32	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1730430179689	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
517	7614	1	historical	0	23	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1730430180354	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
393	7615	1	historical	0	58	f	reallymissingsleep.com	kareneholloway@hotmail.com	1730430185870	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
530	7616	1	historical	0	35	f	tech-wonders.com	backlinsprovider@gmail.com	1730430188185	David	Inbound Sam	f	system	100	£	www.tech-wonders.com
422	7617	1	historical	0	28	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1730430188659	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
1168	7618	1	james.p@frontpageadvantage.com	1726065344402	35	f	birdzpedia.com	sofiakahn06@gmail.com	1730430191479	Sofia	James	f	system	35	$	birdzpedia.com
314	7636	1	historical	0	18	f	thejournalix.com	thejournalix@gmail.com	1730886019374	Joni	Fatjoe	f	james.p@frontpageadvantage.com	15	£	thejournalix.com
327	7842	1	historical	0	24	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1730988695338	Adam Niazi	Fatjoe	f	james.p@frontpageadvantage.com	89	£	www.StartSmarter.co.uk
312	7956	1	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1731325396301	Abbie	Fatjoe	f	james.p@frontpageadvantage.com	135	£	mmbmagazine.co.uk
312	7960	1	historical	0	28	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1731325446884	Abbie	Fatjoe	f	james.p@frontpageadvantage.com	165	£	mmbmagazine.co.uk
1082	8399	1	sam.b@frontpageadvantage.com	1719319867176	30	f	theowlet.co.uk	katherine@orangeoutreach.com	1733022001742	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
483	8400	1	historical	0	30	f	packthepjs.com	tracey@packthepjs.com	1733022002370	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
652	8401	1	chris.p@frontpageadvantage.com	0	31	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1733022003004	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
1355	8402	1	frontpage.ga@gmail.com	1729769821170	36	f	wrapofthedays.co.uk	arianne@timewomenflag.com	1733022007026	Arianna Volkova	inbound	f	system	25	£	wrapofthedays.co.uk
1092	8403	1	sam.b@frontpageadvantage.com	1719320789605	42	f	fabukmagazine.com	katherine@orangeoutreach.com	1733022008033	Katherine Williams	Inbound	f	system	120	£	fabukmagazine.com
752	8404	1	chris.p@frontpageadvantage.com	1708082585011	58	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1733022009588	sophia daniel	Inbound	f	system	50	£	https://www.outdoorproject.com/
316	8405	1	historical	0	29	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1733022011863	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
1153	8406	1	james.p@frontpageadvantage.com	1723644250691	37	f	forbesradar.co.uk	teamforbesradar@gmail.com	1733022014788	Forbes Radar	James	f	system	62	£	https://forbesradar.co.uk/
1054	8407	1	michael.l@frontpageadvantage.com	1716451807667	26	f	flydriveexplore.com	Hello@flydrivexexplore.com	1733022016518	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1053	8408	1	michael.l@frontpageadvantage.com	1716451545373	27	f	emmareed.net	admin@emmareed.net	1733022017046	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
1154	8409	1	james.p@frontpageadvantage.com	1723728287666	33	f	fabcelebbio.com	support@linksposting.com	1733022018841	Links Posting	James	f	system	40	$	https://fabcelebbio.com/
784	8410	1	chris.p@frontpageadvantage.com	1709035290025	35	f	okaybliss.com	infopediapros@gmail.com	1733022027050	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
774	8411	1	chris.p@frontpageadvantage.com	1709030265171	32	f	voiceofaction.org	webmaster@redhatmedia.net	1733022028256	Vivek	outbound	f	system	65	£	http://voiceofaction.org/
765	8412	1	sam.b@frontpageadvantage.com	1708616408925	45	f	storymirror.com	ela690000@gmail.com	1733022029367	Ella	Inbound	f	system	96	£	https://storymirror.com/
702	8413	1	michael.l@frontpageadvantage.com	1708008300694	37	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1733022031691	Front Page Advantage	Email	f	system	10	£	https://frontpageadvantage.com/
405	8414	1	historical	0	37	f	prettybigbutterflies.com	prettybigbutterflies@gmail.com	1733022033207	Hollie	Inbound email	f	system	80	£	www.prettybigbutterflies.com
1071	8415	1	sam.b@frontpageadvantage.com	1719318047364	30	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1733022033646	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1417	8416	1	frontpage.ga@gmail.com	1730297448496	34	f	journaloftradingstandards.co.uk	arianne@timewomenflag.com	1733022034208	Arianne Volkova	inbound	f	system	103	£	journaloftradingstandards.co.uk
333	8417	1	historical	0	16	f	learndeveloplive.com	chris@learndeveloplive.com	1733022034829	Chris Jaggs	Fatjoe	f	system	25	£	www.learndeveloplive.com
1256	8418	1	frontpage.ga@gmail.com	1726827443560	36	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1733022035239	The Everyday Man	Hannah	f	system	150	£	https://theeverydayman.co.uk/
761	8419	1	sam.b@frontpageadvantage.com	1708615661584	35	f	holyroodpr.co.uk	falcobliek@gmail.com	1733022035715	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
1094	8420	1	sam.b@frontpageadvantage.com	1719322155330	28	f	coffeecakekids.com	katherine@orangeoutreach.com	1733022036302	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
1158	8421	1	james.p@frontpageadvantage.com	1725966960853	36	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1733022036892	David	James	f	system	10	$	http://toptechsinfo.com/
1171	8422	1	james.p@frontpageadvantage.com	1726066685680	41	f	shibleysmiles.com	sofiakahn06@gmail.com	1733022037326	Sofia	James	f	system	150	$	shibleysmiles.com
1422	8423	1	frontpage.ga@gmail.com	1730297665873	32	f	taketotheroad.co.uk	arianne@timewomenflag.com	1733022037982	Arianne Volkova	inbound	f	system	139	£	taketotheroad.co.uk
1061	8424	1	michael.l@frontpageadvantage.com	1716453125082	57	f	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	1733022039773	Sarah Dixon 	Outbound Facebook	f	system	100	£	https://www.minimeandluxury.co.uk/
1058	8425	1	michael.l@frontpageadvantage.com	1716452780180	59	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1733022040490	Rowena Becker	Outbound Facebook	f	system	175	£	https://mybalancingact.co.uk/
1070	8426	1	sam.b@frontpageadvantage.com	1719317894569	22	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1733022042510	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1060	8427	1	michael.l@frontpageadvantage.com	1716452913891	43	f	safarisafricana.com	jacquiehale75@gmail.com	1733022046994	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
1258	8428	1	james.p@frontpageadvantage.com	1727177065841	35	f	eruditemeetup.co.uk	teamforbesradar@gmail.com	1733022051830	Forbes Radar	James	f	system	120	$	http://eruditemeetup.co.uk/
1419	8429	1	frontpage.ga@gmail.com	1730297531326	34	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	1733022052920	Arianne Volkova	inbound	f	system	106	£	familyfriendlyworking.co.uk
1428	8430	1	frontpage.ga@gmail.com	1730297891567	28	f	feast-magazine.co.uk	arianne@timewomenflag.com	1733022054011	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
1078	8431	1	sam.b@frontpageadvantage.com	1719319469273	23	f	redkitedays.co.uk	katherine@orangeoutreach.com	1733022057009	Katherine Williams	Inbound	f	system	160	£	redkitedays.co.uk
304	8432	1	historical	0	32	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1733022058064	UKNEWS Group	Inbound email	f	system	40	£	https://www.uknewsgroup.co.uk/
369	8433	1	historical	0	37	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1733022059223	Mellissa Williams	Inbound email	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/
780	8434	1	chris.p@frontpageadvantage.com	1709033136922	18	f	travelistia.com	travelistiausa@gmail.com	1733022059931	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1404	8435	1	frontpage.ga@gmail.com	1730296573812	44	f	pczone.co.uk	arianne@timewomenflag.com	1733022062179	Arianne Volkova	inbound	f	system	114	£	pczone.co.uk
387	8436	1	historical	0	28	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1733022062875	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
1403	8437	1	frontpage.ga@gmail.com	1730296526142	51	f	aboutmanchester.co.uk	arianne@timewomenflag.com	1733022065980	Arianne Volkova	inbound	f	system	146	£	aboutmanchester.co.uk
1405	8438	1	frontpage.ga@gmail.com	1730296607431	38	f	ramzine.co.uk	arianne@timewomenflag.com	1733022066545	Arianne Volkova	inbound	f	system	114	£	ramzine.co.uk
1406	8439	1	frontpage.ga@gmail.com	1730296630124	42	f	madeinshoreditch.co.uk	arianne@timewomenflag.com	1733022067049	Arianne Volkova	inbound	f	system	158	£	madeinshoreditch.co.uk
1408	8440	1	frontpage.ga@gmail.com	1730296799161	40	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1733022068342	Arianne Volkova	inbound	f	system	134	£	fionaoutdoors.co.uk
1410	8441	1	frontpage.ga@gmail.com	1730296903193	36	f	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	1733022069455	Arianne Volkova	inbound	f	system	141	£	glitzandglamourmakeup.co.uk
1411	8442	1	frontpage.ga@gmail.com	1730296950461	38	f	businessvans.co.uk	arianne@timewomenflag.com	1733022070025	Arianne Volkova	inbound	f	system	129	£	businessvans.co.uk
905	8443	1	sam.b@frontpageadvantage.com	1709718547266	49	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1733022073258	David warner 	Inbound	f	system	150	£	https://www.luxurylifestylemag.co.uk/
326	8444	1	historical	0	21	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1733022074844	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
308	8445	1	historical	0	16	f	felifamily.com	suzied@felifamily.com	1733022075635	Suzie	Fatjoe	f	system	25	£	felifamily.com
331	8446	1	historical	0	30	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1733022076257	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
353	8447	1	historical	0	16	f	lingermagazine.com	info@lingermagazine.com	1733022079138	Tiffany Tate	Fatjoe	f	system	82	£	https://www.lingermagazine.com/
341	8448	1	historical	0	15	f	sashashantel.com	contactsashashantel@gmail.com	1733022079884	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
1164	8449	1	james.p@frontpageadvantage.com	1726063207724	56	f	celebrow.org	sofiakahn06@gmail.com	1733022080577	Sofia	James	f	system	30	$	celebrow.org
349	8450	1	historical	0	24	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1733022081327	Vicki	Fatjoe	f	system	60	£	Icenimagazine.co.uk
345	8451	1	historical	0	16	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1733022082870	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
327	8452	1	historical	0	25	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1733022085059	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
312	8453	1	historical	0	29	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1733022086277	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
318	8454	1	historical	0	38	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1733022087430	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
358	8455	1	historical	0	22	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1733022088102	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
346	8456	1	historical	0	20	f	carouseldiary.com	Info@carouseldiary.com	1733022088676	Katrina	Fatjoe	f	system	40	£	Carouseldiary.com
351	8457	1	historical	0	36	f	mycarheaven.com	Info@mycarheaven.com	1733022090939	Chris	Fatjoe	f	system	150	£	Www.mycarheaven.com
367	8458	1	historical	0	22	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1733022092933	Amy Walsh	Inbound email	f	system	40	£	cocktailsinteacups.com
388	8459	1	historical	0	23	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1733022096459	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
386	8460	1	historical	0	50	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1733022096986	Anna marikar	Inbound email	f	system	150	£	Intheplayroom.co.uk
378	8461	1	historical	0	38	f	healthyvix.com	victoria@healthyvix.com	1733022098128	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
406	8462	1	historical	0	27	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1733022099589	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
372	8463	1	historical	0	36	f	fashion-mommy.com	fashionmommywm@gmail.com	1733022101226	emma iannarilli	Inbound email	f	system	85	£	fashion-mommy.com
381	8464	1	historical	0	34	f	therarewelshbit.com	kacie@therarewelshbit.com	1733022101700	Kacie Morgan	Inbound email	f	system	200	£	www.therarewelshbit.com
380	8465	1	historical	0	61	f	captainbobcat.com	Eva@captainbobcat.com	1733022102217	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
394	8466	1	historical	0	37	f	skinnedcartree.com	corinne@skinnedcartree.com	1733022102828	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
389	8467	1	historical	0	28	f	arthurwears.com	Arthurwears.email@gmail.com	1733022105095	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
382	8468	1	historical	0	31	f	stressedmum.co.uk	sam@stressedmum.co.uk	1733022105563	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
1165	8469	1	james.p@frontpageadvantage.com	1726063285389	56	f	filmik.blog	sofiakahn06@gmail.com	1733022106039	Sofia	James	f	system	30	$	filmik.blog
375	8470	1	historical	0	24	f	clairemac.co.uk	clairemacblog@gmail.com	1733022106526	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
401	8471	1	historical	0	30	f	marketme.co.uk	christopher@marketme.co.uk	1733022107072	Christopher	Inbound email	f	system	59	£	https://marketme.co.uk/
423	8472	1	historical	0	29	f	mymoneycottage.com	hello@mymoneycottage.com	1733022108194	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
418	8473	1	historical	0	37	f	amumreviews.co.uk	contact@amumreviews.co.uk	1733022108634	Petra	Facebook	f	system	40	£	https://amumreviews.co.uk/
426	8474	1	historical	0	36	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1733022109700	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
416	8475	1	historical	0	30	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1733022110685	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
440	8476	1	historical	0	64	f	ventsmagazine.com	minalkh124@gmail.com	1733022111821	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
425	8477	1	historical	0	32	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1733022112480	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
432	8478	1	historical	0	45	f	lyliarose.com	victoria@lyliarose.com	1733022114135	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
412	8479	1	historical	0	28	f	laurakatelucas.com	laurakatelucas@hotmail.com	1733022115179	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
420	8480	1	historical	0	30	f	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1733022117406	Anna	Facebook	f	system	150	£	https://www.dontcrampmystyle.co.uk
495	8481	1	historical	0	61	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1733022119712	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
499	8482	1	historical	0	58	f	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	1733022122623	Fazal	Inbound Sam	f	system	144	£	www.lifestyledaily.co.uk
470	8483	1	historical	0	23	f	realwedding.co.uk	hello@contentmother.com	1733022123614	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
493	8484	1	historical	0	36	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1733022124206	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
502	8485	1	historical	0	33	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1733022125323	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
473	8486	1	historical	0	25	f	earthlytaste.com	hello@contentmother.com	1733022126889	Becky	inbound email	f	system	50	£	https://www.earthlytaste.com
477	8487	1	historical	0	16	f	rocketandrelish.com	hello@contentmother.com	1733022127504	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
510	8488	1	historical	0	28	f	powderrooms.co.uk	fazal.akbar@digitalczars.io	1733022128559	Fazal	Inbound Sam	f	system	120	£	powderrooms.co.uk
540	8489	1	historical	0	42	f	otsnews.co.uk	bhaiahsan799@gmail.com	1733022129209	Ashan	Inbound Sam	f	system	55	£	www.otsnews.co.uk
908	8490	1	sam.b@frontpageadvantage.com	1709719594822	31	f	britainreviews.co.uk	kenditoys.com@gmail.com	1733022130255	David warner 	Inbound	f	system	167	£	https://britainreviews.co.uk/
513	8491	1	historical	0	31	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1733022130893	Fazal	Inbound Sam	f	system	168	£	www.thefoodaholic.co.uk
520	8492	1	historical	0	24	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	1733022131511	Fazal	Inbound Sam	f	system	30	£	www.davidsavage.co.uk
907	8493	1	sam.b@frontpageadvantage.com	1709719202025	61	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1733022131910	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
515	8494	1	historical	0	14	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1733022132539	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
516	8495	1	historical	0	28	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1733022133421	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
524	8496	1	historical	0	38	f	travelbeginsat40.com	backlinsprovider@gmail.com	1733022134783	David	Inbound Sam	f	system	100	£	www.travelbeginsat40.com
521	8497	1	historical	0	18	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1733022137195	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
514	8498	1	historical	0	21	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1733022138546	Fazal	Inbound Sam	f	system	120	£	www.tobecomemum.co.uk
1085	8499	1	sam.b@frontpageadvantage.com	1719320223488	36	f	welovebrum.co.uk	katherine@orangeoutreach.com	1733022139460	Katherine Williams	Inbound	f	system	140	£	welovebrum.co.uk
384	8500	1	historical	0	35	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1733022143199	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
303	8501	1	historical	0	19	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1733022143855	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
393	8502	1	historical	0	59	f	reallymissingsleep.com	kareneholloway@hotmail.com	1733022147575	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
422	8503	1	historical	0	29	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1733022149318	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
371	8504	1	historical	0	23	f	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	1733022149817	Jennie Jordan	Inbound email	f	system	80	£	www.ricecakesandraisins.co.uk
407	8505	1	historical	0	20	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1733022150274	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
458	8506	1	historical	0	73	f	spacecoastdaily.com	minalkh124@gmail.com	1733022151307	Maryam bibi	Inbound email	f	system	120	£	https://spacecoastdaily.com/
1167	8507	1	james.p@frontpageadvantage.com	1726063465343	60	f	stylesrant.org	sofiakahn06@gmail.com	1733022153521	Sofia	James	f	system	30	$	stylesrant.org
1168	8508	1	james.p@frontpageadvantage.com	1726065344402	34	f	birdzpedia.com	sofiakahn06@gmail.com	1733022154418	Sofia	James	f	system	35	$	birdzpedia.com
374	8509	1	historical	0	67	f	simslife.co.uk	sim@simslife.co.uk	1733108405831	Sim Riches	Fatjoe	f	system	130	£	https://simslife.co.uk
1091	8510	1	sam.b@frontpageadvantage.com	1719320713419	75	f	businesscasestudies.co.uk	katherine@orangeoutreach.com	1733108409402	Katherine Williams	Inbound	f	system	220	£	businesscasestudies.co.uk
1056	8511	1	michael.l@frontpageadvantage.com	1716452285003	25	f	flyingfluskey.com	rosie@flyingfluskey.com	1733108410481	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
1423	8512	1	frontpage.ga@gmail.com	1730297707203	33	f	planetveggie.co.uk	arianne@timewomenflag.com	1733108413054	Arianne Volkova	inbound	f	system	145	£	planetveggie.co.uk
1425	8513	1	frontpage.ga@gmail.com	1730297780739	33	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1733108413623	Arianne Volkova	inbound	f	system	106	£	lobsterdigitalmarketing.co.uk
1426	8514	1	frontpage.ga@gmail.com	1730297811663	31	f	joannedewberry.co.uk	arianne@timewomenflag.com	1733108414163	Arianne Volkova	inbound	f	system	122	£	joannedewberry.co.uk
1427	8515	1	frontpage.ga@gmail.com	1730297857266	29	f	shelllouise.co.uk	arianne@timewomenflag.com	1733108414703	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
1059	8516	1	michael.l@frontpageadvantage.com	1716452853668	24	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1733108417445	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
330	8517	1	historical	0	38	f	robinwaite.com	robin@robinwaite.com	1733108418548	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
338	8518	1	historical	0	21	f	themammafairy.com	themammafairy@gmail.com	1733108419067	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
335	8519	1	historical	0	21	f	lillaloves.com	lillaallahiary@gmail.com	1733108419918	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
377	8520	1	historical	0	36	f	travelvixta.com	victoria@travelvixta.com	1733108420754	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
398	8521	1	historical	0	23	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1733108421223	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
408	8522	1	historical	0	16	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1733108423022	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
1166	8523	1	james.p@frontpageadvantage.com	1726063406379	36	f	costumeplayhub.com	sofiakahn06@gmail.com	1733108425926	Sofia	James	f	system	30	$	costumeplayhub.com
474	8524	1	historical	0	20	f	lclarke.co.uk	hello@contentmother.com	1733108426899	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
497	8525	1	historical	0	31	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1733108428219	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
418	8967	1	historical	0	37	f	amumreviews.co.uk	contact@amumreviews.co.uk	1734436556249	Petra	Facebook	f	james.p@frontpageadvantage.com	100	£	https://amumreviews.co.uk/
954	9211	1	michael.l@frontpageadvantage.com	1711012828815	51	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1736267127032	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	200	£	https://www.thenonleaguefootballpaper.com/
303	9242	1	historical	0	19	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1736336473382	This is Owned by Chris :-)	Inbound email	f	james.p@frontpageadvantage.com	1	£	www.moneytipsblog.co.uk
374	9839	1	historical	0	66	f	simslife.co.uk	sim@simslife.co.uk	1738378801844	Sim Riches	Fatjoe	f	system	130	£	https://simslife.co.uk
1091	9840	1	sam.b@frontpageadvantage.com	1719320713419	74	f	businesscasestudies.co.uk	katherine@orangeoutreach.com	1738378802806	Katherine Williams	Inbound	f	system	220	£	businesscasestudies.co.uk
1425	9841	1	frontpage.ga@gmail.com	1730297780739	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1738378803894	Arianne Volkova	inbound	f	system	106	£	lobsterdigitalmarketing.co.uk
1052	9842	1	michael.l@frontpageadvantage.com	1716451324696	32	f	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	1738378808778	Louise	Outbound Facebook	f	system	150	£	https://www.adventuresofayorkshiremum.co.uk/
1055	9843	1	michael.l@frontpageadvantage.com	1716452047818	20	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1738378809669	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1088	9844	1	sam.b@frontpageadvantage.com	1719320465060	35	f	family-budgeting.co.uk	katherine@orangeoutreach.com	1738378810590	Katherine Williams	Inbound	f	system	120	£	family-budgeting.co.uk
771	9845	1	chris.p@frontpageadvantage.com	1709027801990	43	f	finehomesandliving.com	info@fine-magazine.com	1738378811510	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
471	9846	1	historical	0	20	f	realparent.co.uk	hello@contentmother.com	1738378812493	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
323	9847	1	historical	0	26	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1738378813393	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
782	9848	1	chris.p@frontpageadvantage.com	1709033531454	19	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1738378814296	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
762	9849	1	sam.b@frontpageadvantage.com	1708615840028	14	f	flatpackhouses.co.uk	falcobliek@gmail.com	1738378815146	Falco	Inbound	f	system	120	£	https://www.flatpackhouses.co.uk/
1082	9850	1	sam.b@frontpageadvantage.com	1719319867176	27	f	theowlet.co.uk	katherine@orangeoutreach.com	1738378818115	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
1254	9851	1	frontpage.ga@gmail.com	1726736911853	27	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1738378820829	Laureny Loves	Hannah	f	system	50	£	https://www.laurenyloves.co.uk/category/money/
1156	9852	1	james.p@frontpageadvantage.com	1725624962664	29	f	cuddlefairy.com	hello@cuddlefairy.com	1738378821655	Becky	James	f	system	45	£	https://www.cuddlefairy.com/
1089	9853	1	sam.b@frontpageadvantage.com	1719320544130	34	f	crummymummy.co.uk	crummymummy@live.co.uk	1738378822538	Natalie	James	f	system	60	£	crummymummy.co.uk
652	9854	1	chris.p@frontpageadvantage.com	0	30	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1738378824562	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
752	9855	1	chris.p@frontpageadvantage.com	1708082585011	59	f	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1738378827045	sophia daniel	Inbound	f	system	50	£	https://www.outdoorproject.com/
316	9856	1	historical	0	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1738378827922	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
1056	9857	1	michael.l@frontpageadvantage.com	1716452285003	26	f	flyingfluskey.com	rosie@flyingfluskey.com	1738378831403	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
784	9858	1	chris.p@frontpageadvantage.com	1709035290025	36	f	okaybliss.com	infopediapros@gmail.com	1738378834141	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
1074	9859	1	sam.b@frontpageadvantage.com	1719318261939	37	f	fivelittledoves.com	katherine@orangeoutreach.com	1738378835712	Katherine Williams	Inbound	f	system	150	£	fivelittledoves.com
1077	9860	1	sam.b@frontpageadvantage.com	1719318416922	50	f	algarvedailynews.com	katherine@orangeoutreach.com	1738378839707	Katherine Williams	Inbound	f	system	175	£	algarvedailynews.com
1152	9861	1	james.p@frontpageadvantage.com	1721314820107	16	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1738378840719	Rose	Contact Form	f	system	20	£	www.RosemaryHelenXO.com
1356	9862	1	frontpage.ga@gmail.com	1729770014428	36	f	mealtop.co.uk	arianne@timewomenflag.com	1738378841507	Arianna Volkova	inbound	f	system	25	£	https://mealtop.co.uk/
1255	9863	1	frontpage.ga@gmail.com	1726784781949	26	f	katiemeehan.co.uk	hello@katiemeehan.co.uk	1738378842368	Katie Meehan	Hannah	f	system	50	£	https://katiemeehan.co.uk/category/lifestyle/
1069	9864	1	sam.b@frontpageadvantage.com	1719317784130	29	f	caranalytics.co.uk	katherine@orangeoutreach.com	1738378844854	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
496	9865	1	historical	0	27	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1738378845724	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
1303	9866	1	chris.p@frontpageadvantage.com	1727252702565	37	f	nyweekly.co.uk	sophiadaniel.co.uk@gmail.com	1738378846569	sophia daniel 	inbound	f	system	55	£	https://nyweekly.co.uk/
1054	9867	1	michael.l@frontpageadvantage.com	1716451807667	27	f	flydriveexplore.com	Hello@flydrivexexplore.com	1738378847362	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1053	9868	1	michael.l@frontpageadvantage.com	1716451545373	28	f	emmareed.net	admin@emmareed.net	1738378848924	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
1423	9869	1	frontpage.ga@gmail.com	1730297707203	35	f	planetveggie.co.uk	arianne@timewomenflag.com	1738378851419	Arianne Volkova	inbound	f	system	145	£	planetveggie.co.uk
1427	9870	1	frontpage.ga@gmail.com	1730297857266	27	f	shelllouise.co.uk	arianne@timewomenflag.com	1738378853893	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
654	9871	1	chris.p@frontpageadvantage.com	0	38	f	acraftedpassion.com	info@morningbusinesschat.com	1738378854588	Brett Napoli	Inbound	f	system	100	£	https://acraftedpassion.com/
489	9872	1	historical	0	70	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1738378855530	Claire James	Inbound Sam	f	system	60	£	www.abcmoney.co.uk
333	9873	1	historical	0	15	f	learndeveloplive.com	chris@learndeveloplive.com	1738378857321	Chris Jaggs	Fatjoe	f	system	25	£	www.learndeveloplive.com
761	9874	1	sam.b@frontpageadvantage.com	1708615661584	36	f	holyroodpr.co.uk	falcobliek@gmail.com	1738378858163	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
765	9875	1	sam.b@frontpageadvantage.com	1708616408925	46	f	storymirror.com	ela690000@gmail.com	1738378861433	Ella	Inbound	f	system	96	£	https://storymirror.com/
702	9876	1	michael.l@frontpageadvantage.com	1708008300694	38	f	frontpageadvantage.com	chris.p@frontpageadvantage.com	1738378862335	Front Page Advantage	Email	f	system	10	£	https://frontpageadvantage.com/
1071	9877	1	sam.b@frontpageadvantage.com	1719318047364	31	f	makemoneywithoutajob.com	katherine@orangeoutreach.com	1738378864164	Katherine Williams	Inbound	f	system	150	£	makemoneywithoutajob.com
1058	9878	1	michael.l@frontpageadvantage.com	1716452780180	58	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1738378868369	Rowena Becker	Outbound Facebook	f	system	175	£	https://mybalancingact.co.uk/
1073	9879	1	sam.b@frontpageadvantage.com	1719318221869	75	f	deadlinenews.co.uk	katherine@orangeoutreach.com	1738378870085	Katherine Williams	Inbound	f	system	150	£	deadlinenews.co.uk
1424	9880	1	frontpage.ga@gmail.com	1730297739559	34	f	mummyinatutu.co.uk	arianne@timewomenflag.com	1738378871140	Arianne Volkova	inbound	f	system	98	£	mummyinatutu.co.uk
655	9881	1	chris.p@frontpageadvantage.com	0	29	f	forgetfulmomma.com	info@morningbusinesschat.com	1738378873333	Brett Napoli	Inbound	f	system	225	£	https://www.forgetfulmomma.com/
902	9882	1	sam.b@frontpageadvantage.com	1709717920944	32	f	trainingexpress.org.uk	kenditoys.com@gmail.com	1738378874216	David warner	Inbound	f	system	150	£	https://trainingexpress.org.uk/
1061	9883	1	michael.l@frontpageadvantage.com	1716453125082	58	f	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	1738378875546	Sarah Dixon 	Outbound Facebook	f	system	100	£	https://www.minimeandluxury.co.uk/
1161	9884	1	james.p@frontpageadvantage.com	1726058268387	76	f	oddee.com	sofiakahn06@gmail.com	1738378876665	Sofia	James	f	system	150	$	oddee.com
775	9885	1	chris.p@frontpageadvantage.com	1709031235193	30	f	followthefashion.org	bhaiahsan799@gmail.com	1738378877773	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
1202	9886	1	james.p@frontpageadvantage.com	1726139288772	41	f	shemightbeloved.com	georgina@shemightbeloved.com	1738378878874	Georgina	James	f	system	200	£	www.shemightbeloved.com
1257	9887	1	frontpage.ga@gmail.com	1727080175363	40	f	vevivos.com	vickywelton@hotmail.com	1738378880133	Verily Victoria Vocalises	Hannah	f	system	175	£	vevivos.com
362	9888	1	historical	0	38	f	hausmanmarketingletter.com	angie@hausmanmarketingletter.com	1738378880937	Angela Hausman	Fatjoe	f	system	150	£	https://hausmanmarketingletter.com
1070	9889	1	sam.b@frontpageadvantage.com	1719317894569	20	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1738378882815	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1059	9890	1	michael.l@frontpageadvantage.com	1716452853668	27	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1738378884797	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
1203	9891	1	james.p@frontpageadvantage.com	1726241391467	36	f	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	1738378890363	Fiona	James	f	system	70	£	http://www.dollydowsie.com/
1159	9892	1	james.p@frontpageadvantage.com	1726057994078	29	f	thistradinglife.com	sofiakahn06@gmail.com	1738378893573	Sofia	James	f	system	35	$	thistradinglife.com
1160	9893	1	james.p@frontpageadvantage.com	1726058131710	45	f	epodcastnetwork.com	sofiakahn06@gmail.com	1738378895448	Sofia		f	system	60	$	epodcastnetwork.com
324	9894	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1738378896383	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1078	9895	1	sam.b@frontpageadvantage.com	1719319469273	22	f	redkitedays.co.uk	katherine@orangeoutreach.com	1738378900622	Katherine Williams	Inbound	f	system	160	£	redkitedays.co.uk
369	9896	1	historical	0	36	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1738378901490	Mellissa Williams	Inbound email	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/
1404	9897	1	frontpage.ga@gmail.com	1730296573812	43	f	pczone.co.uk	arianne@timewomenflag.com	1738378902333	Arianne Volkova	inbound	f	system	114	£	pczone.co.uk
779	9898	1	chris.p@frontpageadvantage.com	1709032988565	20	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1738378905125	Team	inbound	f	system	72	£	https://travelworldfashion.com/
1080	9899	1	sam.b@frontpageadvantage.com	1719319694584	46	f	exposedmagazine.co.uk	katherine@orangeoutreach.com	1738378906066	Katherine Williams	Inbound	f	system	100	£	exposedmagazine.co.uk
348	9900	1	historical	0	24	f	blossomeducation.co.uk	info@blossomeducation.co.uk	1738378907887	Vicki	Fatjoe	f	system	60	£	blossomeducation.co.uk
1402	9901	1	frontpage.ga@gmail.com	1730296493781	52	f	hrnews.co.uk	arianne@timewomenflag.com	1738378908599	Arianne Volkova	inbound	f	system	122	£	hrnews.co.uk
339	9902	1	historical	0	26	f	keralpatel.com	keralpatel@gmail.com	1738378909431	Keral Patel	Fatjoe	f	system	35	£	https://www.keralpatel.com
1204	9903	1	james.p@frontpageadvantage.com	1726564805504	36	f	ladyjaney.co.uk	Jane@ladyjaney.co.uk	1738378910982	Jane	James contact form	f	system	125	£	https://ladyjaney.co.uk/
1406	9904	1	frontpage.ga@gmail.com	1730296630124	43	f	madeinshoreditch.co.uk	arianne@timewomenflag.com	1738378912741	Arianne Volkova	inbound	f	system	158	£	madeinshoreditch.co.uk
1408	9905	1	frontpage.ga@gmail.com	1730296799161	39	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1738378913578	Arianne Volkova	inbound	f	system	134	£	fionaoutdoors.co.uk
905	9906	1	sam.b@frontpageadvantage.com	1709718547266	50	f	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1738378917719	David warner 	Inbound	f	system	150	£	https://www.luxurylifestylemag.co.uk/
1081	9907	1	sam.b@frontpageadvantage.com	1719319784878	38	f	emmysmummy.com	katherine@orangeoutreach.com	1738378919936	Katherine Williams	Inbound	f	system	120	£	emmysmummy.com
330	9908	1	historical	0	39	f	robinwaite.com	robin@robinwaite.com	1738378923132	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
338	9909	1	historical	0	22	f	themammafairy.com	themammafairy@gmail.com	1738378924005	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
335	9910	1	historical	0	24	f	lillaloves.com	lillaallahiary@gmail.com	1738378924847	Lilla	Fatjoe	f	system	20	£	Www.lillaloves.com
334	9911	1	historical	0	23	f	lifeloving.co.uk	sally@lifeloving.co.uk	1738378925760	Sally Allsop	Fatjoe	f	system	60	£	www.lifeloving.co.uk
337	9912	1	historical	0	25	f	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1738378927531	Al Baker	Fatjoe	f	system	40	£	www.thepennypincher.co.uk
305	9913	1	historical	0	16	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1738378928317	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
314	9914	1	historical	0	20	f	thejournalix.com	thejournalix@gmail.com	1738378929228	Joni	Fatjoe	f	system	15	£	thejournalix.com
312	9915	1	historical	0	30	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1738378929842	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
326	9916	1	historical	0	20	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1738378930669	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
320	9917	1	historical	0	29	f	practicalfrugality.com	hello@practicalfrugality.com	1738378931638	Magdalena	Fatjoe	f	system	38	£	www.practicalfrugality.com
318	9918	1	historical	0	39	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1738378932822	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
308	9919	1	historical	0	13	f	felifamily.com	suzied@felifamily.com	1738378933632	Suzie	Fatjoe	f	system	25	£	felifamily.com
331	9920	1	historical	0	31	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1738378934487	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
341	9921	1	historical	0	16	f	sashashantel.com	contactsashashantel@gmail.com	1738378936006	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
311	9922	1	historical	0	18	f	alifeoflovely.com	alifeoflovely@gmail.com	1738378936869	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
345	9923	1	historical	0	17	f	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1738378939435	Laura	Fatjoe	f	system	25	£	threelittlezees.co.uk
327	9924	1	historical	0	24	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1738378940240	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
329	9925	1	historical	0	35	f	wemadethislife.com	wemadethislife@outlook.com	1738378941002	Alina Davies	Fatjoe	f	system	150	£	https://wemadethislife.com
358	9926	1	historical	0	21	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1738378942897	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
351	9927	1	historical	0	35	f	mycarheaven.com	Info@mycarheaven.com	1738378944583	Chris	Fatjoe	f	system	150	£	Www.mycarheaven.com
409	9928	1	historical	0	32	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1738378945409	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
377	9929	1	historical	0	43	f	travelvixta.com	victoria@travelvixta.com	1738378946307	Victoria	Inbound email	f	system	170	£	https://www.travelvixta.com
366	9930	1	historical	0	45	f	barbaraiweins.com	info@barbaraiweins.com	1738378947275	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
398	9931	1	historical	0	24	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1738378948192	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
408	9932	1	historical	0	19	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1738378949018	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
392	9933	1	historical	0	39	f	midlandstraveller.com	contact@midlandstraveller.com	1738378949906	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
365	9934	1	historical	0	39	f	letstalkmommy.com	jenny@letstalkmommy.com	1738378952393	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
361	9935	1	historical	0	57	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	1738378954847	Erica Hughes	Fatjoe	f	system	125	£	https://alittleluxuryfor.me/
390	9936	1	historical	0	30	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1738378955642	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
367	9937	1	historical	0	24	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1738378960649	Amy Walsh	Inbound email	f	system	40	£	cocktailsinteacups.com
399	9938	1	historical	0	33	f	suburban-mum.com	hello@suburban-mum.com	1738378961511	Maria	Inbound email	f	system	100	£	www.suburban-mum.com
388	9939	1	historical	0	24	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1738378962330	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
386	9940	1	historical	0	52	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1738378963075	Anna marikar	Inbound email	f	system	150	£	Intheplayroom.co.uk
378	9941	1	historical	0	36	f	healthyvix.com	victoria@healthyvix.com	1738378963944	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
380	9942	1	historical	0	64	f	captainbobcat.com	Eva@captainbobcat.com	1738378967100	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
382	9943	1	historical	0	30	f	stressedmum.co.uk	sam@stressedmum.co.uk	1738378969645	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
1165	9944	1	james.p@frontpageadvantage.com	1726063285389	57	f	filmik.blog	sofiakahn06@gmail.com	1738378970483	Sofia	James	f	system	30	$	filmik.blog
375	9945	1	historical	0	23	f	clairemac.co.uk	clairemacblog@gmail.com	1738378971302	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
418	9946	1	historical	0	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	1738378973993	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
417	9947	1	historical	0	41	f	globalmousetravels.com	hello@globalmousetravels.com	1738378975875	Nichola West	Facebook	f	system	250	£	https://globalmousetravels.com
433	9948	1	historical	0	36	f	bq-magazine.com	hello@contentmother.com	1738378978409	Lucy Clarke	Facebook	f	system	80	£	https://www.bq-magazine.com
415	9949	1	historical	0	29	f	aaublog.com	rebecca@aaublog.com	1738378979312	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
421	9950	1	historical	0	48	f	glassofbubbly.com	christopher@marketme.co.uk	1738378982720	Christopher	Inbound email	f	system	125	£	https://glassofbubbly.com/
423	9951	1	historical	0	27	f	mymoneycottage.com	hello@mymoneycottage.com	1738378983537	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
416	9952	1	historical	0	32	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1738378985284	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
440	9953	1	historical	0	63	f	ventsmagazine.com	minalkh124@gmail.com	1738378986131	Maryam bibi	Inbound email	f	system	50	£	ventsmagazine.com
425	9954	1	historical	0	30	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1738378987042	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
432	9955	1	historical	0	46	f	lyliarose.com	victoria@lyliarose.com	1738378987750	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
412	9956	1	historical	0	30	f	laurakatelucas.com	laurakatelucas@hotmail.com	1738378988601	Laura Lucas	Facebook	f	system	100	£	www.laurakatelucas.com
441	9957	1	historical	0	78	f	newsbreak.com	minalkh124@gmail.com	1738378990086	Maryam bibi	Inbound email	f	system	55	£	original.newsbreak.com
400	9958	1	historical	0	31	f	estateagentnetworking.co.uk	christopher@estateagentnetworking.co.uk	1738378991049	Christopher	Inbound email	f	system	79	£	https://estateagentnetworking.co.uk/
474	9959	1	historical	0	22	f	lclarke.co.uk	hello@contentmother.com	1738378992842	Becky	inbound email	f	system	50	£	https://lclarke.co.uk
481	9960	1	historical	0	32	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1738378994517	Emily	another blogger	f	system	75	£	https://www.twinmummyanddaddy.com/
484	9961	1	historical	0	89	f	ibtimes.co.uk	i.perez@ibtmedia.co.uk	1738378995294	Inigo	inbound email	f	system	379	£	ibtimes.co.uk
501	9962	1	historical	0	48	f	fashioncapital.co.uk	fazal.akbar@digitalczars.io	1738378996167	Fazal	Inbound Sam	f	system	132	£	www.fashioncapital.co.uk
504	9963	1	historical	0	29	f	westlondonliving.co.uk	fazal.akbar@digitalczars.io	1738378998280	Fazal	Inbound Sam	f	system	84	£	www.westlondonliving.co.uk
414	9964	1	historical	0	24	f	joannavictoria.co.uk	joannabayford@gmail.com	1738378999029	Joanna Bayford	Facebook	f	system	50	£	https://www.joannavictoria.co.uk
495	9965	1	historical	0	65	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1738379002472	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
470	9966	1	historical	0	21	f	realwedding.co.uk	hello@contentmother.com	1738379005103	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
493	9967	1	historical	0	37	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1738379005882	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
502	9968	1	historical	0	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1738379006814	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
477	9969	1	historical	0	15	f	rocketandrelish.com	hello@contentmother.com	1738379008600	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
510	9970	1	historical	0	29	f	powderrooms.co.uk	fazal.akbar@digitalczars.io	1738379009393	Fazal	Inbound Sam	f	system	120	£	powderrooms.co.uk
529	9971	1	historical	0	38	f	houseofcoco.net	backlinsprovider@gmail.com	1738379011178	David	Inbound Sam	f	system	150	£	houseofcoco.net
808	9972	1	sam.b@frontpageadvantage.com	1709637089134	18	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1738379012686	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
434	9973	1	historical	0	20	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1738379013467	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
781	9974	1	chris.p@frontpageadvantage.com	1709033259858	47	f	kidsworldfun.com	enquiry@kidsworldfun.com	1738379014355	Limna	outbound	f	system	80	£	https://www.kidsworldfun.com/
908	9975	1	sam.b@frontpageadvantage.com	1709719594822	32	f	britainreviews.co.uk	kenditoys.com@gmail.com	1738379018405	David warner 	Inbound	f	system	167	£	https://britainreviews.co.uk/
520	9976	1	historical	0	25	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	1738379020240	Fazal	Inbound Sam	f	system	30	£	www.davidsavage.co.uk
465	9977	1	historical	0	82	f	goodmenproject.com	minalkh124@gmail.com	1738379020951	Maryam bibi	Inbound email	f	system	220	£	http://goodmenproject.com
907	9978	1	sam.b@frontpageadvantage.com	1709719202025	65	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1738379021857	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
515	9979	1	historical	0	15	f	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1738379023322	Fazal	Inbound Sam	f	system	120	£	www.travel-bugs.co.uk
516	9980	1	historical	0	29	f	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1738379025996	Fazal	Inbound Sam	f	system	168	£	www.thegardeningwebsite.co.uk
527	9981	1	historical	0	59	f	ourculturemag.com	info@ourculturemag.com	1738379028506	Info	Inbound Sam	f	system	115	£	ourculturemag.com
521	9982	1	historical	0	19	f	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1738379030182	Fazal	Inbound Sam	f	system	96	£	izzydabbles.co.uk
514	9983	1	historical	0	20	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1738379031061	Fazal	Inbound Sam	f	system	120	£	www.tobecomemum.co.uk
959	9984	1	chris.p@frontpageadvantage.com	1711533031802	46	f	talk-business.co.uk	backlinsprovider@gmail.com	1738379032693	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
303	9985	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1738379034407	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
1414	9986	1	frontpage.ga@gmail.com	1730297056465	38	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	1738379036197	Arianne Volkova	inbound	f	system	118	£	singleparentsonholiday.co.uk
508	9987	1	historical	0	33	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1738379037094	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
322	9988	1	historical	0	31	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1738379038062	David	Fatjoe	f	system	45	£	5thingstodotoday.com
517	9989	1	historical	0	24	f	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1738379039672	Fazal	Inbound Sam	f	system	156	£	www.interestingfacts.org.uk
476	9990	1	historical	0	11	f	contentmother.com	hello@contentmother.com	1738379041493	Becky	inbound email	f	system	45	£	https://www.contentmother.com
393	9991	1	historical	0	63	f	reallymissingsleep.com	kareneholloway@hotmail.com	1738379043293	Karen Langridge	Inbound email	f	system	150	£	https://www.reallymissingsleep.com/
809	9992	1	sam.b@frontpageadvantage.com	1709637625007	56	f	pierdom.com	info@pierdom.com	1738379044171	Junaid	Outbound	f	system	25	£	https://pierdom.com/
1087	9993	1	sam.b@frontpageadvantage.com	1719320401710	49	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1738379048446	Katherine Williams	Inbound	f	system	140	£	dailybusinessgroup.co.uk
407	9994	1	historical	0	22	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1738379050153	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
458	9995	1	historical	0	72	f	spacecoastdaily.com	minalkh124@gmail.com	1738379050938	Maryam bibi	Inbound email	f	system	120	£	https://spacecoastdaily.com/
1168	9996	1	james.p@frontpageadvantage.com	1726065344402	35	f	birdzpedia.com	sofiakahn06@gmail.com	1738379051961	Sofia	James	f	system	35	$	birdzpedia.com
780	9997	1	chris.p@frontpageadvantage.com	1709033136922	20	f	travelistia.com	travelistiausa@gmail.com	1738379052742	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
347	9998	1	historical	0	32	f	diydaddyblog.com	Diynige@yahoo.com	1738465203120	Nigel higgins	Fatjoe	f	system	50	£	https://www.diydaddyblog.com/
1096	9999	1	sam.b@frontpageadvantage.com	1719322406613	33	f	businesslancashire.co.uk	katherine@orangeoutreach.com	1738465211128	Katherine Williams	Inbound	f	system	140	£	businesslancashire.co.uk
1155	10000	1	james.p@frontpageadvantage.com	1724849151681	39	f	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	1738465211962	Forbes Network	James	f	system	70	£	https://forbesnetwork.co.uk/
1094	10001	1	sam.b@frontpageadvantage.com	1719322155330	29	f	coffeecakekids.com	katherine@orangeoutreach.com	1738465213454	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
1158	10002	1	james.p@frontpageadvantage.com	1725966960853	38	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1738465214237	David	James	f	system	10	$	http://toptechsinfo.com/
1422	10003	1	frontpage.ga@gmail.com	1730297665873	30	f	taketotheroad.co.uk	arianne@timewomenflag.com	1738465216146	Arianne Volkova	inbound	f	system	139	£	taketotheroad.co.uk
803	10004	1	chris.p@frontpageadvantage.com	1709123162304	48	f	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1738465216963	Sophia	Inbound	f	system	60	£	https://smihub.co.uk/
340	10005	1	historical	0	32	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1738465220156	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
410	10006	1	historical	0	25	f	realgirlswobble.com	rohmankatrina@gmail.com	1738465221526	Katrina Rohman	Facebook	f	system	50	£	https://realgirlswobble.com/
430	10007	1	historical	0	27	f	bizzimummy.com	Bizzimummy@gmail.com	1738465222884	Eva Stretton	Facebook	f	system	55	£	https://bizzimummy.com
1166	10008	1	james.p@frontpageadvantage.com	1726063406379	37	f	costumeplayhub.com	sofiakahn06@gmail.com	1738465223762	Sofia	James	f	system	30	$	costumeplayhub.com
534	10009	1	historical	0	41	f	saddind.co.uk	natalilacanario@gmail.com	1738465224890	Natalila	Inbound Sam	f	system	175	£	saddind.co.uk
1452	10018	0	james.p@frontpageadvantage.com	1738749807697	31	f	lifeloveanddirtydishes.com	claire_ruan@hotmail.com	1738749807697	Claire	James	f	\N	55	£	https://lifeloveanddirtydishes.com/
1452	10019	1	james.p@frontpageadvantage.com	1738749807697	31	f	lifeloveanddirtydishes.com	claire_ruan@hotmail.com	1738749810831	Claire	James	f	system	55	£	https://lifeloveanddirtydishes.com/
1452	10021	1	james.p@frontpageadvantage.com	1738749807697	31	f	lifeloveanddirtydishes.com	claire_ruan@hotmail.com	1738840177899	Claire	James	f	james.p@frontpageadvantage.com	55	£	https://lifeloveanddirtydishes.com/
314	10046	1	historical	0	20	f	thejournalix.com	thejournalix@gmail.com	1739202641061	Joni	Fatjoe	f	james.p@frontpageadvantage.com	15	£	thejournalix.com
440	10099	1	historical	0	63	t	ventsmagazine.com	minalkh124@gmail.com	1739443665089	Maryam bibi	Inbound email	f	chris.p@frontpageadvantage.com	50	£	ventsmagazine.com
1453	10104	0	james.p@frontpageadvantage.com	1739457701377	59	f	houzz.co.uk	sophiadaniel.co.uk@gmail.com	1739457701377	sophia	James	f	\N	30	£	https://www.houzz.co.uk/
1453	10105	1	james.p@frontpageadvantage.com	1739457701377	59	f	houzz.co.uk	sophiadaniel.co.uk@gmail.com	1739457704407	sophia	James	f	system	30	£	https://www.houzz.co.uk/
410	10387	1	historical	0	25	f	realgirlswobble.com	rohmankatrina@gmail.com	1739895917962	Katrina Rohman	Facebook	f	james.p@frontpageadvantage.com	80	£	https://realgirlswobble.com/
1502	10499	0	michael.l@frontpageadvantage.com	1740053738291	57	f	londondaily.news	sophiadaniel.co.uk@gmail.com	1740053738291	Sophia Daniel	Inbound Michael	f	\N	0	£	https://www.londondaily.news/
1502	10500	1	michael.l@frontpageadvantage.com	1740053738291	57	f	londondaily.news	sophiadaniel.co.uk@gmail.com	1740053741247	Sophia Daniel	Inbound Michael	f	system	0	£	https://www.londondaily.news/
314	10540	1	historical	0	20	f	thejournalix.com	thejournalix@gmail.com	1740057898749	Thomas	Fatjoe	f	james.p@frontpageadvantage.com	15	£	thejournalix.com
1502	10541	1	michael.l@frontpageadvantage.com	1740053738291	57	f	londondaily.news	sophiadaniel.co.uk@gmail.com	1740057990093	Sophia Daniel	Inbound Michael	f	james.p@frontpageadvantage.com	65	£	https://www.londondaily.news/
410	10659	1	historical	0	25	t	realgirlswobble.com	rohmankatrina@gmail.com	1740562668954	Katrina Rohman	Facebook	f	james.p@frontpageadvantage.com	80	£	https://realgirlswobble.com/
347	10663	1	historical	0	33	f	diydaddyblog.com	Diynige@yahoo.com	1740798001341	Nigel higgins	Fatjoe	f	system	50	£	https://www.diydaddyblog.com/
534	10664	1	historical	0	42	f	saddind.co.uk	natalilacanario@gmail.com	1740798003274	Natalila	Inbound Sam	f	system	175	£	saddind.co.uk
1425	10665	1	frontpage.ga@gmail.com	1730297780739	31	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1740798003872	Arianne Volkova	inbound	f	system	106	£	lobsterdigitalmarketing.co.uk
771	10666	1	chris.p@frontpageadvantage.com	1709027801990	42	f	finehomesandliving.com	info@fine-magazine.com	1740798010215	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
471	10667	1	historical	0	21	f	realparent.co.uk	hello@contentmother.com	1740798010849	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
783	10668	1	chris.p@frontpageadvantage.com	1709034374081	45	f	corporatelivewire.com	sukhenseoconsultant@gmail.com	1740798014625	Sukhen	inbound	f	system	150	£	https://corporatelivewire.com/
483	10669	1	historical	0	31	f	packthepjs.com	tracey@packthepjs.com	1740798019283	Tracey	Fatjoe	f	system	60	£	http://www.packthepjs.com/
1153	10670	1	james.p@frontpageadvantage.com	1723644250691	35	f	forbesradar.co.uk	teamforbesradar@gmail.com	1740798021224	Forbes Radar	James	f	system	62	£	https://forbesradar.co.uk/
355	10671	1	historical	0	36	f	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	1740798027068	Rebecca	Fatjoe	f	system	100	£	www.ialwaysbelievedinfutures.com
1255	10672	1	frontpage.ga@gmail.com	1726784781949	27	f	katiemeehan.co.uk	hello@katiemeehan.co.uk	1740798028694	Katie Meehan	Hannah	f	system	50	£	https://katiemeehan.co.uk/category/lifestyle/
1415	10673	1	frontpage.ga@gmail.com	1730297155721	35	f	blackeconomics.co.uk	arianne@timewomenflag.com	1740798029690	Arianne Volkova	inbound	f	system	134	£	blackeconomics.co.uk
1069	10674	1	sam.b@frontpageadvantage.com	1719317784130	31	f	caranalytics.co.uk	katherine@orangeoutreach.com	1740798031162	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1152	10675	1	james.p@frontpageadvantage.com	1721314820107	18	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1740798032147	Rose	Contact Form	f	system	20	£	www.RosemaryHelenXO.com
496	10676	1	historical	0	28	f	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1740798034373	Fazal	Inbound Sam	f	system	144	£	enjoytheadventure.co.uk
1053	10677	1	michael.l@frontpageadvantage.com	1716451545373	29	f	emmareed.net	admin@emmareed.net	1740798035918	Emma Reed	Outbound Facebook	f	system	100	£	https://emmareed.net/
1096	10678	1	sam.b@frontpageadvantage.com	1719322406613	34	f	businesslancashire.co.uk	katherine@orangeoutreach.com	1740798036942	Katherine Williams	Inbound	f	system	140	£	businesslancashire.co.uk
1155	10679	1	james.p@frontpageadvantage.com	1724849151681	38	f	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	1740798038559	Forbes Network	James	f	system	70	£	https://forbesnetwork.co.uk/
1416	10680	1	frontpage.ga@gmail.com	1730297416645	34	f	smallcapnews.co.uk	arianne@timewomenflag.com	1740798041337	Arianne Volkova	inbound	f	system	158	£	Smallcapnews.co.uk
405	10681	1	historical	0	36	f	prettybigbutterflies.com	prettybigbutterflies@gmail.com	1740798043392	Hollie	Inbound email	f	system	80	£	www.prettybigbutterflies.com
1256	10682	1	frontpage.ga@gmail.com	1726827443560	35	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1740798044454	The Everyday Man	Hannah	f	system	150	£	https://theeverydayman.co.uk/
954	10683	1	michael.l@frontpageadvantage.com	1711012828815	52	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1740798045541	Sam	Outbound Chris	f	system	200	£	https://www.thenonleaguefootballpaper.com/
357	10684	1	historical	0	57	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	1740798046528	Becky Freeman	Fatjoe	f	system	50	£	www.spiritedpuddlejumper.com
1056	10685	1	michael.l@frontpageadvantage.com	1716452285003	25	f	flyingfluskey.com	rosie@flyingfluskey.com	1740798047090	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
1073	10686	1	sam.b@frontpageadvantage.com	1719318221869	76	f	deadlinenews.co.uk	katherine@orangeoutreach.com	1740798048818	Katherine Williams	Inbound	f	system	150	£	deadlinenews.co.uk
1072	10687	1	sam.b@frontpageadvantage.com	1719318118234	45	f	warrington-worldwide.co.uk	katherine@orangeoutreach.com	1740798049382	Katherine Williams	Inbound	f	system	150	£	warrington-worldwide.co.uk
1424	10688	1	frontpage.ga@gmail.com	1730297739559	35	f	mummyinatutu.co.uk	arianne@timewomenflag.com	1740798049944	Arianne Volkova	inbound	f	system	98	£	mummyinatutu.co.uk
775	10689	1	chris.p@frontpageadvantage.com	1709031235193	29	f	followthefashion.org	bhaiahsan799@gmail.com	1740798050623	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
1202	10690	1	james.p@frontpageadvantage.com	1726139288772	40	f	shemightbeloved.com	georgina@shemightbeloved.com	1740798055132	Georgina	James	f	system	200	£	www.shemightbeloved.com
1070	10691	1	sam.b@frontpageadvantage.com	1719317894569	21	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1740798055695	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
959	10692	1	chris.p@frontpageadvantage.com	1711533031802	47	f	talk-business.co.uk	backlinsprovider@gmail.com	1740798056331	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
761	10693	1	sam.b@frontpageadvantage.com	1708615661584	35	f	holyroodpr.co.uk	falcobliek@gmail.com	1740798059682	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
1159	10694	1	james.p@frontpageadvantage.com	1726057994078	28	f	thistradinglife.com	sofiakahn06@gmail.com	1740798063004	Sofia	James	f	system	35	$	thistradinglife.com
1428	10695	1	frontpage.ga@gmail.com	1730297891567	29	f	feast-magazine.co.uk	arianne@timewomenflag.com	1740798068569	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
765	10696	1	sam.b@frontpageadvantage.com	1708616408925	47	f	storymirror.com	ela690000@gmail.com	1740798069741	Ella	Inbound	f	system	96	£	https://storymirror.com/
387	10697	1	historical	0	29	f	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1740798070206	Anna marikar	Inbound email	f	system	150	£	Onyourjourney.co.uk
779	10698	1	chris.p@frontpageadvantage.com	1709032988565	23	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1740798074356	Team	inbound	f	system	72	£	https://travelworldfashion.com/
1080	10699	1	sam.b@frontpageadvantage.com	1719319694584	47	f	exposedmagazine.co.uk	katherine@orangeoutreach.com	1740798075146	Katherine Williams	Inbound	f	system	100	£	exposedmagazine.co.uk
1163	10700	1	james.p@frontpageadvantage.com	1726061380233	51	f	powerhomebiz.com	sofiakahn06@gmail.com	1740798079531	Sofia	James	f	system	250	$	powerhomebiz.com
1407	10701	1	frontpage.ga@gmail.com	1730296672141	41	f	themarketingblog.co.uk	arianne@timewomenflag.com	1740798082362	Arianne Volkova	inbound	f	system	129	£	themarketingblog.co.uk
340	10702	1	historical	0	33	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1740798085677	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
314	10703	1	historical	0	19	f	thejournalix.com	thejournalix@gmail.com	1740798086857	Thomas	Fatjoe	f	system	15	£	thejournalix.com
338	10704	1	historical	0	20	f	themammafairy.com	themammafairy@gmail.com	1740798088348	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
305	10705	1	historical	0	18	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1740798091607	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
318	10706	1	historical	0	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1740798093772	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
358	10707	1	historical	0	22	f	thisbrilliantday.com	thisbrilliantday@gmail.com	1740798099505	Sophie Harriet	Fatjoe	f	system	50	£	https://thisbrilliantday.com/
1059	10708	1	michael.l@frontpageadvantage.com	1716452853668	28	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1740798102457	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
408	10709	1	historical	0	20	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1740798107278	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
379	10710	1	historical	0	27	f	yeahlifestyle.com	info@yeahlifestyle.com	1740798107811	Asha Carlos	Inbound email	f	system	120	£	https://www.yeahlifestyle.com
392	10711	1	historical	0	46	f	midlandstraveller.com	contact@midlandstraveller.com	1740798108397	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
367	10712	1	historical	0	23	f	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1740798109989	Amy Walsh	Inbound email	f	system	40	£	cocktailsinteacups.com
378	10713	1	historical	0	42	f	healthyvix.com	victoria@healthyvix.com	1740798112964	Victoria	Inbound email	f	system	170	£	https://www.healthyvix.com
380	10714	1	historical	0	63	f	captainbobcat.com	Eva@captainbobcat.com	1740798113493	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
406	10715	1	historical	0	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1740798117796	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
372	10716	1	historical	0	37	f	fashion-mommy.com	fashionmommywm@gmail.com	1740798118384	emma iannarilli	Inbound email	f	system	85	£	fashion-mommy.com
394	10717	1	historical	0	38	f	skinnedcartree.com	corinne@skinnedcartree.com	1740798119517	Corinne	Inbound email	f	system	75	£	https://skinnedcartree.com
426	10718	1	historical	0	37	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1740798122097	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
430	10719	1	historical	0	26	f	bizzimummy.com	Bizzimummy@gmail.com	1740798123248	Eva Stretton	Facebook	f	system	55	£	https://bizzimummy.com
423	10720	1	historical	0	26	f	mymoneycottage.com	hello@mymoneycottage.com	1740798126675	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
432	10721	1	historical	0	47	f	lyliarose.com	victoria@lyliarose.com	1740798127780	Victoria	Facebook	f	system	170	£	https://www.lyliarose.com
411	10722	1	historical	0	22	f	bouquetandbells.com	sarah@dreamofhome.co.uk	1740798130161	Sarah Macklin	Facebook	f	system	60	£	https://bouquetandbells.com/
419	10723	1	historical	0	32	f	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	1740798130579	Ana	Facebook	f	system	100	£	https://fadedspring.co.uk/
330	10724	1	historical	0	38	f	robinwaite.com	robin@robinwaite.com	1740798133033	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
470	10725	1	historical	0	22	f	realwedding.co.uk	hello@contentmother.com	1740798138836	Becky	inbound email	f	system	80	£	https://www.realwedding.co.uk
493	10726	1	historical	0	38	f	greenunion.co.uk	fazal.akbar@digitalczars.io	1740798140249	Fazal	Inbound Sam	f	system	120	£	www.greenunion.co.uk
502	10727	1	historical	0	31	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1740798140900	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
473	10728	1	historical	0	24	f	earthlytaste.com	hello@contentmother.com	1740798143576	Becky	inbound email	f	system	50	£	https://www.earthlytaste.com
434	10729	1	historical	0	21	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1740798145601	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
907	10730	1	sam.b@frontpageadvantage.com	1709719202025	66	f	bmmagazine.co.uk	kenditoys.com@gmail.com	1740798147730	David warner 	Inbound	f	system	200	£	https://bmmagazine.co.uk/
525	10731	1	historical	0	59	f	traveldailynews.com	backlinsprovider@gmail.com	1740798149356	David	Inbound Sam	f	system	91	£	www.traveldailynews.com
514	10732	1	historical	0	21	f	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1740798151121	Fazal	Inbound Sam	f	system	120	£	www.tobecomemum.co.uk
526	10733	1	historical	0	46	f	puretravel.com	backlinsprovider@gmail.com	1740798153000	David	Inbound Sam	f	system	160	£	www.puretravel.com
513	10734	1	historical	0	30	f	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1740798154515	Fazal	Inbound Sam	f	system	168	£	www.thefoodaholic.co.uk
418	10735	1	historical	0	37	f	amumreviews.co.uk	contact@amumreviews.co.uk	1740798159498	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
508	10736	1	historical	0	32	f	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1740798160661	Fazal	Inbound Sam	f	system	120	£	healthylifeessex.co.uk
809	10737	1	sam.b@frontpageadvantage.com	1709637625007	57	f	pierdom.com	info@pierdom.com	1740798164140	Junaid	Outbound	f	system	25	£	https://pierdom.com/
1087	10738	1	sam.b@frontpageadvantage.com	1719320401710	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1740798164532	Katherine Williams	Inbound	f	system	140	£	dailybusinessgroup.co.uk
530	10739	1	historical	0	36	f	tech-wonders.com	backlinsprovider@gmail.com	1740798165065	David	Inbound Sam	f	system	100	£	www.tech-wonders.com
1158	10740	1	james.p@frontpageadvantage.com	1725966960853	37	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1740884405163	David	James	f	system	10	$	http://toptechsinfo.com/
324	10741	1	historical	0	13	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1740884407688	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1413	10742	1	frontpage.ga@gmail.com	1730297027604	40	f	businessfirstonline.co.uk	arianne@timewomenflag.com	1740884413203	Arianne Volkova	inbound	f	system	134	£	businessfirstonline.co.uk
425	10743	1	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1740884418106	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
427	10744	1	historical	0	15	f	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	1740970808926	Shallie	Facebook	f	system	75	£	Shalliespurplebeehive.com
952	10821	1	michael.l@frontpageadvantage.com	1710423264423	53	t	kemotech.co.uk	sophiadaniel.co.uk@gmail.com	1741259529593	sophia daniel 	Inbound Michael	f	chris.p@frontpageadvantage.com	250	£	https://kemotech.co.uk/
1303	10822	1	chris.p@frontpageadvantage.com	1727252702565	37	t	nyweekly.co.uk	sophiadaniel.co.uk@gmail.com	1741259546236	sophia daniel 	inbound	f	chris.p@frontpageadvantage.com	55	£	https://nyweekly.co.uk/
1155	10823	1	james.p@frontpageadvantage.com	1724849151681	38	t	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	1741259564248	Forbes Network	James	f	chris.p@frontpageadvantage.com	70	£	https://forbesnetwork.co.uk/
1453	10824	1	james.p@frontpageadvantage.com	1739457701377	59	t	houzz.co.uk	sophiadaniel.co.uk@gmail.com	1741259580610	sophia	James	f	chris.p@frontpageadvantage.com	30	£	https://www.houzz.co.uk/
1502	10825	1	michael.l@frontpageadvantage.com	1740053738291	57	t	londondaily.news	sophiadaniel.co.uk@gmail.com	1741259596936	Sophia Daniel	Inbound Michael	f	chris.p@frontpageadvantage.com	65	£	https://www.londondaily.news/
803	10826	1	chris.p@frontpageadvantage.com	1709123162304	48	t	smihub.co.uk	sophiadaniel.co.uk@gmail.com	1741259620949	Sophia	Inbound	f	chris.p@frontpageadvantage.com	60	£	https://smihub.co.uk/
752	10827	1	chris.p@frontpageadvantage.com	1708082585011	59	t	outdoorproject.com	sophiadaniel.co.uk@gmail.com	1741259639331	sophia daniel	Inbound	f	chris.p@frontpageadvantage.com	50	£	https://www.outdoorproject.com/
1503	10828	0	frontpage.ga@gmail.com	1741269787500	35	f	latestdash.co.uk	alphaitteamofficial@gmail.com	1741269787500	Latest dash	inbound	f	\N	50	£	latestdash.co.uk
1503	10829	1	frontpage.ga@gmail.com	1741269787500	35	f	latestdash.co.uk	alphaitteamofficial@gmail.com	1741269790901	Latest dash	inbound	f	system	50	£	latestdash.co.uk
1504	10830	0	frontpage.ga@gmail.com	1741270738337	27	f	infinityelse.co.uk	 infinityelse1@gmail.com	1741270738337	Infinity else	inbound	f	\N	65	£	infinityelse.co.uk
1504	10831	1	frontpage.ga@gmail.com	1741270738337	27	f	infinityelse.co.uk	 infinityelse1@gmail.com	1741270741075	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
1505	10832	0	frontpage.ga@gmail.com	1741270951520	38	f	pixwox.co.uk	 pixwoxx@gmail.com	1741270951520	Pixwox	inbound	f	\N	75	£	pixwox.co.uk
1505	10833	1	frontpage.ga@gmail.com	1741270951520	38	f	pixwox.co.uk	 pixwoxx@gmail.com	1741270954181	Pixwox	inbound	f	system	75	£	pixwox.co.uk
1506	10834	0	frontpage.ga@gmail.com	1741271054422	51	f	techktimes.co.uk	Techktimes.official@gmail.com	1741271054422	Teck k times	inbound	f	\N	75	£	techktimes.co.uk
1506	10835	1	frontpage.ga@gmail.com	1741271054422	51	f	techktimes.co.uk	Techktimes.official@gmail.com	1741271057087	Teck k times	inbound	f	system	75	£	techktimes.co.uk
1507	10836	0	frontpage.ga@gmail.com	1741271187248	40	f	interview-coach.co.uk	margaret@interview-coach.co.uk	1741271187248	MargaretBUJ	inbound	f	\N	75	£	interview-coach.co.uk
1507	10837	1	frontpage.ga@gmail.com	1741271187248	40	f	interview-coach.co.uk	margaret@interview-coach.co.uk	1741271190008	MargaretBUJ	inbound	f	system	75	£	interview-coach.co.uk
1508	10838	0	frontpage.ga@gmail.com	1741271505305	56	f	megalithic.co.uk	andy@megalithic.co.uk	1741271505305	The Megalithic Portal	inbound	f	\N	80	£	megalithic.co.uk
1508	10839	1	frontpage.ga@gmail.com	1741271505305	56	f	megalithic.co.uk	andy@megalithic.co.uk	1741271508040	The Megalithic Portal	inbound	f	system	80	£	megalithic.co.uk
483	11136	1	historical	0	31	f	packthepjs.com	tracey@packthepjs.com	1741769130176	Tracey	Fatjoe	f	james.p@frontpageadvantage.com	80	£	http://www.packthepjs.com/
1509	11281	0	james.p@frontpageadvantage.com	1742476076536	31	f	countingtoten.co.uk	countingtotenblog@gmail.com	1742476076536	Kate	James - NEW	f	\N	75	£	https://www.countingtoten.co.uk/
1509	11282	1	james.p@frontpageadvantage.com	1742476076536	31	f	countingtoten.co.uk	countingtotenblog@gmail.com	1742476079406	Kate	James - NEW	f	system	75	£	https://www.countingtoten.co.uk/
1510	11301	0	frontpage.ga@gmail.com	1742850929074	37	f	xatpes.co.uk	 xatpes.official@gmail.com	1742850929074	Xatapes	inbound	f	\N	80	£	https://xatpes.co.uk/contact-us/
1510	11302	1	frontpage.ga@gmail.com	1742850929074	37	f	xatpes.co.uk	 xatpes.official@gmail.com	1742850932205	Xatapes	inbound	f	system	80	£	https://xatpes.co.uk/contact-us/
1511	11303	0	frontpage.ga@gmail.com	1742851051403	35	f	msnpro.co.uk	ankit@zestfulloutreach.com	1742851051403	MSN PRO	inbound	f	\N	80	£	https://msnpro.co.uk/contact-us/
1511	11304	1	frontpage.ga@gmail.com	1742851051403	35	f	msnpro.co.uk	ankit@zestfulloutreach.com	1742851054412	MSN PRO	inbound	f	system	80	£	https://msnpro.co.uk/contact-us/
1512	11305	0	frontpage.ga@gmail.com	1742851181353	34	f	techranker.co.uk	 agencystarseo@gmail.com	1742851181353	TRK	inbound	f	\N	80	£	TechRanker.co.uk
1512	11306	1	frontpage.ga@gmail.com	1742851181353	34	f	techranker.co.uk	 agencystarseo@gmail.com	1742851184377	TRK	inbound	f	system	80	£	TechRanker.co.uk
1513	11307	0	frontpage.ga@gmail.com	1742851433859	38	f	load2learn.org.uk	infopool13@gmail.com	1742851433859	LOAD2LEARN	inbound	f	\N	80	£	load2learn.org.uk
1513	11308	1	frontpage.ga@gmail.com	1742851433859	38	f	load2learn.org.uk	infopool13@gmail.com	1742851436852	LOAD2LEARN	inbound	f	system	80	£	load2learn.org.uk
1514	11309	0	frontpage.ga@gmail.com	1742851604179	38	f	dailywaffle.co.uk	sarah@dailywaffle.co.uk	1742851604179	DAILY WAFFLE	inbound	f	\N	80	£	dailywaffle.co.uk
1514	11310	1	frontpage.ga@gmail.com	1742851604179	38	f	dailywaffle.co.uk	sarah@dailywaffle.co.uk	1742851607247	DAILY WAFFLE	inbound	f	system	80	£	dailywaffle.co.uk
1515	11311	0	frontpage.ga@gmail.com	1742851725672	38	f	ranyy.com	aishwaryagaikwad313@gmail.com	1742851725672	Ranyy	inbound	f	\N	80	£	ranyy.com
1515	11312	1	frontpage.ga@gmail.com	1742851725672	38	f	ranyy.com	aishwaryagaikwad313@gmail.com	1742851728342	Ranyy	inbound	f	system	80	£	ranyy.com
1516	11313	0	frontpage.ga@gmail.com	1742851851548	27	f	thecwordmag.co.uk	info@thecwordmag.co.uk	1742851851548	thecwordmag	inbound	f	\N	80	£	thecwordmag.co.uk
1516	11314	1	frontpage.ga@gmail.com	1742851851548	27	f	thecwordmag.co.uk	info@thecwordmag.co.uk	1742851854716	thecwordmag	inbound	f	system	80	£	thecwordmag.co.uk
1517	11315	0	frontpage.ga@gmail.com	1742852009295	60	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1742852009295	UK Journal	inbound	f	\N	80	£	ukjournal.co.uk
1517	11316	1	frontpage.ga@gmail.com	1742852009295	60	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1742852011940	UK Journal	inbound	f	system	80	£	ukjournal.co.uk
1518	11317	0	frontpage.ga@gmail.com	1742852067954	31	f	guestmagazines.co.uk	megazines04@gmail.com	1742852067954	guest magazines	inbound	f	\N	80	£	Guestmagazines.co.uk
1520	11321	0	frontpage.ga@gmail.com	1742852390702	35	f	exclusivetoday.co.uk	onikawallerson.ot@gmail.com	1742852390702	Exclusive Today	inboud	f	\N	80	£	exclusivetoday.co.uk
1520	11322	1	frontpage.ga@gmail.com	1742852390702	35	f	exclusivetoday.co.uk	onikawallerson.ot@gmail.com	1742852393341	Exclusive Today	inboud	f	system	80	£	exclusivetoday.co.uk
1518	11318	1	frontpage.ga@gmail.com	1742852067954	31	f	guestmagazines.co.uk	megazines04@gmail.com	1742852071095	guest magazines	inbound	f	system	80	£	Guestmagazines.co.uk
1519	11320	1	frontpage.ga@gmail.com	1742852226231	38	f	myflexbot.co.uk	myflexbot11@gmail.com	1742852229063	My Flex Bot	inbound	f	system	80	£	myflexbot.co.uk
1519	11319	0	frontpage.ga@gmail.com	1742852226231	38	f	myflexbot.co.uk	myflexbot11@gmail.com	1742852226231	My Flex Bot	inbound	f	\N	80	£	myflexbot.co.uk
1521	11323	0	frontpage.ga@gmail.com	1742852543019	37	f	grobuzz.co.uk	editorial@rankwc.com	1742852543019	GROBUZZ	inboud	f	\N	80	£	grobuzz.co.uk
1521	11324	1	frontpage.ga@gmail.com	1742852543019	37	f	grobuzz.co.uk	editorial@rankwc.com	1742852546241	GROBUZZ	inboud	f	system	80	£	grobuzz.co.uk
1522	11325	0	frontpage.ga@gmail.com	1742852661569	36	f	techimaging.co.uk	contact@techimaging.co.uk	1742852661569	Tech Imaging	inboud	f	\N	80	£	techimaging.co.uk
1522	11326	1	frontpage.ga@gmail.com	1742852661569	36	f	techimaging.co.uk	contact@techimaging.co.uk	1742852664127	Tech Imaging	inboud	f	system	80	£	techimaging.co.uk
1523	11327	0	frontpage.ga@gmail.com	1742853030124	36	f	ventstimes.co.uk	ventstimesofficial@gmail.com	1742853030124	Vents Times	inboud	f	\N	80	£	Ventstimes.co.uk
1523	11328	1	frontpage.ga@gmail.com	1742853030124	36	f	ventstimes.co.uk	ventstimesofficial@gmail.com	1742853033192	Vents Times	inboud	f	system	80	£	Ventstimes.co.uk
304	11358	1	historical	0	32	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1742907199133	UKNEWS Group	Inbound email	f	james.p@frontpageadvantage.com	30	£	https://www.uknewsgroup.co.uk/
471	11429	1	historical	0	22	f	realparent.co.uk	hello@contentmother.com	1743476409411	Becky	inbound email	f	system	60	£	https://www.realparent.co.uk
323	11430	1	historical	0	27	f	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1743476411069	Claire	Fatjoe	f	system	80	£	clairemorandesigns.co.uk
782	11431	1	chris.p@frontpageadvantage.com	1709033531454	17	f	spokenenglishtips.com	spokenenglishtips@gmail.com	1743476412410	Edu Place	inbound	f	system	30	£	https://spokenenglishtips.com/
1002	11432	1	michael.l@frontpageadvantage.com	1713341748907	46	f	todaynews.co.uk	david@todaynews.co.uk	1743476413661	David	Inbound Michael	f	system	65	£	https://todaynews.co.uk/
1082	11433	1	sam.b@frontpageadvantage.com	1719319867176	29	f	theowlet.co.uk	katherine@orangeoutreach.com	1743476414300	Katherine Williams	Inbound	f	system	100	£	theowlet.co.uk
1089	11434	1	sam.b@frontpageadvantage.com	1719320544130	35	f	crummymummy.co.uk	crummymummy@live.co.uk	1743476417129	Natalie	James	f	system	60	£	crummymummy.co.uk
652	11435	1	chris.p@frontpageadvantage.com	0	31	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1743476417727	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
784	11436	1	chris.p@frontpageadvantage.com	1709035290025	37	f	okaybliss.com	infopediapros@gmail.com	1743476422814	Ricardo	inbound	f	system	80	£	https://www.okaybliss.com/
653	11437	1	chris.p@frontpageadvantage.com	0	40	f	thatdrop.com	info@morningbusinesschat.com	1743476423477	Brett Napoli	Inbound	f	system	83	£	https://thatdrop.com/
359	11438	1	historical	0	28	f	beccafarrelly.co.uk	hello@beccafarrelly.co.uk	1743476424430	Becca	Fatjoe	f	system	100	£	beccafarrelly.co.uk
1076	11439	1	sam.b@frontpageadvantage.com	1719318364944	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1743476426399	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
1152	11440	1	james.p@frontpageadvantage.com	1721314820107	19	f	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1743476428181	Rose	Contact Form	f	system	20	£	www.RosemaryHelenXO.com
1356	11441	1	frontpage.ga@gmail.com	1729770014428	37	f	mealtop.co.uk	arianne@timewomenflag.com	1743476430617	Arianna Volkova	inbound	f	system	25	£	https://mealtop.co.uk/
1154	11442	1	james.p@frontpageadvantage.com	1723728287666	34	f	fabcelebbio.com	support@linksposting.com	1743476431281	Links Posting	James	f	system	40	$	https://fabcelebbio.com/
903	11443	1	sam.b@frontpageadvantage.com	1709718136681	52	f	therugbypaper.co.uk	backlinsprovider@gmail.com	1743476431929	David Smith 	Inbound	f	system	115	£	www.therugbypaper.co.uk
1094	11444	1	sam.b@frontpageadvantage.com	1719322155330	27	f	coffeecakekids.com	katherine@orangeoutreach.com	1743476434408	Katherine Williams	Inbound	f	system	100	£	coffeecakekids.com
954	11445	1	michael.l@frontpageadvantage.com	1711012828815	51	f	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1743476445983	Sam	Outbound Chris	f	system	200	£	https://www.thenonleaguefootballpaper.com/
1056	11446	1	michael.l@frontpageadvantage.com	1716452285003	26	f	flyingfluskey.com	rosie@flyingfluskey.com	1743476447708	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
775	11447	1	chris.p@frontpageadvantage.com	1709031235193	30	f	followthefashion.org	bhaiahsan799@gmail.com	1743476451469	Ashan	inbound	f	system	55	£	https://www.followthefashion.org/
1202	11448	1	james.p@frontpageadvantage.com	1726139288772	41	f	shemightbeloved.com	georgina@shemightbeloved.com	1743476452085	Georgina	James	f	system	200	£	www.shemightbeloved.com
956	11449	1	michael.l@frontpageadvantage.com	1711013035726	25	f	racingahead.net	sam.emery@greenwayspublishing.com	1743476456917	Sam	Outbound Chris	f	system	100	£	https://www.racingahead.net/
761	11450	1	sam.b@frontpageadvantage.com	1708615661584	36	f	holyroodpr.co.uk	falcobliek@gmail.com	1743476466436	Falco	Inbound	f	system	130	£	https://www.holyroodpr.co.uk/
1159	11451	1	james.p@frontpageadvantage.com	1726057994078	30	f	thistradinglife.com	sofiakahn06@gmail.com	1743476467122	Sofia	James	f	system	35	$	thistradinglife.com
324	11452	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1743476468580	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
332	11453	1	historical	0	30	f	autumnsmummyblog.com	laura@autumnsmummyblog.com	1743476469864	Laura Chesmer	Fatjoe	f	system	75	£	https://www.autumnsmummyblog.com
957	11454	1	chris.p@frontpageadvantage.com	1711532679719	45	f	north.wales	backlinsprovider@gmail.com	1743476471856	David Smith	Inbound	f	system	95	£	https://north.wales/
348	11455	1	historical	0	23	f	blossomeducation.co.uk	info@blossomeducation.co.uk	1743476475936	Vicki	Fatjoe	f	system	60	£	blossomeducation.co.uk
1402	11456	1	frontpage.ga@gmail.com	1730296493781	51	f	hrnews.co.uk	arianne@timewomenflag.com	1743476477681	Arianne Volkova	inbound	f	system	122	£	hrnews.co.uk
1408	11457	1	frontpage.ga@gmail.com	1730296799161	40	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1743476481550	Arianne Volkova	inbound	f	system	134	£	fionaoutdoors.co.uk
1519	11458	1	frontpage.ga@gmail.com	1742852226231	39	f	myflexbot.co.uk	myflexbot11@gmail.com	1743476485538	My Flex Bot	inbound	f	system	80	£	myflexbot.co.uk
1410	11459	1	frontpage.ga@gmail.com	1730296903193	37	f	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	1743476486178	Arianne Volkova	inbound	f	system	141	£	glitzandglamourmakeup.co.uk
328	11460	1	historical	0	22	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1743476489190	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1062	11461	1	sam.b@frontpageadvantage.com	1716462238586	36	f	thebraggingmommy.com	kirangupta.outreach@gmail.com	1743476489859	Kiran Gupta	Inbound	f	system	80	£	thebraggingmommy.com
314	11462	1	historical	0	21	f	thejournalix.com	thejournalix@gmail.com	1743476492136	Thomas	Fatjoe	f	system	15	£	thejournalix.com
305	11463	1	historical	0	19	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1743476493636	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
312	11464	1	historical	0	31	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1743476497362	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
341	11465	1	historical	0	17	f	sashashantel.com	contactsashashantel@gmail.com	1743476500417	Sasha Shantel	Fatjoe	f	system	60	£	http://www.sashashantel.com
311	11466	1	historical	0	19	f	alifeoflovely.com	alifeoflovely@gmail.com	1743476500876	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
327	11467	1	historical	0	26	f	startsmarter.co.uk	publishing@startsmarter.co.uk	1743476502370	Adam Niazi	Fatjoe	f	system	89	£	www.StartSmarter.co.uk
408	11468	1	historical	0	21	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1743476507865	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
392	11469	1	historical	0	45	f	midlandstraveller.com	contact@midlandstraveller.com	1743476509100	Simone Ribeiro	Inbound email	f	system	50	£	www.midlandstraveller.com
365	11470	1	historical	0	40	f	letstalkmommy.com	jenny@letstalkmommy.com	1743476509463	Jenny	Fatjoe	f	system	100	£	https://www.Letstalkmommy.com
366	11471	1	historical	0	46	f	barbaraiweins.com	info@barbaraiweins.com	1743476511626	Jason	Inbound email	f	system	37	£	Barbaraiweins.com
398	11472	1	historical	0	25	f	mytunbridgewells.com	mytunbridgewells@gmail.com	1743476512204	Clare Lush-Mansell	Inbound email	f	system	124	£	https://www.mytunbridgewells.com/
390	11473	1	historical	0	31	f	blog.bay-bee.co.uk	Stephi@bay-bee.co.uk	1743476515833	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
388	11474	1	historical	0	25	f	misstillyandme.co.uk	beingtillysmummy@gmail.com	1743476518380	vicky Hall-Newman	Inbound email	f	system	75	£	www.misstillyandme.co.uk
382	11475	1	historical	0	29	f	stressedmum.co.uk	sam@stressedmum.co.uk	1743476519738	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
389	11476	1	historical	0	29	f	arthurwears.com	Arthurwears.email@gmail.com	1743476523896	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
401	11477	1	historical	0	32	f	marketme.co.uk	christopher@marketme.co.uk	1743476524559	Christopher	Inbound email	f	system	59	£	https://marketme.co.uk/
415	11478	1	historical	0	30	f	aaublog.com	rebecca@aaublog.com	1743476527880	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
423	11479	1	historical	0	27	f	mymoneycottage.com	hello@mymoneycottage.com	1743476533561	Clare McDougall	Facebook	f	system	100	£	https://mymoneycottage.com
427	11480	1	historical	0	16	f	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	1743476536809	Shallie	Facebook	f	system	75	£	Shalliespurplebeehive.com
472	11481	1	historical	0	28	f	pleasureprinciple.net	hello@contentmother.com	1743476538850	Becky	inbound email	f	system	50	£	https://www.pleasureprinciple.net
481	11482	1	historical	0	33	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1743476543383	Emily	another blogger	f	system	75	£	https://www.twinmummyanddaddy.com/
414	11483	1	historical	0	20	f	joannavictoria.co.uk	joannabayford@gmail.com	1743476545865	Joanna Bayford	Facebook	f	system	50	£	https://www.joannavictoria.co.uk
495	11484	1	historical	0	63	f	welshmum.co.uk	fazal.akbar@digitalczars.io	1743476547224	Fazal	Inbound Sam	f	system	168	£	www.welshmum.co.uk
505	11485	1	historical	0	29	f	talk-retail.co.uk	backlinsprovider@gmail.com	1743476548505	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
477	11486	1	historical	0	14	f	rocketandrelish.com	hello@contentmother.com	1743476549739	Becky	inbound email	f	system	45	£	https://www.rocketandrelish.com
510	11487	1	historical	0	30	f	powderrooms.co.uk	fazal.akbar@digitalczars.io	1743476550380	Fazal	Inbound Sam	f	system	120	£	powderrooms.co.uk
409	11488	1	historical	0	33	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1743476552165	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
808	11489	1	sam.b@frontpageadvantage.com	1709637089134	19	f	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1743476553686	Vijay Chauhan	Outbound	f	system	41	£	https://myarchitecturesidea.com/
520	11490	1	historical	0	26	f	davidsavage.co.uk	fazal.akbar@digitalczars.io	1743476555514	Fazal	Inbound Sam	f	system	30	£	www.davidsavage.co.uk
527	11491	1	historical	0	58	f	ourculturemag.com	info@ourculturemag.com	1743476558883	Info	Inbound Sam	f	system	115	£	ourculturemag.com
1168	11492	1	james.p@frontpageadvantage.com	1726065344402	36	f	birdzpedia.com	sofiakahn06@gmail.com	1743476560168	Sofia	James	f	system	35	$	birdzpedia.com
958	11493	1	chris.p@frontpageadvantage.com	1711532781458	48	f	deeside.com	backlinsprovider@gmail.com	1743476563246	David Smith	inbound	f	system	95	£	https://www.deeside.com/
779	11494	1	chris.p@frontpageadvantage.com	1709032988565	24	f	travelworldfashion.com	travelworldwithfashion@gmail.com	1743476568792	Team	inbound	f	system	72	£	https://travelworldfashion.com/
497	11495	1	historical	0	32	f	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1743476569399	Fazal	Inbound Sam	f	system	168	£	anythinggoeslifestyle.co.uk
1504	11496	1	frontpage.ga@gmail.com	1741270738337	28	f	infinityelse.co.uk	 infinityelse1@gmail.com	1743476577360	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
407	11497	1	historical	0	23	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1743476578015	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
780	11498	1	chris.p@frontpageadvantage.com	1709033136922	22	f	travelistia.com	travelistiausa@gmail.com	1743476585177	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1515	11499	1	frontpage.ga@gmail.com	1742851725672	37	f	ranyy.com	aishwaryagaikwad313@gmail.com	1743476590192	Ranyy	inbound	f	system	80	£	ranyy.com
1516	11500	1	frontpage.ga@gmail.com	1742851851548	28	f	thecwordmag.co.uk	info@thecwordmag.co.uk	1743476590765	thecwordmag	inbound	f	system	80	£	thecwordmag.co.uk
304	11501	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1743476593099	UKNEWS Group	Inbound email	f	system	30	£	https://www.uknewsgroup.co.uk/
347	11728	1	historical	0	33	f	diydaddyblog.com	Diynige@yahoo.com	1744033927905	Nigel higgins	Fatjoe	f	james.p@frontpageadvantage.com	50	£	https://www.diydaddyblog.com/
324	11729	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1744033938292	Chrissy	Fatjoe	f	james.p@frontpageadvantage.com	20	£	itsmechrissyj.co.uk
1524	11741	0	frontpage.ga@gmail.com	1744278617976	57	f	starmusiq.audio	Contact@guestpost.cc	1744278617976	Star Musiq	inboud	f	\N	30	£	https://starmusiq.audio/
1524	11742	1	frontpage.ga@gmail.com	1744278617976	57	f	starmusiq.audio	Contact@guestpost.cc	1744278621441	Star Musiq	inboud	f	system	30	£	https://starmusiq.audio/
1525	11743	0	frontpage.ga@gmail.com	1744278836662	37	f	hentai20.pro	 technexitspace@gmail.com	1744278836662	Hentai 20 	inboud	f	\N	30	£	hentai20.pro
1525	11744	1	frontpage.ga@gmail.com	1744278836662	37	f	hentai20.pro	 technexitspace@gmail.com	1744278839593	Hentai 20 	inboud	f	system	30	£	hentai20.pro
1526	11745	0	frontpage.ga@gmail.com	1744279580858	57	f	bronwinaurora.com	write@bronwinaurora.com	1744279580858	Bronwin Aurora	inboud	f	\N	40	£	bronwinaurora.com
1526	11746	1	frontpage.ga@gmail.com	1744279580858	57	f	bronwinaurora.com	write@bronwinaurora.com	1744279583919	Bronwin Aurora	inboud	f	system	40	£	bronwinaurora.com
1527	11747	0	frontpage.ga@gmail.com	1744279699951	56	f	ceocolumn.com	Support@gposting.com	1744279699951	Ceo Column	inboud	f	\N	40	£	CeoColumn.com
1527	11748	1	frontpage.ga@gmail.com	1744279699951	56	f	ceocolumn.com	Support@gposting.com	1744279702991	Ceo Column	inboud	f	system	40	£	CeoColumn.com
1528	11749	0	frontpage.ga@gmail.com	1744279857115	54	f	starmusiqweb.com	admin@gpitfirm.com	1744279857115	Star Musiq Web 	inboud	f	\N	40	£	starmusiqweb.com
1528	11750	1	frontpage.ga@gmail.com	1744279857115	54	f	starmusiqweb.com	admin@gpitfirm.com	1744279859940	Star Musiq Web 	inboud	f	system	40	£	starmusiqweb.com
1529	11751	0	frontpage.ga@gmail.com	1744279970120	56	f	thebiographywala.com	support@linksposting.com 	1744279970120	The Biography Wala	inboud	f	\N	40	£	Thebiographywala.com
1529	11752	1	frontpage.ga@gmail.com	1744279970120	56	f	thebiographywala.com	support@linksposting.com 	1744279973180	The Biography Wala	inboud	f	system	40	£	Thebiographywala.com
1530	11753	0	frontpage.ga@gmail.com	1744280227571	52	f	sundarbantracking.com	baldriccada@gmail.com	1744280227571	Sundar Barn	inboud	f	\N	40	£	sundarbantracking.com
1530	11754	1	frontpage.ga@gmail.com	1744280227571	52	f	sundarbantracking.com	baldriccada@gmail.com	1744280230393	Sundar Barn	inboud	f	system	40	£	sundarbantracking.com
1531	11755	0	frontpage.ga@gmail.com	1744280420962	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1744280420962	Every Movie Has A Lesson	inboud	f	\N	40	£	everymoviehasalesson.com
1531	11756	1	frontpage.ga@gmail.com	1744280420962	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1744280423919	Every Movie Has A Lesson	inboud	f	system	40	£	everymoviehasalesson.com
1532	11757	0	frontpage.ga@gmail.com	1744280534970	38	f	nameshype.com	 admin@rabbiitfirm.com	1744280534970	Names Hype 	inboud	f	\N	40	£	nameshype.com
1532	11758	1	frontpage.ga@gmail.com	1744280534970	38	f	nameshype.com	 admin@rabbiitfirm.com	1744280537713	Names Hype 	inboud	f	system	40	£	nameshype.com
1533	11759	0	frontpage.ga@gmail.com	1744280737429	37	f	tuambia.org	contacts@tuambia.org	1744280737429	Tuambia	inboud	f	\N	40	£	tuambia.org
1533	11760	1	frontpage.ga@gmail.com	1744280737429	37	f	tuambia.org	contacts@tuambia.org	1744280740367	Tuambia	inboud	f	system	40	£	tuambia.org
1534	11761	0	frontpage.ga@gmail.com	1744280863821	37	f	dreamchaserhub.com	support@extremebacklink.com 	1744280863821	Dream Chaser Hub 	inboud	f	\N	40	£	dreamchaserhub.com
1534	11762	1	frontpage.ga@gmail.com	1744280863821	37	f	dreamchaserhub.com	support@extremebacklink.com 	1744280866927	Dream Chaser Hub 	inboud	f	system	40	£	dreamchaserhub.com
1535	11763	0	frontpage.ga@gmail.com	1744281089499	36	f	hamsafarshayari.com	admin@gpitfirm.com	1744281089499	Hamsafar Shayari	inbound 	f	\N	40	£	hamsafarshayari.com
1535	11764	1	frontpage.ga@gmail.com	1744281089499	36	f	hamsafarshayari.com	admin@gpitfirm.com	1744281092600	Hamsafar Shayari	inbound 	f	system	40	£	hamsafarshayari.com
1536	11765	0	frontpage.ga@gmail.com	1744281928677	19	f	factquotes.com	support@extremebacklink.com 	1744281928677	Fact Quotes	inboud	f	\N	18	£	factquotes.com
1536	11766	1	frontpage.ga@gmail.com	1744281928677	19	f	factquotes.com	support@extremebacklink.com 	1744281931934	Fact Quotes	inboud	f	system	18	£	factquotes.com
1537	11767	0	frontpage.ga@gmail.com	1744282245029	42	f	topcelebz.com	support@gposting.com	1744282245029	Top Celebz	inboud	f	\N	40	£	Topcelebz.com
1537	11768	1	frontpage.ga@gmail.com	1744282245029	42	f	topcelebz.com	support@gposting.com	1744282248218	Top Celebz	inboud	f	system	40	£	Topcelebz.com
1538	11769	0	frontpage.ga@gmail.com	1744282332763	86	f	theodysseyonline.com	roy@theodysseyonline.com Create with us	1744282332763	Odyssey	inboud	f	\N	50	£	theodysseyonline.com
1538	11770	1	frontpage.ga@gmail.com	1744282332763	86	f	theodysseyonline.com	roy@theodysseyonline.com Create with us	1744282335714	Odyssey	inboud	f	system	50	£	theodysseyonline.com
1539	11771	0	frontpage.ga@gmail.com	1744282455391	66	f	anationofmoms.com	PR@anationofmoms.com	1744282455391	A Nation Of Moms	inboud	f	\N	50	£	anationofmoms.com
1539	11772	1	frontpage.ga@gmail.com	1744282455391	66	f	anationofmoms.com	PR@anationofmoms.com	1744282458166	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
1540	11773	0	frontpage.ga@gmail.com	1744282546745	65	f	africanbusinessreview.co.za	GuestPost@GeniusUpdates.com	1744282546745	African Business review 	inboud	f	\N	50	£	africanbusinessreview.co.za
1540	11774	1	frontpage.ga@gmail.com	1744282546745	65	f	africanbusinessreview.co.za	GuestPost@GeniusUpdates.com	1744282549573	African Business review 	inboud	f	system	50	£	africanbusinessreview.co.za
1541	11775	0	frontpage.ga@gmail.com	1744283499452	54	f	pantheonuk.org	admin@pantheonuk.org	1744283499452	Pan the on UK	inboud	f	\N	50	£	pantheonuk.org
1541	11776	1	frontpage.ga@gmail.com	1744283499452	54	f	pantheonuk.org	admin@pantheonuk.org	1744283502702	Pan the on UK	inboud	f	system	50	£	pantheonuk.org
1542	11777	0	frontpage.ga@gmail.com	1744283598194	46	f	prophecynewswatch.com	 Info@ProphecyNewsWatch.com	1744283598194	PNW	inboud	f	\N	50	£	prophecynewswatch.com
1542	11778	1	frontpage.ga@gmail.com	1744283598194	46	f	prophecynewswatch.com	 Info@ProphecyNewsWatch.com	1744283601525	PNW	inboud	f	system	50	£	prophecynewswatch.com
1543	11779	0	frontpage.ga@gmail.com	1744287332432	45	f	ameyawdebrah.com	@ameyawdebrah.com. 	1744287332432	Ameyaw Debrah	inboud	f	\N	50	£	ameyawdebrah.com
1543	11780	1	frontpage.ga@gmail.com	1744287332432	45	f	ameyawdebrah.com	@ameyawdebrah.com. 	1744287335410	Ameyaw Debrah	inboud	f	system	50	£	ameyawdebrah.com
1544	11781	0	frontpage.ga@gmail.com	1744287545928	44	f	famerize.com	support@seolinkers.com	1744287545928	Fame Rize	inbound 	f	\N	50	£	famerize.com
1544	11782	1	frontpage.ga@gmail.com	1744287545928	44	f	famerize.com	support@seolinkers.com	1744287548836	Fame Rize	inbound 	f	system	50	£	famerize.com
1545	11783	0	frontpage.ga@gmail.com	1744287627439	43	f	mcdmenumy.com	support@seolinkers.com	1744287627439	MCD Menu	inboud	f	\N	50	£	mcdmenumy.com
1545	11784	1	frontpage.ga@gmail.com	1744287627439	43	f	mcdmenumy.com	support@seolinkers.com	1744287630617	MCD Menu	inboud	f	system	50	£	mcdmenumy.com
1546	11785	0	frontpage.ga@gmail.com	1744287722025	45	f	talkssmartly.com	support@seolinkers.com	1744287722025	Talks Smartly	inboud	f	\N	50	£	talkssmartly.com
1546	11786	1	frontpage.ga@gmail.com	1744287722025	45	f	talkssmartly.com	support@seolinkers.com	1744287724851	Talks Smartly	inboud	f	system	50	£	talkssmartly.com
1547	11787	0	frontpage.ga@gmail.com	1744287848608	41	f	talkinemoji.com	support@seolinkers.com	1744287848608	Talk in emoji	inboud	f	\N	50	£	talkinemoji.com
1547	11788	1	frontpage.ga@gmail.com	1744287848608	41	f	talkinemoji.com	support@seolinkers.com	1744287851587	Talk in emoji	inboud	f	system	50	£	talkinemoji.com
1548	11789	0	frontpage.ga@gmail.com	1744287951439	42	f	beumye.com	support@seolinkers.com	1744287951439	beaumye	inboud	f	\N	50	£	beumye.com
1548	11790	1	frontpage.ga@gmail.com	1744287951439	42	f	beumye.com	support@seolinkers.com	1744287954644	beaumye	inboud	f	system	50	£	beumye.com
1202	11944	1	james.p@frontpageadvantage.com	1726139288772	41	f	shemightbeloved.com	georgina@shemightbeloved.com	1744716750087	Georgina	James	f	chris.p@frontpageadvantage.com	100	£	www.shemightbeloved.com
334	12048	1	historical	0	23	f	lifeloving.co.uk	sally@lifeloving.co.uk	1744801811180	Sally Allsop	Fatjoe	f	james.p@frontpageadvantage.com	100	£	www.lifeloving.co.uk
1355	12421	1	frontpage.ga@gmail.com	1729769821170	36	t	wrapofthedays.co.uk	arianne@timewomenflag.com	1745918894052	Arianna Volkova	inbound	f	james.p@frontpageadvantage.com	25	£	wrapofthedays.co.uk
1356	12422	1	frontpage.ga@gmail.com	1729770014428	37	t	mealtop.co.uk	arianne@timewomenflag.com	1745918916482	Arianna Volkova	inbound	f	james.p@frontpageadvantage.com	25	£	https://mealtop.co.uk/
1357	12423	1	chris.p@frontpageadvantage.com	1730196590897	66	t	dailysquib.co.uk	arianna@timewomenflag.com	1745918928355	Arianna Volkova	inbound	f	james.p@frontpageadvantage.com	141	£	dailysquib.co.uk
1358	12424	1	chris.p@frontpageadvantage.com	1730196614139	64	t	marketoracle.co.uk	arianna@timewomenflag.com	1745918937497	Arianna Volkova	inbound	f	james.p@frontpageadvantage.com	94	£	marketoracle.co.uk
702	12425	1	michael.l@frontpageadvantage.com	1708008300694	38	t	frontpageadvantage.com	chris.p@frontpageadvantage.com	1745918966021	Front Page Advantage	Email	f	james.p@frontpageadvantage.com	10	£	https://frontpageadvantage.com/
808	12426	1	sam.b@frontpageadvantage.com	1709637089134	19	t	myarchitecturesidea.com	travelworldwithfashion@gmail.com	1745918968077	Vijay Chauhan	Outbound	f	james.p@frontpageadvantage.com	41	£	https://myarchitecturesidea.com/
762	12427	1	sam.b@frontpageadvantage.com	1708615840028	14	t	flatpackhouses.co.uk	falcobliek@gmail.com	1745918969943	Falco	Inbound	f	james.p@frontpageadvantage.com	120	£	https://www.flatpackhouses.co.uk/
769	12428	1	chris.p@frontpageadvantage.com	1709027357228	60	t	livepositively.com	ela690000@gmail.com	1745919290723	ela	inbound	f	james.p@frontpageadvantage.com	1150	£	https://livepositively.com/
451	12429	1	historical	0	74	t	marketbusinessnews.com	Imjustwebworld@gmail.com	1745919294738	Harshil	Inbound email	f	james.p@frontpageadvantage.com	99	£	marketbusinessnews.com
1163	12430	1	james.p@frontpageadvantage.com	1726061380233	51	t	powerhomebiz.com	sofiakahn06@gmail.com	1745919297677	Sofia	James	f	james.p@frontpageadvantage.com	250	$	powerhomebiz.com
1258	12431	1	james.p@frontpageadvantage.com	1727177065841	35	t	eruditemeetup.co.uk	teamforbesradar@gmail.com	1745919301219	Forbes Radar	James	f	james.p@frontpageadvantage.com	120	$	http://eruditemeetup.co.uk/
784	12432	1	chris.p@frontpageadvantage.com	1709035290025	37	t	okaybliss.com	infopediapros@gmail.com	1745919304305	Ricardo	inbound	f	james.p@frontpageadvantage.com	80	£	https://www.okaybliss.com/
1202	12433	1	james.p@frontpageadvantage.com	1726139288772	41	t	shemightbeloved.com	georgina@shemightbeloved.com	1745919307369	Georgina	James	f	james.p@frontpageadvantage.com	100	£	www.shemightbeloved.com
1164	12434	1	james.p@frontpageadvantage.com	1726063207724	56	t	celebrow.org	sofiakahn06@gmail.com	1745919310438	Sofia	James	f	james.p@frontpageadvantage.com	30	$	celebrow.org
1165	12435	1	james.p@frontpageadvantage.com	1726063285389	57	t	filmik.blog	sofiakahn06@gmail.com	1745919313961	Sofia	James	f	james.p@frontpageadvantage.com	30	$	filmik.blog
1171	12436	1	james.p@frontpageadvantage.com	1726066685680	41	t	shibleysmiles.com	sofiakahn06@gmail.com	1745919317781	Sofia	James	f	james.p@frontpageadvantage.com	150	$	shibleysmiles.com
787	12437	1	sam.b@frontpageadvantage.com	1709041586393	39	t	netizensreport.com	premium@rabbiitfirm.com	1745919320554	Mojammel	Inbound	f	james.p@frontpageadvantage.com	120	£	netizensreport.com
775	12438	1	chris.p@frontpageadvantage.com	1709031235193	30	t	followthefashion.org	bhaiahsan799@gmail.com	1745919323952	Ashan	inbound	f	james.p@frontpageadvantage.com	55	£	https://www.followthefashion.org/
1167	12439	1	james.p@frontpageadvantage.com	1726063465343	60	t	stylesrant.org	sofiakahn06@gmail.com	1745919326196	Sofia	James	f	james.p@frontpageadvantage.com	30	$	stylesrant.org
335	12440	1	historical	0	24	t	lillaloves.com	lillaallahiary@gmail.com	1745919328923	Lilla	Fatjoe	f	james.p@frontpageadvantage.com	20	£	Www.lillaloves.com
341	12441	1	historical	0	17	t	sashashantel.com	contactsashashantel@gmail.com	1745919339703	Sasha Shantel	Fatjoe	f	james.p@frontpageadvantage.com	60	£	http://www.sashashantel.com
346	12442	1	historical	0	20	t	carouseldiary.com	Info@carouseldiary.com	1745919342211	Katrina	Fatjoe	f	james.p@frontpageadvantage.com	40	£	Carouseldiary.com
353	12443	1	historical	0	16	t	lingermagazine.com	info@lingermagazine.com	1745919345664	Tiffany Tate	Fatjoe	f	james.p@frontpageadvantage.com	82	£	https://www.lingermagazine.com/
358	12444	1	historical	0	22	t	thisbrilliantday.com	thisbrilliantday@gmail.com	1745919349176	Sophie Harriet	Fatjoe	f	james.p@frontpageadvantage.com	50	£	https://thisbrilliantday.com/
769	12445	1	chris.p@frontpageadvantage.com	1709027357228	60	t	livepositively.com	ela690000@gmail.com	1745919352207	ela	inbound	f	james.p@frontpageadvantage.com	1150	£	https://livepositively.com/
366	12446	1	historical	0	46	t	barbaraiweins.com	info@barbaraiweins.com	1745919355077	Jason	Inbound email	f	james.p@frontpageadvantage.com	37	£	Barbaraiweins.com
372	12447	1	historical	0	37	t	fashion-mommy.com	fashionmommywm@gmail.com	1745919357673	emma iannarilli	Inbound email	f	james.p@frontpageadvantage.com	85	£	fashion-mommy.com
405	12448	1	historical	0	36	t	prettybigbutterflies.com	prettybigbutterflies@gmail.com	1745919361530	Hollie	Inbound email	f	james.p@frontpageadvantage.com	80	£	www.prettybigbutterflies.com
419	12449	1	historical	0	32	t	fadedspring.co.uk	analuisadejesus1993@hotmail.co.uk	1745919364996	Ana	Facebook	f	james.p@frontpageadvantage.com	100	£	https://fadedspring.co.uk/
472	12450	1	historical	0	28	t	pleasureprinciple.net	hello@contentmother.com	1745919368173	Becky	inbound email	f	james.p@frontpageadvantage.com	50	£	https://www.pleasureprinciple.net
474	12451	1	historical	0	22	t	lclarke.co.uk	hello@contentmother.com	1745919371223	Becky	inbound email	f	james.p@frontpageadvantage.com	50	£	https://lclarke.co.uk
497	12453	1	historical	0	32	t	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	1745919375611	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	anythinggoeslifestyle.co.uk
510	12455	1	historical	0	30	t	powderrooms.co.uk	fazal.akbar@digitalczars.io	1745919381071	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	powderrooms.co.uk
779	12457	1	chris.p@frontpageadvantage.com	1709032988565	24	t	travelworldfashion.com	travelworldwithfashion@gmail.com	1745919387139	Team	inbound	f	james.p@frontpageadvantage.com	72	£	https://travelworldfashion.com/
1152	12463	1	james.p@frontpageadvantage.com	1721314820107	19	t	rosemaryhelenxo.com	info@rosemaryhelenxo.com	1745919405796	Rose	Contact Form	f	james.p@frontpageadvantage.com	20	£	www.RosemaryHelenXO.com
775	12465	1	chris.p@frontpageadvantage.com	1709031235193	30	t	followthefashion.org	bhaiahsan799@gmail.com	1745919414480	Ashan	inbound	f	james.p@frontpageadvantage.com	55	£	https://www.followthefashion.org/
477	12452	1	historical	0	14	t	rocketandrelish.com	hello@contentmother.com	1745919373584	Becky	inbound email	f	james.p@frontpageadvantage.com	45	£	https://www.rocketandrelish.com
499	12454	1	historical	0	58	t	lifestyledaily.co.uk	fazal.akbar@digitalczars.io	1745919378603	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	144	£	www.lifestyledaily.co.uk
655	12456	1	chris.p@frontpageadvantage.com	0	29	t	forgetfulmomma.com	info@morningbusinesschat.com	1745919384368	Brett Napoli	Inbound	f	james.p@frontpageadvantage.com	225	£	https://www.forgetfulmomma.com/
774	12458	1	chris.p@frontpageadvantage.com	1709030265171	32	t	voiceofaction.org	webmaster@redhatmedia.net	1745919390140	Vivek	outbound	f	james.p@frontpageadvantage.com	65	£	http://voiceofaction.org/
1062	12459	1	sam.b@frontpageadvantage.com	1716462238586	36	t	thebraggingmommy.com	kirangupta.outreach@gmail.com	1745919392228	Kiran Gupta	Inbound	f	james.p@frontpageadvantage.com	80	£	thebraggingmommy.com
1088	12461	1	sam.b@frontpageadvantage.com	1719320465060	35	t	family-budgeting.co.uk	katherine@orangeoutreach.com	1745919400681	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	120	£	family-budgeting.co.uk
1084	12460	1	sam.b@frontpageadvantage.com	1719320073095	28	t	bouncemagazine.co.uk	katherine@orangeoutreach.com	1745919395800	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	100	£	bouncemagazine.co.uk
1063	12462	1	sam.b@frontpageadvantage.com	1716462449737	38	t	grapevinebirmingham.com	kirangupta.outreach@gmail.com	1745919403297	Kiran Gupta	Inbound	f	james.p@frontpageadvantage.com	80	£	grapevinebirmingham.com
1094	12464	1	sam.b@frontpageadvantage.com	1719322155330	27	t	coffeecakekids.com	katherine@orangeoutreach.com	1745919408512	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	100	£	coffeecakekids.com
1410	12466	1	frontpage.ga@gmail.com	1730296903193	37	t	glitzandglamourmakeup.co.uk	arianne@timewomenflag.com	1745919418160	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	141	£	glitzandglamourmakeup.co.uk
398	12467	1	historical	0	25	t	mytunbridgewells.com	mytunbridgewells@gmail.com	1745919710094	Clare Lush-Mansell	Inbound email	f	james.p@frontpageadvantage.com	124	£	https://www.mytunbridgewells.com/
401	12468	1	historical	0	32	t	marketme.co.uk	christopher@marketme.co.uk	1745919714770	Christopher	Inbound email	f	james.p@frontpageadvantage.com	59	£	https://marketme.co.uk/
432	12469	1	historical	0	47	t	lyliarose.com	victoria@lyliarose.com	1745919717468	Victoria	Facebook	f	james.p@frontpageadvantage.com	170	£	https://www.lyliarose.com
433	12470	1	historical	0	36	t	bq-magazine.com	hello@contentmother.com	1745919719875	Lucy Clarke	Facebook	f	james.p@frontpageadvantage.com	80	£	https://www.bq-magazine.com
540	12471	1	historical	0	42	t	otsnews.co.uk	bhaiahsan799@gmail.com	1745919792182	Ashan	Inbound Sam	f	james.p@frontpageadvantage.com	55	£	www.otsnews.co.uk
484	12472	1	historical	0	89	t	ibtimes.co.uk	i.perez@ibtmedia.co.uk	1745919794831	Inigo	inbound email	f	james.p@frontpageadvantage.com	379	£	ibtimes.co.uk
468	12473	1	historical	0	92	t	apnews.com	minalkh124@gmail.com	1745919797158	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	240	£	apnews.com
512	12474	1	historical	0	27	t	calculator.co.uk	fazal.akbar@digitalczars.io	1745919799818	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	132	£	www.calculator.co.uk
523	12475	1	historical	0	36	f	daytradetheworld.com	fazal.akbar@digitalczars.io	1745919801879	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	www.daytradetheworld.com
523	12476	1	historical	0	36	t	daytradetheworld.com	fazal.akbar@digitalczars.io	1745919805208	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	www.daytradetheworld.com
535	12477	1	historical	0	57	t	ukbusinessforums.co.uk	natalilacanario@gmail.com	1745919807947	Natalila	Inbound Sam	f	james.p@frontpageadvantage.com	170	£	ukbusinessforums.co.uk
530	12478	1	historical	0	36	t	tech-wonders.com	backlinsprovider@gmail.com	1745919810648	David	Inbound Sam	f	james.p@frontpageadvantage.com	100	£	www.tech-wonders.com
1540	12479	1	frontpage.ga@gmail.com	1744282546745	65	t	africanbusinessreview.co.za	GuestPost@GeniusUpdates.com	1745919813074	African Business review 	inboud	f	james.p@frontpageadvantage.com	50	£	africanbusinessreview.co.za
333	12480	1	historical	0	15	t	learndeveloplive.com	chris@learndeveloplive.com	1745919815881	Chris Jaggs	Fatjoe	f	james.p@frontpageadvantage.com	25	£	www.learndeveloplive.com
458	12481	1	historical	0	72	t	spacecoastdaily.com	minalkh124@gmail.com	1745919818703	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	120	£	https://spacecoastdaily.com/
907	12482	1	sam.b@frontpageadvantage.com	1709719202025	66	t	bmmagazine.co.uk	kenditoys.com@gmail.com	1745919821775	David warner 	Inbound	f	james.p@frontpageadvantage.com	200	£	https://bmmagazine.co.uk/
783	12483	1	chris.p@frontpageadvantage.com	1709034374081	45	t	corporatelivewire.com	sukhenseoconsultant@gmail.com	1745919824559	Sukhen	inbound	f	james.p@frontpageadvantage.com	150	£	https://corporatelivewire.com/
1107	12484	1	sam.b@frontpageadvantage.com	1719408355968	54	t	businesscheshire.co.uk	jagdish.linkbuilder@gmail.com	1745919826898	Jagdish Patel	Inbound	f	james.p@frontpageadvantage.com	140	£	https://www.businesscheshire.co.uk/
778	12485	1	chris.p@frontpageadvantage.com	1709032760082	25	t	suntrics.com	suntrics4u@gmail.com	1745919829944	Suntrics	outbound	f	james.p@frontpageadvantage.com	40	£	https://suntrics.com/
902	12486	1	sam.b@frontpageadvantage.com	1709717920944	32	t	trainingexpress.org.uk	kenditoys.com@gmail.com	1745919833481	David warner	Inbound	f	james.p@frontpageadvantage.com	150	£	https://trainingexpress.org.uk/
1091	12487	1	sam.b@frontpageadvantage.com	1719320713419	74	t	businesscasestudies.co.uk	katherine@orangeoutreach.com	1745919835983	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	220	£	businesscasestudies.co.uk
1153	12488	1	james.p@frontpageadvantage.com	1723644250691	35	t	forbesradar.co.uk	teamforbesradar@gmail.com	1745919838482	Forbes Radar	James	f	james.p@frontpageadvantage.com	62	£	https://forbesradar.co.uk/
1064	12489	1	chris.p@frontpageadvantage.com	1717491149032	31	t	enterpriseleague.com	info@enterpriseleague.com	1745919841088	Irina	outbound	f	james.p@frontpageadvantage.com	280	£	https://enterpriseleague.com/
763	12490	1	sam.b@frontpageadvantage.com	1708616008102	88	t	benzinga.com	falcobliek@gmail.com	1745919843705	Falco	Inbound	f	james.p@frontpageadvantage.com	130	£	https://www.benzinga.com/
761	12491	1	sam.b@frontpageadvantage.com	1708615661584	36	t	holyroodpr.co.uk	falcobliek@gmail.com	1745919846393	Falco	Inbound	f	james.p@frontpageadvantage.com	130	£	https://www.holyroodpr.co.uk/
908	12492	1	sam.b@frontpageadvantage.com	1709719594822	32	t	britainreviews.co.uk	kenditoys.com@gmail.com	1745919849291	David warner 	Inbound	f	james.p@frontpageadvantage.com	167	£	https://britainreviews.co.uk/
1413	12493	1	frontpage.ga@gmail.com	1730297027604	40	t	businessfirstonline.co.uk	arianne@timewomenflag.com	1745919852459	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	134	£	businessfirstonline.co.uk
1411	12494	1	frontpage.ga@gmail.com	1730296950461	38	t	businessvans.co.uk	arianne@timewomenflag.com	1745919855682	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	129	£	businessvans.co.uk
1407	12495	1	frontpage.ga@gmail.com	1730296672141	41	t	themarketingblog.co.uk	arianne@timewomenflag.com	1745919858760	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	129	£	themarketingblog.co.uk
1415	12496	1	frontpage.ga@gmail.com	1730297155721	35	t	blackeconomics.co.uk	arianne@timewomenflag.com	1745919861365	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	134	£	blackeconomics.co.uk
1420	12497	1	frontpage.ga@gmail.com	1730297564122	32	t	clickdo.co.uk	arianne@timewomenflag.com	1745919863587	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	118	£	business.clickdo.co.uk
1421	12498	1	frontpage.ga@gmail.com	1730297627872	34	t	propertydivision.co.uk	arianne@timewomenflag.com	1745919865863	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	131	£	propertydivision.co.uk
1096	12500	1	sam.b@frontpageadvantage.com	1719322406613	34	t	businesslancashire.co.uk	katherine@orangeoutreach.com	1745919871353	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	140	£	businesslancashire.co.uk
323	12501	1	historical	0	27	t	clairemorandesigns.co.uk	hello@clairemorandesigns.co.uk	1745919987779	Claire	Fatjoe	f	james.p@frontpageadvantage.com	80	£	clairemorandesigns.co.uk
327	12499	1	historical	0	26	t	startsmarter.co.uk	publishing@startsmarter.co.uk	1745919868182	Adam Niazi	Fatjoe	f	james.p@frontpageadvantage.com	89	£	www.StartSmarter.co.uk
420	12502	1	historical	0	30	t	dontcrampmystyle.co.uk	anna@dontcrampmystyle.co.uk	1745919990544	Anna	Facebook	f	james.p@frontpageadvantage.com	150	£	https://www.dontcrampmystyle.co.uk
1078	12503	1	sam.b@frontpageadvantage.com	1719319469273	22	t	redkitedays.co.uk	katherine@orangeoutreach.com	1745919993184	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	160	£	redkitedays.co.uk
516	12505	1	historical	0	29	t	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1745919998139	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.thegardeningwebsite.co.uk
1081	12504	1	sam.b@frontpageadvantage.com	1719319784878	38	t	emmysmummy.com	katherine@orangeoutreach.com	1745919995783	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	120	£	emmysmummy.com
782	12506	1	chris.p@frontpageadvantage.com	1709033531454	17	t	spokenenglishtips.com	spokenenglishtips@gmail.com	1745920481682	Edu Place	inbound	f	james.p@frontpageadvantage.com	30	£	https://spokenenglishtips.com/
348	12507	1	historical	0	23	t	blossomeducation.co.uk	info@blossomeducation.co.uk	1745920486755	Vicki	Fatjoe	f	james.p@frontpageadvantage.com	60	£	blossomeducation.co.uk
781	12508	1	chris.p@frontpageadvantage.com	1709033259858	47	t	kidsworldfun.com	enquiry@kidsworldfun.com	1745920500154	Limna	outbound	f	james.p@frontpageadvantage.com	80	£	https://www.kidsworldfun.com/
517	12509	1	historical	0	24	t	interestingfacts.org.uk	fazal.akbar@digitalczars.io	1745920502937	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	156	£	www.interestingfacts.org.uk
653	12510	1	chris.p@frontpageadvantage.com	0	40	t	thatdrop.com	info@morningbusinesschat.com	1745920605845	Brett Napoli	Inbound	f	james.p@frontpageadvantage.com	83	£	https://thatdrop.com/
1524	12511	1	frontpage.ga@gmail.com	1744278617976	57	t	starmusiq.audio	Contact@guestpost.cc	1745920608470	Star Musiq	inboud	f	james.p@frontpageadvantage.com	30	£	https://starmusiq.audio/
1082	12512	1	sam.b@frontpageadvantage.com	1719319867176	29	t	theowlet.co.uk	katherine@orangeoutreach.com	1745920611176	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	100	£	theowlet.co.uk
1085	12513	1	sam.b@frontpageadvantage.com	1719320223488	36	t	welovebrum.co.uk	katherine@orangeoutreach.com	1745920614572	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	140	£	welovebrum.co.uk
765	12514	1	sam.b@frontpageadvantage.com	1708616408925	47	t	storymirror.com	ela690000@gmail.com	1745920616912	Ella	Inbound	f	james.p@frontpageadvantage.com	96	£	https://storymirror.com/
351	12515	1	historical	0	35	t	mycarheaven.com	Info@mycarheaven.com	1745921464059	Chris	Fatjoe	f	james.p@frontpageadvantage.com	150	£	Www.mycarheaven.com
411	12516	1	historical	0	22	t	bouquetandbells.com	sarah@dreamofhome.co.uk	1745921466280	Sarah Macklin	Facebook	f	james.p@frontpageadvantage.com	60	£	https://bouquetandbells.com/
421	12517	1	historical	0	48	t	glassofbubbly.com	christopher@marketme.co.uk	1745921468883	Christopher	Inbound email	f	james.p@frontpageadvantage.com	125	£	https://glassofbubbly.com/
491	12518	1	historical	0	54	t	theexeterdaily.co.uk	fazal.akbar@digitalczars.io	1745921471026	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.theexeterdaily.co.uk
503	12519	1	historical	0	57	t	newsfromwales.co.uk	fazal.akbar@digitalczars.io	1745921473419	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	144	£	newsfromwales.co.uk
504	12520	1	historical	0	29	t	westlondonliving.co.uk	fazal.akbar@digitalczars.io	1745921475598	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	84	£	www.westlondonliving.co.uk
534	12521	1	historical	0	42	t	saddind.co.uk	natalilacanario@gmail.com	1745921478834	Natalila	Inbound Sam	f	james.p@frontpageadvantage.com	175	£	saddind.co.uk
308	12522	1	historical	0	13	t	felifamily.com	suzied@felifamily.com	1745921761209	Suzie	Fatjoe	f	james.p@frontpageadvantage.com	25	£	felifamily.com
329	12523	1	historical	0	35	t	wemadethislife.com	wemadethislife@outlook.com	1745921763647	Alina Davies	Fatjoe	f	james.p@frontpageadvantage.com	150	£	https://wemadethislife.com
345	12524	1	historical	0	17	t	threelittlezees.co.uk	lauraroseclubb@hotmail.com	1745921766786	Laura	Fatjoe	f	james.p@frontpageadvantage.com	25	£	threelittlezees.co.uk
355	12525	1	historical	0	36	t	ialwaysbelievedinfutures.com	rebeccajlsk@gmail.com	1745921769108	Rebecca	Fatjoe	f	james.p@frontpageadvantage.com	100	£	www.ialwaysbelievedinfutures.com
359	12526	1	historical	0	28	t	beccafarrelly.co.uk	hello@beccafarrelly.co.uk	1745921771549	Becca	Fatjoe	f	james.p@frontpageadvantage.com	100	£	beccafarrelly.co.uk
360	12527	1	historical	0	35	t	rachelbustin.com	rachel@rachelbustin.com	1745921773953	Rachel Bustin	Fatjoe	f	james.p@frontpageadvantage.com	85	£	https://rachelbustin.com
367	12528	1	historical	0	23	t	cocktailsinteacups.com	cocktailsinteacups@gmail.com	1745921776702	Amy Walsh	Inbound email	f	james.p@frontpageadvantage.com	40	£	cocktailsinteacups.com
371	12529	1	historical	0	23	t	ricecakesandraisins.co.uk	ricecakesandraisins@hotmail.com	1745921779526	Jennie Jordan	Inbound email	f	james.p@frontpageadvantage.com	80	£	www.ricecakesandraisins.co.uk
379	12530	1	historical	0	27	t	yeahlifestyle.com	info@yeahlifestyle.com	1745921782022	Asha Carlos	Inbound email	f	james.p@frontpageadvantage.com	120	£	https://www.yeahlifestyle.com
388	12531	1	historical	0	25	t	misstillyandme.co.uk	beingtillysmummy@gmail.com	1745921786727	vicky Hall-Newman	Inbound email	f	james.p@frontpageadvantage.com	75	£	www.misstillyandme.co.uk
399	12532	1	historical	0	33	t	suburban-mum.com	hello@suburban-mum.com	1745921792324	Maria	Inbound email	f	james.p@frontpageadvantage.com	100	£	www.suburban-mum.com
414	12533	1	historical	0	20	t	joannavictoria.co.uk	joannabayford@gmail.com	1745921795283	Joanna Bayford	Facebook	f	james.p@frontpageadvantage.com	50	£	https://www.joannavictoria.co.uk
417	12534	1	historical	0	41	t	globalmousetravels.com	hello@globalmousetravels.com	1745921799265	Nichola West	Facebook	f	james.p@frontpageadvantage.com	250	£	https://globalmousetravels.com
430	12535	1	historical	0	26	t	bizzimummy.com	Bizzimummy@gmail.com	1745921802233	Eva Stretton	Facebook	f	james.p@frontpageadvantage.com	55	£	https://bizzimummy.com
471	12536	1	historical	0	22	t	realparent.co.uk	hello@contentmother.com	1745921804498	Becky	inbound email	f	james.p@frontpageadvantage.com	60	£	https://www.realparent.co.uk
1052	12537	1	michael.l@frontpageadvantage.com	1716451324696	32	t	adventuresofayorkshiremum.co.uk	hello@adventuresofayorkshiremum.co.uk	1745921806636	Louise	Outbound Facebook	f	james.p@frontpageadvantage.com	150	£	https://www.adventuresofayorkshiremum.co.uk/
495	12538	1	historical	0	63	t	welshmum.co.uk	fazal.akbar@digitalczars.io	1745921808996	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.welshmum.co.uk
496	12539	1	historical	0	28	t	enjoytheadventure.co.uk	fazal.akbar@digitalczars.io	1745921811253	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	144	£	enjoytheadventure.co.uk
507	12540	1	historical	0	34	t	toddleabout.co.uk	fazal.akbar@digitalczars.io	1745921813636	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	toddleabout.co.uk
520	12541	1	historical	0	26	t	davidsavage.co.uk	fazal.akbar@digitalczars.io	1745921815757	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	30	£	www.davidsavage.co.uk
1053	12542	1	michael.l@frontpageadvantage.com	1716451545373	29	t	emmareed.net	admin@emmareed.net	1745921818989	Emma Reed	Outbound Facebook	f	james.p@frontpageadvantage.com	100	£	https://emmareed.net/
1061	12543	1	michael.l@frontpageadvantage.com	1716453125082	58	t	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	1745921823275	Sarah Dixon 	Outbound Facebook	f	james.p@frontpageadvantage.com	100	£	https://www.minimeandluxury.co.uk/
809	12544	1	sam.b@frontpageadvantage.com	1709637625007	57	t	pierdom.com	info@pierdom.com	1745921825549	Junaid	Outbound	f	james.p@frontpageadvantage.com	25	£	https://pierdom.com/
1429	12545	1	frontpage.ga@gmail.com	1730297923475	26	t	simpleparenting.co.uk	arianne@timewomenflag.com	1745921827808	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	139	£	simpleparenting.co.uk
516	12546	1	historical	0	29	t	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1745922001614	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.thegardeningwebsite.co.uk
412	12548	1	historical	0	30	t	laurakatelucas.com	laurakatelucas@hotmail.com	1745922007182	Laura Lucas	Facebook	f	james.p@frontpageadvantage.com	100	£	www.laurakatelucas.com
317	12547	1	historical	0	29	t	jenloumeredith.com	JENLOUMEREDITH@GMAIL.COM	1745922004831	Jen	Fatjoe	f	james.p@frontpageadvantage.com	30	£	www.jenloumeredith.com
1423	12549	1	frontpage.ga@gmail.com	1730297707203	35	t	planetveggie.co.uk	arianne@timewomenflag.com	1745922801832	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	145	£	planetveggie.co.uk
378	12550	1	historical	0	42	t	healthyvix.com	victoria@healthyvix.com	1745922807023	Victoria	Inbound email	f	james.p@frontpageadvantage.com	170	£	https://www.healthyvix.com
381	12551	1	historical	0	34	t	therarewelshbit.com	kacie@therarewelshbit.com	1745922810289	Kacie Morgan	Inbound email	f	james.p@frontpageadvantage.com	200	£	www.therarewelshbit.com
473	12552	1	historical	0	24	t	earthlytaste.com	hello@contentmother.com	1745922813063	Becky	inbound email	f	james.p@frontpageadvantage.com	50	£	https://www.earthlytaste.com
513	12553	1	historical	0	30	t	thefoodaholic.co.uk	fazal.akbar@digitalczars.io	1745922815599	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.thefoodaholic.co.uk
1065	12554	1	chris.p@frontpageadvantage.com	1718109354711	33	t	cocktailswithmom.com	deebat@cocktailswithmom.com	1745922836723	Dee Marie	Fatjoe	t	james.p@frontpageadvantage.com	118	£	https://cocktailswithmom.com
516	12555	1	historical	0	29	t	thegardeningwebsite.co.uk	fazal.akbar@digitalczars.io	1745922860061	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.thegardeningwebsite.co.uk
953	12556	1	michael.l@frontpageadvantage.com	1711012683237	41	t	thecricketpaper.com	sam.emery@greenwayspublishing.com	1745922862693	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	100	£	https://www.thecricketpaper.com/
904	12557	1	sam.b@frontpageadvantage.com	1709718289226	38	t	theleaguepaper.com	sam.emery@greenwayspublishing.com	1745922866038	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	100	£	www.theleaguepaper.com
955	12558	1	michael.l@frontpageadvantage.com	1711012971138	27	t	latetacklemagazine.com	sam.emery@greenwayspublishing.com	1745922869255	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	100	£	https://www.latetacklemagazine.com/
956	12559	1	michael.l@frontpageadvantage.com	1711013035726	25	t	racingahead.net	sam.emery@greenwayspublishing.com	1745922871688	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	100	£	https://www.racingahead.net/
954	12560	1	michael.l@frontpageadvantage.com	1711012828815	51	t	thenonleaguefootballpaper.com	sam.emery@greenwayspublishing.com	1745922892115	Sam	Outbound Chris	f	james.p@frontpageadvantage.com	200	£	https://www.thenonleaguefootballpaper.com/
1535	12561	1	frontpage.ga@gmail.com	1744281089499	36	t	hamsafarshayari.com	admin@gpitfirm.com	1745923138440	Hamsafar Shayari	inbound 	f	james.p@frontpageadvantage.com	40	£	hamsafarshayari.com
1077	12562	1	sam.b@frontpageadvantage.com	1719318416922	50	t	algarvedailynews.com	katherine@orangeoutreach.com	1745923141215	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	175	£	algarvedailynews.com
476	12563	1	historical	0	11	t	contentmother.com	hello@contentmother.com	1745923144176	Becky	inbound email	f	james.p@frontpageadvantage.com	45	£	https://www.contentmother.com
1537	12564	1	frontpage.ga@gmail.com	1744282245029	42	t	topcelebz.com	support@gposting.com	1745923146909	Top Celebz	inboud	f	james.p@frontpageadvantage.com	40	£	Topcelebz.com
465	12565	1	historical	0	82	t	goodmenproject.com	minalkh124@gmail.com	1745923170715	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	220	£	http://goodmenproject.com
1503	12566	1	frontpage.ga@gmail.com	1741269787500	35	t	latestdash.co.uk	alphaitteamofficial@gmail.com	1745923173279	Latest dash	inbound	f	james.p@frontpageadvantage.com	50	£	latestdash.co.uk
1516	12567	1	frontpage.ga@gmail.com	1742851851548	28	t	thecwordmag.co.uk	info@thecwordmag.co.uk	1745923176023	thecwordmag	inbound	f	james.p@frontpageadvantage.com	80	£	thecwordmag.co.uk
1541	12568	1	frontpage.ga@gmail.com	1744283499452	54	t	pantheonuk.org	admin@pantheonuk.org	1745923178708	Pan the on UK	inboud	f	james.p@frontpageadvantage.com	50	£	pantheonuk.org
1525	12569	1	frontpage.ga@gmail.com	1744278836662	37	t	hentai20.pro	 technexitspace@gmail.com	1745923180890	Hentai 20 	inboud	f	james.p@frontpageadvantage.com	30	£	hentai20.pro
1526	12570	1	frontpage.ga@gmail.com	1744279580858	57	t	bronwinaurora.com	write@bronwinaurora.com	1745923186998	Bronwin Aurora	inboud	f	james.p@frontpageadvantage.com	40	£	bronwinaurora.com
1527	12571	1	frontpage.ga@gmail.com	1744279699951	56	t	ceocolumn.com	Support@gposting.com	1745923189771	Ceo Column	inboud	f	james.p@frontpageadvantage.com	40	£	CeoColumn.com
1543	12572	1	frontpage.ga@gmail.com	1744287332432	45	t	ameyawdebrah.com	@ameyawdebrah.com. 	1745923239296	Ameyaw Debrah	inboud	f	james.p@frontpageadvantage.com	50	£	ameyawdebrah.com
1528	12573	1	frontpage.ga@gmail.com	1744279857115	54	t	starmusiqweb.com	admin@gpitfirm.com	1745923242893	Star Musiq Web 	inboud	f	james.p@frontpageadvantage.com	40	£	starmusiqweb.com
1544	12574	1	frontpage.ga@gmail.com	1744287545928	44	t	famerize.com	support@seolinkers.com	1745923296483	Fame Rize	inbound 	f	james.p@frontpageadvantage.com	50	£	famerize.com
1545	12575	1	frontpage.ga@gmail.com	1744287627439	43	t	mcdmenumy.com	support@seolinkers.com	1745923299076	MCD Menu	inboud	f	james.p@frontpageadvantage.com	50	£	mcdmenumy.com
1547	12576	1	frontpage.ga@gmail.com	1744287848608	41	t	talkinemoji.com	support@seolinkers.com	1745923301474	Talk in emoji	inboud	f	james.p@frontpageadvantage.com	50	£	talkinemoji.com
1548	12577	1	frontpage.ga@gmail.com	1744287951439	42	t	beumye.com	support@seolinkers.com	1745923304424	beaumye	inboud	f	james.p@frontpageadvantage.com	50	£	beumye.com
1302	12578	1	rdomloge@gmail.com	1727196482040	98	t	whatsapp.com	ramsay.domloge@bca.com	1745923307185	Ramsay test	Testing	f	james.p@frontpageadvantage.com	10	£	www.whatsapp.com
1412	12579	1	frontpage.ga@gmail.com	1730296980153	39	t	kettlemag.co.uk	arianne@timewomenflag.com	1745923318797	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	130	£	kettlemag.co.uk
1405	12580	1	frontpage.ga@gmail.com	1730296607431	38	t	ramzine.co.uk	arianne@timewomenflag.com	1745923321115	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	114	£	ramzine.co.uk
1402	12581	1	frontpage.ga@gmail.com	1730296493781	51	t	hrnews.co.uk	arianne@timewomenflag.com	1745923323287	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	122	£	hrnews.co.uk
1422	12582	1	frontpage.ga@gmail.com	1730297665873	30	t	taketotheroad.co.uk	arianne@timewomenflag.com	1745923325473	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	139	£	taketotheroad.co.uk
1424	12583	1	frontpage.ga@gmail.com	1730297739559	35	t	mummyinatutu.co.uk	arianne@timewomenflag.com	1745923328810	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	98	£	mummyinatutu.co.uk
1533	12585	1	frontpage.ga@gmail.com	1744280737429	37	t	tuambia.org	contacts@tuambia.org	1745923333899	Tuambia	inboud	f	james.p@frontpageadvantage.com	40	£	tuambia.org
1426	12584	1	frontpage.ga@gmail.com	1730297811663	31	t	joannedewberry.co.uk	arianne@timewomenflag.com	1745923331524	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	122	£	joannedewberry.co.uk
903	12593	1	sam.b@frontpageadvantage.com	1709718136681	52	t	therugbypaper.co.uk	backlinsprovider@gmail.com	1745923533754	David Smith 	Inbound	f	james.p@frontpageadvantage.com	115	£	www.therugbypaper.co.uk
906	12595	1	sam.b@frontpageadvantage.com	1709718918993	46	t	liverpoolway.co.uk	kenditoys.com@gmail.com	1745923538797	David warner 	Inbound	f	james.p@frontpageadvantage.com	142	£	https://www.liverpoolway.co.uk/
337	12599	1	historical	0	25	t	thepennypincher.co.uk	howdy@thepennypincher.co.uk	1745923750444	Al Baker	Fatjoe	f	james.p@frontpageadvantage.com	40	£	www.thepennypincher.co.uk
1534	12586	1	frontpage.ga@gmail.com	1744280863821	37	t	dreamchaserhub.com	support@extremebacklink.com 	1745923336368	Dream Chaser Hub 	inboud	f	james.p@frontpageadvantage.com	40	£	dreamchaserhub.com
387	12588	1	historical	0	29	t	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	1745923519025	Anna marikar	Inbound email	f	james.p@frontpageadvantage.com	150	£	Onyourjourney.co.uk
1409	12597	1	frontpage.ga@gmail.com	1730296845823	40	t	britishicehockey.co.uk	arianne@timewomenflag.com	1745923543818	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	134	£	britishicehockey.co.uk
339	12587	1	historical	0	26	t	keralpatel.com	keralpatel@gmail.com	1745923515928	Keral Patel	Fatjoe	f	james.p@frontpageadvantage.com	35	£	https://www.keralpatel.com
393	12589	1	historical	0	63	t	reallymissingsleep.com	kareneholloway@hotmail.com	1745923521303	Karen Langridge	Inbound email	f	james.p@frontpageadvantage.com	150	£	https://www.reallymissingsleep.com/
427	12590	1	historical	0	16	t	shalliespurplebeehive.com	Shalliespurplebeehive@gmail.com	1745923524492	Shallie	Facebook	f	james.p@frontpageadvantage.com	75	£	Shalliespurplebeehive.com
852	12591	1	sam.b@frontpageadvantage.com	1709645596330	37	t	golfnews.co.uk	kenditoys.com@gmail.com	1745923529030	David warner	Outbound	f	james.p@frontpageadvantage.com	125	£	https://golfnews.co.uk/
508	12592	1	historical	0	32	t	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	1745923531398	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	healthylifeessex.co.uk
905	12594	1	sam.b@frontpageadvantage.com	1709718547266	50	t	luxurylifestylemag.co.uk	kenditoys.com@gmail.com	1745923536067	David warner 	Inbound	f	james.p@frontpageadvantage.com	150	£	https://www.luxurylifestylemag.co.uk/
760	12596	1	sam.b@frontpageadvantage.com	1708613844903	36	t	fiso.co.uk	falcobliek@gmail.com	1745923541086	Falco	Inbound	f	james.p@frontpageadvantage.com	130	£	https://www.fiso.co.uk/
1404	12598	1	frontpage.ga@gmail.com	1730296573812	43	t	pczone.co.uk	arianne@timewomenflag.com	1745923703562	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	114	£	pczone.co.uk
320	12600	1	historical	0	29	t	practicalfrugality.com	hello@practicalfrugality.com	1745924269632	Magdalena	Fatjoe	f	james.p@frontpageadvantage.com	38	£	www.practicalfrugality.com
332	12601	1	historical	0	30	t	autumnsmummyblog.com	laura@autumnsmummyblog.com	1745924273424	Laura Chesmer	Fatjoe	f	james.p@frontpageadvantage.com	75	£	https://www.autumnsmummyblog.com
377	12602	1	historical	0	43	t	travelvixta.com	victoria@travelvixta.com	1745924278639	Victoria	Inbound email	f	james.p@frontpageadvantage.com	170	£	https://www.travelvixta.com
391	12603	1	historical	0	40	t	conversanttraveller.com	heather@conversanttraveller.com	1745924286657	Heather	Inbound email	f	james.p@frontpageadvantage.com	180	£	www.conversanttraveller.com
395	12604	1	historical	0	25	t	missmanypennies.com	hello@missmanypennies.com	1745924291203	Hayley	Inbound email	f	james.p@frontpageadvantage.com	85	£	www.missmanypennies.com
423	12605	1	historical	0	27	t	mymoneycottage.com	hello@mymoneycottage.com	1745924299150	Clare McDougall	Facebook	f	james.p@frontpageadvantage.com	100	£	https://mymoneycottage.com
470	12606	1	historical	0	22	t	realwedding.co.uk	hello@contentmother.com	1745924301567	Becky	inbound email	f	james.p@frontpageadvantage.com	80	£	https://www.realwedding.co.uk
501	12607	1	historical	0	48	t	fashioncapital.co.uk	fazal.akbar@digitalczars.io	1745924304457	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	132	£	www.fashioncapital.co.uk
493	12608	1	historical	0	38	t	greenunion.co.uk	fazal.akbar@digitalczars.io	1745924308171	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	www.greenunion.co.uk
514	12609	1	historical	0	21	t	tobecomemum.co.uk	fazal.akbar@digitalczars.io	1745924310444	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	www.tobecomemum.co.uk
515	12610	1	historical	0	15	t	travel-bugs.co.uk	fazal.akbar@digitalczars.io	1745924314997	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	120	£	www.travel-bugs.co.uk
518	12611	1	historical	0	21	t	ukcaravanrental.co.uk	fazal.akbar@digitalczars.io	1745924317472	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	168	£	www.ukcaravanrental.co.uk
521	12612	1	historical	0	19	t	izzydabbles.co.uk	fazal.akbar@digitalczars.io	1745924319943	Fazal	Inbound Sam	f	james.p@frontpageadvantage.com	96	£	izzydabbles.co.uk
524	12613	1	historical	0	38	t	travelbeginsat40.com	backlinsprovider@gmail.com	1745924322601	David	Inbound Sam	f	james.p@frontpageadvantage.com	100	£	www.travelbeginsat40.com
526	12614	1	historical	0	46	t	puretravel.com	backlinsprovider@gmail.com	1745924325200	David	Inbound Sam	f	james.p@frontpageadvantage.com	160	£	www.puretravel.com
529	12615	1	historical	0	38	t	houseofcoco.net	backlinsprovider@gmail.com	1745924328485	David	Inbound Sam	f	james.p@frontpageadvantage.com	150	£	houseofcoco.net
1255	12616	1	frontpage.ga@gmail.com	1726784781949	27	t	katiemeehan.co.uk	hello@katiemeehan.co.uk	1745924331132	Katie Meehan	Hannah	f	james.p@frontpageadvantage.com	50	£	https://katiemeehan.co.uk/category/lifestyle/
1071	12617	1	sam.b@frontpageadvantage.com	1719318047364	31	t	makemoneywithoutajob.com	katherine@orangeoutreach.com	1745924333662	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	150	£	makemoneywithoutajob.com
1257	12618	1	frontpage.ga@gmail.com	1727080175363	40	t	vevivos.com	vickywelton@hotmail.com	1745924336605	Verily Victoria Vocalises	Hannah	f	james.p@frontpageadvantage.com	175	£	vevivos.com
342	12619	1	historical	0	36	t	karlismyunkle.com	karlismyunkle@gmail.com	1745924340021	Nik Thakkar	Fatjoe	f	james.p@frontpageadvantage.com	45	£	www.karlismyunkle.com
374	12620	1	historical	0	66	t	simslife.co.uk	sim@simslife.co.uk	1745924762311	Sim Riches	Fatjoe	f	james.p@frontpageadvantage.com	130	£	https://simslife.co.uk
318	12621	1	historical	0	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1745924957490	Tanya	Fatjoe	f	james.p@frontpageadvantage.com	150	£	luckyattitude.co.uk
1095	12622	1	sam.b@frontpageadvantage.com	1719322290354	34	f	largerfamilylife.com	katherine@orangeoutreach.com	1745924967466	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	100	£	largerfamilylife.com
349	12623	1	historical	0	24	f	icenimagazine.co.uk	vicki@icenimagazine.co.uk	1745924975093	Vicki	Fatjoe	f	james.p@frontpageadvantage.com	60	£	Icenimagazine.co.uk
338	12624	1	historical	0	20	f	themammafairy.com	themammafairy@gmail.com	1745924985719	Laura Breslin	Fatjoe	f	james.p@frontpageadvantage.com	45	£	www.themammafairy.com
340	12625	1	historical	0	33	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1745924989175	Jenny Marston	Fatjoe	f	james.p@frontpageadvantage.com	80	£	http://www.Jennyinneverland.com
361	12626	1	historical	0	57	f	alittleluxuryfor.me	erica@alittleluxuryfor.me	1745924993126	Erica Hughes	Fatjoe	f	james.p@frontpageadvantage.com	125	£	https://alittleluxuryfor.me/
365	12627	1	historical	0	40	f	letstalkmommy.com	jenny@letstalkmommy.com	1745924997519	Jenny	Fatjoe	f	james.p@frontpageadvantage.com	100	£	https://www.Letstalkmommy.com
369	12628	1	historical	0	36	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1745925001454	Mellissa Williams	Inbound email	f	james.p@frontpageadvantage.com	60	£	https://www.thediaryofajewellerylover.co.uk/
375	12630	1	historical	0	23	f	clairemac.co.uk	clairemacblog@gmail.com	1745925012301	Claire Chircop	Inbound email	f	james.p@frontpageadvantage.com	60	£	www.clairemac.co.uk
390	12633	1	historical	0	31	f	bay-bee.co.uk	Stephi@bay-bee.co.uk	1745925027740	Steph Moore	Inbound email	f	james.p@frontpageadvantage.com	115	£	https://blog.bay-bee.co.uk/
415	12637	1	historical	0	30	f	aaublog.com	rebecca@aaublog.com	1745925056564	Rebecca Urie	Facebook	f	james.p@frontpageadvantage.com	35	£	https://www.AAUBlog.com
425	12639	1	historical	0	31	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1745925065577	Jess Howliston	Facebook	f	james.p@frontpageadvantage.com	75	£	www.tantrumstosmiles.co.uk
426	12640	1	historical	0	37	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1745925069089	Kara Guppy	Facebook	f	james.p@frontpageadvantage.com	75	£	https://www.chelseamamma.co.uk/
481	12643	1	historical	0	33	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1745925097358	Emily	another blogger	f	james.p@frontpageadvantage.com	75	£	https://www.twinmummyanddaddy.com/
532	12644	1	historical	0	65	f	varsity.co.uk	backlinsprovider@gmail.com	1745925100532	David	Inbound Sam	f	james.p@frontpageadvantage.com	150	£	www.varsity.co.uk
322	12645	1	historical	0	31	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1745925105493	David	Fatjoe	f	james.p@frontpageadvantage.com	45	£	5thingstodotoday.com
331	12648	1	historical	0	31	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1745925117925	Angela Riches	Fatjoe	f	james.p@frontpageadvantage.com	40	£	www.hnmagazine.co.uk
1086	12650	1	sam.b@frontpageadvantage.com	1719320331730	41	f	lovebelfast.co.uk	katherine@orangeoutreach.com	1745925126417	Katherine Williams	Inbound	f	james.p@frontpageadvantage.com	120	£	lovebelfast.co.uk
316	12651	1	historical	0	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1745925136577	Karl	Fatjoe	f	james.p@frontpageadvantage.com	50	£	www.newvalleynews.co.uk
1256	12653	1	frontpage.ga@gmail.com	1726827443560	35	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1745925143261	The Everyday Man	Hannah	f	james.p@frontpageadvantage.com	150	£	https://theeverydayman.co.uk/
527	12654	1	historical	0	58	f	ourculturemag.com	info@ourculturemag.com	1745925147181	Info	Inbound Sam	f	james.p@frontpageadvantage.com	115	£	ourculturemag.com
1089	12656	1	sam.b@frontpageadvantage.com	1719320544130	35	f	crummymummy.co.uk	crummymummy@live.co.uk	1745925158105	Natalie	James	f	james.p@frontpageadvantage.com	60	£	crummymummy.co.uk
373	12629	1	historical	0	32	f	kateonthinice.com	kateonthinice1@gmail.com	1745925007497	Kate Holmes	Inbound email	f	james.p@frontpageadvantage.com	75	£	kateonthinice.com
386	12632	1	historical	0	52	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	1745925021805	Anna marikar	Inbound email	f	james.p@frontpageadvantage.com	150	£	Intheplayroom.co.uk
397	12634	1	historical	0	59	f	emmaplusthree.com	emmaplusthree@gmail.com	1745925032381	Emma Easton	Inbound email	f	james.p@frontpageadvantage.com	100	£	www.emmaplusthree.com
407	12635	1	historical	0	23	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1745925040527	Rachael Sheehan	Inbound email	f	james.p@frontpageadvantage.com	50	£	https://lukeosaurusandme.co.uk
409	12636	1	historical	0	33	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1745925052532	Debz	Facebook	f	james.p@frontpageadvantage.com	75	£	www.wannabeprincess.co.uk
416	12638	1	historical	0	32	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1745925060724	Micaela	Facebook	f	james.p@frontpageadvantage.com	75	£	https://www.stylishlondonliving.co.uk/
434	12641	1	historical	0	21	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1745925073715	Kara Guppy	Facebook	f	james.p@frontpageadvantage.com	75	£	https://arewenearlythereyet.co.uk/
392	12647	1	historical	0	45	f	midlandstraveller.com	contact@midlandstraveller.com	1745925114742	Simone Ribeiro	Inbound email	f	james.p@frontpageadvantage.com	50	£	www.midlandstraveller.com
441	12649	1	historical	0	78	f	newsbreak.com	minalkh124@gmail.com	1745925121465	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	55	£	original.newsbreak.com
328	12652	1	historical	0	22	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1745925140038	Emma	Fatjoe	f	james.p@frontpageadvantage.com	70	£	www.beemoneysavvy.com
382	12631	1	historical	0	29	f	stressedmum.co.uk	sam@stressedmum.co.uk	1745925016846	Samantha Donnelly	Inbound email	f	james.p@frontpageadvantage.com	80	£	https://stressedmum.co.uk
452	12642	1	historical	0	66	f	bignewsnetwork.com	minalkh124@gmail.com	1745925093062	Maryam bibi	Inbound email	f	james.p@frontpageadvantage.com	100	£	bignewsnetwork.com
483	12646	1	historical	0	31	f	packthepjs.com	tracey@packthepjs.com	1745925109621	Tracey	Fatjoe	f	james.p@frontpageadvantage.com	80	£	http://www.packthepjs.com/
525	12655	1	historical	0	59	f	traveldailynews.com	backlinsprovider@gmail.com	1745925154271	David	Inbound Sam	f	james.p@frontpageadvantage.com	91	£	www.traveldailynews.com
357	12657	1	historical	0	57	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	1745925162329	Becky Freeman	Fatjoe	f	james.p@frontpageadvantage.com	50	£	www.spiritedpuddlejumper.com
312	12658	1	historical	0	31	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1745925166596	Abbie	Fatjoe	f	james.p@frontpageadvantage.com	165	£	mmbmagazine.co.uk
418	12659	1	historical	0	37	f	amumreviews.co.uk	contact@amumreviews.co.uk	1745925172714	Petra	Facebook	f	james.p@frontpageadvantage.com	100	£	https://amumreviews.co.uk/
1090	12667	1	sam.b@frontpageadvantage.com	1719320639079	70	f	markmeets.com	katherine@orangeoutreach.com	1746068401437	Katherine Williams	Inbound	f	system	100	£	markmeets.com
324	12668	1	historical	0	13	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1746068414208	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1069	12669	1	sam.b@frontpageadvantage.com	1719317784130	32	f	caranalytics.co.uk	katherine@orangeoutreach.com	1746068415523	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1154	12670	1	james.p@frontpageadvantage.com	1723728287666	33	f	fabcelebbio.com	support@linksposting.com	1746068418457	Links Posting	James	f	system	40	$	https://fabcelebbio.com/
1057	12671	1	michael.l@frontpageadvantage.com	1716452525532	49	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	1746068419097	Elaine Wilson 	Outbound Facebook	f	system	150	£	https://eccentricengland.co.uk/
1427	12672	1	frontpage.ga@gmail.com	1730297857266	28	f	shelllouise.co.uk	arianne@timewomenflag.com	1746068420457	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
1087	12673	1	sam.b@frontpageadvantage.com	1719320401710	49	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1746068421642	Katherine Williams	Inbound	f	system	140	£	dailybusinessgroup.co.uk
1158	12674	1	james.p@frontpageadvantage.com	1725966960853	35	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1746068422246	David	James	f	system	10	$	http://toptechsinfo.com/
1518	12675	1	frontpage.ga@gmail.com	1742852067954	30	f	guestmagazines.co.uk	megazines04@gmail.com	1746068424822	guest magazines	inbound	f	system	80	£	Guestmagazines.co.uk
959	12676	1	chris.p@frontpageadvantage.com	1711533031802	48	f	talk-business.co.uk	backlinsprovider@gmail.com	1746068430505	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
1419	12677	1	frontpage.ga@gmail.com	1730297531326	33	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	1746068439307	Arianne Volkova	inbound	f	system	106	£	familyfriendlyworking.co.uk
1204	12678	1	james.p@frontpageadvantage.com	1726564805504	37	f	ladyjaney.co.uk	Jane@ladyjaney.co.uk	1746068440967	Jane	James contact form	f	system	125	£	https://ladyjaney.co.uk/
1406	12679	1	frontpage.ga@gmail.com	1730296630124	42	f	madeinshoreditch.co.uk	arianne@timewomenflag.com	1746068441572	Arianne Volkova	inbound	f	system	158	£	madeinshoreditch.co.uk
1508	12680	1	frontpage.ga@gmail.com	1741271505305	55	f	megalithic.co.uk	andy@megalithic.co.uk	1746068442227	The Megalithic Portal	inbound	f	system	80	£	megalithic.co.uk
305	12681	1	historical	0	18	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1746068449753	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
311	12682	1	historical	0	18	f	alifeoflovely.com	alifeoflovely@gmail.com	1746068450420	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
406	12683	1	historical	0	27	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1746068455803	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
408	12684	1	historical	0	20	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1746068457775	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
389	12685	1	historical	0	30	f	arthurwears.com	Arthurwears.email@gmail.com	1746068458462	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
375	12686	1	historical	0	24	f	clairemac.co.uk	clairemacblog@gmail.com	1746068460383	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
460	12687	1	historical	0	26	f	techacrobat.com	minalkh124@gmail.com	1746068465104	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
415	12688	1	historical	0	31	f	aaublog.com	rebecca@aaublog.com	1746068465775	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
416	12689	1	historical	0	31	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1746068466502	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
481	12690	1	historical	0	32	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1746068472162	Emily	another blogger	f	system	75	£	https://www.twinmummyanddaddy.com/
409	12691	1	historical	0	34	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1746068475468	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
1086	12692	1	sam.b@frontpageadvantage.com	1719320331730	42	f	lovebelfast.co.uk	katherine@orangeoutreach.com	1746068476500	Katherine Williams	Inbound	f	system	120	£	lovebelfast.co.uk
303	12693	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1746068478995	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
1504	12694	1	frontpage.ga@gmail.com	1741270738337	27	f	infinityelse.co.uk	 infinityelse1@gmail.com	1746068479971	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
422	12695	1	historical	0	33	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1746068483039	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
780	12696	1	chris.p@frontpageadvantage.com	1709033136922	21	f	travelistia.com	travelistiausa@gmail.com	1746068494026	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1515	12697	1	frontpage.ga@gmail.com	1742851725672	36	f	ranyy.com	aishwaryagaikwad313@gmail.com	1746068494877	Ranyy	inbound	f	system	80	£	ranyy.com
1531	12698	1	frontpage.ga@gmail.com	1744280420962	39	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1746068496239	Every Movie Has A Lesson	inboud	f	system	40	£	everymoviehasalesson.com
1536	12699	1	frontpage.ga@gmail.com	1744281928677	18	f	factquotes.com	support@extremebacklink.com 	1746068497558	Fact Quotes	inboud	f	system	18	£	factquotes.com
1539	12700	1	frontpage.ga@gmail.com	1744282455391	67	f	anationofmoms.com	PR@anationofmoms.com	1746068498545	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
1546	12701	1	frontpage.ga@gmail.com	1744287722025	44	f	talkssmartly.com	support@seolinkers.com	1746068499232	Talks Smartly	inboud	f	system	50	£	talkssmartly.com
340	12702	1	historical	0	32	f	jennyinneverland.com	Jenny.in.neverland@hotmail.co.Uk	1746068499905	Jenny Marston	Fatjoe	f	system	80	£	http://www.Jennyinneverland.com
434	12703	1	historical	0	22	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1746068502641	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
316	12708	1	historical	0	31	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	1746154801153	Karl	Fatjoe	f	system	50	£	www.newvalleynews.co.uk
1075	12709	1	sam.b@frontpageadvantage.com	1719318317308	39	f	tobyandroo.com	katherine@orangeoutreach.com	1746154802243	Katherine Williams	Inbound	f	system	150	£	tobyandroo.com
347	12795	1	historical	0	33	f	diydaddyblog.com	Diynige@yahoo.com	1746798592948	Nigel higgins	Fatjoe	f	james.p@frontpageadvantage.com	45	£	https://www.diydaddyblog.com/
500	12902	1	historical	0	37	f	pat.org.uk	hello@pat.org.uk	1747144967730	Fazal	Inbound Sam	f	millie.t@frontpageadvantage.com	30	£	www.pat.org.uk
500	12903	1	historical	0	37	f	pat.org.uk	hello@pat.org.uk	1747144967932	Fazal	Inbound Sam	f	millie.t@frontpageadvantage.com	30	£	www.pat.org.uk
304	13219	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1747732580564	UKNEWS Group	Inbound email	f	james.p@frontpageadvantage.com	50	£	https://www.uknewsgroup.co.uk/
1549	13365	0	millie.t@frontpageadvantage.com	1747837129945	38	f	thefestivals.uk	sam@thefestivals.uk	1747837129945	Sam	Tanya	f	\N	90	£	https://thefestivals.uk/
1549	13366	1	millie.t@frontpageadvantage.com	1747837129945	38	f	thefestivals.uk	sam@thefestivals.uk	1747837133370	Sam	Tanya	f	system	90	£	https://thefestivals.uk/
1550	13367	0	millie.t@frontpageadvantage.com	1747837279774	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	1747837279774	Matt	Tanya	f	\N	75	£	https://www.lifeunexpected.co.uk/
1550	13368	1	millie.t@frontpageadvantage.com	1747837279774	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	1747837283064	Matt	Tanya	f	system	75	£	https://www.lifeunexpected.co.uk/
1551	13369	0	millie.t@frontpageadvantage.com	1747837606638	55	f	tweakyourbiz.com	editor@tweakyourbiz.com	1747837606638	Editors	Tanya	f	\N	150	$	https://tweakyourbiz.com/
1551	13370	1	millie.t@frontpageadvantage.com	1747837606638	55	f	tweakyourbiz.com	editor@tweakyourbiz.com	1747837609800	Editors	Tanya	f	system	150	$	https://tweakyourbiz.com/
415	13380	1	historical	0	31	f	aaublog.com	allaboutublog@gmail.com	1747900965658	Rebecca Urie	Facebook	f	james.p@frontpageadvantage.com	35	£	https://www.AAUBlog.com
500	13432	1	historical	0	37	f	pat.org.uk	hello@pat.org.uk	1748443732106	Sam	Inbound Sam	f	james.p@frontpageadvantage.com	30	£	www.pat.org.uk
1532	13480	1	frontpage.ga@gmail.com	1744280534970	38	t	nameshype.com	 admin@rabbiitfirm.com	1748445192929	Names Hype 	inboud	f	james.p@frontpageadvantage.com	40	£	nameshype.com
1552	13516	0	james.p@frontpageadvantage.com	1748504396998	60	f	blackbud.co.uk	blackbuduk@gmail.com	1748504396998	Black Bud	Tanya	f	\N	60	£	https://www.blackbud.co.uk/
1552	13517	1	james.p@frontpageadvantage.com	1748504396998	60	f	blackbud.co.uk	blackbuduk@gmail.com	1748504400210	Black Bud	Tanya	f	system	60	£	https://www.blackbud.co.uk/
1055	13565	1	michael.l@frontpageadvantage.com	1716452047818	21	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1748746802046	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1089	13566	1	sam.b@frontpageadvantage.com	1719320544130	34	f	crummymummy.co.uk	crummymummy@live.co.uk	1748746806972	Natalie	James	f	system	60	£	crummymummy.co.uk
1090	13567	1	sam.b@frontpageadvantage.com	1719320639079	69	f	markmeets.com	katherine@orangeoutreach.com	1748746811717	Katherine Williams	Inbound	f	system	100	£	markmeets.com
1054	13568	1	michael.l@frontpageadvantage.com	1716451807667	28	f	flydriveexplore.com	Hello@flydrivexexplore.com	1748746815851	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1075	13569	1	sam.b@frontpageadvantage.com	1719318317308	37	f	tobyandroo.com	katherine@orangeoutreach.com	1748746818193	Katherine Williams	Inbound	f	system	150	£	tobyandroo.com
1520	13570	1	frontpage.ga@gmail.com	1742852390702	33	f	exclusivetoday.co.uk	onikawallerson.ot@gmail.com	1748746821350	Exclusive Today	inboud	f	system	80	£	exclusivetoday.co.uk
1427	13571	1	frontpage.ga@gmail.com	1730297857266	27	f	shelllouise.co.uk	arianne@timewomenflag.com	1748746823293	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
1087	13572	1	sam.b@frontpageadvantage.com	1719320401710	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	1748746823745	Katherine Williams	Inbound	f	system	140	£	dailybusinessgroup.co.uk
1518	13573	1	frontpage.ga@gmail.com	1742852067954	31	f	guestmagazines.co.uk	megazines04@gmail.com	1748746824875	guest magazines	inbound	f	system	80	£	Guestmagazines.co.uk
489	13574	1	historical	0	71	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1748746831324	Claire James	Inbound Sam	f	system	60	£	www.abcmoney.co.uk
1159	13575	1	james.p@frontpageadvantage.com	1726057994078	43	f	thistradinglife.com	sofiakahn06@gmail.com	1748746833452	Sofia	James	f	system	35	$	thistradinglife.com
1058	13576	1	michael.l@frontpageadvantage.com	1716452780180	59	f	mybalancingact.co.uk	rowena@mybalancingact.co.uk	1748746841497	Rowena Becker	Outbound Facebook	f	system	175	£	https://mybalancingact.co.uk/
331	13577	1	historical	0	32	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1748746844456	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
312	13578	1	historical	0	30	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1748746845151	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
305	13579	1	historical	0	21	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1748746845673	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
382	13580	1	historical	0	30	f	stressedmum.co.uk	sam@stressedmum.co.uk	1748746851231	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
406	13581	1	historical	0	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1748746853321	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
331	15482	1	historical	0	31	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1754017247598	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
408	13582	1	historical	0	21	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	1748746853843	Michelle O’Connor	Inbound email	f	system	75	£	Https://www.the-willowtree.com
375	13583	1	historical	0	28	f	clairemac.co.uk	clairemacblog@gmail.com	1748746854937	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
1428	13584	1	frontpage.ga@gmail.com	1730297891567	30	f	feast-magazine.co.uk	arianne@timewomenflag.com	1748746856776	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
460	13585	1	historical	0	27	f	techacrobat.com	minalkh124@gmail.com	1748746859874	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
1166	13586	1	james.p@frontpageadvantage.com	1726063406379	41	f	costumeplayhub.com	sofiakahn06@gmail.com	1748746860396	Sofia	James	f	system	30	$	costumeplayhub.com
481	13587	1	historical	0	33	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1748746863674	Emily	another blogger	f	system	75	£	https://www.twinmummyanddaddy.com/
384	13588	1	historical	0	36	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	1748746869206	Jeni	Inbound email	f	system	150	£	Https://chillingwithlucas.com
1059	13589	1	michael.l@frontpageadvantage.com	1716452853668	27	f	flashpackingfamily.com	flashpackingfamily@gmail.com	1748746873317	Jacquie Hale	Outbound Facebook	f	system	150	£	https://flashpackingfamily.com/
1517	13590	1	frontpage.ga@gmail.com	1742852009295	61	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1748746877646	UK Journal	inbound	f	system	80	£	ukjournal.co.uk
426	13591	1	historical	0	36	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1748746881820	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
780	13592	1	chris.p@frontpageadvantage.com	1709033136922	23	f	travelistia.com	travelistiausa@gmail.com	1748746882466	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1531	13593	1	frontpage.ga@gmail.com	1744280420962	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1748746883778	Every Movie Has A Lesson	inboud	f	system	40	£	everymoviehasalesson.com
1536	13594	1	frontpage.ga@gmail.com	1744281928677	19	f	factquotes.com	support@extremebacklink.com 	1748746884789	Fact Quotes	inboud	f	system	18	£	factquotes.com
1504	13595	1	frontpage.ga@gmail.com	1741270738337	28	f	infinityelse.co.uk	 infinityelse1@gmail.com	1748746888096	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
434	13596	1	historical	0	20	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1748746889201	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
1417	13597	1	frontpage.ga@gmail.com	1730297448496	33	f	journaloftradingstandards.co.uk	arianne@timewomenflag.com	1748833201951	Arianne Volkova	inbound	f	system	103	£	journaloftradingstandards.co.uk
1552	13632	1	james.p@frontpageadvantage.com	1748504396998	60	t	blackbud.co.uk	blackbuduk@gmail.com	1748950834065	Black Bud	Tanya	f	millie.t@frontpageadvantage.com	60	£	https://www.blackbud.co.uk/
1553	13658	0	millie.t@frontpageadvantage.com	1749110988493	27	f	thecoachspace.com	gabrielle@thecoachspace.com	1749110988493	Gabrielle	Tanya	f	\N	82	£	https://thecoachspace.com/
1553	13659	1	millie.t@frontpageadvantage.com	1749110988493	27	f	thecoachspace.com	gabrielle@thecoachspace.com	1749110991521	Gabrielle	Tanya	f	system	82	£	https://thecoachspace.com/
1554	13661	0	james.p@frontpageadvantage.com	1749112026452	54	f	ukfitness.pro	hello@ukfitness.pro	1749112026452	UK fitness pro	Tanya	f	\N	100	£	https://ukfitness.pro/write-for-us
1554	13662	1	james.p@frontpageadvantage.com	1749112026452	54	f	ukfitness.pro	hello@ukfitness.pro	1749112029548	UK fitness pro	Tanya	f	system	100	£	https://ukfitness.pro/write-for-us
1555	13681	0	millie.t@frontpageadvantage.com	1749116001624	0	f	\N	\N	1749116001624	https://www.clickintelligence.co.uk/	\N	t	\N	0	\N	\N
1555	13682	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1551	13690	1	millie.t@frontpageadvantage.com	1747837606638	55	t	tweakyourbiz.com	editor@tweakyourbiz.com	1749117436084	Editors	Tanya	f	james.p@frontpageadvantage.com	150	$	https://tweakyourbiz.com/
1550	13691	1	millie.t@frontpageadvantage.com	1747837279774	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	1749117485063	Matt	Tanya	f	james.p@frontpageadvantage.com	75	£	https://www.lifeunexpected.co.uk/
1505	13727	1	frontpage.ga@gmail.com	1741270951520	38	t	pixwox.co.uk	 pixwoxx@gmail.com	1749133683619	Pixwox	inbound	f	james.p@frontpageadvantage.com	75	£	pixwox.co.uk
1507	13733	1	frontpage.ga@gmail.com	1741271187248	40	t	interview-coach.co.uk	margaret@interview-coach.co.uk	1749133907234	MargaretBUJ	inbound	f	james.p@frontpageadvantage.com	75	£	interview-coach.co.uk
1417	13734	1	frontpage.ga@gmail.com	1730297448496	33	t	journaloftradingstandards.co.uk	arianne@timewomenflag.com	1749133969274	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	103	£	journaloftradingstandards.co.uk
1203	13738	1	james.p@frontpageadvantage.com	1726241391467	36	t	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	1749134022625	Fiona	James	f	james.p@frontpageadvantage.com	70	£	http://www.dollydowsie.com/
1162	13755	1	james.p@frontpageadvantage.com	1726058412889	72	t	cyprus-mail.com	sofiakahn06@gmail.com	1749198071570	Sofia	James	f	chris.p@frontpageadvantage.com	270	$	cyprus-mail.com
1538	13756	1	frontpage.ga@gmail.com	1744282332763	86	f	theodysseyonline.com	roy@theodysseyonline.com Create with us	1749198328984	Odyssey	inboud	f	james.p@frontpageadvantage.com	50	£	theodysseyonline.com
1161	13757	1	james.p@frontpageadvantage.com	1726058268387	76	f	oddee.com	sofiakahn06@gmail.com	1749198341471	Sofia	James	f	james.p@frontpageadvantage.com	150	$	oddee.com
1508	13758	1	frontpage.ga@gmail.com	1741271505305	55	f	megalithic.co.uk	andy@megalithic.co.uk	1749198362568	The Megalithic Portal	inbound	f	james.p@frontpageadvantage.com	80	£	megalithic.co.uk
1406	13759	1	frontpage.ga@gmail.com	1730296630124	42	t	madeinshoreditch.co.uk	arianne@timewomenflag.com	1749198378959	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	158	£	madeinshoreditch.co.uk
1506	13760	1	frontpage.ga@gmail.com	1741271054422	51	f	techktimes.co.uk	Techktimes.official@gmail.com	1749198395339	Teck k times	inbound	f	james.p@frontpageadvantage.com	75	£	techktimes.co.uk
1403	13761	1	frontpage.ga@gmail.com	1730296526142	51	t	aboutmanchester.co.uk	arianne@timewomenflag.com	1749198404369	Arianne Volkova	inbound	f	james.p@frontpageadvantage.com	146	£	aboutmanchester.co.uk
959	13762	1	chris.p@frontpageadvantage.com	1711533031802	48	f	talk-business.co.uk	backlinsprovider@gmail.com	1749198763360	David Smith	Inbound	f	james.p@frontpageadvantage.com	115	£	https://www.talk-business.co.uk/
1556	13763	0	james.p@frontpageadvantage.com	1749199373428	65	f	placeholder.com	millie.t@frontpageadvantage.com	1749199373428	placeholder	James	f	\N	100	£	placeholder.com
1556	13764	1	james.p@frontpageadvantage.com	1749199373428	65	f	placeholder.com	millie.t@frontpageadvantage.com	1749199376315	placeholder	James	f	system	100	£	placeholder.com
1602	14441	0	millie.t@frontpageadvantage.com	1750841059853	46	f	slummysinglemummy.com	jo@slummysinglemummy.com	1750841059853	Jo  	Millie	f	\N	100	£	https://slummysinglemummy.com/
1602	14442	1	millie.t@frontpageadvantage.com	1750841059853	46	f	slummysinglemummy.com	jo@slummysinglemummy.com	1750841063560	Jo  	Millie	f	system	100	£	https://slummysinglemummy.com/
1602	14510	1	millie.t@frontpageadvantage.com	1750841059853	46	f	slummysinglemummy.com	jo@slummysinglemummy.com	1750864077674	Jo  	Millie	f	millie.t@frontpageadvantage.com	100	£	https://slummysinglemummy.com/
1556	14514	1	james.p@frontpageadvantage.com	1749199373428	65	t	placeholder.com	millie.t@frontpageadvantage.com	1750864554900	placeholder	James	f	millie.t@frontpageadvantage.com	100	£	placeholder.com
1603	14589	0	millie.t@frontpageadvantage.com	1751012371517	43	f	uknip.co.uk	uknewsinpictures@gmail.com	1751012371517	UKnip		f	\N	90	£	https://uknip.co.uk/
1603	14590	1	millie.t@frontpageadvantage.com	1751012371517	43	f	uknip.co.uk	uknewsinpictures@gmail.com	1751012374456	UKnip		f	system	90	£	https://uknip.co.uk/
1425	14689	1	frontpage.ga@gmail.com	1730297780739	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	1751338801369	Arianne Volkova	inbound	f	system	106	£	lobsterdigitalmarketing.co.uk
483	14690	1	historical	0	30	f	packthepjs.com	tracey@packthepjs.com	1751338806740	Tracey	Fatjoe	f	system	80	£	http://www.packthepjs.com/
1092	14691	1	sam.b@frontpageadvantage.com	1719320789605	41	f	fabukmagazine.com	katherine@orangeoutreach.com	1751338815399	Katherine Williams	Inbound	f	system	120	£	fabukmagazine.com
1074	14692	1	sam.b@frontpageadvantage.com	1719318261939	38	f	fivelittledoves.com	katherine@orangeoutreach.com	1751338816814	Katherine Williams	Inbound	f	system	150	£	fivelittledoves.com
1170	14693	1	james.p@frontpageadvantage.com	1726065836927	51	f	nerdbot.com	sofiakahn06@gmail.com	1751338818020	Sofia	James	f	system	150	$	nerdbot.com
1076	14694	1	sam.b@frontpageadvantage.com	1719318364944	30	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1751338818666	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
1069	14695	1	sam.b@frontpageadvantage.com	1719317784130	33	f	caranalytics.co.uk	katherine@orangeoutreach.com	1751338819920	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1054	14696	1	michael.l@frontpageadvantage.com	1716451807667	27	f	flydriveexplore.com	Hello@flydrivexexplore.com	1751338821127	Marcus Williams 	Outbound Facebook	f	system	80	£	https://www.flydriveexplore.com/
1070	14697	1	sam.b@frontpageadvantage.com	1719317894569	20	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1751338831455	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
1056	14698	1	michael.l@frontpageadvantage.com	1716452285003	27	f	flyingfluskey.com	rosie@flyingfluskey.com	1751338832057	Rosie Fluskey 	Outbound Facebook	f	system	250	£	https://www.flyingfluskey.com
959	14699	1	chris.p@frontpageadvantage.com	1711533031802	47	f	talk-business.co.uk	backlinsprovider@gmail.com	1751338835181	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
369	14700	1	historical	0	35	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1751338837684	Mellissa Williams	Inbound email	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/
957	14701	1	chris.p@frontpageadvantage.com	1711532679719	46	f	north.wales	backlinsprovider@gmail.com	1751338842900	David Smith	Inbound	f	system	95	£	https://north.wales/
334	14702	1	historical	0	24	f	lifeloving.co.uk	sally@lifeloving.co.uk	1751338845237	Sally Allsop	Fatjoe	f	system	100	£	www.lifeloving.co.uk
312	14703	1	historical	0	31	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1751338848608	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
305	14704	1	historical	0	20	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1751338849175	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
368	14705	1	historical	0	57	f	justeilidh.com	just.eilidhg@gmail.com	1751338852391	Eilidh	Inbound email	f	system	100	£	www.justeilidh.com
389	14706	1	historical	0	29	f	arthurwears.com	Arthurwears.email@gmail.com	1751338858860	Sarah	Inbound email	f	system	250	£	Https://www.arthurwears.com
453	14707	1	historical	0	71	f	techbullion.com	angelascottbriggs@techbullion.com	1751338860698	Angela Scott-Briggs 	Inbound email	f	system	100	£	http://techbullion.com
416	14708	1	historical	0	32	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1751338862142	Micaela	Facebook	f	system	75	£	https://www.stylishlondonliving.co.uk/
415	14709	1	historical	0	32	f	aaublog.com	allaboutublog@gmail.com	1751338863017	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
1428	14710	1	frontpage.ga@gmail.com	1730297891567	32	f	feast-magazine.co.uk	arianne@timewomenflag.com	1751338864925	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
502	14711	1	historical	0	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1751338866879	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
1166	14712	1	james.p@frontpageadvantage.com	1726063406379	40	f	costumeplayhub.com	sofiakahn06@gmail.com	1751338869347	Sofia	James	f	system	30	$	costumeplayhub.com
1168	14713	1	james.p@frontpageadvantage.com	1726065344402	37	f	birdzpedia.com	sofiakahn06@gmail.com	1751338870485	Sofia	James	f	system	35	$	birdzpedia.com
407	14714	1	historical	0	24	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1751338877743	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
322	14715	1	historical	0	32	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1751338878499	David	Fatjoe	f	system	45	£	5thingstodotoday.com
303	14716	1	historical	0	20	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1751338880087	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
1539	14717	1	frontpage.ga@gmail.com	1744282455391	66	f	anationofmoms.com	PR@anationofmoms.com	1751338887822	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
304	14718	1	historical	0	34	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1751338889344	UKNEWS Group	Inbound email	f	system	50	£	https://www.uknewsgroup.co.uk/
422	14719	1	historical	0	34	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1751338895977	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
1504	14720	1	frontpage.ga@gmail.com	1741270738337	27	f	infinityelse.co.uk	 infinityelse1@gmail.com	1751338896535	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
328	14732	1	historical	0	21	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1751425203728	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1604	14736	0	millie.t@frontpageadvantage.com	1751885774816	40	f	business-money.com	info@business-money.com	1751885774816	BusinessMoneyTeam	Tanya	f	\N	30	£	https://www.business-money.com/
1604	14737	1	millie.t@frontpageadvantage.com	1751885774816	40	f	business-money.com	info@business-money.com	1751885777802	BusinessMoneyTeam	Tanya	f	system	30	£	https://www.business-money.com/
1605	14740	0	millie.t@frontpageadvantage.com	1751886706863	13	f	tibbingtonconsulting.co.uk	info@globelldigital.com	1751886706863	Tibbington Consulting	Tanya	f	\N	25	£	https://www.tibbingtonconsulting.co.uk/
1605	14741	1	millie.t@frontpageadvantage.com	1751886706863	13	f	tibbingtonconsulting.co.uk	info@globelldigital.com	1751886709789	Tibbington Consulting	Tanya	f	system	25	£	https://www.tibbingtonconsulting.co.uk/
1606	14840	0	millie.t@frontpageadvantage.com	1751973800624	23	f	indowapblog.com	contactsiteseo@gmail.com	1751973800624	French Blogger	contactsiteseo@gmail.com	f	\N	25	€	https://indowapblog.com/
1606	14841	1	millie.t@frontpageadvantage.com	1751973800624	23	f	indowapblog.com	contactsiteseo@gmail.com	1751973803623	French Blogger	contactsiteseo@gmail.com	f	system	25	€	https://indowapblog.com/
1607	15099	0	millie.t@frontpageadvantage.com	1752138697761	0	f	\N	\N	1752138697761	Click intelligence	\N	t	\N	0	\N	\N
1608	15101	0	millie.t@frontpageadvantage.com	1752139005960	0	f	\N	\N	1752139005960	Click Intelligence	\N	t	\N	0	\N	\N
1609	15103	0	millie.t@frontpageadvantage.com	1752139047012	0	f	\N	\N	1752139047012	Click Intelligence	\N	t	\N	0	\N	\N
1610	15106	0	millie.t@frontpageadvantage.com	1752139070886	0	f	\N	\N	1752139070886	Click Intelligence	\N	t	\N	0	\N	\N
1611	15108	0	millie.t@frontpageadvantage.com	1752139081370	0	f	\N	\N	1752139081370	Click intelligence	\N	t	\N	0	\N	\N
416	15238	1	historical	0	32	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1752234283528	Micaela	Facebook	f	millie.t@frontpageadvantage.com	100	£	https://www.stylishlondonliving.co.uk/
1608	15304	1	millie.t@frontpageadvantage.com	1752139005960	24	f	elevatedmagazines.com	\N	1752741913553	Click Intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.elevatedmagazines.com
1607	15307	1	millie.t@frontpageadvantage.com	1752138697761	23	f	homeandgardenlistings.co.uk	\N	1752742009408	Click intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.homeandgardenlistings.co.uk
1609	15310	1	millie.t@frontpageadvantage.com	1752139047012	40	f	voucherix.co.uk	\N	1752742152434	Click Intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.voucherix.co.uk
1611	15317	1	millie.t@frontpageadvantage.com	1752139081370	39	f	primmart.com	\N	1752743306163	Click intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://primmart.com
1607	15320	1	millie.t@frontpageadvantage.com	1752138697761	0	f	\N	\N	1752743327522	Click intelligence	\N	t	millie.t@frontpageadvantage.com	0	\N	\N
1607	15322	1	millie.t@frontpageadvantage.com	1752138697761	70	f	homeandgardenlistings.co.uk	\N	1752743400626	Click intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.homeandgardenlistings.co.uk
1608	15325	1	millie.t@frontpageadvantage.com	1752139005960	0	f	\N	\N	1752743436838	Click Intelligence	\N	t	millie.t@frontpageadvantage.com	0	\N	\N
1608	15327	1	millie.t@frontpageadvantage.com	1752139005960	48	f	elevatedmagazines.com	\N	1752743511931	Click Intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.elevatedmagazines.com
1610	15330	1	millie.t@frontpageadvantage.com	1752139070886	33	f	myuniquehome.co.uk	\N	1752743736848	Click Intelligence	\N	t	millie.t@frontpageadvantage.com	80	£	https://www.myuniquehome.co.uk
1055	15463	1	michael.l@frontpageadvantage.com	1716452047818	20	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1754017201517	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1090	15464	1	sam.b@frontpageadvantage.com	1719320639079	70	f	markmeets.com	katherine@orangeoutreach.com	1754017204165	Katherine Williams	Inbound	f	system	100	£	markmeets.com
652	15465	1	chris.p@frontpageadvantage.com	0	30	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	1754017211069	Gemma	inbound email	f	system	80	£	https://gemmalouise.co.uk/
1170	15466	1	james.p@frontpageadvantage.com	1726065836927	50	f	nerdbot.com	sofiakahn06@gmail.com	1754017219144	Sofia	James	f	system	150	$	nerdbot.com
1069	15467	1	sam.b@frontpageadvantage.com	1719317784130	32	f	caranalytics.co.uk	katherine@orangeoutreach.com	1754017219912	Katherine Williams	Inbound	f	system	150	£	caranalytics.co.uk
1416	15468	1	frontpage.ga@gmail.com	1730297416645	33	f	smallcapnews.co.uk	arianne@timewomenflag.com	1754017221567	Arianne Volkova	inbound	f	system	158	£	Smallcapnews.co.uk
1523	15469	1	frontpage.ga@gmail.com	1742853030124	35	f	ventstimes.co.uk	ventstimesofficial@gmail.com	1754017223788	Vents Times	inboud	f	system	80	£	Ventstimes.co.uk
1158	15470	1	james.p@frontpageadvantage.com	1725966960853	34	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1754017225739	David	James	f	system	10	$	http://toptechsinfo.com/
1518	15471	1	frontpage.ga@gmail.com	1742852067954	30	f	guestmagazines.co.uk	megazines04@gmail.com	1754017226855	guest magazines	inbound	f	system	80	£	Guestmagazines.co.uk
1060	15472	1	michael.l@frontpageadvantage.com	1716452913891	44	f	safarisafricana.com	jacquiehale75@gmail.com	1754017230377	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
1070	15473	1	sam.b@frontpageadvantage.com	1719317894569	21	f	theautoexperts.co.uk	katherine@orangeoutreach.com	1754017231372	Katherine Williams	Inbound	f	system	125	£	theautoexperts.co.uk
777	15474	1	chris.p@frontpageadvantage.com	1709032527056	28	f	yourpetplanet.com	info@yourpetplanet.com	1754017233615	Your Pet Planet	inbound	f	system	42	£	https://yourpetplanet.com/
369	15475	1	historical	0	36	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	1754017234190	Mellissa Williams	Inbound email	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/
489	15476	1	historical	0	70	f	abcmoney.co.uk	advertise@abcmoney.co.uk	1754017236080	Claire James	Inbound Sam	f	system	60	£	www.abcmoney.co.uk
1408	15477	1	frontpage.ga@gmail.com	1730296799161	38	f	fionaoutdoors.co.uk	arianne@timewomenflag.com	1754017240324	Arianne Volkova	inbound	f	system	134	£	fionaoutdoors.co.uk
326	15478	1	historical	0	19	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1754017243437	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
318	15479	1	historical	0	38	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1754017244635	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
338	15480	1	historical	0	19	f	themammafairy.com	themammafairy@gmail.com	1754017245787	Laura Breslin	Fatjoe	f	system	45	£	www.themammafairy.com
311	15481	1	historical	0	17	f	alifeoflovely.com	alifeoflovely@gmail.com	1754017246336	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
334	15483	1	historical	0	23	f	lifeloving.co.uk	sally@lifeloving.co.uk	1754017248272	Sally Allsop	Fatjoe	f	system	100	£	www.lifeloving.co.uk
380	15484	1	historical	0	62	f	captainbobcat.com	Eva@captainbobcat.com	1754017250700	Eva Katona	Inbound email	f	system	180	£	Https://www.captainbobcat.com
347	15485	1	historical	0	34	f	diydaddyblog.com	Diynige@yahoo.com	1754017255306	Nigel higgins	Fatjoe	f	system	45	£	https://www.diydaddyblog.com/
406	15486	1	historical	0	27	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1754017255792	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
375	15487	1	historical	0	27	f	clairemac.co.uk	clairemacblog@gmail.com	1754017258541	Claire Chircop	Inbound email	f	system	60	£	www.clairemac.co.uk
368	15488	1	historical	0	56	f	justeilidh.com	just.eilidhg@gmail.com	1754017259138	Eilidh	Inbound email	f	system	100	£	www.justeilidh.com
415	15489	1	historical	0	31	f	aaublog.com	allaboutublog@gmail.com	1754017262711	Rebecca Urie	Facebook	f	system	35	£	https://www.AAUBlog.com
1428	15490	1	frontpage.ga@gmail.com	1730297891567	30	f	feast-magazine.co.uk	arianne@timewomenflag.com	1754017263216	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
416	15491	1	historical	0	31	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1754017263804	Micaela	Facebook	f	system	100	£	https://www.stylishlondonliving.co.uk/
1083	15492	1	sam.b@frontpageadvantage.com	1719319963927	34	f	edinburgers.co.uk	katherine@orangeoutreach.com	1754017265042	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
505	15493	1	historical	0	28	f	talk-retail.co.uk	backlinsprovider@gmail.com	1754017265654	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
502	15494	1	historical	0	31	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1754017267329	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
1166	15495	1	james.p@frontpageadvantage.com	1726063406379	41	f	costumeplayhub.com	sofiakahn06@gmail.com	1754017267967	Sofia	James	f	system	30	$	costumeplayhub.com
1168	15496	1	james.p@frontpageadvantage.com	1726065344402	36	f	birdzpedia.com	sofiakahn06@gmail.com	1754017269626	Sofia	James	f	system	35	$	birdzpedia.com
409	15497	1	historical	0	33	f	wannabeprincess.co.uk	Debzjs@hotmail.com	1754017271673	Debz	Facebook	f	system	75	£	www.wannabeprincess.co.uk
1414	15498	1	frontpage.ga@gmail.com	1730297056465	37	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	1754017272442	Arianne Volkova	inbound	f	system	118	£	singleparentsonholiday.co.uk
407	15499	1	historical	0	23	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	1754017276388	Rachael Sheehan	Inbound email	f	system	50	£	https://lukeosaurusandme.co.uk
330	15500	1	historical	0	37	f	robinwaite.com	robin@robinwaite.com	1754017280616	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
1539	15501	1	frontpage.ga@gmail.com	1744282455391	67	f	anationofmoms.com	PR@anationofmoms.com	1754017281241	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
1511	15502	1	frontpage.ga@gmail.com	1742851051403	34	f	msnpro.co.uk	ankit@zestfulloutreach.com	1754017282004	MSN PRO	inbound	f	system	80	£	https://msnpro.co.uk/contact-us/
1521	15503	1	frontpage.ga@gmail.com	1742852543019	36	f	grobuzz.co.uk	editorial@rankwc.com	1754017283918	GROBUZZ	inboud	f	system	80	£	grobuzz.co.uk
1522	15504	1	frontpage.ga@gmail.com	1742852661569	35	f	techimaging.co.uk	contact@techimaging.co.uk	1754017284520	Tech Imaging	inboud	f	system	80	£	techimaging.co.uk
1515	15505	1	frontpage.ga@gmail.com	1742851725672	39	f	ranyy.com	aishwaryagaikwad313@gmail.com	1754017287290	Ranyy	inbound	f	system	80	£	ranyy.com
1546	15506	1	frontpage.ga@gmail.com	1744287722025	45	f	talkssmartly.com	support@seolinkers.com	1754017287853	Talks Smartly	inboud	f	system	50	£	talkssmartly.com
1504	15507	1	frontpage.ga@gmail.com	1741270738337	25	f	infinityelse.co.uk	 infinityelse1@gmail.com	1754017293009	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
780	15508	1	chris.p@frontpageadvantage.com	1709033136922	21	f	travelistia.com	travelistiausa@gmail.com	1754017295164	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1550	15509	1	millie.t@frontpageadvantage.com	1747837279774	32	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	1754017298058	Matt	Tanya	f	system	75	£	https://www.lifeunexpected.co.uk/
1254	15532	1	frontpage.ga@gmail.com	1726736911853	26	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1754103602038	Laureny Loves	Hannah	f	system	50	£	https://www.laurenyloves.co.uk/category/money/
304	15533	1	historical	0	33	f	uknewsgroup.co.uk	olly@uknewsgroup.co.uk	1754103608770	UKNEWS Group	Inbound email	f	system	50	£	https://www.uknewsgroup.co.uk/
1536	15534	1	frontpage.ga@gmail.com	1744281928677	18	f	factquotes.com	support@extremebacklink.com 	1754103611856	Fact Quotes	inboud	f	system	18	£	factquotes.com
1612	15621	0	millie.t@frontpageadvantage.com	1754379974064	41	f	hearthomemag.co.uk	advertise@mintymarketing.co.uk	1754379974064	Minty	Tanya	f	\N	100	£	https://hearthomemag.co.uk/
1612	15622	1	millie.t@frontpageadvantage.com	1754379974064	41	f	hearthomemag.co.uk	advertise@mintymarketing.co.uk	1754379977355	Minty	Tanya	f	system	100	£	https://hearthomemag.co.uk/
1613	15623	0	millie.t@frontpageadvantage.com	1754383774862	0	f	\N	\N	1754383774862	Click Intelligence	\N	t	\N	0	\N	\N
1614	15930	0	millie.t@frontpageadvantage.com	1754479907265	78	f	manilatimes.net	advertise@mintymarketing.co.uk	1754479907265	Minty	Tanya	f	\N	80	$	https://www.manilatimes.net/
1614	15931	1	millie.t@frontpageadvantage.com	1754479907265	78	f	manilatimes.net	advertise@mintymarketing.co.uk	1754479910059	Minty	Tanya	f	system	80	$	https://www.manilatimes.net/
1607	15941	1	millie.t@frontpageadvantage.com	1752138697761	70	f	homeandgardenlistings.co.uk	\N	1754486250776	Click intelligence	\N	t	chris.p@frontpageadvantage.com	150	£	https://www.homeandgardenlistings.co.uk
1615	16152	0	millie.t@frontpageadvantage.com	1754559255202	27	f	ucantwearthat.com	ucantwearthattoo@gmail.com	1754559255202	Lucia	Millie	f	\N	60	£	http://www.ucantwearthat.com/
1615	16153	1	millie.t@frontpageadvantage.com	1754559255202	27	f	ucantwearthat.com	ucantwearthattoo@gmail.com	1754559258439	Lucia	Millie	f	system	60	£	http://www.ucantwearthat.com/
1616	16154	0	millie.t@frontpageadvantage.com	1754566343999	84	f	zerohedge.com	calahlane3@gmail.com	1754566343999	Zero Hedge	Millie	f	\N	90	£	https://www.zerohedge.com/
1616	16155	1	millie.t@frontpageadvantage.com	1754566343999	84	f	zerohedge.com	calahlane3@gmail.com	1754566346960	Zero Hedge	Millie	f	system	90	£	https://www.zerohedge.com/
1617	16156	0	millie.t@frontpageadvantage.com	1754566382919	70	f	hackmd.io	calahlane3@gmail.com	1754566382919	Hack MD	Millie	f	\N	60	£	https://hackmd.io/
1617	16157	1	millie.t@frontpageadvantage.com	1754566382919	70	f	hackmd.io	calahlane3@gmail.com	1754566385579	Hack MD	Millie	f	system	60	£	https://hackmd.io/
1620	16162	0	millie.t@frontpageadvantage.com	1754566476971	38	f	thedatascientist.com	calahlane3@gmail.com	1754566476971	Thedatascientist	Millie	f	\N	120	£	https://thedatascientist.com/
1620	16163	1	millie.t@frontpageadvantage.com	1754566476971	38	f	thedatascientist.com	calahlane3@gmail.com	1754566479730	Thedatascientist	Millie	f	system	120	£	https://thedatascientist.com/
1621	16165	1	millie.t@frontpageadvantage.com	1754566514837	69	f	portotheme.com	calahlane3@gmail.com	1754566517482	Portotheme	Millie	f	system	80	£	https://www.portotheme.com/
1618	16158	0	millie.t@frontpageadvantage.com	1754566417149	64	f	coda.io	calahlane3@gmail.com	1754566417149	Coda IO	Millie	f	\N	90	£	https://coda.io/
1618	16159	1	millie.t@frontpageadvantage.com	1754566417149	64	f	coda.io	calahlane3@gmail.com	1754566420003	Coda IO	Millie	f	system	90	£	https://coda.io/
1619	16160	0	millie.t@frontpageadvantage.com	1754566452647	56	f	indibloghub.com	calahlane3@gmail.com	1754566452647	Indibloghub	Millie	f	\N	50	£	https://indibloghub.com/
1619	16161	1	millie.t@frontpageadvantage.com	1754566452647	56	f	indibloghub.com	calahlane3@gmail.com	1754566455466	Indibloghub	Millie	f	system	50	£	https://indibloghub.com/
1621	16164	0	millie.t@frontpageadvantage.com	1754566514837	69	f	portotheme.com	calahlane3@gmail.com	1754566514837	Portotheme	Millie	f	\N	80	£	https://www.portotheme.com/
1622	16166	0	millie.t@frontpageadvantage.com	1754566562692	33	f	webstosociety.co.uk	calahlane3@gmail.com	1754566562692	websstosociety	Millie	f	\N	30	£	https://webstosociety.co.uk/
1622	16167	1	millie.t@frontpageadvantage.com	1754566562692	33	f	webstosociety.co.uk	calahlane3@gmail.com	1754566565727	websstosociety	Millie	f	system	30	£	https://webstosociety.co.uk/
1623	16169	0	millie.t@frontpageadvantage.com	1754570606930	35	f	mrsshilts.co.uk	emma.shilton@outlook.com	1754570606930	Emma Shilton	Millie	f	\N	100	£	http://www.mrsshilts.co.uk/
1623	16170	1	millie.t@frontpageadvantage.com	1754570606930	35	f	mrsshilts.co.uk	emma.shilton@outlook.com	1754570609695	Emma Shilton	Millie	f	system	100	£	http://www.mrsshilts.co.uk/
1624	16190	0	millie.t@frontpageadvantage.com	1754660310525	38	f	deepinmummymatters.com	mummymatters@gmail.com	1754660310525	Sabina	Millie	f	\N	130	£	https://deepinmummymatters.com/
1624	16191	1	millie.t@frontpageadvantage.com	1754660310525	38	f	deepinmummymatters.com	mummymatters@gmail.com	1754660313941	Sabina	Millie	f	system	130	£	https://deepinmummymatters.com/
1625	16192	0	millie.t@frontpageadvantage.com	1754664916120	55	f	insequiral.com	hello@insequiral.com	1754664916120	Fiona	Millie	f	\N	100	£	http://www.insequiral.com/
1625	16193	1	millie.t@frontpageadvantage.com	1754664916120	55	f	insequiral.com	hello@insequiral.com	1754664919130	Fiona	Millie	f	system	100	£	http://www.insequiral.com/
1626	16194	0	millie.t@frontpageadvantage.com	1754665321436	60	f	lifeinabreakdown.com	sarah@lifeinabreakdown.com	1754665321436	Sarah	Millie	f	\N	250	£	https://www.lifeinabreakdown.com/
1626	16195	1	millie.t@frontpageadvantage.com	1754665321436	60	f	lifeinabreakdown.com	sarah@lifeinabreakdown.com	1754665324554	Sarah	Millie	f	system	250	£	https://www.lifeinabreakdown.com/
1627	16196	0	millie.t@frontpageadvantage.com	1754898182768	25	f	infullflavour.com	infullflavour@gmail.com	1754898182768	Sarah	Millie	f	\N	65	£	http://infullflavour.com/
1627	16197	1	millie.t@frontpageadvantage.com	1754898182768	25	f	infullflavour.com	infullflavour@gmail.com	1754898185616	Sarah	Millie	f	system	65	£	http://infullflavour.com/
1628	16382	0	millie.t@frontpageadvantage.com	1755526189848	34	f	mummyvswork.co.uk	paula@mummyvswork.co.uk	1755526189848	Paula	Millie	f	\N	150	£	https://mummyvswork.co.uk/
1628	16383	1	millie.t@frontpageadvantage.com	1755526189848	34	f	mummyvswork.co.uk	paula@mummyvswork.co.uk	1755526193177	Paula	Millie	f	system	150	£	https://mummyvswork.co.uk/
1629	16388	0	millie.t@frontpageadvantage.com	1755610853604	29	f	rhianwestbury.co.uk	westburyrhian@gmail.com	1755610853604	Rhian	Millie	f	\N	100	£	http://www.rhianwestbury.co.uk/
1629	16389	1	millie.t@frontpageadvantage.com	1755610853604	29	f	rhianwestbury.co.uk	westburyrhian@gmail.com	1755610856887	Rhian	Millie	f	system	100	£	http://www.rhianwestbury.co.uk/
1630	16390	0	millie.t@frontpageadvantage.com	1755675826171	36	f	omgflix.co.uk	calahlane3@gmail.com	1755675826171	OmgFlix	Millie	f	\N	50	£	https://www.omgflix.co.uk/author/sky-bloom-inc
1630	16391	1	millie.t@frontpageadvantage.com	1755675826171	36	f	omgflix.co.uk	calahlane3@gmail.com	1755675828961	OmgFlix	Millie	f	system	50	£	https://www.omgflix.co.uk/author/sky-bloom-inc
1631	16392	0	millie.t@frontpageadvantage.com	1755675865921	43	f	reelsmedia.co.uk	calahlane3@gmail.com	1755675865921	ReelsMedia	Millie	f	\N	50	£	http://reelsmedia.co.uk/
1631	16393	1	millie.t@frontpageadvantage.com	1755675865921	43	f	reelsmedia.co.uk	calahlane3@gmail.com	1755675868881	ReelsMedia	Millie	f	system	50	£	http://reelsmedia.co.uk/
1632	16394	0	millie.t@frontpageadvantage.com	1755675953072	32	f	imagefap.uk	calahlane3@gmail.com	1755675953072	ImageFap	Millie	f	\N	50	£	http://imagefap.uk/
1632	16395	1	millie.t@frontpageadvantage.com	1755675953072	32	f	imagefap.uk	calahlane3@gmail.com	1755675955733	ImageFap	Millie	f	system	50	£	http://imagefap.uk/
1633	16396	0	millie.t@frontpageadvantage.com	1755675994853	38	f	tubegalore.uk	calahlane3@gmail.com	1755675994853	Tube Galore	Millie	f	\N	50	£	http://tubegalore.uk/
1633	16397	1	millie.t@frontpageadvantage.com	1755675994853	38	f	tubegalore.uk	calahlane3@gmail.com	1755675997722	Tube Galore	Millie	f	system	50	£	http://tubegalore.uk/
1634	16398	0	millie.t@frontpageadvantage.com	1755676747408	21	f	thestrawberryfountain.com	thestrawberryfountain@hotmail.com	1755676747408	Terri Brown	Millie	f	\N	100	£	http://www.thestrawberryfountain.com/
1634	16399	1	millie.t@frontpageadvantage.com	1755676747408	21	f	thestrawberryfountain.com	thestrawberryfountain@hotmail.com	1755676750215	Terri Brown	Millie	f	system	100	£	http://www.thestrawberryfountain.com/
1635	16400	0	millie.t@frontpageadvantage.com	1755683084092	35	f	thefrenchiemummy.com	cecile@thefrenchiemummy.com	1755683084092	Cecile 	Millie	f	\N	107	£	https://thefrenchiemummy.com/
1635	16401	1	millie.t@frontpageadvantage.com	1755683084092	35	f	thefrenchiemummy.com	cecile@thefrenchiemummy.com	1755683087058	Cecile 	Millie	f	system	107	£	https://thefrenchiemummy.com/
1636	16404	0	millie.t@frontpageadvantage.com	1755848328859	25	f	birdsandlilies.com	birdsandlilies@gmail.com	1755848328859	Louise	Millie	f	\N	100	£	https://www.birdsandlilies.com/
1636	16405	1	millie.t@frontpageadvantage.com	1755848328859	25	f	birdsandlilies.com	birdsandlilies@gmail.com	1755848331794	Louise	Millie	f	system	100	£	https://www.birdsandlilies.com/
771	16406	1	chris.p@frontpageadvantage.com	1709027801990	44	f	finehomesandliving.com	info@fine-magazine.com	1756695602780	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
1170	16407	1	james.p@frontpageadvantage.com	1726065836927	51	f	nerdbot.com	sofiakahn06@gmail.com	1756695620614	Sofia	James	f	system	150	$	nerdbot.com
1060	16408	1	michael.l@frontpageadvantage.com	1716452913891	43	f	safarisafricana.com	jacquiehale75@gmail.com	1756695632083	Jacquie Hale	Outbound Facebook	f	system	200	£	https://safarisafricana.com/
502	16409	1	historical	0	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	1756695667173	Fazal	Inbound Sam	f	system	108	£	explorersagainstextinction.co.uk
1621	16410	1	millie.t@frontpageadvantage.com	1754566514837	70	f	portotheme.com	calahlane3@gmail.com	1756695668255	Portotheme	Millie	f	system	80	£	https://www.portotheme.com/
527	16411	1	historical	0	59	f	ourculturemag.com	info@ourculturemag.com	1756695669536	Info	Inbound Sam	f	system	115	£	ourculturemag.com
303	16412	1	historical	0	21	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	1756695679387	This is Owned by Chris :-)	Inbound email	f	system	1	£	www.moneytipsblog.co.uk
1517	16413	1	frontpage.ga@gmail.com	1742852009295	62	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1756695688645	UK Journal	inbound	f	system	80	£	ukjournal.co.uk
1546	16414	1	frontpage.ga@gmail.com	1744287722025	44	f	talkssmartly.com	support@seolinkers.com	1756695692368	Talks Smartly	inboud	f	system	50	£	talkssmartly.com
1159	16418	1	james.p@frontpageadvantage.com	1726057994078	43	t	thistradinglife.com	sofiakahn06@gmail.com	1756819944805	Sofia	James	f	millie.t@frontpageadvantage.com	35	$	thistradinglife.com
1619	16426	1	millie.t@frontpageadvantage.com	1754566452647	56	t	indibloghub.com	calahlane3@gmail.com	1756820383164	Indibloghub	Millie	f	millie.t@frontpageadvantage.com	50	£	https://indibloghub.com/
1622	16703	1	millie.t@frontpageadvantage.com	1754566562692	33	f	webstosociety.co.uk	calahlane3@gmail.com	1757062850911	websstosociety	Millie	f	millie.t@frontpageadvantage.com	42	£	https://webstosociety.co.uk/
1637	17059	0	millie.t@frontpageadvantage.com	1757597977070	48	f	financial-news.co.uk	backlinsprovider@gmail.com	1757597977070	Financial News	David Smith 	f	\N	110	£	http://financial-news.co.uk/
1637	17060	1	millie.t@frontpageadvantage.com	1757597977070	48	f	financial-news.co.uk	backlinsprovider@gmail.com	1757597980036	Financial News	David Smith 	f	system	110	£	http://financial-news.co.uk/
1638	17061	0	millie.t@frontpageadvantage.com	1757598029993	42	f	costaprices.co.uk	backlinsprovider@gmail.com	1757598029993	Costa Prices	David Smith 	f	\N	85	$	https://costaprices.co.uk/
1638	17062	1	millie.t@frontpageadvantage.com	1757598029993	42	f	costaprices.co.uk	backlinsprovider@gmail.com	1757598033137	Costa Prices	David Smith 	f	system	85	$	https://costaprices.co.uk/
1639	17063	0	millie.t@frontpageadvantage.com	1757598163477	72	f	thelondoneconomic.com	backlinsprovider@gmail.com	1757598163477	London economic	David Smith 	f	\N	370	£	http://thelondoneconomic.com/
1639	17064	1	millie.t@frontpageadvantage.com	1757598163477	72	f	thelondoneconomic.com	backlinsprovider@gmail.com	1757598166665	London economic	David Smith 	f	system	370	£	http://thelondoneconomic.com/
1254	17231	1	frontpage.ga@gmail.com	1726736911853	25	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1759287601657	Laureny Loves	Hannah	f	system	50	£	https://www.laurenyloves.co.uk/category/money/
1055	17232	1	michael.l@frontpageadvantage.com	1716452047818	21	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1759287617212	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1170	17233	1	james.p@frontpageadvantage.com	1726065836927	50	f	nerdbot.com	sofiakahn06@gmail.com	1759287619384	Sofia	James	f	system	150	$	nerdbot.com
1076	17234	1	sam.b@frontpageadvantage.com	1719318364944	33	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1759287620676	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
324	17235	1	historical	0	14	f	itsmechrissyj.co.uk	Mrscjones1985@gmail.com	1759287621697	Chrissy	Fatjoe	f	system	20	£	itsmechrissyj.co.uk
1158	17236	1	james.p@frontpageadvantage.com	1725966960853	33	f	toptechsinfo.com	david.linkedbuilders@gmail.com	1759287628170	David	James	f	system	10	$	http://toptechsinfo.com/
1523	17237	1	frontpage.ga@gmail.com	1742853030124	36	f	ventstimes.co.uk	ventstimesofficial@gmail.com	1759287631122	Vents Times	inboud	f	system	80	£	Ventstimes.co.uk
357	17238	1	historical	0	56	f	spiritedpuddlejumper.com	spiritedpuddlejumper@yahoo.com	1759287634708	Becky Freeman	Fatjoe	f	system	50	£	www.spiritedpuddlejumper.com
959	17239	1	chris.p@frontpageadvantage.com	1711533031802	46	f	talk-business.co.uk	backlinsprovider@gmail.com	1759287636303	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
777	17240	1	chris.p@frontpageadvantage.com	1709032527056	31	f	yourpetplanet.com	info@yourpetplanet.com	1759287639387	Your Pet Planet	inbound	f	system	42	£	https://yourpetplanet.com/
1617	17241	1	millie.t@frontpageadvantage.com	1754566382919	71	f	hackmd.io	calahlane3@gmail.com	1759287641542	Hack MD	Millie	f	system	60	£	https://hackmd.io/
957	17242	1	chris.p@frontpageadvantage.com	1711532679719	45	f	north.wales	backlinsprovider@gmail.com	1759287646420	David Smith	Inbound	f	system	95	£	https://north.wales/
328	17243	1	historical	0	22	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1759287647088	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1618	17244	1	millie.t@frontpageadvantage.com	1754566417149	65	f	coda.io	calahlane3@gmail.com	1759287647875	Coda IO	Millie	f	system	90	£	https://coda.io/
311	17245	1	historical	0	16	f	alifeoflovely.com	alifeoflovely@gmail.com	1759287650195	Lu	Fatjoe	f	system	25	£	alifeoflovely.com
331	17246	1	historical	0	32	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	1759287652470	Angela Riches	Fatjoe	f	system	40	£	www.hnmagazine.co.uk
382	17247	1	historical	0	31	f	stressedmum.co.uk	sam@stressedmum.co.uk	1759287653745	Samantha Donnelly	Inbound email	f	system	80	£	https://stressedmum.co.uk
383	17248	1	historical	0	38	f	whingewhingewine.co.uk	fran@whingewhingewine.co.uk	1759287655170	Fran	Inbound email	f	system	75	£	www.whingewhingewine.co.uk
406	17249	1	historical	0	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1759287657442	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
1428	17250	1	frontpage.ga@gmail.com	1730297891567	31	f	feast-magazine.co.uk	arianne@timewomenflag.com	1759287665765	Arianne Volkova	inbound	f	system	118	£	feast-magazine.co.uk
1620	17251	1	millie.t@frontpageadvantage.com	1754566476971	36	f	thedatascientist.com	calahlane3@gmail.com	1759287667143	Thedatascientist	Millie	f	system	120	£	https://thedatascientist.com/
481	17252	1	historical	0	29	f	twinmummyanddaddy.com	twinmumanddad@yahoo.co.uk	1759287669081	Emily	another blogger	f	system	75	£	https://www.twinmummyanddaddy.com/
1083	17253	1	sam.b@frontpageadvantage.com	1719319963927	35	f	edinburgers.co.uk	katherine@orangeoutreach.com	1759287669538	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
1166	17254	1	james.p@frontpageadvantage.com	1726063406379	40	f	costumeplayhub.com	sofiakahn06@gmail.com	1759287671092	Sofia	James	f	system	30	$	costumeplayhub.com
527	17255	1	historical	0	58	f	ourculturemag.com	info@ourculturemag.com	1759287671694	Info	Inbound Sam	f	system	115	£	ourculturemag.com
1622	17256	1	millie.t@frontpageadvantage.com	1754566562692	34	f	webstosociety.co.uk	calahlane3@gmail.com	1759287677734	websstosociety	Millie	f	system	42	£	https://webstosociety.co.uk/
1414	17257	1	frontpage.ga@gmail.com	1730297056465	38	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	1759287680012	Arianne Volkova	inbound	f	system	118	£	singleparentsonholiday.co.uk
418	17258	1	historical	0	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	1759287681863	Petra	Facebook	f	system	100	£	https://amumreviews.co.uk/
1623	17259	1	millie.t@frontpageadvantage.com	1754570606930	34	f	mrsshilts.co.uk	emma.shilton@outlook.com	1759287686244	Emma Shilton	Millie	f	system	100	£	http://www.mrsshilts.co.uk/
1546	17260	1	frontpage.ga@gmail.com	1744287722025	45	f	talkssmartly.com	support@seolinkers.com	1759287689298	Talks Smartly	inboud	f	system	50	£	talkssmartly.com
1539	17261	1	frontpage.ga@gmail.com	1744282455391	69	f	anationofmoms.com	PR@anationofmoms.com	1759287692925	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
1515	17262	1	frontpage.ga@gmail.com	1742851725672	41	f	ranyy.com	aishwaryagaikwad313@gmail.com	1759287695551	Ranyy	inbound	f	system	80	£	ranyy.com
1638	17263	1	millie.t@frontpageadvantage.com	1757598029993	44	f	costaprices.co.uk	backlinsprovider@gmail.com	1759287697548	Costa Prices	David Smith 	f	system	85	$	https://costaprices.co.uk/
1086	17264	1	sam.b@frontpageadvantage.com	1719320331730	43	f	lovebelfast.co.uk	katherine@orangeoutreach.com	1759287699650	Katherine Williams	Inbound	f	system	120	£	lovebelfast.co.uk
434	17265	1	historical	0	19	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	1759287701414	Kara Guppy	Facebook	f	system	75	£	https://arewenearlythereyet.co.uk/
422	17266	1	historical	0	37	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1759287702043	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
1629	17267	1	millie.t@frontpageadvantage.com	1755610853604	30	f	rhianwestbury.co.uk	westburyrhian@gmail.com	1759287702428	Rhian	Millie	f	system	100	£	http://www.rhianwestbury.co.uk/
1504	17268	1	frontpage.ga@gmail.com	1741270738337	26	f	infinityelse.co.uk	 infinityelse1@gmail.com	1759287703075	Infinity else	inbound	f	system	65	£	infinityelse.co.uk
1631	17269	1	millie.t@frontpageadvantage.com	1755675865921	44	f	reelsmedia.co.uk	calahlane3@gmail.com	1759287704339	ReelsMedia	Millie	f	system	50	£	http://reelsmedia.co.uk/
771	17270	1	chris.p@frontpageadvantage.com	1709027801990	42	f	finehomesandliving.com	info@fine-magazine.com	1759287704924	Fine Home Team	outbound	f	system	100	£	https://www.finehomesandliving.com/
1632	17271	1	millie.t@frontpageadvantage.com	1755675953072	34	f	imagefap.uk	calahlane3@gmail.com	1759287708986	ImageFap	Millie	f	system	50	£	http://imagefap.uk/
1602	17272	1	millie.t@frontpageadvantage.com	1750841059853	44	f	slummysinglemummy.com	jo@slummysinglemummy.com	1759287709629	Jo  	Millie	f	system	100	£	https://slummysinglemummy.com/
1633	17273	1	millie.t@frontpageadvantage.com	1755675994853	39	f	tubegalore.uk	calahlane3@gmail.com	1759287712691	Tube Galore	Millie	f	system	50	£	http://tubegalore.uk/
326	17274	1	historical	0	20	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1759287713389	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
780	17275	1	chris.p@frontpageadvantage.com	1709033136922	20	f	travelistia.com	travelistiausa@gmail.com	1759287713977	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1529	17293	1	frontpage.ga@gmail.com	1744279970120	57	f	thebiographywala.com	support@linksposting.com 	1759374002294	The Biography Wala	inboud	f	system	40	£	Thebiographywala.com
1517	17294	1	frontpage.ga@gmail.com	1742852009295	61	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1759374005446	UK Journal	inbound	f	system	80	£	ukjournal.co.uk
1531	17295	1	frontpage.ga@gmail.com	1744280420962	37	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1759374008835	Every Movie Has A Lesson	inboud	f	system	40	£	everymoviehasalesson.com
1553	17296	1	millie.t@frontpageadvantage.com	1749110988493	26	f	thecoachspace.com	gabrielle@thecoachspace.com	1759374014550	Gabrielle	Tanya	f	system	82	£	https://thecoachspace.com/
1652	17394	0	millie.t@frontpageadvantage.com	1759840271455	42	f	ukstartupmagazine.co.uk	jonathan@ukstartupmagazine.co.uk	1759840271455	Jonathon	Tanya	f	\N	300	£	https://www.ukstartupmagazine.co.uk/
1652	17395	1	millie.t@frontpageadvantage.com	1759840271455	42	f	ukstartupmagazine.co.uk	jonathan@ukstartupmagazine.co.uk	1759840274789	Jonathon	Tanya	f	system	300	£	https://www.ukstartupmagazine.co.uk/
1653	17396	0	millie.t@frontpageadvantage.com	1759840429117	16	f	houseandhomeideas.co.uk	info@houseandhomeideas.co.uk	1759840429117	House & Homes	Tanya	f	\N	20	£	https://www.houseandhomeideas.co.uk/
1653	17397	1	millie.t@frontpageadvantage.com	1759840429117	16	f	houseandhomeideas.co.uk	info@houseandhomeideas.co.uk	1759840432448	House & Homes	Tanya	f	system	20	£	https://www.houseandhomeideas.co.uk/
1654	17398	0	millie.t@frontpageadvantage.com	1759841564720	42	f	midlandsbusinessnews.co.uk	amlivemanagement@hotmail.co.uk	1759841564720	Midlands Business News	Tanya	f	\N	40	£	https://midlandsbusinessnews.co.uk/contact/
1654	17399	1	millie.t@frontpageadvantage.com	1759841564720	42	f	midlandsbusinessnews.co.uk	amlivemanagement@hotmail.co.uk	1759841567689	Midlands Business News	Tanya	f	system	40	£	https://midlandsbusinessnews.co.uk/contact/
1702	17817	0	millie.t@frontpageadvantage.com	1760429536786	40	f	captionbio.co.uk	backlinsprovider@gmail.com	1760429536786	Captin Bio 	David Smith	f	\N	75	$	https://captionbio.co.uk/
1702	17818	1	millie.t@frontpageadvantage.com	1760429536786	40	f	captionbio.co.uk	backlinsprovider@gmail.com	1760429539877	Captin Bio 	David Smith	f	system	75	$	https://captionbio.co.uk/
1622	17912	1	millie.t@frontpageadvantage.com	1754566562692	34	f	webstosociety.co.uk	calahlane3@gmail.com	1760610506710	websstosociety	Millie	f	millie.t@frontpageadvantage.com	85	£	https://webstosociety.co.uk/
1703	17925	0	millie.t@frontpageadvantage.com	1760711132182	33	f	buzblog.co.uk	backlinsprovider@gmail.com	1760711132182	Buzz BLOG	David Smith 	f	\N	68	$	https://buzblog.co.uk/
1703	17926	1	millie.t@frontpageadvantage.com	1760711132182	33	f	buzblog.co.uk	backlinsprovider@gmail.com	1760711135384	Buzz BLOG	David Smith 	f	system	68	$	https://buzblog.co.uk/
1704	17940	0	millie.t@frontpageadvantage.com	1760947883867	20	f	staceyinthesticks.com	stacey@staceyinthesticks.com	1760947883867	Stacey	Millie	f	\N	70	£	www.staceyinthesticks.com
1704	17941	1	millie.t@frontpageadvantage.com	1760947883867	20	f	staceyinthesticks.com	stacey@staceyinthesticks.com	1760947887019	Stacey	Millie	f	system	70	£	www.staceyinthesticks.com
1705	17943	0	millie.t@frontpageadvantage.com	1760948438416	53	f	boho-weddings.com	kelly@boho-weddings.com	1760948438416	Kelly	Tanya	f	\N	199	£	https://www.boho-weddings.com/
1705	17944	1	millie.t@frontpageadvantage.com	1760948438416	53	f	boho-weddings.com	kelly@boho-weddings.com	1760948441367	Kelly	Tanya	f	system	199	£	https://www.boho-weddings.com/
1706	17950	0	millie.t@frontpageadvantage.com	1760967354015	42	f	uknewstap.co.uk	calahlane3@gmail.com	1760967354015	Uk News Tap	Calah	f	\N	55	£	http://uknewstap.co.uk/
1706	17951	1	millie.t@frontpageadvantage.com	1760967354015	42	f	uknewstap.co.uk	calahlane3@gmail.com	1760967356782	Uk News Tap	Calah	f	system	55	£	http://uknewstap.co.uk/
1707	17952	0	millie.t@frontpageadvantage.com	1760967404074	32	f	imhentai.co.uk	calahlane3@gmail.com	1760967404074	Im hen Tai	Calah	f	\N	50	£	http://imhentai.co.uk/
1707	17953	1	millie.t@frontpageadvantage.com	1760967404074	32	f	imhentai.co.uk	calahlane3@gmail.com	1760967407280	Im hen Tai	Calah	f	system	50	£	http://imhentai.co.uk/
1708	17954	0	millie.t@frontpageadvantage.com	1760967461561	31	f	thestripesblog.co.uk	calahlane3@gmail.com	1760967461561	The Stripes Blog	Calah	f	\N	55	£	thestripesblog.co.uk
1708	17955	1	millie.t@frontpageadvantage.com	1760967461561	31	f	thestripesblog.co.uk	calahlane3@gmail.com	1760967464189	The Stripes Blog	Calah	f	system	55	£	thestripesblog.co.uk
1709	17956	0	millie.t@frontpageadvantage.com	1760967514629	41	f	businesstask.co.uk	calahlane3@gmail.com	1760967514629	Business Task	Calah	f	\N	50	£	https://businesstask.co.uk/
1709	17957	1	millie.t@frontpageadvantage.com	1760967514629	41	f	businesstask.co.uk	calahlane3@gmail.com	1760967517812	Business Task	Calah	f	system	50	£	https://businesstask.co.uk/
1710	17958	0	millie.t@frontpageadvantage.com	1761039824470	51	f	invisioncommunity.co.uk	backlinsprovider@gmail.com	1761039824470	David Invision Community	David Smith 	f	\N	65	£	https://invisioncommunity.co.uk/
1710	17959	1	millie.t@frontpageadvantage.com	1761039824470	51	f	invisioncommunity.co.uk	backlinsprovider@gmail.com	1761039827326	David Invision Community	David Smith 	f	system	65	£	https://invisioncommunity.co.uk/
1711	17960	0	millie.t@frontpageadvantage.com	1761039859361	40	f	racingbetter.co.uk	backlinsprovider@gmail.com	1761039859361	David Racing Better	David Smith 	f	\N	60	£	https://racingbetter.co.uk/
1711	17961	1	millie.t@frontpageadvantage.com	1761039859361	40	f	racingbetter.co.uk	backlinsprovider@gmail.com	1761039861995	David Racing Better	David Smith 	f	system	60	£	https://racingbetter.co.uk/
1712	17979	0	millie.t@frontpageadvantage.com	1761816876951	38	f	newsdipper.co.uk	calahlane3@gmail.com	1761816876951	News Dipper	Calah	f	\N	50	£	https://newsdipper.co.uk/
1712	17980	1	millie.t@frontpageadvantage.com	1761816876951	38	f	newsdipper.co.uk	calahlane3@gmail.com	1761816879724	News Dipper	Calah	f	system	50	£	https://newsdipper.co.uk/
1254	17981	1	frontpage.ga@gmail.com	1726736911853	24	f	laurenyloves.co.uk	lauren@laurenyloves.co.uk	1761966002970	Laureny Loves	Hannah	f	system	50	£	https://www.laurenyloves.co.uk/category/money/
1055	17982	1	michael.l@frontpageadvantage.com	1716452047818	20	f	lindyloves.co.uk	Hello@lindyloves.co.uk	1761966003576	Lindy	Outbound Facebook	f	system	50	£	https://www.lindyloves.co.uk/
1156	17983	1	james.p@frontpageadvantage.com	1725624962664	30	f	cuddlefairy.com	hello@cuddlefairy.com	1761966004374	Becky	James	f	system	45	£	https://www.cuddlefairy.com/
1089	17984	1	sam.b@frontpageadvantage.com	1719320544130	33	f	crummymummy.co.uk	crummymummy@live.co.uk	1761966013567	Natalie	James	f	system	60	£	crummymummy.co.uk
1170	17985	1	james.p@frontpageadvantage.com	1726065836927	51	f	nerdbot.com	sofiakahn06@gmail.com	1761966020021	Sofia	James	f	system	150	$	nerdbot.com
1076	17986	1	sam.b@frontpageadvantage.com	1719318364944	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	1761966020510	Katherine Williams	Inbound	f	system	100	£	wellbeingmagazine.com
1614	17987	1	millie.t@frontpageadvantage.com	1754479907265	74	f	manilatimes.net	advertise@mintymarketing.co.uk	1761966025596	Minty	Tanya	f	system	80	$	https://www.manilatimes.net/
1512	17988	1	frontpage.ga@gmail.com	1742851181353	33	f	techranker.co.uk	 agencystarseo@gmail.com	1761966027318	TRK	inbound	f	system	80	£	TechRanker.co.uk
1427	17989	1	frontpage.ga@gmail.com	1730297857266	26	f	shelllouise.co.uk	arianne@timewomenflag.com	1761966028530	Arianne Volkova	inbound	f	system	106	£	shelllouise.co.uk
1256	17990	1	frontpage.ga@gmail.com	1726827443560	34	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	1761966028869	The Everyday Man	Hannah	f	system	150	£	https://theeverydayman.co.uk/
959	17991	1	chris.p@frontpageadvantage.com	1711533031802	47	f	talk-business.co.uk	backlinsprovider@gmail.com	1761966034819	David Smith	Inbound	f	system	115	£	https://www.talk-business.co.uk/
1161	17992	1	james.p@frontpageadvantage.com	1726058268387	77	f	oddee.com	sofiakahn06@gmail.com	1761966035501	Sofia	James	f	system	150	$	oddee.com
328	17993	1	historical	0	21	f	beemoneysavvy.com	Emma@beemoneysavvy.com	1761966042625	Emma	Fatjoe	f	system	70	£	www.beemoneysavvy.com
1519	17994	1	frontpage.ga@gmail.com	1742852226231	38	f	myflexbot.co.uk	myflexbot11@gmail.com	1761966045856	My Flex Bot	inbound	f	system	80	£	myflexbot.co.uk
312	17995	1	historical	0	30	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	1761966047470	Abbie	Fatjoe	f	system	165	£	mmbmagazine.co.uk
314	17996	1	historical	0	18	f	thejournalix.com	thejournalix@gmail.com	1761966049161	Thomas	Fatjoe	f	system	15	£	thejournalix.com
305	17997	1	historical	0	21	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	1761966051334	Thirfty Bride	Fatjoe	f	system	40	£	https://www.thethriftybride.co.uk
318	17998	1	historical	0	37	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	1761966051976	Tanya	Fatjoe	f	system	150	£	luckyattitude.co.uk
406	17999	1	historical	0	27	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	1761966055083	Ruth Davies Knowles	Inbound email	f	system	116	£	Https://rocknrollerbaby.co.uk
390	18000	1	historical	0	30	f	bay-bee.co.uk	Stephi@bay-bee.co.uk	1761966058404	Steph Moore	Inbound email	f	system	115	£	https://blog.bay-bee.co.uk/
425	18001	1	historical	0	30	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	1761966064210	Jess Howliston	Facebook	f	system	75	£	www.tantrumstosmiles.co.uk
460	18002	1	historical	0	26	f	techacrobat.com	minalkh124@gmail.com	1761966065449	Maryam bibi	Inbound email	f	system	140	£	techacrobat.com
453	18003	1	historical	0	72	f	techbullion.com	angelascottbriggs@techbullion.com	1761966066069	Angela Scott-Briggs 	Inbound email	f	system	100	£	http://techbullion.com
416	18004	1	historical	0	30	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	1761966067290	Micaela	Facebook	f	system	100	£	https://www.stylishlondonliving.co.uk/
1530	18005	1	frontpage.ga@gmail.com	1744280227571	51	f	sundarbantracking.com	baldriccada@gmail.com	1761966067853	Sundar Barn	inboud	f	system	40	£	sundarbantracking.com
1083	18006	1	sam.b@frontpageadvantage.com	1719319963927	34	f	edinburgers.co.uk	katherine@orangeoutreach.com	1761966069131	Katherine Williams	Inbound	f	system	100	£	edinburgers.co.uk
505	18007	1	historical	0	29	f	talk-retail.co.uk	backlinsprovider@gmail.com	1761966070792	David Smith	Inbound Sam	f	system	95	£	talk-retail.co.uk
527	18008	1	historical	0	59	f	ourculturemag.com	info@ourculturemag.com	1761966071387	Info	Inbound Sam	f	system	115	£	ourculturemag.com
322	18009	1	historical	0	35	f	5thingstodotoday.com	5thingstodotoday@gmail.com	1761966083088	David	Fatjoe	f	system	45	£	5thingstodotoday.com
1624	18010	1	millie.t@frontpageadvantage.com	1754660310525	37	f	deepinmummymatters.com	mummymatters@gmail.com	1761966087205	Sabina	Millie	f	system	130	£	https://deepinmummymatters.com/
1539	18011	1	frontpage.ga@gmail.com	1744282455391	70	f	anationofmoms.com	PR@anationofmoms.com	1761966089891	A Nation Of Moms	inboud	f	system	50	£	anationofmoms.com
1517	18012	1	frontpage.ga@gmail.com	1742852009295	58	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	1761966090745	UK Journal	inbound	f	system	80	£	ukjournal.co.uk
330	18013	1	historical	0	38	f	robinwaite.com	robin@robinwaite.com	1761966094528	Robin Waite	Fatjoe	f	system	42	£	https://www.robinwaite.com
1511	18014	1	frontpage.ga@gmail.com	1742851051403	28	f	msnpro.co.uk	ankit@zestfulloutreach.com	1761966095679	MSN PRO	inbound	f	system	80	£	https://msnpro.co.uk/contact-us/
1521	18015	1	frontpage.ga@gmail.com	1742852543019	42	f	grobuzz.co.uk	editorial@rankwc.com	1761966096326	GROBUZZ	inboud	f	system	80	£	grobuzz.co.uk
1626	18016	1	millie.t@frontpageadvantage.com	1754665321436	61	f	lifeinabreakdown.com	sarah@lifeinabreakdown.com	1761966097842	Sarah	Millie	f	system	250	£	https://www.lifeinabreakdown.com/
1702	18017	1	millie.t@frontpageadvantage.com	1760429536786	39	f	captionbio.co.uk	backlinsprovider@gmail.com	1761966103187	Captin Bio 	David Smith	f	system	75	$	https://captionbio.co.uk/
1622	18018	1	millie.t@frontpageadvantage.com	1754566562692	35	f	webstosociety.co.uk	calahlane3@gmail.com	1761966103837	websstosociety	Millie	f	system	85	£	https://webstosociety.co.uk/
1709	18019	1	millie.t@frontpageadvantage.com	1760967514629	42	f	businesstask.co.uk	calahlane3@gmail.com	1761966107280	Business Task	Calah	f	system	50	£	https://businesstask.co.uk/
426	18020	1	historical	0	35	f	chelseamamma.co.uk	Chelseamamma@gmail.com	1761966115993	Kara Guppy	Facebook	f	system	75	£	https://www.chelseamamma.co.uk/
1531	18021	1	frontpage.ga@gmail.com	1744280420962	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	1761966116382	Every Movie Has A Lesson	inboud	f	system	40	£	everymoviehasalesson.com
1603	18022	1	millie.t@frontpageadvantage.com	1751012371517	42	f	uknip.co.uk	uknewsinpictures@gmail.com	1761966118048	UKnip		f	system	90	£	https://uknip.co.uk/
1550	18023	1	millie.t@frontpageadvantage.com	1747837279774	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	1761966119231	Matt	Tanya	f	system	75	£	https://www.lifeunexpected.co.uk/
1515	18024	1	frontpage.ga@gmail.com	1742851725672	42	f	ranyy.com	aishwaryagaikwad313@gmail.com	1761966122308	Ranyy	inbound	f	system	80	£	ranyy.com
422	18025	1	historical	0	34	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	1761966123996	Tom	Google Search	f	system	75	£	https://ukconstructionblog.co.uk/
1632	18026	1	millie.t@frontpageadvantage.com	1755675953072	31	f	imagefap.uk	calahlane3@gmail.com	1761966124533	ImageFap	Millie	f	system	50	£	http://imagefap.uk/
1633	18027	1	millie.t@frontpageadvantage.com	1755675994853	38	f	tubegalore.uk	calahlane3@gmail.com	1761966125774	Tube Galore	Millie	f	system	50	£	http://tubegalore.uk/
326	18028	1	historical	0	19	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	1761966126366	Lisa Ventura MBE	Fatjoe	f	system	30	£	https://www.cybergeekgirl.co.uk
780	18029	1	chris.p@frontpageadvantage.com	1709033136922	22	f	travelistia.com	travelistiausa@gmail.com	1761966126969	Ferona	outbound	f	system	27	£	https://www.travelistia.com/
1542	18030	1	frontpage.ga@gmail.com	1744283598194	47	f	prophecynewswatch.com	 Info@ProphecyNewsWatch.com	1762052406585	PNW	inboud	f	system	50	£	prophecynewswatch.com
1713	18031	0	millie.t@frontpageadvantage.com	1762252583668	30	f	accidentalhipstermum.com	accidentalhipstermum@gmail.com	1762252583668	Jenny	Millie	f	\N	120	£	http://accidentalhipstermum.com/
1713	18032	1	millie.t@frontpageadvantage.com	1762252583668	30	f	accidentalhipstermum.com	accidentalhipstermum@gmail.com	1762252586859	Jenny	Millie	f	system	120	£	http://accidentalhipstermum.com/
1714	18150	0	millie.t@frontpageadvantage.com	1762790571756	0	f	thetraveldaily.co.uk	backlinsprovider@gmail.com	1762790571756	The Travel Daily David	David Smith 	f	\N	85	£	https://www.thetraveldaily.co.uk/
1714	18151	1	millie.t@frontpageadvantage.com	1762790571756	24	f	thetraveldaily.co.uk	backlinsprovider@gmail.com	1762790574863	The Travel Daily David	David Smith 	f	system	85	£	https://www.thetraveldaily.co.uk/
1715	18161	0	millie.t@frontpageadvantage.com	1762792457787	37	f	whatkatysaid.com	katy@whatkatysaid.com	1762792457787	katy	Millie	f	\N	75	£	http://www.whatkatysaid.com/
1715	18162	1	millie.t@frontpageadvantage.com	1762792457787	37	f	whatkatysaid.com	katy@whatkatysaid.com	1762792460729	katy	Millie	f	system	75	£	http://www.whatkatysaid.com/
1704	18530	1	millie.t@frontpageadvantage.com	1760947883867	20	f	staceyinthesticks.com	stacey@staceyinthesticks.com	1763479614095	Stacey	Millie	f	millie.t@frontpageadvantage.com	40	£	www.staceyinthesticks.com
\.


--
-- Data for Name: supplier_categories; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.supplier_categories (supplier_id, categories_id) FROM stdin;
952	57
952	69
758	84
758	54
758	64
758	70
758	62
758	67
758	63
449	52
449	72
305	85
305	70
305	63
305	58
449	70
1072	55
1072	75
1073	55
1073	60
1073	75
374	76
374	81
374	70
374	83
1095	66
1095	62
311	70
311	67
311	54
311	84
952	55
952	83
1502	66
1502	81
1502	71
1095	67
1095	71
1095	70
1095	61
1502	77
1095	60
1095	63
1095	84
1095	79
1502	53
1095	74
1095	64
398	70
398	55
398	71
398	61
432	70
432	55
1095	76
340	70
340	66
340	67
432	67
432	84
540	55
540	61
540	75
540	58
1502	67
1502	78
1502	75
1502	60
752	67
752	61
752	84
752	62
361	64
361	84
361	70
361	66
330	55
330	77
330	72
752	55
752	53
752	56
382	77
382	66
382	70
382	76
752	70
752	58
382	67
1109	60
540	70
468	84
468	75
468	55
702	59
702	56
453	57
1654	66
453	83
453	55
468	60
702	52
762	52
762	56
762	62
762	70
762	73
762	55
762	82
1109	71
1109	70
1109	67
1110	60
1110	61
1110	70
363	70
363	55
363	84
363	83
1110	84
1110	71
1170	84
1170	53
1170	55
1170	66
1170	64
1170	67
1170	69
1170	70
318	67
1075	60
1075	62
401	72
401	55
433	55
433	83
318	66
318	77
318	70
349	70
349	71
349	55
349	66
349	53
433	70
433	81
1075	70
1075	76
1076	67
1076	70
484	55
484	75
484	83
512	73
512	55
365	70
365	84
365	62
365	66
365	76
373	62
1303	80
1303	56
1303	62
1303	83
373	77
535	55
1540	59
1540	55
373	66
373	70
373	76
386	70
458	67
458	83
458	60
458	55
1303	68
1303	54
1303	70
1303	63
458	70
458	75
783	82
386	76
386	81
386	62
386	66
397	70
397	76
397	62
397	64
397	66
380	84
380	70
380	82
407	70
407	81
407	76
407	62
383	76
383	70
383	68
384	76
384	62
384	70
384	81
385	76
385	70
385	68
407	66
409	66
409	70
409	54
409	81
409	63
389	76
389	59
389	70
389	62
1076	84
434	84
434	81
434	66
434	70
394	70
394	66
394	77
394	67
783	55
778	83
778	55
778	68
400	56
400	55
400	72
778	84
778	70
1303	75
1303	72
1303	84
1303	82
403	76
403	62
403	70
1303	78
1303	61
1303	74
1303	52
778	67
778	82
778	53
902	55
406	70
406	76
406	74
406	84
408	70
408	76
408	67
408	81
1303	58
1303	81
1303	66
1303	76
338	67
338	66
338	76
338	70
338	62
369	66
369	54
468	66
333	55
333	77
333	67
369	70
369	63
375	81
375	70
375	66
375	54
375	67
1303	77
1303	55
1303	73
1303	64
907	78
907	83
907	55
907	73
390	66
390	76
390	70
390	62
390	81
422	56
422	52
422	55
422	83
1107	61
1107	60
425	76
425	70
425	62
1303	59
1303	60
1303	67
1303	69
1107	55
1107	59
1107	70
1107	63
425	81
425	66
426	62
426	66
1107	67
1411	55
1303	53
1303	85
426	70
426	76
426	84
1453	82
1453	69
1453	62
1453	61
1453	84
1453	52
1453	83
1453	59
1453	74
1453	60
1453	78
1453	64
1453	70
1453	54
1453	68
1453	79
1453	65
1453	55
1453	77
1453	66
1453	75
1453	53
1453	85
1453	63
1453	81
1453	58
1415	55
1420	55
327	72
327	66
327	55
327	70
420	70
420	68
420	58
420	63
1078	60
1078	67
1078	68
1078	70
1078	62
1078	78
1078	63
1078	59
1078	64
1078	66
1078	76
460	81
326	83
326	55
326	69
489	78
489	55
489	83
437	83
437	81
443	60
443	70
443	67
443	83
445	81
445	70
445	55
445	83
446	81
446	60
446	70
450	70
450	81
450	64
1453	73
1453	72
1002	75
1002	82
1002	65
1002	85
1002	78
1453	56
1453	80
1453	76
467	72
467	83
1002	83
1002	55
1080	58
1080	60
1080	61
1080	62
452	60
452	78
452	66
452	55
452	75
452	70
523	57
523	55
523	78
530	55
452	83
483	62
483	70
530	83
763	55
763	57
763	78
1080	63
1080	64
1080	66
483	76
483	66
525	84
525	70
761	72
761	55
908	55
908	72
1453	71
1453	57
1453	67
1080	67
1080	68
1413	55
1407	55
1081	61
525	66
357	66
357	53
357	70
357	62
357	76
1080	70
1080	74
1080	78
357	55
1081	66
1081	59
357	64
312	62
312	81
312	66
312	70
454	70
454	55
312	55
312	58
312	76
418	81
454	83
454	75
455	60
455	70
418	70
418	76
418	62
1081	63
1081	76
418	66
1081	84
1081	77
1081	62
455	81
461	55
1081	78
1081	64
1081	58
1081	67
461	83
464	55
502	82
464	75
1081	60
1081	70
1081	74
1081	79
1423	64
378	67
378	64
381	84
381	81
381	70
381	64
473	70
473	64
473	67
953	67
953	65
953	75
904	75
904	65
904	67
955	65
955	67
955	75
956	75
956	65
956	67
954	65
954	75
954	67
1535	66
476	81
476	70
476	76
476	66
465	76
465	67
465	66
465	70
1528	66
1544	66
1545	66
1548	66
1402	66
1424	66
1533	66
1534	66
387	67
387	84
387	77
387	70
1409	67
481	62
481	70
481	81
368	54
368	84
368	55
368	63
368	70
803	64
803	83
1080	79
1080	84
481	76
396	75
396	55
396	83
396	70
315	70
315	63
315	54
315	68
344	84
344	70
344	80
481	66
803	63
803	58
803	55
803	60
803	81
803	53
532	66
532	59
532	70
1056	84
1539	66
322	70
322	67
902	77
1091	69
1091	75
1091	83
1091	70
777	79
1091	55
1153	84
322	66
322	55
331	66
331	54
331	70
331	55
331	63
321	77
321	70
321	67
331	84
1153	67
1153	83
1086	61
1086	66
1086	55
1153	64
1153	68
1153	55
424	55
424	72
325	70
325	73
652	70
652	62
652	84
652	54
652	66
652	58
652	73
652	55
364	76
364	70
364	67
364	81
1086	60
1086	70
1086	64
1153	70
1153	63
1153	75
1153	56
1086	62
1086	58
1086	63
1086	74
456	60
456	70
456	61
457	55
457	83
457	75
459	72
459	83
536	64
537	55
537	83
538	68
538	58
485	70
485	60
1086	67
1086	71
460	83
487	70
487	60
487	63
438	55
438	72
438	71
306	76
306	67
306	81
306	70
310	64
310	76
310	70
310	81
319	55
336	67
336	76
336	70
350	70
350	78
350	73
352	70
352	54
352	63
352	81
356	62
356	84
356	76
356	70
370	70
370	54
370	63
370	81
376	58
376	70
376	68
413	54
413	81
413	70
413	63
429	68
429	70
429	62
429	64
431	63
431	84
431	70
431	54
435	67
435	83
444	58
444	68
444	70
444	67
447	81
447	70
447	60
462	75
462	70
462	61
462	55
466	55
466	67
466	70
478	79
478	70
478	67
478	81
479	81
479	70
479	63
479	54
1153	66
1064	83
1064	69
802	55
802	82
802	63
802	73
802	81
802	76
802	67
802	53
1064	55
1064	59
1064	78
1421	55
1096	83
1096	75
1096	55
1096	69
802	83
802	75
436	70
436	82
436	83
802	70
1057	84
1509	66
1509	69
1509	70
1509	71
1509	72
1509	76
1509	75
1509	83
482	70
482	55
494	72
494	55
754	57
754	55
754	66
754	77
754	83
754	60
754	54
754	69
772	69
772	67
772	59
772	73
772	83
772	55
772	54
772	62
772	60
772	58
772	70
772	63
1509	84
323	70
323	72
323	58
323	68
513	70
513	64
1543	66
1547	66
1302	66
1405	66
339	77
339	67
339	70
393	70
393	76
393	81
1111	60
1111	71
1111	70
1112	70
1112	62
1112	68
1112	76
1112	77
1112	67
1113	55
1113	59
1113	77
1115	64
1115	63
1115	61
1115	74
1115	76
1115	60
1115	68
1115	62
1115	70
1115	75
1115	67
1103	67
1103	63
1103	70
1103	64
1103	79
1103	61
1103	60
1103	58
1103	77
1103	68
1103	54
1103	62
1103	76
1103	74
1103	84
1104	59
1116	72
1116	81
1116	76
1098	68
1098	75
1098	60
1098	84
1098	70
1098	62
1098	54
1098	63
1098	74
1098	59
1098	64
1098	76
1098	55
1098	67
1098	66
1098	61
1098	73
1098	71
393	67
427	67
427	70
427	77
1160	53
1160	55
1160	56
1160	58
1160	66
1160	67
1160	69
1160	71
1160	72
1160	73
1160	74
1160	75
1160	83
1170	72
480	70
480	64
448	83
448	84
392	67
392	55
392	70
392	59
392	81
392	84
392	66
1060	84
441	75
441	56
441	55
441	83
441	70
441	58
441	54
1078	79
1078	58
1078	73
441	66
328	58
1065	65
516	68
516	58
1077	75
1077	66
1537	66
1503	66
1516	66
1541	66
1525	66
1526	66
1527	66
1412	66
1422	66
1426	66
903	75
903	67
328	66
328	73
328	70
343	70
343	77
343	62
343	76
328	78
328	55
1520	75
324	77
324	70
324	66
324	76
324	67
906	67
307	67
307	72
307	66
475	56
475	72
475	66
786	70
786	63
786	66
786	60
786	62
786	55
786	67
786	82
786	64
785	67
785	83
785	59
785	55
785	60
785	63
785	70
785	84
785	66
785	82
1083	58
1083	59
1083	60
1083	61
1083	62
1083	64
1083	63
1083	66
1083	67
1083	68
1083	70
1083	71
1083	76
1083	84
1083	79
1083	75
906	71
337	70
337	73
1114	74
1114	72
1114	70
1100	75
1100	67
1100	55
1100	70
1102	71
1102	73
1102	61
1102	59
1102	58
1102	62
1102	70
1102	68
1102	67
1102	79
1102	60
1102	63
1102	54
1102	76
1102	64
1102	55
1102	84
1170	74
1170	81
1170	83
490	70
490	75
490	61
490	66
498	84
498	70
528	60
528	70
782	62
782	59
348	59
348	76
781	59
781	62
517	59
517	66
428	67
428	70
1086	84
316	71
316	66
316	56
316	68
428	81
428	63
773	59
773	55
773	53
773	66
773	54
773	77
773	83
773	72
957	71
957	75
411	61
309	67
309	66
309	72
354	72
354	55
463	55
469	55
469	83
469	81
442	84
442	70
442	73
442	55
442	54
442	68
442	63
509	52
509	56
411	85
411	70
491	61
491	66
491	70
491	75
345	62
345	81
345	76
345	70
471	70
471	62
471	76
495	76
316	70
316	55
1256	70
1256	66
527	66
527	60
527	70
1089	68
1089	58
1089	76
1087	55
1087	75
495	62
495	70
852	67
852	70
852	84
508	67
508	70
508	77
905	70
905	84
905	67
760	70
760	67
1404	69
1089	79
1089	66
1089	70
1089	62
1542	75
1090	54
1090	55
1090	58
1090	59
1090	60
1090	61
1090	62
1090	63
1090	64
1090	67
1090	68
1090	70
1090	71
1090	73
1090	74
1090	76
1090	77
1090	78
1090	79
1090	84
1092	54
1092	55
1092	60
1092	63
1092	64
1092	67
1092	70
1092	75
1092	84
1163	66
1163	55
1163	53
1163	70
1163	83
1097	68
1097	61
1097	63
1097	84
1097	54
1097	67
1097	58
1097	70
1097	62
1097	64
492	75
492	61
492	66
492	70
653	61
653	74
653	60
1524	66
1524	60
1082	70
1082	60
347	58
347	76
347	66
1082	84
1082	61
1085	67
1085	84
1085	60
1085	70
1085	71
1085	66
1085	63
771	85
771	73
771	53
771	68
771	81
771	76
771	62
771	67
771	56
771	78
771	64
771	79
771	84
771	66
771	59
771	54
771	77
771	55
771	58
771	69
771	70
771	63
771	83
771	82
511	52
511	56
539	74
347	70
347	62
539	75
1093	54
1093	55
1093	58
1093	59
1093	60
1093	61
1093	62
958	71
958	75
1093	63
1093	64
1093	67
1093	68
1093	66
1093	69
1093	70
1093	71
1093	73
1093	74
1093	76
1093	77
1093	78
1093	79
1093	84
1085	62
1085	61
334	53
334	68
334	66
334	64
334	58
334	70
334	67
1085	64
765	70
765	60
351	70
1097	60
1099	75
1099	67
1099	66
1101	70
1101	67
1101	55
1105	55
1117	53
1117	55
1117	59
1117	69
1117	70
1117	61
1117	60
1117	71
1117	67
1117	62
347	81
347	59
347	73
347	67
304	55
351	61
351	81
351	53
421	64
421	70
421	61
503	75
503	70
503	61
504	61
504	70
534	75
534	61
534	70
308	84
308	76
308	62
308	64
329	62
329	64
329	76
1166	55
1166	66
1166	67
1166	69
1166	70
1166	83
1166	75
1166	84
1166	72
329	70
355	70
355	81
355	62
355	76
359	76
359	62
359	70
359	81
360	76
1204	53
1204	55
1204	56
1204	58
1204	66
1204	67
1204	69
1204	70
1204	72
1204	73
1204	77
1204	83
1204	84
360	70
360	62
360	81
367	70
367	84
367	62
367	76
531	56
531	55
531	59
531	58
371	62
304	83
304	70
304	75
506	83
506	55
506	75
519	70
533	75
654	63
654	68
654	79
654	70
654	62
654	64
654	55
654	67
654	66
654	76
654	54
654	58
439	83
439	75
439	55
304	73
371	64
371	70
334	60
334	84
787	75
787	70
371	76
388	76
388	62
388	67
388	70
496	84
496	70
787	66
496	62
320	70
320	73
332	67
332	70
332	62
332	76
377	80
302	79
302	70
302	68
302	60
776	79
377	70
377	84
391	70
391	84
391	80
395	70
395	73
423	73
423	70
423	78
522	57
488	83
470	85
470	70
470	81
501	63
501	70
1167	72
1167	70
1167	53
1167	66
1167	69
1167	67
1120	56
1120	82
1120	66
1119	84
1119	70
1119	59
1119	78
1119	74
1119	60
1119	61
1106	60
1106	63
1106	70
1106	61
1118	61
1118	74
1108	67
1108	59
1108	61
313	77
313	55
909	67
909	78
909	55
909	84
909	75
505	75
505	55
1156	66
1156	67
1156	53
1156	70
1167	55
1167	83
335	70
335	84
335	54
335	63
486	83
486	75
486	55
486	60
764	55
764	71
764	75
341	84
341	70
341	54
341	63
346	54
346	84
346	70
346	63
353	63
353	54
353	70
358	54
358	67
358	70
358	77
769	83
769	53
769	67
769	75
769	80
769	56
769	79
769	84
769	54
769	81
769	85
769	62
769	61
769	60
769	58
769	66
769	74
769	77
769	73
769	78
769	72
769	70
769	55
769	71
769	59
769	82
769	69
769	68
531	78
531	53
379	62
379	70
379	84
379	67
399	76
399	70
399	62
399	81
414	70
414	81
414	62
414	76
417	62
417	84
417	81
430	81
430	62
430	70
430	76
1052	62
1052	84
1052	68
507	70
507	62
507	76
520	70
1549	66
1549	61
415	70
415	66
362	72
362	55
1157	53
1157	66
1157	55
1157	70
1157	83
1157	56
1157	75
770	83
770	55
770	69
770	73
770	78
404	62
404	70
404	67
404	76
415	76
415	62
415	81
500	56
780	84
402	70
402	84
402	76
402	63
804	52
1531	66
500	55
500	66
1532	66
1552	66
1554	66
1551	55
1551	66
1505	83
1538	66
1161	66
1602	66
1605	55
1605	66
1605	77
1605	78
1605	83
1606	66
416	63
416	54
416	84
416	66
416	70
1408	84
1612	66
1607	66
1615	66
1616	66
1617	66
1414	84
1624	66
1416	75
1418	84
1419	75
1625	66
1628	66
1628	62
1630	66
1631	66
1425	72
1635	66
1427	77
1428	75
1636	66
1355	64
1356	64
1356	84
1356	83
1356	66
1356	55
451	83
451	55
1159	68
1159	73
1159	55
1159	81
451	53
1258	67
1258	66
1258	53
1258	64
1258	83
1159	67
1159	66
1159	83
303	55
303	53
303	70
303	63
303	62
303	72
303	75
303	73
303	60
303	52
303	54
303	64
303	58
303	71
303	78
303	59
303	84
303	74
303	82
303	81
303	83
303	56
303	68
303	77
303	69
303	57
303	65
303	61
303	79
303	76
303	67
303	85
303	80
303	66
1452	57
1452	62
1452	64
1452	67
1452	74
1452	70
1452	81
1452	66
1452	82
1452	77
1452	63
1258	72
1258	78
1258	70
1258	69
1258	84
1202	70
1202	78
1202	66
1202	84
1202	53
1159	78
1159	56
1159	70
1452	76
1452	52
1452	68
1452	69
1452	85
1452	61
1452	84
1452	78
1452	54
1452	59
1452	58
1452	83
1452	79
1452	56
1452	73
1452	55
1452	53
1452	75
1452	60
1452	71
1452	65
1452	80
1452	72
1357	66
808	83
808	70
808	52
808	75
784	70
784	53
784	81
784	66
784	82
784	67
1164	66
1164	55
1164	70
1164	56
1164	53
1164	83
1165	53
1165	55
1165	66
1165	67
1165	72
1165	83
1165	75
1165	70
1171	83
1171	67
1171	70
1171	53
1171	66
1171	84
1171	69
440	70
440	81
440	74
440	60
520	62
520	76
1053	62
1053	84
1053	54
1061	68
1061	84
1061	67
1061	62
1061	63
809	70
809	84
809	62
1429	62
493	85
493	82
493	70
514	76
514	70
515	70
515	84
518	70
518	84
521	84
521	70
1550	66
1507	66
1508	66
1506	66
1556	66
1632	66
1633	66
1171	55
1171	56
1171	72
787	83
787	55
787	84
787	60
787	67
787	69
787	53
1159	69
314	74
314	78
314	71
314	61
314	81
314	63
314	56
314	80
314	79
314	60
314	85
314	84
314	70
314	65
314	54
314	57
314	67
314	68
314	53
314	58
314	76
314	73
314	69
314	82
314	77
314	52
314	83
314	72
314	64
314	62
314	66
314	75
314	59
314	55
410	57
410	74
410	54
410	83
410	77
410	61
410	73
410	70
410	62
410	55
410	75
410	69
410	56
410	81
410	53
410	68
410	58
410	79
410	66
410	59
410	64
410	65
410	72
410	85
410	76
410	67
410	82
410	60
410	78
410	80
410	71
410	52
410	63
410	84
769	76
769	64
769	63
366	63
366	70
366	54
372	54
372	70
372	63
372	81
405	54
405	63
405	70
405	67
419	67
419	70
419	63
419	54
472	67
472	63
472	70
472	54
474	63
474	70
474	77
474	54
497	63
497	54
497	70
510	70
510	67
510	54
779	62
779	84
779	85
779	61
779	76
779	63
779	54
779	75
1152	84
1152	70
1152	54
1152	67
775	81
775	78
775	54
775	82
775	58
775	79
775	85
775	62
775	59
775	68
775	66
775	67
775	80
775	70
775	72
775	53
775	64
775	84
775	55
775	63
775	77
1203	84
1203	78
412	84
412	70
412	54
412	63
524	84
524	70
529	70
529	84
529	63
1203	55
1203	70
1203	53
1203	66
1203	72
1203	73
1203	76
1203	67
1203	83
959	66
959	55
959	72
959	77
959	83
959	73
959	78
959	53
1634	66
1619	66
1637	66
1652	66
1622	66
1703	66
1706	66
1710	66
1712	66
1713	66
1713	70
1714	66
1714	84
1704	66
477	70
477	84
477	54
477	63
499	67
499	70
499	54
499	63
655	77
655	66
655	68
655	79
655	70
655	56
655	58
655	61
655	54
655	67
655	76
655	78
655	60
655	64
655	62
655	73
655	59
774	55
774	62
774	82
774	68
774	77
774	67
774	70
774	54
774	63
774	83
774	76
774	59
774	79
774	64
774	85
774	72
774	84
774	60
1062	54
1062	70
1062	62
1062	60
1062	61
1062	76
1062	67
1062	58
1084	54
1084	76
1084	68
1084	58
1084	74
1084	63
1084	79
1084	64
1084	71
1084	84
1084	60
1084	67
1084	70
1084	61
1084	62
1088	79
1088	58
1088	74
1088	70
1088	54
1088	64
1088	78
1088	60
1088	61
1088	67
1088	62
1088	71
1088	73
1088	68
1088	63
1088	59
1088	76
1088	84
1063	74
1063	64
1063	61
1063	54
1063	63
1063	60
1063	71
1094	67
1094	63
1094	64
1094	58
1094	54
1094	55
1094	61
1094	84
1094	76
1094	60
1094	71
1094	70
1094	62
1094	79
1094	68
1410	54
317	70
317	84
317	77
317	63
526	84
526	70
1255	70
1071	78
1071	73
1071	70
1257	70
342	84
342	70
342	63
342	80
1638	66
1639	66
1653	66
1653	68
1705	66
1705	85
1707	66
1711	66
1715	66
1715	67
1715	59
1715	68
1715	58
1715	84
1715	70
\.


--
-- Data for Name: supplier_categories_aud; Type: TABLE DATA; Schema: public; Owner: slinkylinky
--

COPY public.supplier_categories_aud (rev, supplier_id, categories_id, revtype) FROM stdin;
1	302	68	0
1	302	79	0
1	302	70	0
1	302	60	0
1	304	75	0
1	304	55	0
1	304	83	0
1	304	70	0
1	305	85	0
1	305	70	0
1	305	63	0
1	305	58	0
1	306	81	0
1	306	76	0
1	306	70	0
1	306	67	0
1	307	72	0
1	307	67	0
1	307	66	0
1	308	62	0
1	308	76	0
1	308	64	0
1	308	84	0
1	309	72	0
1	309	66	0
1	309	67	0
1	310	64	0
1	310	70	0
1	310	76	0
1	310	81	0
1	311	70	0
1	311	67	0
1	311	54	0
1	311	84	0
1	312	76	0
1	312	62	0
1	312	70	0
1	312	81	0
1	313	55	0
1	313	77	0
1	314	74	0
1	314	70	0
1	314	60	0
1	316	71	0
1	316	55	0
1	316	70	0
1	317	70	0
1	317	63	0
1	317	84	0
1	317	77	0
1	318	77	0
1	318	67	0
1	318	70	0
1	319	55	0
1	320	70	0
1	320	73	0
1	323	72	0
1	323	70	0
1	323	58	0
1	323	68	0
1	324	70	0
1	324	76	0
1	324	67	0
1	324	77	0
1	326	83	0
1	326	69	0
1	327	55	0
1	327	72	0
1	328	78	0
1	328	70	0
1	328	73	0
1	328	55	0
1	329	76	0
1	329	62	0
1	329	70	0
1	329	64	0
1	330	55	0
1	330	77	0
1	330	72	0
1	331	70	0
1	331	63	0
1	331	54	0
1	331	84	0
1	332	76	0
1	332	62	0
1	332	70	0
1	332	67	0
1	334	70	0
1	334	84	0
1	334	67	0
1	334	64	0
1	335	63	0
1	335	54	0
1	335	70	0
1	335	84	0
1	336	76	0
1	336	67	0
1	336	70	0
1	337	70	0
1	337	73	0
1	338	76	0
1	338	62	0
1	338	70	0
1	338	67	0
1	339	77	0
1	339	67	0
1	339	70	0
1	340	70	0
1	341	63	0
1	341	54	0
1	341	70	0
1	341	84	0
1	342	63	0
1	342	70	0
1	342	84	0
1	342	80	0
1	343	76	0
1	343	70	0
1	343	77	0
1	343	62	0
1	345	76	0
1	345	62	0
1	345	70	0
1	345	81	0
1	346	70	0
1	346	63	0
1	346	54	0
1	346	84	0
1	347	76	0
1	347	62	0
1	347	70	0
1	347	81	0
1	348	59	0
1	348	76	0
1	349	71	0
1	349	55	0
1	349	70	0
1	350	78	0
1	350	73	0
1	350	70	0
1	351	53	0
1	351	70	0
1	351	61	0
1	351	81	0
1	352	54	0
1	352	63	0
1	352	70	0
1	352	81	0
1	353	70	0
1	353	63	0
1	353	54	0
1	354	55	0
1	354	72	0
1	355	76	0
1	355	70	0
1	355	81	0
1	355	62	0
1	356	76	0
1	356	62	0
1	356	70	0
1	356	84	0
1	357	76	0
1	357	62	0
1	357	70	0
1	357	64	0
1	358	70	0
1	358	67	0
1	358	77	0
1	358	54	0
1	359	76	0
1	359	62	0
1	359	70	0
1	359	81	0
1	360	76	0
1	360	70	0
1	360	81	0
1	360	62	0
1	361	70	0
1	361	84	0
1	361	64	0
1	362	72	0
1	362	55	0
1	363	83	0
1	363	55	0
1	363	70	0
1	363	84	0
1	365	76	0
1	365	62	0
1	365	70	0
1	365	84	0
1	366	70	0
1	366	63	0
1	366	54	0
1	367	76	0
1	367	62	0
1	367	70	0
1	367	84	0
1	368	70	0
1	368	54	0
1	368	63	0
1	368	84	0
1	369	63	0
1	369	54	0
1	369	70	0
1	370	63	0
1	370	81	0
1	370	70	0
1	370	54	0
1	371	76	0
1	371	62	0
1	371	70	0
1	371	64	0
1	372	63	0
1	372	70	0
1	372	54	0
1	372	81	0
1	373	76	0
1	373	70	0
1	373	77	0
1	373	62	0
1	374	70	0
1	374	76	0
1	374	83	0
1	374	81	0
1	375	70	0
1	375	54	0
1	375	67	0
1	375	81	0
1	376	58	0
1	376	68	0
1	376	70	0
1	377	84	0
1	377	70	0
1	377	80	0
1	378	67	0
1	378	64	0
1	379	70	0
1	379	62	0
1	379	67	0
1	379	84	0
1	380	84	0
1	380	70	0
1	380	82	0
1	381	64	0
1	381	81	0
1	381	84	0
1	381	70	0
1	382	76	0
1	382	70	0
1	382	67	0
1	382	77	0
1	383	76	0
1	383	70	0
1	383	68	0
1	384	76	0
1	384	62	0
1	384	70	0
1	384	81	0
1	385	76	0
1	385	70	0
1	385	68	0
1	386	76	0
1	386	62	0
1	386	70	0
1	386	81	0
1	387	77	0
1	387	67	0
1	387	84	0
1	387	70	0
1	388	76	0
1	388	70	0
1	388	67	0
1	388	62	0
1	389	76	0
1	389	59	0
1	389	70	0
1	389	62	0
1	390	76	0
1	390	62	0
1	390	70	0
1	390	81	0
1	391	84	0
1	391	70	0
1	391	80	0
1	392	84	0
1	392	70	0
1	392	81	0
1	393	76	0
1	393	70	0
1	393	67	0
1	393	81	0
1	394	70	0
1	394	66	0
1	394	77	0
1	394	67	0
1	395	70	0
1	395	73	0
1	397	76	0
1	397	62	0
1	397	70	0
1	397	64	0
1	398	71	0
1	398	61	0
1	398	70	0
1	398	55	0
1	399	76	0
1	399	62	0
1	399	70	0
1	399	81	0
1	400	56	0
1	400	55	0
1	400	72	0
1	401	55	0
1	402	70	0
1	402	76	0
1	402	63	0
1	402	84	0
1	403	76	0
1	403	62	0
1	403	70	0
1	404	76	0
1	404	62	0
1	404	70	0
1	404	67	0
1	405	63	0
1	405	54	0
1	405	70	0
1	405	67	0
1	406	70	0
1	406	76	0
1	406	74	0
1	406	84	0
1	407	76	0
1	407	62	0
1	407	70	0
1	407	81	0
1	408	70	0
1	408	76	0
1	408	67	0
1	408	81	0
1	409	63	0
1	409	54	0
1	409	70	0
1	409	81	0
1	410	63	0
1	410	70	0
1	410	54	0
1	410	84	0
1	411	85	0
1	411	61	0
1	411	70	0
1	412	70	0
1	412	63	0
1	412	54	0
1	412	84	0
1	413	54	0
1	413	63	0
1	413	70	0
1	413	81	0
1	414	76	0
1	414	62	0
1	414	70	0
1	414	81	0
1	415	76	0
1	415	62	0
1	415	70	0
1	415	81	0
1	416	70	0
1	416	63	0
1	416	54	0
1	416	84	0
1	417	84	0
1	417	62	0
1	417	81	0
1	418	76	0
1	418	62	0
1	418	70	0
1	418	81	0
1	419	70	0
1	419	63	0
1	419	54	0
1	419	67	0
1	420	70	0
1	420	68	0
1	420	63	0
1	420	58	0
1	421	64	0
1	421	70	0
1	421	61	0
1	422	56	0
1	422	52	0
1	422	55	0
1	422	83	0
1	423	78	0
1	423	73	0
1	423	70	0
1	425	76	0
1	425	62	0
1	425	70	0
1	425	81	0
1	426	76	0
1	426	62	0
1	426	70	0
1	426	84	0
1	427	77	0
1	427	67	0
1	427	70	0
1	428	70	0
1	428	63	0
1	428	67	0
1	428	81	0
1	429	70	0
1	429	68	0
1	429	64	0
1	429	62	0
1	430	76	0
1	430	62	0
1	430	70	0
1	430	81	0
1	431	70	0
1	431	63	0
1	431	54	0
1	431	84	0
1	432	70	0
1	432	55	0
1	432	84	0
1	432	67	0
1	433	55	0
1	433	83	0
1	433	70	0
1	433	81	0
1	434	84	0
1	434	70	0
1	434	81	0
1	435	67	0
1	435	83	0
1	436	82	0
1	436	70	0
1	436	83	0
1	437	83	0
1	437	81	0
1	438	55	0
1	438	72	0
1	438	71	0
1	440	60	0
1	440	74	0
1	440	70	0
1	440	81	0
1	441	75	0
1	441	70	0
1	441	55	0
1	441	83	0
1	442	70	0
1	442	63	0
1	442	54	0
1	442	84	0
1	443	70	0
1	443	60	0
1	443	67	0
1	443	83	0
1	444	68	0
1	444	70	0
1	444	58	0
1	444	67	0
1	445	55	0
1	445	83	0
1	445	70	0
1	445	81	0
1	446	60	0
1	446	70	0
1	446	81	0
1	447	70	0
1	447	60	0
1	447	81	0
1	448	83	0
1	448	84	0
1	449	52	0
1	449	72	0
1	449	70	0
1	450	64	0
1	450	81	0
1	450	70	0
1	451	55	0
1	451	83	0
1	452	75	0
1	452	55	0
1	452	83	0
1	452	70	0
1	453	83	0
1	453	55	0
1	453	57	0
1	454	75	0
1	454	70	0
1	454	55	0
1	454	83	0
1	455	60	0
1	455	70	0
1	455	81	0
1	456	70	0
1	456	61	0
1	456	60	0
1	457	83	0
1	457	55	0
1	457	75	0
1	458	75	0
1	458	70	0
1	458	60	0
1	458	83	0
1	459	83	0
1	459	72	0
1	460	81	0
1	461	55	0
1	461	83	0
1	462	55	0
1	462	70	0
1	462	75	0
1	462	61	0
1	463	55	0
1	464	55	0
1	464	75	0
1	465	70	0
1	465	67	0
1	466	70	0
1	466	67	0
1	466	55	0
1	467	72	0
1	467	83	0
1	468	75	0
1	468	55	0
1	468	84	0
1	469	81	0
1	469	83	0
1	469	55	0
1	470	85	0
1	470	70	0
1	470	81	0
1	471	76	0
1	471	62	0
1	471	70	0
1	472	70	0
1	472	63	0
1	472	54	0
1	472	67	0
1	473	64	0
1	473	70	0
1	473	67	0
1	474	70	0
1	474	63	0
1	474	54	0
1	474	77	0
1	475	56	0
1	475	72	0
1	475	66	0
1	476	76	0
1	476	70	0
1	476	66	0
1	476	81	0
1	477	70	0
1	477	63	0
1	477	54	0
1	477	84	0
1	478	79	0
1	478	70	0
1	478	81	0
1	478	67	0
1	479	54	0
1	479	70	0
1	479	63	0
1	479	81	0
1	480	64	0
1	480	70	0
1	481	76	0
1	481	62	0
1	481	70	0
1	481	81	0
1	482	55	0
1	482	70	0
1	483	70	0
1	483	76	0
1	483	62	0
1	484	75	0
1	484	55	0
1	484	83	0
1	485	70	0
1	485	60	0
1	486	75	0
1	486	83	0
1	486	55	0
1	486	60	0
1	488	83	0
1	489	78	0
1	489	55	0
1	490	75	0
1	490	66	0
1	490	61	0
1	490	70	0
1	491	75	0
1	491	66	0
1	491	61	0
1	491	70	0
1	492	75	0
1	492	66	0
1	492	61	0
1	492	70	0
1	493	70	0
1	493	85	0
1	493	82	0
1	494	55	0
1	494	72	0
1	495	76	0
1	495	62	0
1	495	70	0
1	496	84	0
1	496	62	0
1	496	70	0
1	497	70	0
1	497	63	0
1	497	54	0
1	498	84	0
1	498	70	0
1	499	70	0
1	499	63	0
1	499	54	0
1	499	67	0
1	500	67	0
1	500	70	0
1	501	63	0
1	501	70	0
1	502	82	0
1	503	75	0
1	503	61	0
1	503	70	0
1	504	70	0
1	504	61	0
1	505	55	0
1	505	75	0
1	506	75	0
1	506	55	0
1	506	83	0
1	507	76	0
1	507	70	0
1	507	62	0
1	508	67	0
1	508	70	0
1	508	77	0
1	509	52	0
1	509	56	0
1	510	54	0
1	510	67	0
1	510	70	0
1	511	52	0
1	511	56	0
1	512	55	0
1	512	73	0
1	513	70	0
1	513	64	0
1	514	76	0
1	514	70	0
1	515	84	0
1	515	70	0
1	516	58	0
1	516	68	0
1	517	59	0
1	517	66	0
1	518	84	0
1	518	70	0
1	519	70	0
1	520	70	0
1	520	76	0
1	520	62	0
1	521	70	0
1	521	84	0
1	522	57	0
1	523	78	0
1	523	57	0
1	523	55	0
1	524	84	0
1	524	70	0
1	525	84	0
1	525	70	0
1	526	84	0
1	526	70	0
1	527	70	0
1	527	60	0
1	528	60	0
1	528	70	0
1	529	70	0
1	529	63	0
1	529	84	0
1	530	83	0
1	530	55	0
1	531	55	0
1	531	78	0
1	532	59	0
1	532	70	0
1	533	75	0
1	534	75	0
1	534	61	0
1	534	70	0
1	535	55	0
1	536	64	0
1	537	83	0
1	537	55	0
1	538	58	0
1	538	68	0
1	539	74	0
1	539	75	0
1	540	75	0
1	540	61	0
1	540	70	0
1	396	75	0
1	396	55	0
1	396	83	0
1	396	70	0
1	315	70	0
1	315	63	0
1	315	54	0
1	315	68	0
1	322	70	0
1	322	55	0
1	322	67	0
1	344	84	0
1	344	70	0
1	344	80	0
1	439	55	0
1	439	75	0
1	439	83	0
1	303	78	0
1	303	73	0
1	303	55	0
1	321	77	0
1	321	70	0
1	321	67	0
1	333	77	0
1	333	67	0
1	333	55	0
1	487	70	0
1	487	60	0
1	487	63	0
1	424	55	0
1	424	72	0
1	325	70	0
1	325	73	0
1	652	70	0
1	652	62	0
1	652	84	0
1	652	54	0
1	652	66	0
1	652	58	0
1	652	73	0
1	652	55	0
1	364	76	0
1	364	70	0
1	364	67	0
1	364	81	0
1	653	61	0
1	653	74	0
1	653	60	0
1	654	54	0
1	654	58	0
1	654	62	0
1	654	63	0
1	654	64	0
1	654	66	0
1	654	67	0
1	654	68	0
1	654	70	0
1	654	76	0
1	654	79	0
1	655	54	0
1	655	56	0
1	655	58	0
1	655	59	0
1	655	60	0
1	655	61	0
1	655	62	0
1	655	66	0
1	655	67	0
1	655	68	0
1	655	70	0
1	655	73	0
1	655	76	0
1	655	77	0
1	655	78	0
1	655	79	0
1	655	64	0
1	340	67	0
1	401	72	0
1	460	83	0
239	702	56	0
239	702	52	0
260	752	67	0
260	752	84	0
260	752	62	0
260	752	61	0
260	752	70	0
262	754	54	0
262	754	83	0
262	754	60	0
262	754	77	0
262	754	69	0
262	754	57	0
262	754	55	0
262	754	66	0
299	654	55	0
587	758	84	0
587	758	67	0
587	758	62	0
587	758	64	0
587	758	63	0
587	758	70	0
587	758	54	0
599	760	70	0
599	760	67	0
601	761	55	0
601	761	72	0
603	762	56	0
603	762	70	0
603	762	73	0
603	762	82	0
603	762	62	0
603	762	55	0
603	762	52	0
606	763	57	0
606	763	78	0
606	763	55	0
608	764	75	0
608	764	55	0
608	764	71	0
610	765	70	0
610	765	60	0
706	769	64	0
706	769	85	0
706	769	62	0
706	769	73	0
706	769	84	0
706	769	70	0
706	769	60	0
706	769	72	0
706	769	55	0
706	769	61	0
706	769	79	0
706	769	77	0
706	769	54	0
706	769	69	0
706	769	66	0
706	769	78	0
706	769	53	0
706	769	71	0
706	769	63	0
706	769	74	0
706	769	80	0
706	769	83	0
706	769	67	0
706	769	82	0
706	769	81	0
706	769	56	0
706	769	75	0
706	769	59	0
706	769	76	0
706	769	58	0
706	769	68	0
708	770	73	0
708	770	78	0
708	770	83	0
708	770	55	0
708	770	69	0
710	771	85	0
710	771	66	0
710	771	69	0
710	771	58	0
710	771	64	0
710	771	68	0
710	771	77	0
710	771	67	0
710	771	83	0
710	771	59	0
710	771	81	0
710	771	70	0
710	771	53	0
710	771	54	0
710	771	56	0
710	771	62	0
710	771	73	0
710	771	79	0
710	771	82	0
710	771	78	0
710	771	76	0
710	771	84	0
710	771	55	0
710	771	63	0
712	772	59	0
712	772	62	0
712	772	69	0
712	772	70	0
712	772	54	0
712	772	55	0
712	772	58	0
712	772	73	0
712	772	83	0
712	772	60	0
712	772	67	0
712	772	63	0
715	773	54	0
715	773	77	0
715	773	55	0
715	773	66	0
715	773	59	0
715	773	53	0
715	773	83	0
715	773	72	0
719	774	63	0
719	774	54	0
719	774	68	0
719	774	67	0
719	774	85	0
719	774	55	0
719	774	72	0
719	774	60	0
719	774	62	0
719	774	77	0
719	774	76	0
719	774	64	0
719	774	59	0
719	774	70	0
719	774	79	0
719	774	83	0
719	774	84	0
719	774	82	0
721	775	58	0
721	775	80	0
721	775	85	0
721	775	82	0
721	775	62	0
721	775	63	0
721	775	84	0
721	775	59	0
721	775	66	0
721	775	68	0
721	775	53	0
721	775	70	0
721	775	78	0
721	775	54	0
721	775	72	0
721	775	81	0
721	775	67	0
721	775	55	0
721	775	64	0
721	775	79	0
721	775	77	0
724	776	79	0
726	777	79	0
729	778	53	0
729	778	55	0
729	778	83	0
729	778	67	0
729	778	82	0
729	778	84	0
729	778	70	0
731	779	63	0
731	779	61	0
731	779	84	0
731	779	76	0
731	779	62	0
731	779	75	0
731	779	85	0
731	779	54	0
733	780	84	0
735	781	62	0
735	781	59	0
737	782	62	0
737	782	59	0
739	783	55	0
739	783	82	0
746	784	81	0
746	784	82	0
746	784	70	0
746	784	53	0
746	784	67	0
746	784	66	0
747	785	83	0
747	785	70	0
747	785	63	0
747	785	84	0
747	785	66	0
747	785	55	0
747	785	60	0
747	785	59	0
747	785	82	0
747	785	67	0
749	786	66	0
749	786	70	0
749	786	64	0
749	786	60	0
749	786	55	0
749	786	67	0
749	786	82	0
749	786	62	0
749	786	63	0
753	787	70	0
753	787	67	0
753	787	60	0
753	787	69	0
753	787	84	0
753	787	55	0
753	787	75	0
753	787	83	0
802	303	66	0
811	802	73	0
811	802	75	0
811	802	55	0
811	802	81	0
811	802	82	0
811	802	67	0
811	802	70	0
811	802	83	0
811	802	53	0
811	802	63	0
811	802	76	0
813	803	60	0
813	803	63	0
813	803	58	0
813	803	64	0
813	803	55	0
813	803	83	0
813	803	53	0
816	804	52	0
822	808	83	0
822	808	52	0
822	808	75	0
822	808	70	0
824	809	70	0
824	809	62	0
824	809	84	0
852	347	67	0
852	347	73	0
852	347	59	0
852	347	58	0
855	852	70	0
855	852	67	0
855	852	84	0
910	902	55	0
910	902	77	0
911	903	75	0
911	903	67	0
912	904	67	0
912	904	75	0
913	905	67	0
913	905	70	0
913	905	84	0
917	906	71	0
917	906	67	0
918	907	73	0
918	907	83	0
918	907	55	0
918	907	78	0
919	908	72	0
919	908	55	0
920	909	84	0
920	909	75	0
920	909	78	0
920	909	55	0
920	909	67	0
982	303	59	0
983	702	59	0
1037	303	67	0
1530	952	55	0
1530	952	69	0
1530	952	57	0
1530	952	83	0
1597	953	65	0
1597	953	75	0
1597	953	67	0
1598	904	65	0
1599	954	75	0
1599	954	65	0
1599	954	67	0
1600	955	67	0
1600	955	75	0
1600	955	65	0
1601	956	65	0
1601	956	67	0
1601	956	75	0
1608	957	71	0
1608	957	75	0
1609	958	71	0
1609	958	75	0
1611	959	73	0
1611	959	78	0
1611	959	72	0
1611	959	83	0
1611	959	77	0
1611	959	55	0
2107	540	55	0
2154	778	68	0
2163	442	55	0
2168	442	73	0
2169	442	68	0
2248	531	59	0
2250	1002	78	0
2250	1002	83	0
2250	1002	82	0
2250	1002	55	0
2250	1002	75	0
2425	303	81	0
2664	540	58	0
2672	303	58	0
2685	316	68	0
2736	441	54	0
2742	441	56	0
2742	441	58	0
2743	316	56	0
2744	531	56	0
2744	531	58	0
2744	531	53	0
2745	500	66	0
2745	500	56	0
2745	500	81	0
2746	500	55	0
2836	959	53	0
2872	500	66	2
2872	500	81	2
2872	500	67	2
2872	500	70	2
3037	357	53	0
3037	357	55	0
3080	752	55	0
3129	1052	62	0
3129	1052	84	0
3129	1052	68	0
3130	1053	84	0
3130	1053	54	0
3130	1053	62	0
3133	1056	84	0
3134	1057	84	0
3137	1060	84	0
3138	1061	84	0
3138	1061	63	0
3138	1061	68	0
3138	1061	67	0
3138	1061	62	0
3139	1062	54	0
3139	1062	61	0
3139	1062	60	0
3139	1062	58	0
3139	1062	62	0
3139	1062	67	0
3139	1062	70	0
3139	1062	76	0
3140	1063	71	0
3140	1063	64	0
3140	1063	61	0
3140	1063	54	0
3140	1063	63	0
3140	1063	74	0
3140	1063	60	0
3307	1064	59	0
3307	1064	78	0
3307	1064	55	0
3307	1064	83	0
3307	1064	69	0
3320	803	81	0
3380	326	55	0
3465	1002	85	0
3667	392	55	0
3671	392	67	0
3671	392	59	0
3672	312	55	0
3673	312	58	0
3678	331	55	0
3725	489	83	0
3729	452	60	0
3729	452	78	0
3730	468	66	0
3730	468	60	0
3735	465	76	0
3735	465	66	0
3740	458	67	0
3740	458	55	0
3754	304	73	0
3757	328	58	0
3767	787	53	0
3767	787	66	0
3770	334	58	0
3770	334	60	0
3770	334	66	0
3770	334	68	0
3953	1065	65	0
3959	1002	65	0
4021	368	55	0
4045	451	53	0
4081	1071	70	0
4081	1071	73	0
4081	1071	78	0
4083	1072	75	0
4083	1072	55	0
4085	1073	55	0
4085	1073	60	0
4085	1073	75	0
4089	1075	76	0
4089	1075	70	0
4089	1075	60	0
4089	1075	62	0
4091	1076	84	0
4091	1076	67	0
4091	1076	70	0
4093	1077	75	0
4093	1077	66	0
4095	1078	68	0
4095	1078	58	0
4095	1078	63	0
4095	1078	60	0
4095	1078	64	0
4095	1078	59	0
4095	1078	70	0
4095	1078	73	0
4095	1078	78	0
4095	1078	79	0
4095	1078	67	0
4095	1078	76	0
4095	1078	66	0
4095	1078	62	0
4099	1080	62	0
4099	1080	67	0
4099	1080	74	0
4099	1080	79	0
4099	1080	63	0
4099	1080	61	0
4099	1080	58	0
4099	1080	64	0
4099	1080	84	0
4099	1080	60	0
4099	1080	66	0
4099	1080	70	0
4099	1080	78	0
4099	1080	68	0
4101	1081	79	0
4101	1081	64	0
4101	1081	77	0
4101	1081	63	0
4101	1081	84	0
4101	1081	67	0
4101	1081	76	0
4101	1081	59	0
4101	1081	78	0
4101	1081	61	0
4101	1081	58	0
4101	1081	60	0
4101	1081	66	0
4101	1081	74	0
4101	1081	70	0
4101	1081	62	0
4103	1082	60	0
4103	1082	61	0
4103	1082	70	0
4103	1082	84	0
4105	1083	61	0
4105	1083	67	0
4105	1083	70	0
4105	1083	75	0
4105	1083	59	0
4105	1083	64	0
4105	1083	66	0
4105	1083	68	0
4105	1083	79	0
4105	1083	58	0
4105	1083	60	0
4105	1083	62	0
4105	1083	63	0
4105	1083	71	0
4105	1083	76	0
4105	1083	84	0
4107	1084	54	0
4107	1084	84	0
4107	1084	71	0
4107	1084	76	0
4107	1084	79	0
4107	1084	60	0
4107	1084	63	0
4107	1084	58	0
4107	1084	74	0
4107	1084	68	0
4107	1084	64	0
4107	1084	62	0
4107	1084	61	0
4107	1084	67	0
4107	1084	70	0
4109	1085	61	0
4109	1085	60	0
4109	1085	64	0
4109	1085	71	0
4109	1085	63	0
4109	1085	62	0
4109	1085	70	0
4109	1085	84	0
4109	1085	66	0
4109	1085	67	0
4111	1086	63	0
4111	1086	84	0
4111	1086	70	0
4111	1086	61	0
4111	1086	71	0
4111	1086	74	0
4111	1086	55	0
4111	1086	58	0
4111	1086	60	0
4111	1086	62	0
4111	1086	67	0
4111	1086	64	0
4113	1087	75	0
4113	1087	55	0
4115	1088	60	0
4115	1088	68	0
4115	1088	61	0
4115	1088	54	0
4115	1088	62	0
4115	1088	67	0
4115	1088	73	0
4115	1088	84	0
4115	1088	78	0
4115	1088	74	0
4115	1088	59	0
4115	1088	79	0
4115	1088	58	0
4115	1088	63	0
4115	1088	70	0
4115	1088	64	0
4115	1088	76	0
4115	1088	71	0
4117	1089	70	0
4117	1089	76	0
4117	1089	58	0
4117	1089	68	0
4117	1089	62	0
4117	1089	79	0
4119	1090	76	0
4119	1090	68	0
4119	1090	62	0
4119	1090	70	0
4119	1090	67	0
4119	1090	78	0
4119	1090	84	0
4119	1090	60	0
4119	1090	61	0
4119	1090	77	0
4119	1090	54	0
4119	1090	55	0
4119	1090	58	0
4119	1090	71	0
4119	1090	74	0
4119	1090	73	0
4119	1090	79	0
4119	1090	63	0
4119	1090	64	0
4119	1090	59	0
4121	1091	83	0
4121	1091	70	0
4121	1091	75	0
4121	1091	55	0
4121	1091	69	0
4123	1092	60	0
4123	1092	84	0
4123	1092	75	0
4123	1092	64	0
4123	1092	67	0
4123	1092	55	0
4123	1092	63	0
4123	1092	54	0
4123	1092	70	0
4125	1093	60	0
4125	1093	74	0
4125	1093	64	0
4125	1093	69	0
4125	1093	67	0
4125	1093	66	0
4125	1093	63	0
4125	1093	68	0
4125	1093	70	0
4125	1093	78	0
4125	1093	59	0
4125	1093	58	0
4125	1093	73	0
4125	1093	76	0
4125	1093	77	0
4125	1093	54	0
4125	1093	84	0
4125	1093	79	0
4125	1093	62	0
4125	1093	71	0
4125	1093	55	0
4125	1093	61	0
4127	1094	61	0
4127	1094	64	0
4127	1094	58	0
4127	1094	68	0
4127	1094	84	0
4127	1094	71	0
4127	1094	76	0
4127	1094	60	0
4127	1094	79	0
4127	1094	55	0
4127	1094	70	0
4127	1094	54	0
4127	1094	63	0
4127	1094	62	0
4127	1094	67	0
4129	1095	67	0
4129	1095	76	0
4129	1095	63	0
4129	1095	64	0
4129	1095	70	0
4129	1095	74	0
4129	1095	62	0
4129	1095	60	0
4129	1095	84	0
4129	1095	71	0
4129	1095	61	0
4129	1095	79	0
4131	1096	75	0
4131	1096	83	0
4131	1096	69	0
4131	1096	55	0
4133	1097	70	0
4133	1097	54	0
4133	1097	62	0
4133	1097	58	0
4133	1097	61	0
4133	1097	63	0
4133	1097	68	0
4133	1097	60	0
4133	1097	64	0
4133	1097	67	0
4133	1097	84	0
4135	1098	66	0
4135	1098	54	0
4135	1098	55	0
4135	1098	67	0
4135	1098	68	0
4135	1098	74	0
4135	1098	75	0
4135	1098	71	0
4135	1098	73	0
4135	1098	76	0
4135	1098	84	0
4135	1098	59	0
4135	1098	62	0
4135	1098	63	0
4135	1098	60	0
4135	1098	61	0
4135	1098	70	0
4135	1098	64	0
4137	1099	75	0
4137	1099	66	0
4137	1099	67	0
4139	1100	70	0
4139	1100	55	0
4139	1100	67	0
4139	1100	75	0
4141	1101	55	0
4141	1101	67	0
4141	1101	70	0
4143	1102	60	0
4143	1102	67	0
4143	1102	55	0
4143	1102	63	0
4143	1102	64	0
4143	1102	68	0
4143	1102	58	0
4143	1102	73	0
4143	1102	62	0
4143	1102	70	0
4143	1102	54	0
4143	1102	59	0
4143	1102	71	0
4143	1102	79	0
4143	1102	61	0
4143	1102	76	0
4143	1102	84	0
4145	1103	77	0
4145	1103	70	0
4145	1103	63	0
4145	1103	84	0
4145	1103	62	0
4145	1103	54	0
4145	1103	68	0
4145	1103	76	0
4145	1103	58	0
4145	1103	60	0
4145	1103	67	0
4145	1103	64	0
4145	1103	61	0
4145	1103	74	0
4145	1103	79	0
4147	1104	59	0
4149	1105	55	0
4151	1106	60	0
4151	1106	70	0
4151	1106	61	0
4151	1106	63	0
4153	1107	60	0
4153	1107	61	0
4153	1107	63	0
4153	1107	59	0
4153	1107	70	0
4153	1107	67	0
4153	1107	55	0
4155	1108	59	0
4155	1108	67	0
4155	1108	61	0
4157	1109	70	0
4157	1109	60	0
4157	1109	67	0
4157	1109	71	0
4159	1110	70	0
4159	1110	61	0
4159	1110	84	0
4159	1110	71	0
4159	1110	60	0
4161	1111	70	0
4161	1111	71	0
4161	1111	60	0
4163	1112	62	0
4163	1112	77	0
4163	1112	68	0
4163	1112	67	0
4163	1112	70	0
4163	1112	76	0
4165	1113	55	0
4165	1113	59	0
4165	1113	77	0
4167	1114	72	0
4167	1114	70	0
4167	1114	74	0
4169	1115	61	0
4169	1115	62	0
4169	1115	68	0
4169	1115	76	0
4169	1115	64	0
4169	1115	67	0
4169	1115	63	0
4169	1115	70	0
4169	1115	74	0
4169	1115	75	0
4169	1115	60	0
4171	1116	76	0
4171	1116	72	0
4171	1116	81	0
4173	1117	61	0
4173	1117	69	0
4173	1117	53	0
4173	1117	55	0
4173	1117	60	0
4173	1117	62	0
4173	1117	67	0
4173	1117	70	0
4173	1117	59	0
4173	1117	71	0
4175	1118	74	0
4175	1118	61	0
4177	1119	61	0
4177	1119	59	0
4177	1119	70	0
4177	1119	84	0
4177	1119	74	0
4177	1119	78	0
4177	1119	60	0
4179	1120	56	0
4179	1120	66	0
4179	1120	82	0
4858	1152	54	0
4858	1152	67	0
4858	1152	70	0
4858	1152	84	0
4943	334	53	0
4945	349	53	0
5303	303	75	0
5303	303	72	0
5303	303	77	0
5303	303	74	0
5303	303	79	0
5303	303	76	0
5303	303	64	0
5303	303	69	0
5303	303	71	0
5303	303	68	0
5303	303	70	0
5303	303	83	0
5303	303	80	0
5303	303	85	0
5303	303	82	0
5303	303	84	0
5303	303	56	0
5303	303	61	0
5303	303	63	0
5303	303	60	0
5303	303	65	0
5303	303	62	0
5303	303	53	0
5303	303	52	0
5303	303	57	0
5303	303	54	0
5848	1153	75	0
5848	1153	63	0
5848	1153	67	0
5848	1153	68	0
5848	1153	84	0
5848	1153	66	0
5848	1153	55	0
5848	1153	56	0
5848	1153	64	0
5848	1153	70	0
5848	1153	83	0
6040	1156	66	0
6040	1156	67	0
6040	1156	70	0
6040	1156	53	0
6118	1157	53	0
6118	1157	70	0
6118	1157	55	0
6118	1157	75	0
6118	1157	56	0
6118	1157	66	0
6118	1157	83	0
6186	1159	55	0
6186	1159	73	0
6186	1159	69	0
6186	1159	70	0
6186	1159	56	0
6186	1159	66	0
6186	1159	68	0
6186	1159	78	0
6186	1159	81	0
6186	1159	67	0
6186	1159	83	0
6188	1160	73	0
6188	1160	56	0
6188	1160	74	0
6188	1160	72	0
6188	1160	75	0
6188	1160	53	0
6188	1160	66	0
6188	1160	69	0
6188	1160	58	0
6188	1160	67	0
6188	1160	83	0
6188	1160	71	0
6188	1160	55	0
6194	1163	66	0
6194	1163	53	0
6194	1163	70	0
6194	1163	83	0
6194	1163	55	0
6196	1164	56	0
6196	1164	55	0
6196	1164	66	0
6196	1164	83	0
6196	1164	70	0
6196	1164	53	0
6198	1165	70	0
6198	1165	55	0
6198	1165	67	0
6198	1165	53	0
6198	1165	75	0
6198	1165	72	0
6198	1165	83	0
6198	1165	66	0
6200	1166	66	0
6200	1166	70	0
6200	1166	67	0
6200	1166	83	0
6200	1166	84	0
6200	1166	75	0
6200	1166	72	0
6200	1166	69	0
6200	1166	55	0
6202	1167	66	0
6202	1167	72	0
6202	1167	67	0
6202	1167	83	0
6202	1167	53	0
6202	1167	55	0
6202	1167	69	0
6202	1167	70	0
6208	1170	66	0
6208	1170	83	0
6208	1170	81	0
6208	1170	55	0
6208	1170	70	0
6208	1170	64	0
6208	1170	69	0
6208	1170	84	0
6208	1170	53	0
6208	1170	67	0
6208	1170	74	0
6208	1170	72	0
6210	1171	70	0
6210	1171	55	0
6210	1171	67	0
6210	1171	66	0
6210	1171	84	0
6210	1171	56	0
6210	1171	69	0
6210	1171	53	0
6210	1171	72	0
6210	1171	83	0
6288	1202	70	0
6288	1202	78	0
6288	1202	84	0
6288	1202	66	0
6288	1202	53	0
6433	1203	78	0
6433	1203	73	0
6433	1203	53	0
6433	1203	70	0
6433	1203	72	0
6433	1203	66	0
6433	1203	55	0
6433	1203	83	0
6433	1203	84	0
6433	1203	67	0
6433	1203	76	0
6530	1204	73	0
6530	1204	83	0
6530	1204	56	0
6530	1204	72	0
6530	1204	58	0
6530	1204	70	0
6530	1204	53	0
6530	1204	69	0
6530	1204	55	0
6530	1204	67	0
6530	1204	84	0
6530	1204	66	0
6530	1204	77	0
6581	1255	70	0
6587	1256	70	0
6592	1257	70	0
6608	1258	53	0
6608	1258	70	0
6608	1258	69	0
6608	1258	66	0
6608	1258	64	0
6608	1258	67	0
6608	1258	83	0
6608	1258	78	0
6608	1258	84	0
6608	1258	72	0
6654	1302	66	0
6674	1303	62	0
6674	1303	75	0
6674	1303	63	0
6674	1303	67	0
6674	1303	83	0
6674	1303	73	0
6674	1303	74	0
6674	1303	69	0
6674	1303	81	0
6674	1303	53	0
6674	1303	68	0
6674	1303	80	0
6674	1303	56	0
6674	1303	82	0
6674	1303	77	0
6674	1303	84	0
6674	1303	54	0
6674	1303	59	0
6674	1303	64	0
6674	1303	58	0
6674	1303	60	0
6674	1303	52	0
6674	1303	76	0
6674	1303	61	0
6674	1303	85	0
6674	1303	66	0
6674	1303	78	0
6674	1303	55	0
6674	1303	70	0
6674	1303	72	0
7274	752	56	0
7274	752	58	0
7274	752	53	0
7332	1355	64	0
7339	1356	84	0
7339	1356	66	0
7339	1356	83	0
7339	1356	64	0
7339	1356	55	0
7354	1357	66	0
7503	1402	66	0
7507	1404	69	0
7509	1405	66	0
7513	1407	55	0
7515	1408	84	0
7517	1409	67	0
7519	1410	54	0
7521	1411	55	0
7523	1412	66	0
7525	1413	55	0
7527	1414	84	0
7529	1415	55	0
7531	1416	75	0
7535	1418	84	0
7537	1419	75	0
7539	1420	55	0
7541	1421	55	0
7543	1422	66	0
7545	1423	64	0
7547	1424	66	0
7549	1425	72	0
7551	1426	66	0
7553	1427	77	0
7555	1428	75	0
7557	1429	62	0
7636	314	66	0
7636	314	68	0
7636	314	55	0
7636	314	56	0
7636	314	58	0
7842	327	66	0
7842	327	70	0
10021	1452	57	0
10021	1452	62	0
10021	1452	64	0
10021	1452	67	0
10021	1452	74	0
10021	1452	70	0
10021	1452	81	0
10021	1452	66	0
10021	1452	82	0
10021	1452	77	0
10021	1452	63	0
10021	1452	76	0
10021	1452	52	0
10021	1452	68	0
10021	1452	69	0
10021	1452	85	0
10021	1452	61	0
10021	1452	84	0
10021	1452	78	0
10021	1452	54	0
10021	1452	59	0
10021	1452	58	0
10021	1452	83	0
10021	1452	79	0
10021	1452	56	0
10021	1452	73	0
10021	1452	55	0
10021	1452	53	0
10021	1452	75	0
10021	1452	60	0
10021	1452	71	0
10021	1452	65	0
10021	1452	80	0
10021	1452	72	0
10046	314	84	0
10046	314	85	0
10046	314	61	0
10046	314	62	0
10046	314	63	0
10046	314	64	0
10046	314	65	0
10046	314	67	0
10046	314	52	0
10046	314	53	0
10046	314	54	0
10046	314	57	0
10046	314	59	0
10046	314	76	0
10046	314	77	0
10046	314	78	0
10046	314	79	0
10046	314	80	0
10046	314	81	0
10046	314	82	0
10046	314	83	0
10046	314	69	0
10046	314	71	0
10046	314	72	0
10046	314	73	0
10046	314	75	0
10104	1453	63	0
10104	1453	59	0
10104	1453	58	0
10104	1453	78	0
10104	1453	56	0
10104	1453	82	0
10104	1453	72	0
10104	1453	69	0
10104	1453	60	0
10104	1453	64	0
10104	1453	66	0
10104	1453	77	0
10104	1453	83	0
10104	1453	76	0
10104	1453	85	0
10104	1453	70	0
10104	1453	57	0
10104	1453	67	0
10104	1453	52	0
10104	1453	79	0
10104	1453	65	0
10104	1453	54	0
10104	1453	71	0
10104	1453	68	0
10104	1453	80	0
10104	1453	74	0
10104	1453	73	0
10104	1453	81	0
10104	1453	84	0
10104	1453	75	0
10104	1453	53	0
10104	1453	55	0
10104	1453	61	0
10104	1453	62	0
10387	410	60	0
10387	410	61	0
10387	410	62	0
10387	410	64	0
10387	410	65	0
10387	410	66	0
10387	410	67	0
10387	410	52	0
10387	410	53	0
10387	410	55	0
10387	410	56	0
10387	410	57	0
10387	410	58	0
10387	410	59	0
10387	410	76	0
10387	410	77	0
10387	410	78	0
10387	410	79	0
10387	410	80	0
10387	410	81	0
10387	410	82	0
10387	410	83	0
10387	410	68	0
10387	410	69	0
10387	410	71	0
10387	410	72	0
10387	410	73	0
10387	410	74	0
10387	410	75	0
10387	410	85	0
10499	1502	77	0
10499	1502	75	0
10499	1502	60	0
10499	1502	71	0
10499	1502	81	0
10499	1502	78	0
10499	1502	53	0
10499	1502	67	0
10499	1502	66	0
10828	1503	66	0
10832	1505	83	0
10836	1507	66	0
11281	1509	71	0
11281	1509	72	0
11281	1509	83	0
11281	1509	84	0
11281	1509	69	0
11281	1509	75	0
11281	1509	66	0
11281	1509	70	0
11281	1509	76	0
11313	1516	66	0
11321	1520	75	0
11728	347	66	0
11729	324	66	0
11741	1524	66	0
11741	1524	60	0
11743	1525	66	0
11745	1526	66	0
11747	1527	66	0
11749	1528	66	0
11755	1531	66	0
11757	1532	66	0
11759	1533	66	0
11761	1534	66	0
11763	1535	66	0
11767	1537	66	0
11771	1539	66	0
11773	1540	55	0
11773	1540	59	0
11775	1541	66	0
11777	1542	75	0
11779	1543	66	0
11781	1544	66	0
11783	1545	66	0
11787	1547	66	0
11789	1548	66	0
12621	318	66	0
12622	1095	66	0
12623	349	66	0
12624	338	66	0
12625	340	66	0
12626	361	66	0
12627	365	66	0
12628	369	66	0
12629	373	66	0
12630	375	66	0
12631	382	66	0
12632	386	66	0
12633	390	66	0
12634	397	66	0
12635	407	66	0
12636	409	66	0
12637	415	66	0
12638	416	66	0
12639	425	66	0
12640	426	66	0
12641	434	66	0
12642	452	66	0
12643	481	66	0
12644	532	66	0
12645	322	66	0
12646	483	66	0
12647	392	66	0
12648	331	66	0
12649	441	66	0
12650	1086	66	0
12651	316	66	0
12652	328	66	0
12653	1256	66	0
12654	527	66	0
12655	525	66	0
12656	1089	66	0
12657	357	66	0
12658	312	66	0
12659	418	66	0
12902	500	66	0
13365	1549	66	0
13365	1549	61	0
13369	1551	55	0
13369	1551	66	0
13516	1552	66	0
13661	1554	66	0
13691	1550	66	0
13756	1538	66	0
13757	1161	66	0
13758	1508	66	0
13760	1506	66	0
13762	959	66	0
13763	1556	66	0
14510	1602	66	0
14740	1605	83	0
14740	1605	55	0
14740	1605	77	0
14740	1605	78	0
14740	1605	66	0
14840	1606	66	0
15621	1612	66	0
15941	1607	66	0
16152	1615	66	0
16154	1616	66	0
16156	1617	66	0
16160	1619	66	0
16166	1622	66	0
16190	1624	66	0
16192	1625	66	0
16382	1628	66	0
16382	1628	62	0
16390	1630	66	0
16392	1631	66	0
16394	1632	66	0
16396	1633	66	0
16398	1634	66	0
16400	1635	66	0
16404	1636	66	0
17059	1637	66	0
17061	1638	66	0
17063	1639	66	0
17394	1652	66	0
17396	1653	66	0
17396	1653	68	0
17398	1654	66	0
17925	1703	66	0
17940	1704	66	0
17943	1705	66	0
17943	1705	85	0
17950	1706	66	0
17952	1707	66	0
17958	1710	66	0
17960	1711	66	0
17979	1712	66	0
18031	1713	66	0
18031	1713	70	0
18150	1714	66	0
18150	1714	84	0
18161	1715	84	0
18161	1715	68	0
18161	1715	70	0
18161	1715	66	0
18161	1715	59	0
18161	1715	67	0
18161	1715	58	0
\.


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
-- Name: category uk46ccwnsi9409t36lurvtyljak; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT uk46ccwnsi9409t36lurvtyljak UNIQUE (name);


--
-- Name: black_listed_supplier ukb9rjxhwahqtfklf7ubammbuoh; Type: CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.black_listed_supplier
    ADD CONSTRAINT ukb9rjxhwahqtfklf7ubammbuoh UNIQUE (domain);


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
-- Name: idx46ccwnsi9409t36lurvtyljak; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idx46ccwnsi9409t36lurvtyljak ON public.category USING btree (name);


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
-- Name: idxjh6ueu99didab475jafjxvsut; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxjh6ueu99didab475jafjxvsut ON public.supplier USING btree (da);


--
-- Name: idxr9ii2bdptwiwljggtkn44ygkg; Type: INDEX; Schema: public; Owner: slinkylinky
--

CREATE INDEX idxr9ii2bdptwiwljggtkn44ygkg ON public.supplier USING btree (domain);


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
-- Name: category_aud fkc9m640crhsib2ws80um6xuk1w; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.category_aud
    ADD CONSTRAINT fkc9m640crhsib2ws80um6xuk1w FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: supplier_aud fkd8mhbb2j0c9woft7uaik3opek; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_aud
    ADD CONSTRAINT fkd8mhbb2j0c9woft7uaik3opek FOREIGN KEY (rev) REFERENCES public.revinfo(rev);


--
-- Name: supplier_categories fkk2mqj6ffc0ppgcpw7w40n3kbm; Type: FK CONSTRAINT; Schema: public; Owner: slinkylinky
--

ALTER TABLE ONLY public.supplier_categories
    ADD CONSTRAINT fkk2mqj6ffc0ppgcpw7w40n3kbm FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- PostgreSQL database dump complete
--

\unrestrict bbLUnxxji6QLsk1gg6mtnpAWMPtxWfyV6BxAX2I2gwKiyq8a2xRDrhyMQ3e9QJ4

