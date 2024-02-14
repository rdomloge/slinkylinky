#!/bin/bash


docker run -ti --rm --mount type=bind,source="/c/Users/domloger/repos/chris/linkservice/testcafe/tests",target=/tests testcafe/testcafe chromium /tests/**/*.js --live
