#!/bin/bash

mvn clean package -Dmaven.test.skip=true && \
docker buildx build --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-linkservice:latest . --push
