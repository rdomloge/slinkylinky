#!/bin/sh

# This assumes that the database you are restoring to already is running on IP 10.0.0.229 and there is a 
# backup file in the Windows Download named 2023-12-12T10_24_59Z-backup.sql

## THE DATABASES MUST ALREADY EXIST AND BE OWNED BY SLINKYLINKY

docker run --rm --env PGPASSWORD=sl --entrypoint psql -i postgres \
-h host.docker.internal -U slinkylinky postgres < "//DiskStation/sl-backup/2026-04-03_1900-backup.sql"

#docker run -ti --rm --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/repos/chris/linkservice/db-scripts:/backup -ti postgres \
#-f backup/v5.1-sql-changes-linksvc.sql -h host.docker.internal -U slinkylinky slinkylinky

#docker run -ti --rm --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/repos/chris/linkservice/db-scripts:/backup -ti postgres \
#-f backup/v5.1-sql-changes-suppeng.sql -h host.docker.internal -U slinkylinky supplierengagement