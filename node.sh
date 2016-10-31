#!/bin/bash

docker run --rm -v "$(pwd)/web/html":"/app" -w="/app" node $1
