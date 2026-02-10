alter table if exists line_item add column price float(53) not null;
alter table if exists line_item add column product_id bigint not null;
alter table if exists line_item add column product_name varchar(255);
alter table if exists line_item add column product_name_with_word_count varchar(255);
alter table if exists line_item add column tax float(53) not null;
alter table if exists line_item add column word_count integer not null;

alter table if exists woo_order add column link_details_email_sent boolean default false;
alter table if exists woo_order add column link_details_email_sent_date timestamp(6);