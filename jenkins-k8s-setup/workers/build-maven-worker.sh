#!/bin/sh

docker buildx build \
--builder mybuilder \
--platform linux/amd64,linux/arm64 \
-t rdomloge/jenkins-worker-maven-jdk21-latest \
-f Dockerfile-maven-jdk21-latest.dockerfile  . \
--push