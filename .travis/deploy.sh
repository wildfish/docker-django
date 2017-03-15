#!/usr/bin/env bash

set -e;
set -x;

cd `dirname $0`

wget https://gist.githubusercontent.com/OmegaDroid/22b6e15b2050841d5733095509a97258/raw/e1c8cf52ee3e139c06fa5ac81e4a326621fdd20e/up_version.py;
chmod +x up_version.py;

git remote set-url origin "git@github.com:wildfish/django.git"
git config --global user.email "deployer@wildfish.com";
git config --global user.name "WildfishDeployer";

VERSION=`./up_version.py`;
TAGS=()
echo $LABELS
for label in ${LABELS}
do
    TAGS+=(${label})
    if [ "${label}" != "latest" ]; then
        TAGS+=("${VERSION}-${label}")
    else
        TAGS+=("${VERSION}")
    fi
done

docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";

../push.sh ${TAGS[@]};
