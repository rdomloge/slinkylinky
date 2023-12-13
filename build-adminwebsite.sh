#!/bin/bash

docker buildx build --push --builder mybuilder --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-adminwebsite:latest .