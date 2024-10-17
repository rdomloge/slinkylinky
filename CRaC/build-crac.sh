#!/bin/bash

cd ..
mvn -Dmaven.test.skip=true clean package && \
docker buildx build --no-cache --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-linkservice-crac . --push -f ./CRaC/Dockerfile.crac
