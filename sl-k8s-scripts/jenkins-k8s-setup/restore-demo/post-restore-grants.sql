--
-- post-restore-grants.sql
-- Re-apply database grants after a production pg_dumpall restore wipes all prior grants.
-- Run as the postgres superuser immediately after restoring from a production backup.
-- Uses \connect to switch databases within a single psql session.
--

-- -----------------------------------------------------------------------
-- slinkylinky database
-- -----------------------------------------------------------------------
\connect slinkylinky

-- linkservice_user is the application user for the slinkylinky database.
GRANT ALL ON SCHEMA public TO linkservice_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO linkservice_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO linkservice_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO linkservice_user;

-- slinkylinky role owns tables in the production backup (ALTER TABLE ... OWNER TO slinkylinky).
-- Grant it access so it can still be referenced without errors.
GRANT ALL ON SCHEMA public TO slinkylinky;
GRANT ALL ON ALL TABLES IN SCHEMA public TO slinkylinky;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO slinkylinky;

-- -----------------------------------------------------------------------
-- supplierengagement database
-- -----------------------------------------------------------------------
\connect supplierengagement

GRANT ALL ON SCHEMA public TO supplierengagement_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO supplierengagement_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO supplierengagement_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO supplierengagement_user;

-- -----------------------------------------------------------------------
-- stats database
-- -----------------------------------------------------------------------
\connect stats

GRANT ALL ON SCHEMA public TO stats_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO stats_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO stats_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO stats_user;

-- -----------------------------------------------------------------------
-- audit database
-- -----------------------------------------------------------------------
\connect audit

GRANT ALL ON SCHEMA public TO audit_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO audit_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO audit_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO audit_user;
