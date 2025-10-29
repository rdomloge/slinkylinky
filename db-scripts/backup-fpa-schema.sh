#!/bin/sh

docker run -ti --rm --env PGPASSWORD=sl --entrypoint pg_dumpall -ti postgres \
--schema-only --clean -h host.docker.internal -U slinkylinky --no-role-passwords > C:/Users/RamsayDomloge/Downloads/full-db-schema-backup.sql

docker run -ti --rm --env PGPASSWORD=sl --entrypoint pg_dump -ti postgres \
--schema-only --no-owner \
-h host.docker.internal -U slinkylinky > C:/Users/RamsayDomloge/Downloads/slinkylinky-schema-backup.sql

docker run -ti --rm --env PGPASSWORD=sl --entrypoint pg_dump -ti postgres \
-t category -t category_aud -t black_listed_supplier -t supplier -t supplier_categories -t supplier_aud -t supplier_categories_aud \
-h host.docker.internal -U slinkylinky > C:/Users/RamsayDomloge/Downloads/core-tables-backup.sql


#-f backup/2025-06-18_1300-backup.sql -h host.docker.internal -U slinkylinky postgres

#pg_dumpall --schema-only --clean --if-exists -h postgres-service -U slinkylinky --no-role-passwords -f /backup/$(FILENAME)-backup.sql