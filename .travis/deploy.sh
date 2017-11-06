#!/usr/bin/env bash

set -e;

cd `dirname $0`

VERSION=$TRAVIS_TAG
TAGS=()
echo $LABELS
for label in ${LABELS}
do
    striped_label="$(echo -e "${label}" | tr -d '[:space:]')"
    TAGS+=(${striped_label})
    if [ "${striped_label}" != "latest" ]; then
        TAGS+=("${VERSION}-${striped_label}")
    else
        TAGS+=("${VERSION}")
    fi
done

docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";

../push.sh ${TAGS[@]};
