#!/bin/bash


docker run --restart unless-stopped --mount type=bind,source="${PWD}"/react,target=/adminwebsite -p 3000:3000 --name react -ti node:current-slim bash

echo Now, npm run dev