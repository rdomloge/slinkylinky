#!/bin/sh
docker run --restart unless-stopped --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password -d postgres
docker run --restart unless-stopped --name pgadmin --link postgres -p 83:80 -e PGADMIN_DEFAULT_PASSWORD=password -e PGADMIN_DEFAULT_EMAIL=rdomloge@gmail.com -d dpage/pgadmin4