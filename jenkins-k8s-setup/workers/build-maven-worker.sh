#!/bin/sh

docker buildx build \
--builder mybuilder \
--platform linux/amd64,linux/arm64 \
-t rdomloge/jenkins-worker-maven-jdk21-latest:1.0.14 \
-f Dockerfile-maven-jdk21-latest.dockerfile  . \
--push