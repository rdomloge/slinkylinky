alter table if exists engagement 
    add column invoice_url varchar(512),
    add constraint single_invoice_url unique (invoice_url),
    drop column invoice_file_name,
    drop column invoice_file_content_type,
    drop column invoice_file_content;

drop table if exists audit_record;