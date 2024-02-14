set role slinkylinky;

alter table proposal add column supplier_snapshot_version bigint not null default 0;
alter table supplier drop column sem_rush_authority_score;
alter table supplier drop column sem_rush_uk_jan23traffic;
alter table supplier drop column sem_rush_uk_monthly_traffic;

alter table if exists category add column version bigint default 0;
create table category_aud (id bigint not null, rev integer not null, revtype smallint, created_by varchar(255), disabled boolean default false, name varchar(255), updated_by varchar(255), primary key (rev, id));
create table paid_link_aud (id bigint not null, rev integer not null, revtype smallint, supplier_id bigint, primary key (rev, id));
alter table if exists paid_link add column version bigint default 0;
alter table if exists proposal add column version bigint not null default 1;

create table proposal_aud (id bigint not null, rev integer not null, revtype smallint, article TEXT, blog_live boolean, content_ready boolean, created_by varchar(255), date_accepted_by_supplier timestamp(6), date_blog_live timestamp(6), date_created timestamp(6), date_invoice_paid timestamp(6), date_invoice_received timestamp(6), date_sent_to_supplier timestamp(6), invoice_paid boolean, invoice_received boolean, live_link_title varchar(255), live_link_url varchar(255), proposal_accepted boolean, proposal_sent boolean, supplier_snapshot_version bigint not null default 0, updated_by varchar(255), primary key (rev, id));

create table proposal_paid_links_aud (rev integer not null, proposal_id bigint not null, paid_links_id bigint not null, revtype smallint, primary key (proposal_id, rev, paid_links_id));
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

-- this is the initial revision, with an arbitrary timestamp
insert into REVINFO(REV,REVTSTMP) values (1,1322687394907); 

-- this copies the relevant row data from the Supplier table to the audit table
insert into supplier_aud(
	rev,revtype,id,created_by,da,disabled,domain,email,name,third_party,updated_by,
	we_write_fee,we_write_fee_currency,website,source,created_date,modified_date) 
	select 1,0,id,created_by,da,disabled,domain,email,name,third_party,updated_by,we_write_fee,
	we_write_fee_currency,website,source,created_date,modified_date from supplier;

-- this copies the relevant row data from the Proposal table to the audit table
insert into proposal_aud(
    rev,revtype,id,article,blog_live,content_ready,created_by,date_accepted_by_supplier,
    date_blog_live,date_created,date_invoice_paid,date_invoice_received,date_sent_to_supplier,
    invoice_paid,invoice_received,live_link_title,live_link_url,proposal_accepted,proposal_sent,
    supplier_snapshot_version,updated_by) 
    select 1,0,id,article,blog_live,content_ready,created_by,date_accepted_by_supplier,
    date_blog_live,date_created,date_invoice_paid,date_invoice_received,date_sent_to_supplier,
    invoice_paid,invoice_received,live_link_title,live_link_url,proposal_accepted,proposal_sent,
    supplier_snapshot_version,updated_by from proposal;

-- this copies the relevant row data from the Category table to the audit table
insert into category_aud(rev,revtype,id,created_by,disabled,name,updated_by) 
    select 1,0,id,created_by,disabled,name,updated_by from category;

-- this copies the relevant row data from the PaidLink table to the audit table
insert into paid_link_aud(rev,revtype,id,supplier_id) 
    select 1,0,id,supplier_id from paid_link;

delete from supplier_categories sc where sc.supplier_id=340 and categories_id=67; -- duplicates
insert into supplier_categories (supplier_id, categories_id) values (340, 67);
delete from supplier_categories sc where sc.supplier_id=401 and categories_id=72; -- duplicates
insert into supplier_categories (supplier_id, categories_id) values (401, 72);
delete from supplier_categories sc where sc.supplier_id=460 and categories_id=83; -- duplicates
insert into supplier_categories (supplier_id, categories_id) values (460, 83);
alter table if exists supplier_categories add constraint UNIQUE_SUPPLIER_CATEGORIES_CONSTRAINT UNIQUE (supplier_id, categories_id);

-- this copies the relevant row data from the SupplierCategories table to the audit table
insert into supplier_categories_aud(rev,revtype,supplier_id,categories_id) 
    select 1,0,supplier_id,categories_id from supplier_categories;

select nextval('revinfo_seq');