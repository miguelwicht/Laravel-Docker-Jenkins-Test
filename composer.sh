#!/bin/bash

cd src

docker run --rm -v "$(pwd)":/app composer/composer:php5 $1
