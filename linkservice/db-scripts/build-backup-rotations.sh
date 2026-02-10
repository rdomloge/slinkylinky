#!/bin/sh

docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64 -t rdomloge/backup-rotation:latest --push -f Dockerfile-rotate-backups .