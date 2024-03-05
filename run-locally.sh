#!/bin/sh

docker run \
--env spring_datasource_url='jdbc:postgresql://10.0.0.229:5432/supplierengagement?user=slinkylinky&password=sl' \
-e mail_password=BNZi+X464fPiz4EQcFyg7utUBK6qu+bgyHwSpCeFCr6J \
-e mail_username=AKIA6BJW6V6R3FCUU4UH \
-e mail_host=email-smtp.eu-west-2.amazonaws.com \
-e mail_from=no-reply@slinkylinky.uk \
-e linkservice_baseurl=http://localhost:8080/.rest \
-e slinkylinky_domain=http://localhost:3000 \
-e server_port=8081 \
-e slinkylinky_vhost=dev-slinkylinky \
--rm rdomloge/slinky-linky-supplierengagement:3.0.1 sl-supplier-engagement 
