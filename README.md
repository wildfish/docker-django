# django-base
Base docker container including common django dependencies

The idea of this container is to speed up building djanog containers by first bundling common dependencies 
that would usually take a while to install (eg image libraries for pillow).

Scripts for installing other components are also included such as node-js.

## Assumptions

The image assumes you are using `/usr/src/app/` as your working directory, `script/entrypoint.sh` as your entry point and
port 8000 although these can be overwridden using `WORKDIR`, `CMD` and `EXPOSE` respectively.

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

## Convenience scripts

* `bootstrap-node.sh` - Installs the node version from the `.nvmrc` file in your working directory or the version set in the
`NODE_VERSION` environment variable. If neither exist `6.9.5` will be installed.
