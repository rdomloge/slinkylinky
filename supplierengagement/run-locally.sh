#!/bin/sh

# Export required environment variables before running this script.
docker run \
-e spring_datasource_url="${spring_datasource_url}" \
-e mail_password="${mail_password}" \
-e mail_username="${mail_username}" \
-e mail_host="${mail_host}" \
-e mail_from="${mail_from}" \
-e linkservice_baseurl="${linkservice_baseurl}" \
-e slinkylinky_domain="${slinkylinky_domain}" \
-e server_port="${server_port:-8081}" \
-e slinkylinky_vhost="${slinkylinky_vhost}" \
-e slinkylinky_rabbitmq_host="${slinkylinky_rabbitmq_host}" \
-e slinkylinky_rabbitmq_username="${slinkylinky_rabbitmq_username}" \
-e slinkylinky_rabbitmq_password="${slinkylinky_rabbitmq_password}" \
--rm rdomloge/slinky-linky-supplierengagement:3.0.1 sl-supplier-engagement 
