#!/usr/bin/env bash

set -e

if [ -f .nvmrc ]; then
    echo 'Found .nvmrc'
    NODE_VERSION=v`cat .nvmrc`;
elif [ -z $NODE_VERSION ]; then
    echo 'Default node version not set'
    NODE_VERSION=v6.9.5
fi

echo "Installing node version: ${NODE_VERSION}"

# install build dependencies
buildDeps='xz-utils'
apt-get update && apt-get install -y $buildDeps --no-install-recommends

curl -SLO "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz"
curl -SLO "https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc"
gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc
grep " node-$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c -
tar -xJf "node-$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1

# cleanup build deps and src
rm "node-$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt
apt-get purge -y --auto-remove $buildDeps
