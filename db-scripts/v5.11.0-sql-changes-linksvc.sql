--- Create a function that checks for duplicate entries in the paid_link table by joining the demand, the supplier and the demand_site tables
--- it is a duplicate if there is already a paid_link linking the supplier domain and the demand_site domain (via the demand being linked to the demand_site)
--- The function will be called by a trigger that will be executed before an insert or update operation on the paid_link table
create or replace function paid_link_duplicate_check()
      returns trigger 
     language plpgsql
    as $$
    begin
        if tg_table_name = 'paid_link' and tg_op = 'INSERT' then
            if exists (select 1 from paid_link pl
                        join demand d on pl.demand_id = d.id
                        join demand_site ds on d.demand_site_id = ds.id
                        join supplier s on s.id=pl.supplier_id
                        where s.id = new.supplier_id and ds.domain = (
                                select innerds.domain 
                                from demand_site innerds 
                                join demand innerd on innerd.demand_site_id = innerds.id
                                where innerd.id = new.demand_id
                            )
                        ) then
                raise exception 'A paid link already exists between the supplier domain and the demand site domain';
            end if;
        end if; 
       return new; 
    end;
    $$;

    create trigger paid_link_duplicate_check_trigger
       before insert or update 
       on paid_link
       for each row 
           execute procedure paid_link_duplicate_check();
   