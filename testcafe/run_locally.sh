#!/bin/bash


docker run -ti --rm -e githubUsername=[USERNAME] \
-e githubPassword=[PASSWORD] \
-e HOST=host.docker.internal \
--mount type=bind,source="/c/Users/domloger/repos/chris/adminwebsite/testcafe/tests",target=/tests testcafe/testcafe chromium /tests/**/*.js --live
 