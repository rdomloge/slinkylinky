#!/bin/bash


docker run -ti \
-e githubUsername=$githubUsername \
-e githubPassword=$githubPassword \
-e HOST=host.docker.internal \
--mount type=bind,source="/c/Users/domloger/repos/chris/adminwebsite/testcafe/tests",target=/tests \
--mount type=bind,source="/c/Users/domloger/repos/chris/adminwebsite/testcafe/.container..testcaferc.json",target=/testcaferc.json \
testcafe/testcafe:ffmpeg chromium /tests/**/*.js