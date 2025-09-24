#!/bin/bash

docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/scp-sshpass:1.0 -f Dockerfile-scp-sshpass . --push
