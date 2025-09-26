#!/bin/bash

docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/utils:1.0 -f Dockerfile-utils . --push
