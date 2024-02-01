update supplier delete column sem_rush_authority_score;
update supplier delete column sem_rush_uk_jan23traffic;
update supplier delete column sem_rush_uk_monthly_traffic;

alter table if exists category add column version bigint default 0;
create table category_aud (id bigint not null, rev integer not null, revtype smallint, created_by varchar(255), disabled boolean default false, name varchar(255), updated_by varchar(255), primary 
key (rev, id));

create table paid_link_aud (id bigint not null, rev integer not null, revtype smallint, supplier_id bigint, primary key (rev, id));
alter table if exists paid_link add column version bigint default 0;
alter table if exists proposal add column version bigint default 0;

create table proposal_aud (id bigint not null, rev integer not null, revtype smallint, article TEXT, blog_live boolean, content_ready boolean, created_by varchar(255), date_accepted_by_supplier timestamp(6), date_blog_live timestamp(6), date_created timestamp(6), date_invoice_paid timestamp(6), date_invoice_received timestamp(6), date_sent_to_supplier timestamp(6), invoice_paid boolean, invoice_received boolean, live_link_title varchar(255), live_link_url varchar(255), proposal_accepted boolean, proposal_sent boolean, updated_by varchar(255), primary key (rev, id));

create table proposal_paid_links_aud (rev integer not null, proposal_id bigint not null, paid_links_id bigint not null, revtype smallint, primary key (proposal_id, rev, paid_links_id))
create table revinfo (rev integer not null, revtstmp bigint, primary key (rev));
alter table if exists supplier add column created_date bigint default 0 not null;
alter table if exists supplier add column modified_date bigint default 0;
alter table if exists supplier add column version bigint default 0;
create table supplier_aud (id bigint not null, rev integer not null, revtype smallint, created_by varchar(255), created_date bigint default 0, da integer, disabled boolean, domain varchar(255), email varchar(255), modified_date bigint default 0, name varchar(255), source varchar(255), third_party boolean, updated_by varchar(255), we_write_fee integer, we_write_fee_currency varchar(255), website varchar(255), primary key (rev, id));

create table supplier_categories_aud (rev integer not null, supplier_id bigint not null, categories_id bigint not null, revtype smallint, primary key (rev, supplier_id, categories_id));
create sequence revinfo_seq start with 1 increment by 50;
alter table if exists category_aud add constraint FKc9m640crhsib2ws80um6xuk1w foreign key (rev) references revinfo;
alter table if exists paid_link_aud add constraint FKircge39g5e8w9smys4vcu1l7o foreign key (rev) references revinfo;
alter table if exists proposal_aud add constraint FKgqaws0nt50391dvtg5gy63mhq foreign key (rev) references revinfo;
alter table if exists proposal_paid_links_aud add constraint FKq1iikwi86pdlroww7syyeaqj2 foreign key (rev) references revinfo;
alter table if exists supplier_aud add constraint FKd8mhbb2j0c9woft7uaik3opek foreign key (rev) references revinfo;
alter table if exists supplier_categories_aud add constraint FK5qusdv1jexi76506lm9nub3kv foreign key (rev) references revinfo;