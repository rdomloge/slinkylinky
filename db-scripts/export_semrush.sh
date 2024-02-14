#!/bin/bash

docker run --env PGPASSWORD=sl --entrypoint psql -v C:/Users/domloger/Downloads/temp:/backup -ti postgres \
-c '\copy sem_rush_monthly_data to /backup/sem_rush_monthly_data.csv with csv header' -h 10.0.0.229 -U slinkylinky stats