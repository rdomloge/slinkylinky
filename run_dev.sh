#!/bin/bash

docker run --mount type=bind,source="${PWD}"/react,target=/adminwebsite -p 3000:3000 -ti rdomloge/react-build 

echo Now -> npm run dev