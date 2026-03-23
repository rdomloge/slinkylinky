-- Migration: add supplierSnapshotRevision to proposal table
--
-- supplierSnapshotRevision stores the Hibernate Envers revision number of the
-- supplier at the time the proposal was created. This allows
-- getProposalsWithOriginalSuppliers to call auditReader.find() directly,
-- skipping the auditReader.getRevisions() round-trip that was previously
-- required to translate a JPA version number into an Envers revision number.
--
-- Existing proposals default to 0 (legacy sentinel). For those rows the
-- endpoint falls back to the old index-based lookup path automatically.

ALTER TABLE proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;
ALTER TABLE proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot_revision BIGINT DEFAULT 0;
