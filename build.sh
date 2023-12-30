#!/bin/bash

mvn clean package && \
docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-linkservice:1.6 . --push
