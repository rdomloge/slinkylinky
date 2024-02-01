#!/bin/sh

docker run -ti -p 8080:8080 \
--env spring_datasource_url='jdbc:postgresql://10.0.0.229:5432/slinkylinky?user=slinkylinky&password=sl' \
-e chatgpt_api_key='blah' \
-e chatgpt_model='blah' \
-e slinkylinky_vhost='dev-slinkylinky' \
-e moz_accesskey='blah' \
-e moz_secret='blah' \
rdomloge/slinky-linky-linkservice:2.1