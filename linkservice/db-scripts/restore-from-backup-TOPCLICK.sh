#!/bin/bash

docker run -ti --rm --env PGPASSWORD=sl --entrypoint psql -v C:/Users/ramsaydomloge/Downloads/temp:/backup -ti postgres \
-f backup/2025-09-23_1100-backup.sql -h host.docker.internal -p 6432 -U slinkylinky postgres