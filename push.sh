#!/usr/bin/env bash

set -e

for tag in $@; do
    echo "Pushing ${tag}"
    docker tag wildfish/django wildfish/django:$tag
    docker push wildfish/django:$tag
done
