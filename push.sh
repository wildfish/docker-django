#!/usr/bin/env bash

set -e

for tag in $@; do
    echo "Pushing ${tag}"
    docker tag wildfish/django-base wildfish/django-base:$tag
    docker push wildfish/django-base:$tag
done
