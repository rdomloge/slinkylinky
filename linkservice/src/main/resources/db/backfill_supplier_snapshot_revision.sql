-- Backfill supplierSnapshotRevision for proposals created before this field existed.
--
-- Hibernate Envers does NOT write the JPA @Version field into the _aud table, so
-- we can't join on a version column. Instead we reproduce what the Java code does:
-- getRevisions() returns revisions ordered by rev ASC, and supplierSnapshotVersion
-- is used as a 0-based index into that list. ROW_NUMBER() recreates that index.
--
-- The join table between proposal and paid_link is proposal_paid_links
-- (Hibernate default for Proposal.paidLinks with no @JoinTable annotation).
-- If your schema uses different names, adjust accordingly — you can verify with:
--   SELECT table_name FROM information_schema.tables WHERE table_name LIKE 'proposal%';
--
-- Safe to run multiple times: the WHERE clause filters to only unset rows.
-- Run AFTER add_supplier_snapshot_revision.sql.

WITH ranked_supplier_revisions AS (
    SELECT
        id,
        rev,
        (ROW_NUMBER() OVER (PARTITION BY id ORDER BY rev ASC) - 1) AS idx
    FROM supplier_aud
)
UPDATE proposal
SET supplier_snapshot_revision = sub.rev
FROM (
    SELECT DISTINCT ON (ppl.proposal_id)
           ppl.proposal_id,
           rsr.rev
    FROM proposal_paid_links         ppl
    JOIN paid_link                    pl  ON pl.id   = ppl.paid_links_id
    JOIN proposal                      p  ON p.id    = ppl.proposal_id
                                       AND p.supplier_snapshot_revision = 0
    JOIN ranked_supplier_revisions   rsr  ON rsr.id  = pl.supplier_id
                                        AND rsr.idx  = p.supplier_snapshot_version
    ORDER BY ppl.proposal_id
) sub
WHERE proposal.id                        = sub.proposal_id
  AND proposal.supplier_snapshot_revision = 0;
