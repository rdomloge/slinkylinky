alter table if exists proposal 
    add column validated boolean default false,
    add column date_validated timestamp(6) without time zone;

alter table if exists proposal_aud
    add column validated boolean default false,
    add column date_validated timestamp(6) without time zone;