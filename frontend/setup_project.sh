#!/bin/bash

docker run --mount type=bind,source="${PWD}"/react,target=/adminwebsite -ti rdomloge/react-build 
#npx create-next-app@latest adminwebsite --js
