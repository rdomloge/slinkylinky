--
-- post-restore-grants.sql
-- Re-apply database grants after DROP SCHEMA public CASCADE wipes all prior grants.
-- Run as the postgres superuser immediately after restoring from a production backup.
--

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
