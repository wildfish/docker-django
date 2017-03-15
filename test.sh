#!/usr/bin/env bash

set -e

cd `dirname $0`
./build.sh

python -m unittest discover --start-directory tests
