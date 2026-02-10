#!/bin/sh

VERSION=5.2.1

docker run -ti -p 8080:8080 \
--rm \
--name sl-linkservice \
--env spring_datasource_url='jdbc:postgresql://host.docker.internal:5432/slinkylinky?user=slinkylinky&password=sl' \
-e chatgpt_api_key='blah' \
-e chatgpt_model='blah' \
-e slinkylinky_vhost='dev-slinkylinky' \
-e moz_accesskey='blah' \
-e moz_secret='blah' \
rdomloge/slinky-linky-linkservice:${VERSION}