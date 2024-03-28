create table black_listed_supplier (id bigint not null, created_by varchar(255) not null, da integer not null, data_points_json TEXT, date_created timestamp(6) not null, domain varchar(255) not null, spam_rating integer not null, primary key (id));
create index IDXb9rjxhwahqtfklf7ubammbuoh on black_listed_supplier (domain);
create sequence black_listed_supplier_seq start 101 increment by 50;