--
-- PostgreSQL database dump
--

\restrict 5Vyd2KhCJhz01bTyiJgpmDXgMgHKVxZAmnftsGuTKzEXz3vUqORMm5gv6NrltdX

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg13+2)
-- Dumped by pg_dump version 18.1 (Debian 18.1-1.pgdg13+2)

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
102	asdf	rdomloge@gmail.com	t	rdomloge@gmail.com	1
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
316	historical	30	f	newvalleynews.co.uk	karl@newvalleynews.co.uk	Karl	f	system	50	£	www.newvalleynews.co.uk	Fatjoe	0	1764558012471	12
483	historical	29	f	packthepjs.com	tracey@packthepjs.com	Tracey	f	system	80	£	http://www.packthepjs.com/	Fatjoe	0	1764558019052	10
1425	frontpage.ga@gmail.com	32	f	lobsterdigitalmarketing.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	lobsterdigitalmarketing.co.uk	inbound	1730297780739	1751338801369	5
1090	sam.b@frontpageadvantage.com	70	f	markmeets.com	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	markmeets.com	Inbound	1719320639079	1754017204165	6
652	chris.p@frontpageadvantage.com	30	f	gemmalouise.co.uk	gemma@gemmalouise.co.uk	Gemma	f	system	80	£	https://gemmalouise.co.uk/	inbound email	0	1754017211069	8
1157	james.p@frontpageadvantage.com	33	t	englishlush.com	david.linkedbuilders@gmail.com	David	f	chris.p@frontpageadvantage.com	10	$	http://englishlush.com/	James	1725966904913	1727789891750	2
356	historical	45	t	sorry-about-the-mess.co.uk	chloebridge@gmail.com	Chloe Bridge	f	chris.p@frontpageadvantage.com	60	£	https://sorry-about-the-mess.co.uk	Fatjoe	0	1708424380177	2
439	historical	66	t	timebusinessnews.com	minalkh124@gmail.com	Maryam bibi	f	michael.l@frontpageadvantage.com	25	£	timebusinessnews.com	Inbound email	0	1708596721953	2
763	sam.b@frontpageadvantage.com	88	t	benzinga.com	falcobliek@gmail.com	Falco	f	james.p@frontpageadvantage.com	130	£	https://www.benzinga.com/	Inbound	1708616008102	1745919843705	3
1720	millie.t@frontpageadvantage.com	73	f	mayfair-london.co.uk	info@soho-london.co.uk	MayFair London	f	system	360	£	https://www.mayfair-london.co.uk/	Tanya	1764668455388	1764668458582	1
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
1053	michael.l@frontpageadvantage.com	29	t	emmareed.net	admin@emmareed.net	Emma Reed	f	james.p@frontpageadvantage.com	100	£	https://emmareed.net/	Outbound Facebook	1716451545373	1745921818989	8
1076	sam.b@frontpageadvantage.com	32	f	wellbeingmagazine.com	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	wellbeingmagazine.com	Inbound	1719318364944	1761966020510	6
1077	sam.b@frontpageadvantage.com	50	t	algarvedailynews.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	175	£	algarvedailynews.com	Inbound	1719318416922	1745923141215	4
852	sam.b@frontpageadvantage.com	37	t	golfnews.co.uk	kenditoys.com@gmail.com	David warner	f	james.p@frontpageadvantage.com	125	£	https://golfnews.co.uk/	Outbound	1709645596330	1745923529030	2
1170	james.p@frontpageadvantage.com	50	f	nerdbot.com	sofiakahn06@gmail.com	Sofia	f	system	150	$	nerdbot.com	James	1726065836927	1764558021705	7
1154	james.p@frontpageadvantage.com	32	f	fabcelebbio.com	support@linksposting.com	Links Posting	f	system	40	$	https://fabcelebbio.com/	James	1723728287666	1764558022507	5
1074	sam.b@frontpageadvantage.com	37	f	fivelittledoves.com	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	fivelittledoves.com	Inbound	1719318261939	1764558023739	5
1054	michael.l@frontpageadvantage.com	26	f	flydriveexplore.com	Hello@flydrivexexplore.com	Marcus Williams 	f	system	80	£	https://www.flydriveexplore.com/	Outbound Facebook	1716451807667	1764558024319	7
1075	sam.b@frontpageadvantage.com	37	f	tobyandroo.com	katherine@orangeoutreach.com	Katherine Williams	f	system	150	£	tobyandroo.com	Inbound	1719318317308	1748746818193	4
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
1427	frontpage.ga@gmail.com	25	f	shelllouise.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	shelllouise.co.uk	inbound	1730297857266	1764558027658	7
1066	chris.p@frontpageadvantage.com	28	f	timesinternational.net	\N	Fatjoe	t	chris.p@frontpageadvantage.com	130	£	https://timesinternational.net	\N	1718109368739	1718356477146	1
1307	james.p@frontpageadvantage.com	42	f	b31.org.uk	\N	Click Intelligence	t	james.p@frontpageadvantage.com	180	£	https://b31.org.uk	\N	1727789991606	1728378370976	1
1523	frontpage.ga@gmail.com	36	f	ventstimes.co.uk	ventstimesofficial@gmail.com	Vents Times	f	system	80	£	Ventstimes.co.uk	inboud	1742853030124	1759287631122	3
1305	james.p@frontpageadvantage.com	56	f	budgetsavvydiva.com	\N	Rhino Rank	t	james.p@frontpageadvantage.com	0	\N	https://www.budgetsavvydiva.com	\N	1727789968431	1728563534667	3
1354	frontpage.ga@gmail.com	55	t	couponfollow.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	chris.p@frontpageadvantage.com	25	£	https://couponfollow.co.uk/	inbound	1729769295496	1729855125410	2
1353	frontpage.ga@gmail.com	63	t	uvenco.co.uk	arianne@timewomenflag.com	Arianna Volkova	f	chris.p@frontpageadvantage.com	25	£	uvenco.co.uk	inbound	1729768339748	1729855146460	2
1422	frontpage.ga@gmail.com	30	t	taketotheroad.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	139	£	taketotheroad.co.uk	inbound	1730297665873	1745923325473	4
1614	millie.t@frontpageadvantage.com	74	f	manilatimes.net	advertise@mintymarketing.co.uk	Minty	f	system	80	$	https://www.manilatimes.net/	Tanya	1754479907265	1761966025596	2
1512	frontpage.ga@gmail.com	33	f	techranker.co.uk	 agencystarseo@gmail.com	TRK	f	system	80	£	TechRanker.co.uk	inbound	1742851181353	1761966027318	2
1155	james.p@frontpageadvantage.com	38	t	forbesnetwork.co.uk	sophiadaniel.co.uk@gmail.com	Forbes Network	f	chris.p@frontpageadvantage.com	70	£	https://forbesnetwork.co.uk/	James	1724849151681	1741259564248	4
1416	frontpage.ga@gmail.com	33	f	smallcapnews.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	158	£	Smallcapnews.co.uk	inbound	1730297416645	1754017221567	3
1417	frontpage.ga@gmail.com	33	t	journaloftradingstandards.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	103	£	journaloftradingstandards.co.uk	inbound	1730297448496	1749133969274	4
764	sam.b@frontpageadvantage.com	94	t	yahoo.com	ela690000@gmail.com	Ella	f	james.p@frontpageadvantage.com	125	£	https://news.yahoo.com/	Inbound	1708616228406	1727187207276	2
1452	james.p@frontpageadvantage.com	32	f	lifeloveanddirtydishes.com	claire_ruan@hotmail.com	Claire	f	system	55	£	https://lifeloveanddirtydishes.com/	James	1738749807697	1764558025310	3
1256	frontpage.ga@gmail.com	35	f	theeverydayman.co.uk	mail@theeverydayman.co.uk	The Everyday Man	f	system	150	£	https://theeverydayman.co.uk/	Hannah	1726827443560	1764558028288	6
1520	frontpage.ga@gmail.com	33	f	exclusivetoday.co.uk	onikawallerson.ot@gmail.com	Exclusive Today	f	system	80	£	exclusivetoday.co.uk	inboud	1742852390702	1748746821350	2
1518	frontpage.ga@gmail.com	29	f	guestmagazines.co.uk	megazines04@gmail.com	guest magazines	f	system	80	£	Guestmagazines.co.uk	inbound	1742852067954	1764558031919	5
1426	frontpage.ga@gmail.com	31	t	joannedewberry.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	122	£	joannedewberry.co.uk	inbound	1730297811663	1745923331524	3
903	sam.b@frontpageadvantage.com	52	t	therugbypaper.co.uk	backlinsprovider@gmail.com	David Smith 	f	james.p@frontpageadvantage.com	115	£	www.therugbypaper.co.uk	Inbound	1709718136681	1745923533754	6
1057	michael.l@frontpageadvantage.com	49	f	eccentricengland.co.uk	Ewilson1066@gmail.com 	Elaine Wilson 	f	system	150	£	https://eccentricengland.co.uk/	Outbound Facebook	1716452525532	1746068419097	3
1087	sam.b@frontpageadvantage.com	48	f	dailybusinessgroup.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	140	£	dailybusinessgroup.co.uk	Inbound	1719320401710	1748746823745	5
1507	frontpage.ga@gmail.com	40	t	interview-coach.co.uk	margaret@interview-coach.co.uk	MargaretBUJ	f	james.p@frontpageadvantage.com	75	£	interview-coach.co.uk	inbound	1741271187248	1749133907234	2
1506	frontpage.ga@gmail.com	51	f	techktimes.co.uk	Techktimes.official@gmail.com	Teck k times	f	james.p@frontpageadvantage.com	75	£	techktimes.co.uk	inbound	1741271054422	1749198395339	2
1067	chris.p@frontpageadvantage.com	0	f	\N	\N	test	t	\N	0	\N	\N	\N	1718272062687	1718272062687	0
1097	sam.b@frontpageadvantage.com	31	t	strikeapose.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://www.strikeapose.co.uk/	Inbound	1719396496757	1722930132941	2
1721	millie.t@frontpageadvantage.com	21	f	talesfrommamaville.com	talesfrommamaville@gmail.com	Nicole	f	system	100	£	http://talesfrommamaville.com/	Millie	1764675598960	1764675601906	1
1306	james.p@frontpageadvantage.com	47	f	phoenixfm.com	\N	Click Intelligence	t	james.p@frontpageadvantage.com	180	£	https://www.phoenixfm.com	\N	1727789980135	1728378333390	1
1099	sam.b@frontpageadvantage.com	36	t	seriousaboutrl.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	140	£	https://www.seriousaboutrl.com/	Inbound	1719396643226	1722930140795	3
459	historical	56	t	digitalengineland.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	120	£	digitalengineland.com	Inbound email	0	1718366902112	3
1100	sam.b@frontpageadvantage.com	36	t	pharmacy.biz	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	104	£	https://www.pharmacy.biz/	Inbound	1719396696751	1722930147855	2
757	chris.p@frontpageadvantage.com	27	f	respawning.co.uk	\N	Fatjoe	t	chris.p@frontpageadvantage.com	80	£	https://respawning.co.uk	\N	1708088289766	1709287346849	1
524	historical	38	t	travelbeginsat40.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	100	£	www.travelbeginsat40.com	Inbound Sam	0	1745924322601	7
1101	sam.b@frontpageadvantage.com	67	t	pitchero.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	48	£	https://www.pitchero.com/	Inbound	1719396748047	1722930153401	2
1061	michael.l@frontpageadvantage.com	58	t	minimeandluxury.co.uk	Hello@minimeandluxury.co.uk	Sarah Dixon 	f	james.p@frontpageadvantage.com	100	£	https://www.minimeandluxury.co.uk/	Outbound Facebook	1716453125082	1745921823275	4
1102	sam.b@frontpageadvantage.com	47	t	yourthurrock.com	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	120	£	https://www.yourthurrock.com/	Inbound	1719396805201	1722930162387	2
1103	sam.b@frontpageadvantage.com	34	t	mummyfever.co.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	160	£	https://mummyfever.co.uk/	Inbound	1719396859158	1722930178715	2
902	sam.b@frontpageadvantage.com	32	t	trainingexpress.org.uk	kenditoys.com@gmail.com	David warner	f	james.p@frontpageadvantage.com	150	£	https://trainingexpress.org.uk/	Inbound	1709717920944	1745919833481	8
1104	sam.b@frontpageadvantage.com	66	t	wlv.ac.uk	jagdish.linkbuilder@gmail.com	Jagdish Patel	f	james.p@frontpageadvantage.com	48	£	https://www.wlv.ac.uk/	Inbound	1719396923079	1722930184406	2
362	historical	37	f	hausmanmarketingletter.com	angie@hausmanmarketingletter.com	Angela Hausman	f	system	150	£	https://hausmanmarketingletter.com	Fatjoe	0	1764558035755	6
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
1161	james.p@frontpageadvantage.com	77	f	oddee.com	sofiakahn06@gmail.com	Sofia	f	system	150	$	oddee.com	James	1726058268387	1761966035501	4
1418	frontpage.ga@gmail.com	33	f	thisisbrighton.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	140	£	thisisbrighton.co.uk	inbound	1730297487047	1764558032605	2
959	chris.p@frontpageadvantage.com	48	f	talk-business.co.uk	backlinsprovider@gmail.com	David Smith	f	system	115	£	https://www.talk-business.co.uk/	Inbound	1711533031802	1764558036364	12
1056	michael.l@frontpageadvantage.com	26	f	flyingfluskey.com	rosie@flyingfluskey.com	Rosie Fluskey 	f	system	250	£	https://www.flyingfluskey.com	Outbound Facebook	1716452285003	1764558037645	10
1070	sam.b@frontpageadvantage.com	17	f	theautoexperts.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	125	£	theautoexperts.co.uk	Inbound	1719317894569	1764558038250	10
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
1419	frontpage.ga@gmail.com	34	f	familyfriendlyworking.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	106	£	familyfriendlyworking.co.uk	inbound	1730297531326	1764558041095	4
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
1203	james.p@frontpageadvantage.com	36	t	dollydowsie.com	fionanaughton.dollydowsie@gmail.com	Fiona	f	james.p@frontpageadvantage.com	70	£	http://www.dollydowsie.com/	James	1726241391467	1749134022625	3
1162	james.p@frontpageadvantage.com	72	t	cyprus-mail.com	sofiakahn06@gmail.com	Sofia	f	chris.p@frontpageadvantage.com	270	$	cyprus-mail.com	James	1726058412889	1749198071570	2
369	historical	36	f	thediaryofajewellerylover.co.uk	Mrsw@flydriveexplore.com	Mellissa Williams	f	system	60	£	https://www.thediaryofajewellerylover.co.uk/	Inbound email	0	1754017234190	6
489	historical	70	f	abcmoney.co.uk	advertise@abcmoney.co.uk	Claire James	f	system	60	£	www.abcmoney.co.uk	Inbound Sam	0	1754017236080	8
1527	frontpage.ga@gmail.com	56	t	ceocolumn.com	Support@gposting.com	Ceo Column	f	james.p@frontpageadvantage.com	40	£	CeoColumn.com	inboud	1744279699951	1745923189771	2
336	historical	41	t	midwifeandlife.com	Jenny@midwifeandlife.com	Jenny Lord	f	chris.p@frontpageadvantage.com	70	£	midwifeandlife.com	Fatjoe	0	1708424366153	2
302	historical	8	t	poocrazy.com	paul@moneytipsblog.co.uk	Paul	f	chris.p@frontpageadvantage.com	10	£	www.poocrazy.com	Inbound email	0	1708693689221	2
1412	frontpage.ga@gmail.com	39	t	kettlemag.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	130	£	kettlemag.co.uk	inbound	1730296980153	1745923318797	2
402	historical	58	t	mammaprada.com	mammaprada@gmail.com	Kristie Prada	f	chris.p@frontpageadvantage.com	90	£	https://www.mammaprada.com	Inbound email	0	1727944130012	7
1752	millie.t@frontpageadvantage.com	29	f	mrspinch.com	hello@makemoneywithoutajob.com	Emma	f	system	75	£	http://mrspinch.com/	Millie	1766411704731	1766411708585	1
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
1529	frontpage.ga@gmail.com	59	f	thebiographywala.com	support@linksposting.com 	The Biography Wala	f	system	40	£	Thebiographywala.com	inboud	1744279970120	1764558045446	3
486	historical	88	t	digitaljournal.com	sophiadaniel.co.uk@gmail.com	Sophia	f	james.p@frontpageadvantage.com	130	£	www.digitaljournal.com	Inbound Sam	0	1727187191791	2
1509	james.p@frontpageadvantage.com	31	f	countingtoten.co.uk	countingtotenblog@gmail.com	Kate	f	system	75	£	https://www.countingtoten.co.uk/	James - NEW	1742476076536	1742476079406	1
1513	frontpage.ga@gmail.com	38	f	load2learn.org.uk	infopool13@gmail.com	LOAD2LEARN	f	system	80	£	load2learn.org.uk	inbound	1742851433859	1742851436852	1
1411	frontpage.ga@gmail.com	38	t	businessvans.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	129	£	businessvans.co.uk	inbound	1730296950461	1745919855682	3
1081	sam.b@frontpageadvantage.com	38	t	emmysmummy.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	120	£	emmysmummy.com	Inbound	1719319784878	1745919995783	5
1519	frontpage.ga@gmail.com	38	f	myflexbot.co.uk	myflexbot11@gmail.com	My Flex Bot	f	system	80	£	myflexbot.co.uk	inbound	1742852226231	1761966045856	3
765	sam.b@frontpageadvantage.com	47	t	storymirror.com	ela690000@gmail.com	Ella	f	james.p@frontpageadvantage.com	96	£	https://storymirror.com/	Inbound	1708616408925	1745920616912	7
1071	sam.b@frontpageadvantage.com	31	t	makemoneywithoutajob.com	katherine@orangeoutreach.com	Katherine Williams	f	james.p@frontpageadvantage.com	150	£	makemoneywithoutajob.com	Inbound	1719318047364	1745924333662	8
1508	frontpage.ga@gmail.com	56	f	megalithic.co.uk	andy@megalithic.co.uk	The Megalithic Portal	f	system	80	£	megalithic.co.uk	inbound	1741271505305	1764558044380	4
1510	frontpage.ga@gmail.com	36	f	xatpes.co.uk	 xatpes.official@gmail.com	Xatapes	f	system	80	£	https://xatpes.co.uk/contact-us/	inbound	1742850929074	1764558046030	2
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
1164	james.p@frontpageadvantage.com	56	t	celebrow.org	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	30	$	celebrow.org	James	1726063207724	1745919310438	4
335	historical	24	t	lillaloves.com	lillaallahiary@gmail.com	Lilla	f	james.p@frontpageadvantage.com	20	£	Www.lillaloves.com	Fatjoe	0	1745919328923	7
344	historical	11	t	hellowanderer.co.uk	hellowandereruk@gmail.com	Chloe	f	chris.p@frontpageadvantage.com	25	£	http://www.hellowanderer.co.uk	Fatjoe	0	0	0
331	historical	32	f	hnmagazine.co.uk	angela@hnmagazine.co.uk	Angela Riches	f	system	40	£	www.hnmagazine.co.uk	Fatjoe	0	1759287652470	9
307	historical	13	t	peterwynmosey.com	contact@peterwynmosey.com	Peter	f	james.p@frontpageadvantage.com	15	£	peterwynmosey.com	Fatjoe	0	1718283964819	3
309	historical	15	t	annabelwrites.com	annabelwrites.blog@gmail.com	Annabel	f	james.p@frontpageadvantage.com	20	£	annabelwrites.com	Fatjoe	0	1718283984529	4
341	historical	17	t	sashashantel.com	contactsashashantel@gmail.com	Sasha Shantel	f	james.p@frontpageadvantage.com	60	£	http://www.sashashantel.com	Fatjoe	0	1745919339703	9
314	historical	18	f	thejournalix.com	thejournalix@gmail.com	Thomas	f	system	15	£	thejournalix.com	Fatjoe	0	1761966049161	10
346	historical	20	t	carouseldiary.com	Info@carouseldiary.com	Katrina	f	james.p@frontpageadvantage.com	40	£	Carouseldiary.com	Fatjoe	0	1745919342211	3
358	historical	22	t	thisbrilliantday.com	thisbrilliantday@gmail.com	Sophie Harriet	f	james.p@frontpageadvantage.com	50	£	https://thisbrilliantday.com/	Fatjoe	0	1745919349176	10
327	historical	26	t	startsmarter.co.uk	publishing@startsmarter.co.uk	Adam Niazi	f	james.p@frontpageadvantage.com	89	£	www.StartSmarter.co.uk	Fatjoe	0	1745919868182	9
1502	michael.l@frontpageadvantage.com	57	t	londondaily.news	sophiadaniel.co.uk@gmail.com	Sophia Daniel	f	chris.p@frontpageadvantage.com	65	£	https://www.londondaily.news/	Inbound Michael	1740053738291	1741259596936	3
305	historical	21	f	thethriftybride.co.uk	hello@thethriftybride.co.uk	Thirfty Bride	f	system	40	£	https://www.thethriftybride.co.uk	Fatjoe	0	1761966051334	12
351	historical	35	t	mycarheaven.com	Info@mycarheaven.com	Chris	f	james.p@frontpageadvantage.com	150	£	Www.mycarheaven.com	Fatjoe	0	1745921464059	4
311	historical	17	f	alifeoflovely.com	alifeoflovely@gmail.com	Lu	f	system	25	£	alifeoflovely.com	Fatjoe	0	1764558048960	9
312	historical	31	f	mmbmagazine.co.uk	INFO@MMBMAGAZINE.CO.UK	Abbie	f	system	165	£	mmbmagazine.co.uk	Fatjoe	0	1764558050109	14
308	historical	13	t	felifamily.com	suzied@felifamily.com	Suzie	f	james.p@frontpageadvantage.com	25	£	felifamily.com	Fatjoe	0	1745921761209	4
445	historical	61	t	networkustad.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	80	£	networkustad.com	Inbound email	0	1718366875618	2
318	historical	38	f	luckyattitude.co.uk	tanya@luckyattitude.co.uk	Tanya	f	system	150	£	luckyattitude.co.uk	Fatjoe	0	1764558051906	9
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
390	historical	30	f	bay-bee.co.uk	Stephi@bay-bee.co.uk	Steph Moore	f	system	115	£	https://blog.bay-bee.co.uk/	Inbound email	0	1761966058404	9
394	historical	38	f	skinnedcartree.com	corinne@skinnedcartree.com	Corinne	f	system	75	£	https://skinnedcartree.com	Inbound email	0	1740798119517	6
1634	millie.t@frontpageadvantage.com	20	f	thestrawberryfountain.com	thestrawberryfountain@hotmail.com	Terri Brown	f	system	100	£	http://www.thestrawberryfountain.com/	Millie	1755676747408	1764558054951	2
406	historical	28	f	rocknrollerbaby.co.uk	Rocknrollerbaby@hotmail.co.uk	Ruth Davies Knowles	f	system	116	£	Https://rocknrollerbaby.co.uk	Inbound email	0	1764558055983	10
397	historical	60	f	emmaplusthree.com	emmaplusthree@gmail.com	Emma Easton	f	system	100	£	www.emmaplusthree.com	Inbound email	0	1764558059275	6
380	historical	61	f	captainbobcat.com	Eva@captainbobcat.com	Eva Katona	f	system	180	£	Https://www.captainbobcat.com	Inbound email	0	1764558060331	10
365	historical	40	f	letstalkmommy.com	jenny@letstalkmommy.com	Jenny	f	james.p@frontpageadvantage.com	100	£	https://www.Letstalkmommy.com	Fatjoe	0	1745924997519	9
373	historical	32	f	kateonthinice.com	kateonthinice1@gmail.com	Kate Holmes	f	james.p@frontpageadvantage.com	75	£	kateonthinice.com	Inbound email	0	1745925007497	3
386	historical	52	f	intheplayroom.co.uk	Luciana@intheplayroom.co.uk	Anna marikar	f	james.p@frontpageadvantage.com	150	£	Intheplayroom.co.uk	Inbound email	0	1745925021805	6
408	historical	21	f	the-willowtree.com	Thewillowtreeblog@yahoo.com	Michelle O’Connor	f	system	75	£	Https://www.the-willowtree.com	Inbound email	0	1748746853843	10
1611	millie.t@frontpageadvantage.com	39	f	primmart.com	\N	Click intelligence	t	millie.t@frontpageadvantage.com	80	£	https://primmart.com	\N	1752139081370	1752743306163	1
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
425	historical	28	f	tantrumstosmiles.co.uk	tantrumstosmiles@outlook.com	Jess Howliston	f	system	75	£	www.tantrumstosmiles.co.uk	Facebook	0	1764558063464	12
416	historical	29	f	stylishlondonliving.co.uk	Micaelaburr@gmail.com	Micaela	f	system	100	£	https://www.stylishlondonliving.co.uk/	Facebook	0	1764558065692	13
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
484	historical	89	t	ibtimes.co.uk	i.perez@ibtmedia.co.uk	Inigo	f	james.p@frontpageadvantage.com	379	£	ibtimes.co.uk	inbound email	0	1745919794831	5
504	historical	29	t	westlondonliving.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	84	£	www.westlondonliving.co.uk	Inbound Sam	0	1745921475598	4
414	historical	20	t	joannavictoria.co.uk	joannabayford@gmail.com	Joanna Bayford	f	james.p@frontpageadvantage.com	50	£	https://www.joannavictoria.co.uk	Facebook	0	1745921795283	6
495	historical	63	t	welshmum.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	www.welshmum.co.uk	Inbound Sam	0	1745921808996	7
507	historical	34	t	toddleabout.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	toddleabout.co.uk	Inbound Sam	0	1745921813636	3
473	historical	24	t	earthlytaste.com	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	50	£	https://www.earthlytaste.com	inbound email	0	1745922813063	4
387	historical	29	t	onyourjourney.co.uk	Luciana@intheplayroom.co.uk	Anna marikar	f	james.p@frontpageadvantage.com	150	£	Onyourjourney.co.uk	Inbound email	0	1745923519025	7
1083	sam.b@frontpageadvantage.com	35	f	edinburgers.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	100	£	edinburgers.co.uk	Inbound	1719319963927	1764558069619	7
470	historical	22	t	realwedding.co.uk	hello@contentmother.com	Becky	f	james.p@frontpageadvantage.com	80	£	https://www.realwedding.co.uk	inbound email	0	1745924301567	8
501	historical	48	t	fashioncapital.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	132	£	www.fashioncapital.co.uk	Inbound Sam	0	1745924304457	3
493	historical	38	t	greenunion.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	www.greenunion.co.uk	Inbound Sam	0	1745924308171	8
487	historical	80	t	thefrisky.com	sophiadaniel.co.uk@gmail.com	Sophia	f	michael.l@frontpageadvantage.com	150	£	thefrisky.com	Inbound Sam	0	1708007305158	1
466	historical	66	t	swaay.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	220	£	swaay.com	Inbound email	0	1708424423842	2
479	historical	17	t	poppyandblush.com	hello@contentmother.com	Becky	f	chris.p@frontpageadvantage.com	45	£	http://poppyandblush.com	inbound email	0	1708424431847	1
480	historical	25	t	the-pudding.com	hello@contentmother.com	Becky	f	chris.p@frontpageadvantage.com	45	£	http://www.the-pudding.com	inbound email	0	1708424437246	2
490	historical	57	t	theedinburghreporter.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	168	£	theedinburghreporter.co.uk	Inbound Sam	0	1708424443094	2
492	historical	27	t	thedevondaily.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	120	£	www.thedevondaily.co.uk	Inbound Sam	0	1708424447248	2
498	historical	17	t	gonetravelling.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	84	£	gonetravelling.co.uk	Inbound Sam	0	1708424450853	2
506	historical	43	t	eagle.co.ug	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	114	£	eagle.co.ug	Inbound Sam	0	1708424454491	2
505	historical	28	f	talk-retail.co.uk	backlinsprovider@gmail.com	David Smith	f	system	95	£	talk-retail.co.uk	Inbound Sam	0	1764558070210	8
500	historical	38	f	pat.org.uk	hello@pat.org.uk	Sam	f	system	30	£	www.pat.org.uk	Inbound Sam	0	1764558070785	10
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
526	historical	46	t	puretravel.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	160	£	www.puretravel.com	Inbound Sam	0	1745924325200	6
532	historical	65	f	varsity.co.uk	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	150	£	www.varsity.co.uk	Inbound Sam	0	1745925100532	3
1168	james.p@frontpageadvantage.com	36	f	birdzpedia.com	sofiakahn06@gmail.com	Sofia	f	system	35	$	birdzpedia.com	James	1726065344402	1754017269626	8
525	historical	59	f	traveldailynews.com	backlinsprovider@gmail.com	David	f	james.p@frontpageadvantage.com	91	£	www.traveldailynews.com	Inbound Sam	0	1745925154271	5
409	historical	33	f	wannabeprincess.co.uk	Debzjs@hotmail.com	Debz	f	system	75	£	www.wannabeprincess.co.uk	Facebook	0	1754017271673	9
1635	millie.t@frontpageadvantage.com	35	f	thefrenchiemummy.com	cecile@thefrenchiemummy.com	Cecile 	f	system	107	£	https://thefrenchiemummy.com/	Millie	1755683084092	1755683087058	1
404	historical	22	t	whererootsandwingsentwine.com	rootsandwingsentwine@gmail.com	Elizabeth Williams	f	chris.p@frontpageadvantage.com	80	£	www.whererootsandwingsentwine.com	Inbound email	0	1727877493262	4
403	historical	54	f	sparklesandstretchmarks.com	Hayley@sparklesandstretchmarks.com	Hayley Mclean	f	system	100	£	Https://www.sparklesandstretchmarks.com	Inbound email	0	1722481606511	2
467	historical	58	f	underconstructionpage.com	minalkh124@gmail.com	Maryam bibi	f	system	230	£	http://underconstructionpage.com	Inbound email	0	1717211201824	2
437	historical	54	t	techbehindit.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	55	£	techbehindit.com	Inbound email	0	1718366857704	2
418	historical	36	f	amumreviews.co.uk	contact@amumreviews.co.uk	Petra	f	system	100	£	https://amumreviews.co.uk/	Facebook	0	1759287681863	11
497	historical	32	t	anythinggoeslifestyle.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	168	£	anythinggoeslifestyle.co.uk	Inbound Sam	0	1745919375611	9
1167	james.p@frontpageadvantage.com	60	t	stylesrant.org	sofiakahn06@gmail.com	Sofia	f	james.p@frontpageadvantage.com	30	$	stylesrant.org	James	1726063465343	1745919326196	3
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
1414	frontpage.ga@gmail.com	37	f	singleparentsonholiday.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	system	118	£	singleparentsonholiday.co.uk	inbound	1730297056465	1764558077363	5
455	historical	57	t	programminginsider.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	100	£	programminginsider.com	Inbound email	0	1718366889849	2
457	historical	54	t	techktimes.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	110	£	http://techktimes.com/	Inbound email	0	1718366898669	2
909	sam.b@frontpageadvantage.com	58	t	blogstory.co.uk	kenditoys.com@gmail.com	David warner 	f	chris.p@frontpageadvantage.com	125	£	https://blogstory.co.uk/	Inbound	1709720316064	1726056501919	3
511	historical	73	t	edinburgharchitecture.co.uk	fazal.akbar@digitalczars.io	Fazal	f	chris.p@frontpageadvantage.com	132	£	www.edinburgharchitecture.co.uk	Inbound Sam	0	1718367489944	3
449	historical	47	t	urbansplatter.com	minalkh124@gmail.com	Maryam bibi	f	chris.p@frontpageadvantage.com	85	£	https://www.urbansplatter.com/	Inbound email	0	1718367513245	3
539	historical	58	t	tamilworlds.com	natalilacanario@gmail.com	Natalila	f	chris.p@frontpageadvantage.com	150	£	Tamilworlds.com	Inbound Sam	0	1718975358204	3
508	historical	32	t	healthylifeessex.co.uk	fazal.akbar@digitalczars.io	Fazal	f	james.p@frontpageadvantage.com	120	£	healthylifeessex.co.uk	Inbound Sam	0	1745923531398	7
1629	millie.t@frontpageadvantage.com	29	f	rhianwestbury.co.uk	westburyrhian@gmail.com	Rhian	f	system	100	£	http://www.rhianwestbury.co.uk/	Millie	1755610853604	1764558080319	3
322	historical	33	f	5thingstodotoday.com	5thingstodotoday@gmail.com	David	f	system	45	£	5thingstodotoday.com	Fatjoe	0	1764558081091	8
407	historical	22	f	lukeosaurusandme.co.uk	lukeosaurusandme@gmail.com	Rachael Sheehan	f	system	50	£	https://lukeosaurusandme.co.uk	Inbound email	0	1764558081726	11
384	historical	35	f	chillingwithlucas.com	Chillingwithlucas@outlook.com	Jeni	f	system	150	£	Https://chillingwithlucas.com	Inbound email	0	1764558082791	9
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
1625	millie.t@frontpageadvantage.com	55	f	insequiral.com	hello@insequiral.com	Fiona	f	system	100	£	http://www.insequiral.com/	Millie	1754664916120	1754664919130	1
1514	frontpage.ga@gmail.com	38	f	dailywaffle.co.uk	sarah@dailywaffle.co.uk	DAILY WAFFLE	f	system	80	£	dailywaffle.co.uk	inbound	1742851604179	1742851607247	1
1505	frontpage.ga@gmail.com	38	t	pixwox.co.uk	 pixwoxx@gmail.com	Pixwox	f	james.p@frontpageadvantage.com	75	£	pixwox.co.uk	inbound	1741270951520	1749133683619	2
1623	millie.t@frontpageadvantage.com	34	f	mrsshilts.co.uk	emma.shilton@outlook.com	Emma Shilton	f	system	100	£	http://www.mrsshilts.co.uk/	Millie	1754570606930	1759287686244	2
1539	frontpage.ga@gmail.com	69	f	anationofmoms.com	PR@anationofmoms.com	A Nation Of Moms	f	system	50	£	anationofmoms.com	inboud	1744282455391	1764558086625	7
330	historical	37	f	robinwaite.com	robin@robinwaite.com	Robin Waite	f	system	42	£	https://www.robinwaite.com	Fatjoe	0	1764558090225	9
1517	frontpage.ga@gmail.com	58	f	ukjournal.co.uk	 Contact@ukjournal.co.uk	UK Journal	f	system	80	£	ukjournal.co.uk	inbound	1742852009295	1761966090745	5
1059	michael.l@frontpageadvantage.com	27	f	flashpackingfamily.com	flashpackingfamily@gmail.com	Jacquie Hale	f	system	150	£	https://flashpackingfamily.com/	Outbound Facebook	1716452853668	1748746873317	8
1542	frontpage.ga@gmail.com	47	f	prophecynewswatch.com	 Info@ProphecyNewsWatch.com	PNW	f	system	50	£	prophecynewswatch.com	inboud	1744283598194	1762052406585	2
1715	millie.t@frontpageadvantage.com	37	f	whatkatysaid.com	katy@whatkatysaid.com	katy	f	system	75	£	http://www.whatkatysaid.com/	Millie	1762792457787	1762792460729	1
1712	millie.t@frontpageadvantage.com	37	f	newsdipper.co.uk	calahlane3@gmail.com	News Dipper	f	system	50	£	https://newsdipper.co.uk/	Calah	1761816876951	1764558089003	2
1511	frontpage.ga@gmail.com	33	f	msnpro.co.uk	ankit@zestfulloutreach.com	MSN PRO	f	system	80	£	https://msnpro.co.uk/contact-us/	inbound	1742851051403	1764558091005	4
1407	frontpage.ga@gmail.com	41	t	themarketingblog.co.uk	arianne@timewomenflag.com	Arianne Volkova	f	james.p@frontpageadvantage.com	129	£	themarketingblog.co.uk	inbound	1730296672141	1745919858760	3
1543	frontpage.ga@gmail.com	45	t	ameyawdebrah.com	@ameyawdebrah.com. 	Ameyaw Debrah	f	james.p@frontpageadvantage.com	50	£	ameyawdebrah.com	inboud	1744287332432	1745923239296	2
1544	frontpage.ga@gmail.com	44	t	famerize.com	support@seolinkers.com	Fame Rize	f	james.p@frontpageadvantage.com	50	£	famerize.com	inbound 	1744287545928	1745923296483	2
1545	frontpage.ga@gmail.com	43	t	mcdmenumy.com	support@seolinkers.com	MCD Menu	f	james.p@frontpageadvantage.com	50	£	mcdmenumy.com	inboud	1744287627439	1745923299076	2
1547	frontpage.ga@gmail.com	41	t	talkinemoji.com	support@seolinkers.com	Talk in emoji	f	james.p@frontpageadvantage.com	50	£	talkinemoji.com	inboud	1744287848608	1745923301474	2
1521	frontpage.ga@gmail.com	44	f	grobuzz.co.uk	editorial@rankwc.com	GROBUZZ	f	system	80	£	grobuzz.co.uk	inboud	1742852543019	1764558092425	4
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
1714	millie.t@frontpageadvantage.com	23	f	thetraveldaily.co.uk	backlinsprovider@gmail.com	The Travel Daily David	f	system	85	£	https://www.thetraveldaily.co.uk/	David Smith 	1762790571756	1764644407489	2
1639	millie.t@frontpageadvantage.com	72	f	thelondoneconomic.com	backlinsprovider@gmail.com	London economic	f	system	370	£	http://thelondoneconomic.com/	David Smith 	1757598163477	1757598166665	1
1638	millie.t@frontpageadvantage.com	44	f	costaprices.co.uk	backlinsprovider@gmail.com	Costa Prices	f	system	85	$	https://costaprices.co.uk/	David Smith 	1757598029993	1759287697548	2
1504	frontpage.ga@gmail.com	26	f	infinityelse.co.uk	 infinityelse1@gmail.com	Infinity else	f	system	65	£	infinityelse.co.uk	inbound	1741270738337	1759287703075	7
1631	millie.t@frontpageadvantage.com	44	f	reelsmedia.co.uk	calahlane3@gmail.com	ReelsMedia	f	system	50	£	http://reelsmedia.co.uk/	Millie	1755675865921	1759287704339	2
771	chris.p@frontpageadvantage.com	42	f	finehomesandliving.com	info@fine-magazine.com	Fine Home Team	f	system	100	£	https://www.finehomesandliving.com/	outbound	1709027801990	1759287704924	8
1652	millie.t@frontpageadvantage.com	42	f	ukstartupmagazine.co.uk	jonathan@ukstartupmagazine.co.uk	Jonathon	f	system	300	£	https://www.ukstartupmagazine.co.uk/	Tanya	1759840271455	1759840274789	1
1654	millie.t@frontpageadvantage.com	42	f	midlandsbusinessnews.co.uk	amlivemanagement@hotmail.co.uk	Midlands Business News	f	system	40	£	https://midlandsbusinessnews.co.uk/contact/	Tanya	1759841564720	1759841567689	1
1705	millie.t@frontpageadvantage.com	53	f	boho-weddings.com	kelly@boho-weddings.com	Kelly	f	system	199	£	https://www.boho-weddings.com/	Tanya	1760948438416	1760948441367	1
1636	millie.t@frontpageadvantage.com	26	f	birdsandlilies.com	birdsandlilies@gmail.com	Louise	f	system	100	£	https://www.birdsandlilies.com/	Millie	1755848328859	1764558096863	2
1710	millie.t@frontpageadvantage.com	51	f	invisioncommunity.co.uk	backlinsprovider@gmail.com	David Invision Community	f	system	65	£	https://invisioncommunity.co.uk/	David Smith 	1761039824470	1761039827326	1
1711	millie.t@frontpageadvantage.com	40	f	racingbetter.co.uk	backlinsprovider@gmail.com	David Racing Better	f	system	60	£	https://racingbetter.co.uk/	David Smith 	1761039859361	1761039861995	1
1702	millie.t@frontpageadvantage.com	39	f	captionbio.co.uk	backlinsprovider@gmail.com	Captin Bio 	f	system	75	$	https://captionbio.co.uk/	David Smith	1760429536786	1761966103187	2
422	historical	34	f	ukconstructionblog.co.uk	advertising@ukconstructionblog.co.uk	Tom	f	system	75	£	https://ukconstructionblog.co.uk/	Google Search	0	1761966123996	7
1633	millie.t@frontpageadvantage.com	38	f	tubegalore.uk	calahlane3@gmail.com	Tube Galore	f	system	50	£	http://tubegalore.uk/	Millie	1755675994853	1761966125774	3
780	chris.p@frontpageadvantage.com	22	f	travelistia.com	travelistiausa@gmail.com	Ferona	f	system	27	£	https://www.travelistia.com/	outbound	1709033136922	1761966126969	14
1704	millie.t@frontpageadvantage.com	20	f	staceyinthesticks.com	stacey@staceyinthesticks.com	Stacey	f	millie.t@frontpageadvantage.com	40	£	www.staceyinthesticks.com	Millie	1760947883867	1763479614095	2
1716	millie.t@frontpageadvantage.com	34	f	theladybirdsadventures.co.uk	claire@theladybirdsadventures.co.uk	Claire	f	system	150	£	https://theladybirdsadventures.co.uk	Millie	1763981435400	1763981438335	1
1717	millie.t@frontpageadvantage.com	29	f	wedmagazine.co.uk	wed@wedmagazine.co.uk	Brendan	f	system	150	£	https://www.wedmagazine.co.uk/	Chris	1764086176499	1764086179396	1
1707	millie.t@frontpageadvantage.com	32	t	imhentai.co.uk	calahlane3@gmail.com	Im hen Tai	f	chris.p@frontpageadvantage.com	50	£	http://imhentai.co.uk/	Calah	1760967404074	1764257148502	2
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
1621	millie.t@frontpageadvantage.com	69	f	portotheme.com	calahlane3@gmail.com	Portotheme	f	system	80	£	https://www.portotheme.com/	Millie	1754566514837	1764558115424	3
1630	millie.t@frontpageadvantage.com	36	f	omgflix.co.uk	calahlane3@gmail.com	OmgFlix	f	system	50	£	https://www.omgflix.co.uk/author/sky-bloom-inc	Millie	1755675826171	1755675828961	1
1060	michael.l@frontpageadvantage.com	43	f	safarisafricana.com	jacquiehale75@gmail.com	Jacquie Hale	f	system	200	£	https://safarisafricana.com/	Outbound Facebook	1716452913891	1756695632083	6
502	historical	32	f	explorersagainstextinction.co.uk	fazal.akbar@digitalczars.io	Fazal	f	system	108	£	explorersagainstextinction.co.uk	Inbound Sam	0	1756695667173	10
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
1632	millie.t@frontpageadvantage.com	31	t	imagefap.uk	calahlane3@gmail.com	ImageFap	f	chris.p@frontpageadvantage.com	50	£	http://imagefap.uk/	Millie	1755675953072	1764257137351	4
1604	millie.t@frontpageadvantage.com	40	f	business-money.com	info@business-money.com	BusinessMoneyTeam	f	system	30	£	https://www.business-money.com/	Tanya	1751885774816	1751885777802	1
1606	millie.t@frontpageadvantage.com	23	f	indowapblog.com	contactsiteseo@gmail.com	French Blogger	f	system	25	€	https://indowapblog.com/	contactsiteseo@gmail.com	1751973800624	1751973803623	1
1531	frontpage.ga@gmail.com	38	f	everymoviehasalesson.com	everymoviehasalesson@gmail.com	Every Movie Has A Lesson	f	system	40	£	everymoviehasalesson.com	inboud	1744280420962	1761966116382	5
1619	millie.t@frontpageadvantage.com	56	t	indibloghub.com	calahlane3@gmail.com	Indibloghub	f	millie.t@frontpageadvantage.com	50	£	https://indibloghub.com/	Millie	1754566452647	1756820383164	2
1637	millie.t@frontpageadvantage.com	48	f	financial-news.co.uk	backlinsprovider@gmail.com	Financial News	f	system	110	£	http://financial-news.co.uk/	David Smith 	1757597977070	1757597980036	1
1158	james.p@frontpageadvantage.com	33	f	toptechsinfo.com	david.linkedbuilders@gmail.com	David	f	system	10	$	http://toptechsinfo.com/	James	1725966960853	1759287628170	8
1618	millie.t@frontpageadvantage.com	65	f	coda.io	calahlane3@gmail.com	Coda IO	f	system	90	£	https://coda.io/	Millie	1754566417149	1759287647875	2
1086	sam.b@frontpageadvantage.com	43	f	lovebelfast.co.uk	katherine@orangeoutreach.com	Katherine Williams	f	system	120	£	lovebelfast.co.uk	Inbound	1719320331730	1759287699650	4
1602	millie.t@frontpageadvantage.com	44	f	slummysinglemummy.com	jo@slummysinglemummy.com	Jo  	f	system	100	£	https://slummysinglemummy.com/	Millie	1750841059853	1759287709629	3
1603	millie.t@frontpageadvantage.com	42	f	uknip.co.uk	uknewsinpictures@gmail.com	UKnip	f	system	90	£	https://uknip.co.uk/		1751012371517	1761966118048	2
1550	millie.t@frontpageadvantage.com	33	f	lifeunexpected.co.uk	contact@mattbarltd.co.uk	Matt	f	system	75	£	https://www.lifeunexpected.co.uk/	Tanya	1747837279774	1761966119231	4
1605	millie.t@frontpageadvantage.com	14	f	tibbingtonconsulting.co.uk	info@globelldigital.com	Tibbington Consulting	f	system	25	£	https://www.tibbingtonconsulting.co.uk/	Tanya	1751886706863	1764558119546	2
382	historical	32	f	stressedmum.co.uk	sam@stressedmum.co.uk	Samantha Donnelly	f	system	80	£	https://stressedmum.co.uk	Inbound email	0	1764558123382	10
434	historical	18	f	arewenearlythereyet.co.uk	Chelseamamma@gmail.com	Kara Guppy	f	system	75	£	https://arewenearlythereyet.co.uk/	Facebook	0	1764558124574	10
1515	frontpage.ga@gmail.com	41	f	ranyy.com	aishwaryagaikwad313@gmail.com	Ranyy	f	system	80	£	ranyy.com	inbound	1742851725672	1764558126964	7
1718	millie.t@frontpageadvantage.com	27	f	investinginwomen.co.uk	elizabeth@investinginwomen.co.uk	Elizabeth	f	system	47	£	https://investinginwomen.co.uk/	Chris	1764148348201	1764148351090	1
1706	millie.t@frontpageadvantage.com	42	t	uknewstap.co.uk	calahlane3@gmail.com	Uk News Tap	f	chris.p@frontpageadvantage.com	55	£	http://uknewstap.co.uk/	Calah	1760967354015	1764257142644	2
1708	millie.t@frontpageadvantage.com	31	t	thestripesblog.co.uk	calahlane3@gmail.com	The Stripes Blog	f	chris.p@frontpageadvantage.com	55	£	thestripesblog.co.uk	Calah	1760967461561	1764257153285	2
1703	millie.t@frontpageadvantage.com	34	f	buzblog.co.uk	backlinsprovider@gmail.com	Buzz BLOG	f	system	68	$	https://buzblog.co.uk/	David Smith 	1760711132182	1764558101944	2
1713	millie.t@frontpageadvantage.com	29	f	accidentalhipstermum.com	accidentalhipstermum@gmail.com	Jenny	f	system	120	£	http://accidentalhipstermum.com/	Millie	1762252583668	1764558103480	2
1624	millie.t@frontpageadvantage.com	38	f	deepinmummymatters.com	mummymatters@gmail.com	Sabina	f	system	130	£	https://deepinmummymatters.com/	Millie	1754660310525	1764558105051	3
1626	millie.t@frontpageadvantage.com	58	f	lifeinabreakdown.com	sarah@lifeinabreakdown.com	Sarah	f	system	250	£	https://www.lifeinabreakdown.com/	Millie	1754665321436	1764558105640	3
1622	millie.t@frontpageadvantage.com	34	f	webstosociety.co.uk	calahlane3@gmail.com	websstosociety	f	system	85	£	https://webstosociety.co.uk/	Millie	1754566562692	1764558106838	6
1709	millie.t@frontpageadvantage.com	41	f	businesstask.co.uk	calahlane3@gmail.com	Business Task	f	system	50	£	https://businesstask.co.uk/	Calah	1760967514629	1764558107429	3
326	historical	18	f	cybergeekgirl.co.uk	lisa_ventura@outlook.com	Lisa Ventura MBE	f	system	30	£	https://www.cybergeekgirl.co.uk	Fatjoe	0	1764558109283	12
1719	millie.t@frontpageadvantage.com	27	f	rachelnicole.co.uk	rachel.nicole-x@hotmail.com	Rachel	f	system	75	£	https://www.rachelnicole.co.uk/	Chris	1764346277142	1764558128294	2
1653	millie.t@frontpageadvantage.com	18	f	houseandhomeideas.co.uk	info@houseandhomeideas.co.uk	House & Homes	f	rdomloge@gmail.com	20	£	https://www.houseandhomeideas.co.uk/	Tanya	1759840429117	1774034238385	5
303	historical	22	f	moneytipsblog.co.uk	paul@moneytipsblog.co.uk	This is Owned by Chris :-)	f	rdomloge@gmail.com	2	£	www.moneytipsblog.co.uk	Inbound email	0	1774639451153	20
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
1710	66
1712	66
1713	66
1713	70
1714	66
1714	84
1704	66
1716	66
1716	62
1716	70
1716	68
1718	66
1718	55
1632	66
1719	63
1719	70
1719	84
1719	54
1719	66
1720	66
1720	64
1720	71
1721	66
1752	66
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
1705	66
1705	85
1711	66
1715	66
1715	67
1715	59
1715	68
1715	58
1715	84
1715	70
1706	66
1707	66
1653	68
1653	66
1653	52
303	53
303	61
303	63
303	58
303	83
303	79
303	80
303	54
303	85
303	64
303	70
303	71
303	52
303	77
303	75
303	76
303	59
303	67
303	55
303	65
303	56
303	68
303	82
303	62
303	81
303	57
303	73
303	78
303	60
303	69
303	72
303	74
303	84
303	66
\.


--
-- PostgreSQL database dump complete
--

\unrestrict 5Vyd2KhCJhz01bTyiJgpmDXgMgHKVxZAmnftsGuTKzEXz3vUqORMm5gv6NrltdX

