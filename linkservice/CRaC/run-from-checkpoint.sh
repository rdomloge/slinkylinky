#!/bin/sh

docker run -ti -p 8080:8080 \
--cap-add=CHECKPOINT_RESTORE --cap-add=SYS_PTRACE \
--env spring_datasource_url='jdbc:postgresql://host.docker.internal:5432/slinkylinky?user=slinkylinky&password=sl' \
-e chatgpt_api_key='blah' \
-e chatgpt_model='blah' \
-e slinkylinky_vhost='dev-slinkylinky' \
-e moz_accesskey='blah' \
-e moz_secret='blah' \
--name sl-linkservice \
--rm \
rdomloge/slinky-linky-linkservice-crac-cp \
java -XX:CRaCRestoreFrom=crac-files