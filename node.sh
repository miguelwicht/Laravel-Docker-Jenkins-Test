#!/bin/bash

docker run --rm -v "$(pwd)/web/src":"/app" -w="/app" node $1
