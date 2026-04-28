#!/bin/bash
# Maven wrapper for WSL2 environment using Maven at /mnt/c/apps/apache-maven-3.9.12

MAVEN_HOME="/mnt/c/apps/apache-maven-3.9.12"

if [ ! -d "$MAVEN_HOME" ]; then
    echo "Error: Maven not found at $MAVEN_HOME" >&2
    exit 1
fi

export PATH="$MAVEN_HOME/bin:$PATH"
exec mvn "$@"
