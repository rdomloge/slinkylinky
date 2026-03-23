-- v5.12.0 - Supplier responsiveness metric (stats database)
-- Run this against the STATS database, not the linkservice database.

CREATE TABLE supplier_responsiveness (
    id BIGSERIAL PRIMARY KEY,
    supplier_id BIGINT NOT NULL UNIQUE,
    domain VARCHAR(255),
    avg_response_days DOUBLE PRECISION NOT NULL DEFAULT 0,
    sample_size INTEGER NOT NULL DEFAULT 0,
    last_calculated TIMESTAMP
);

CREATE INDEX idx_responsiveness_supplier_id ON supplier_responsiveness(supplier_id);
CREATE INDEX idx_responsiveness_domain ON supplier_responsiveness(domain);
