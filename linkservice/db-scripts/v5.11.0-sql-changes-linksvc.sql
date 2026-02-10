--- Add 2 columns to the paidlink table, demand_domain and supplier_domain, varchar(256)
--- Add a unique constraint on the combination of demand_domain, supplier_domain

ALTER TABLE paid_link ADD COLUMN demand_domain VARCHAR(256);
ALTER TABLE paid_link ADD COLUMN supplier_domain VARCHAR(256);
ALTER TABLE paid_link ADD CONSTRAINT paidlink_demand_supplier UNIQUE (demand_domain, supplier_domain);



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

--- Populate the contents of the new columns with domain from the linked demand table and the linked supplier table
UPDATE paid_link pl
SET demand_domain = (SELECT domain FROM demand WHERE id = pl.demand_id),
    supplier_domain = (SELECT domain FROM supplier WHERE id = pl.supplier_id);