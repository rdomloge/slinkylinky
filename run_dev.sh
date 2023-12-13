#!/bin/bash


docker run --mount type=bind,source="${PWD}"/react,target=/adminwebsite -p 3000:3000 --name react --rm -ti node:current-slim bash

echo Now, npm run dev