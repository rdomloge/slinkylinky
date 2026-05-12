#!/bin/bash
#
# Run TestCafe tests in Docker.
#
# Environment variables (with defaults):
#   HOST       – hostname (default: host.docker.internal)
#   APP_PORT   – port (default: 5173)
#   PROTOCOL   – http or https (default: http)
#   githubUsername / githubPassword – GitHub OAuth credentials
#
# Examples:
#   # Default (localhost:5173)
#   ./run_locally.sh
#
#   # Custom port
#   APP_PORT=8080 ./run_locally.sh
#
#   # Remote host
#   HOST=staging.example.com APP_PORT=443 PROTOCOL=https ./run_locally.sh

HOST=${HOST:-host.docker.internal}
APP_PORT=${APP_PORT:-5173}
PROTOCOL=${PROTOCOL:-http}

docker run -ti \
-e githubUsername=$githubUsername \
-e githubPassword=$githubPassword \
-e HOST=$HOST \
-e APP_PORT=$APP_PORT \
-e PROTOCOL=$PROTOCOL \
--mount type=bind,source="/c/Users/domloger/repos/chris/adminwebsite/testcafe/tests",target=/tests \
--mount type=bind,source="/c/Users/domloger/repos/chris/adminwebsite/testcafe/.container..testcaferc.json",target=/testcaferc.json \
testcafe/testcafe:ffmpeg chromium /tests/**/*.js