#!/bin/sh

docker buildx build \
--builder mybuilder \
--platform linux/amd64,linux/arm64 \
-t rdomloge/jenkins-worker-kubectl:1.0.0 \
-f Dockerfile-kubectl.dockerfile  . \
--push