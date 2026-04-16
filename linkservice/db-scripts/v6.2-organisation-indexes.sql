-- Phase 7: Performance indexes for organisation_id columns
-- Run against each respective database as the appropriate user.

-- linkservice DB
CREATE INDEX IF NOT EXISTS idx_demand_org      ON demand(organisation_id);
CREATE INDEX IF NOT EXISTS idx_demand_site_org ON demand_site(organisation_id);
CREATE INDEX IF NOT EXISTS idx_proposal_org    ON proposal(organisation_id);
CREATE INDEX IF NOT EXISTS idx_paid_link_org   ON paid_link(organisation_id);

-- supplierengagement DB (run separately against supplierengagement DB)
-- CREATE INDEX IF NOT EXISTS idx_engagement_org  ON engagement(organisation_id);

-- audit DB (run separately against audit DB)
-- CREATE INDEX IF NOT EXISTS idx_audit_org       ON audit_record(organisation_id);
