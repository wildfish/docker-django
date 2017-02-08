#!/usr/bin/env bash

set -e;

chmod 600 deployer;
eval `ssh-agent -s`;
ssh-add deployer;

wget https://gist.githubusercontent.com/OmegaDroid/22b6e15b2050841d5733095509a97258/raw/e1c8cf52ee3e139c06fa5ac81e4a326621fdd20e/up_version.py;
chmod +x up_version.py;

git config --global user.email "deployer@wildfish.com";
git config --global user.name "WildfishDeployer";

TAG=`./up_version.py`;
echo "New tag: ${TAG}"

docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";

./push.sh $TAG;
