#!/bin/bash

# Go to project root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$DIR"

cd ..

# run node command
docker run --rm -v "$(pwd)/web/src":"/app" -w="/app" node $1
