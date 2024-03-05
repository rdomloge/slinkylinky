#!/bin/sh

# This assumes that the database you are restoring to already is running on IP 10.0.0.229 and there is a 
# backup file in the Windows Download named 2023-12-12T10_24_59Z-backup.sql

## THE DATABASES MUST ALREADY EXIST AND BE OWNED BY SLINKYLINKY

docker run -ti --rm --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/Downloads/temp:/backup -ti postgres \
-f backup/2024-03-04_1600-backup.sql -h host.docker.internal -U slinkylinky postgres

docker run -ti --rm --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/repos/chris/linkservice/db-scripts:/backup -ti postgres \
-f backup/v3.6-sql-changes.sql -h host.docker.internal -U slinkylinky woo