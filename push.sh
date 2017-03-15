#!/usr/bin/env bash

set -e

for tag in $@; do
    docker tag wildfish/django-base wildfish/django-base:$tag
    docker push wildfish/django-base:$tag
done
