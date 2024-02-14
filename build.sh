#!/bin/bash

mvn -Dmaven.test.skip=true clean package && \
docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-stats:3.0 . --push
