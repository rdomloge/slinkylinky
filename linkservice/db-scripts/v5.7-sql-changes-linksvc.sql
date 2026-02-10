alter table if exists proposal add column do_not_expire boolean default false;
alter table if exists proposal_aud add column do_not_expire boolean default false;