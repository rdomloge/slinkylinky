--- Add 2 columns to the paidlink table, demand_domain and supplier_domain, varchar(256)
--- Add a unique constraint on the combination of demand_domain, supplier_domain

ALTER TABLE paid_link ADD COLUMN demand_domain VARCHAR(256);
ALTER TABLE paid_link ADD COLUMN supplier_domain VARCHAR(256);
ALTER TABLE paid_link ADD CONSTRAINT paidlink_demand_supplier UNIQUE (demand_domain, supplier_domain);

--- Populate the contents of the new columns with domain from the linked demand table and the linked supplier table
UPDATE paid_link pl
SET demand_domain = (SELECT domain FROM demand WHERE id = pl.demand_id),
    supplier_domain = (SELECT domain FROM supplier WHERE id = pl.supplier_id);

--- Problem 1 (single demand)

select p.id, date_created from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='uknewsgroup.co.uk'
and d.domain='evalian.co.uk'

select d.id as demand_id, 
	pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where p.id=285;

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 358;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = 358);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;


--- Problem 2 (306 - 3 demands :: 308 - 2 demands)

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='diydaddyblog.com'
and d.domain='as-landscapes.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 441;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

--- Problem 3

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='businesspartnermagazine.com'
and d.domain='washco.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 445;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

--- MULTIPLE (3) PROPOSALS

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='estateagentnetworking.co.uk'
and d.domain='cityhire.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 454;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 502;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='workingdaddy.co.uk'
and d.domain='loftplan.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 382;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='businesspartnermagazine.com'
and d.domain='shop.acticareuk.com'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 598;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='ukconstructionblog.co.uk'
and d.domain='dcwhite.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 612;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='mmbmagazine.co.uk'
and d.domain='therebegiants.com'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 632;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='robinwaite.com'
and d.domain='evalian.co.uk'


DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 641;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='businesspartnermagazine.com'
and d.domain='strategicproposals.com'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 755;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='robinwaite.com'
and d.domain='cmpsolutions.ie'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 788;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

---

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='robinwaite.com'
and d.domain='simply-search.co.uk'

DO $$
	DEClARE
	  	demand_id_var INTEGER;
		paid_link_id_var INTEGER;
		proposal_id_var INTEGER;
	BEGIN
		paid_link_id_var := 790;
		demand_id_var := (select pl.demand_id from paid_link pl where pl.id = paid_link_id_var);
		proposal_id_var := (select proposal_id from proposal_paid_links where paid_links_id = paid_link_id_var);

		delete from proposal_paid_links 	where paid_links_id = paid_link_id_var;
		---delete from proposal p 				where p.id = proposal_id_var;
		delete from demand_categories dc 	where dc.demand_id = demand_id_var;
		delete from paid_link 				where id = paid_link_id_var;		
		delete from demand d 				where d.id = demand_id_var;
END$$;

--- no longer needed

select p.id as proposal_id, date_created, pl.id as paid_link_id
from paid_link pl
join supplier s on s.id=pl.supplier_id
join demand d on d.id=pl.demand_id
join proposal_paid_links ppl on ppl.paid_links_id=pl.id
join proposal p on ppl.proposal_id=p.id
where s.domain='thejournalix.com'
and d.domain='cityhire.co.uk'
