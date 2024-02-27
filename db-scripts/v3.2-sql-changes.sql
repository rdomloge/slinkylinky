alter table if exists demand add column source varchar(255);
update demand set source = 'SlinkyLinky';