#!/usr/bin/env bash

set -e

docker build -t "wildfish/django-base-test" -f Dockerfile.test .
