#!/bin/bash

docker run --rm -v "$(pwd)/web/html":/app composer/composer:php5 $1
