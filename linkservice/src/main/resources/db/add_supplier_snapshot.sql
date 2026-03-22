-- Migration: add supplierSnapshot to proposal table
--
-- Stores a JSON serialization of the supplier as it was when the proposal was
-- created. When present, getProposalsWithOriginalSuppliers uses this directly
-- and makes zero Envers queries for that proposal.
--
-- Existing proposals default to NULL. On first access they are lazily backfilled
-- via updateSupplierSnapshot() — after which subsequent requests use JSON too.

ALTER TABLE proposal     ADD COLUMN IF NOT EXISTS supplier_snapshot TEXT;
ALTER TABLE proposal_aud ADD COLUMN IF NOT EXISTS supplier_snapshot TEXT;
