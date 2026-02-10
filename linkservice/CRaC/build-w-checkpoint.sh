#!/bin/sh

docker buildx build --no-cache --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-linkservice-crac-cp . --push -f Dockerfile.crac-checkpoint