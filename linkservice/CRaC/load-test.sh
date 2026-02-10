#!/bin/sh

# Check if load-test-urls.txt exists
if [ ! -f load-test-urls.txt ]; then
  echo "File load-test-urls.txt not found!"
  exit 1
fi

# Run the siege container with the URLs from load-test-urls.txt
#docker run --rm -v "/$(pwd)/load-test-urls.txt:/etc/siege/urls.txt" jstarcher/siege -f "etc/siege/urls.txt" -r 100 -c 25

docker run --rm jstarcher/siege host.docker.internal:3000/demand -r 100 -c 25