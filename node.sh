#!/bin/bash

cd src

docker run --rm -v "$(pwd)":"/app" -w="/app" node $1
