#!/bin/bash


docker run --restart unless-stopped --mount type=bind,source="${PWD}/react",target=/frontend -p 3000:3000 --name react -ti node:current-slim bash

# Now, npm run dev