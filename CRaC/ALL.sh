#!/bin/sh

## Maybe delete local images here?


./build-crac.sh

# This will need to be forked so the next command runs
run-crac.sh

# Wait for the service to start

# load test to make sure that all the hotspots are hit
./load-test.sh


docker exec -ti sl-linkservice jcmd linkservice.jar JDK.checkpoint

./build-w-checkpoint.sh

./run-from-checkpoint.sh