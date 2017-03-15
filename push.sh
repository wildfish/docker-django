#!/usr/bin/env bash

set -e

for tag in $@; do
    echo "Pushing ${tag}"

    striped_tag="$(echo -e "${tag}" | tr -d '[:space:]')"
    if [ "${striped_tag}" == "latest" ]; then
        docker push wildfish/django
        docker push wildfish/django:onbuild
    fi

    docker tag wildfish/django wildfish/django:${striped_tag}
    docker push wildfish/django:${striped_tag}

    docker tag wildfish/django:onbuild wildfish/django:${striped_tag}-onbuild
    docker push wildfish/django:${striped_tag}-onbuild
done
