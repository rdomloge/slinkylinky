#!/bin/bash

#docker buildx build --push --builder remote-container --platform linux/arm64\
# -t rdomloge/slinky-linky-adminwebsite:3.1 .

docker buildx build --push --platform linux/amd64,linux/arm64\
 -t rdomloge/slinky-linky-adminwebsite:5.8 .