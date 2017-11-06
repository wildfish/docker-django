#!/usr/bin/env bash

set -e;

cd `dirname $0`

wget https://gist.githubusercontent.com/OmegaDroid/22b6e15b2050841d5733095509a97258/raw/32e994ab416512334122e9959acd3e6d7e709cc6/up_version.py;
chmod +x up_version.py;

git remote set-url origin "git@github.com:wildfish/docker-django.git"
git config --global user.email "deployer@wildfish.com";
git config --global user.name "WildfishDeployer";

VERSION=`./up_version.py`;
