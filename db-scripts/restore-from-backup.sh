#!/bin/sh

# This assumes that the database you are restoring to already is running on IP 10.0.0.229 and there is a 
# backup file in the Windows Download named 2023-12-12T10_24_59Z-backup.sql

## THE DATABASES MUST ALREADY EXIST AND BE OWNED BY SLINKYLINKY

docker run --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/Downloads/temp:/backup -ti postgres \
-f backup/2024-02-08_1100-backup.sql -h 10.0.0.229 -U slinkylinky postgres

docker run --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/repos/chris/linkservice/db-scripts:/backup -ti postgres \
-f backup/v2.3-sql-changes.sql -h 10.0.0.229 -U slinkylinky slinkylinky