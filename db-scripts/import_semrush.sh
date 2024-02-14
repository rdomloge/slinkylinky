#!/bin/bash

docker run --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/repos/chris/linkservice/db-scripts:/backup -ti postgres \
-c '\copy sem_rush_monthly_data from /backup/sem_rush_monthly_data.csv with csv header' -h 10.0.0.229 -U slinkylinky stats