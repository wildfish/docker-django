# docker-django
Base docker container including common django dependencies.

The idea of this container is to speed up building django containers by first bundling common dependencies 
that would usually take a while to install (eg image libraries for pillow).

Scripts for installing other components are also included such as node.js.

## Assumptions

The image assumes you are using `/usr/src/app/` as your working directory (as per the official Python
images), `script/entrypoint.sh` as your entry point and port 8000 although these can be overwridden using
`WORKDIR`, `CMD` and `EXPOSE` respectively.

## Installed dependencies

* Python 3.6
* ca-certificates
* git
* ssh
* curl
* wget
* gcc, g++
* postgres (postgresql-client, libpq-dev, binutils)
* pillow (libtiff5-dev, libjpeg-dev, zlib1g-dev, libfreetype6-dev, liblcms2-dev)
* GeoDjango (binutils, libproj-dev, gdal-bin, libgdal1-dev)
* lxml (libxml2-dev, libxslt-dev)
* pip (pip-tools)
* libffi-dev

## Images

There are several images available on
[dockerhub](https://hub.docker.com/r/wildfish/django/tags/), these include python3.6 
and a pre installed version of node, the base images available are:

* latest - lts node version
* node-\<version\> - node version
* node-lts - lts node version
* node-latest - latest node version

There are also images available that will install your app. These use `ONBUILD` commands
to copy your code into `/usr/src/app/`, install node dependencies and set the running
user as `django`. These images are all suffixed with `-onbuild` 
(eg `node-lts-onbuild`).

If you want to pin to a specific container, each tag can also be prefixed with a 
container version eg `0.0.49-node-latest`. These tags match the git tags of the same 
number.

## Convenience scripts

* `bootstrap-node.sh` - Installs the node version from the `.nvmrc` file in your 
  working directory or the version set in the `NODE_VERSION` environment variable. 
  If neither exist `6.9.5` will be installed.
