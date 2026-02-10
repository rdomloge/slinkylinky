#!/bin/sh

docker buildx build \
--builder mybuilder \
--platform linux/amd64,linux/arm64 \
-t rdomloge/jenkins-worker-cloudflared:1.0.0 \
-f cloudflare.dockerfile  . \
--push