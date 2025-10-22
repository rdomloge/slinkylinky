#!/bin/sh

docker buildx build \
--builder mybuilder \
--platform linux/amd64,linux/arm64 \
-t rdomloge/jenkins-worker-helm:1.0.0 \
-f Dockerfile-helm.dockerfile  . \
--push