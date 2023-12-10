#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-adminwebsite:latest . --push