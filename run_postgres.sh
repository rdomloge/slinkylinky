#!/bin/sh
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password --rm -d postgres
docker run --name pgadmin --link postgres -p 83:80 -e PGADMIN_DEFAULT_PASSWORD=password -e PGADMIN_DEFAULT_PASSWORD=password -e PGADMIN_DEFAULT_EMAIL=rdomloge@gmail.com --rm -d dpage/pgadmin4