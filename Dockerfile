FROM python:3.9-slim

ENV UWSGI_CONF ./etc/uwsgi.ini

RUN sed 's/jessie/stretch/g' /etc/apt/sources.list -i && \
        apt-get update && apt-get upgrade -y

# create the django user
RUN groupadd -r django && useradd -r -d /home/django -g django django
RUN mkdir /home/django
RUN chown -R django:django /home/django

# Essentials not included in slim
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        wget \
        git-core \
        ssh \
        gnupg \
        dirmngr \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Database drivers 
RUN apt-get update && apt-get install -y \
        libpq-dev \
        gdal-bin binutils libgdal-dev \
        gcc \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN echo deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main >> /etc/apt/sources.list && \
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
        apt-get update && apt-get install postgresql-client -y

# Pillow dependencies
RUN apt-get update && apt-get install -y \
        libtiff5-dev \
        libjpeg-dev \
        zlib1g-dev \
        libfreetype6-dev \
        liblcms2-dev \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# GeoDjango dependencies
RUN apt-get update && apt-get install -y \
        binutils \
        libproj-dev \
        gdal-bin \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# lxml dependencies
RUN apt-get update && apt-get install -y \
        libxml2-dev \
        libxslt-dev \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
        libffi-dev \
        g++ \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# pcre for uwsgi routing
RUN apt-get update && apt-get install -y \
        libpcre3 \
        libpcre3-dev \
        --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install pip pip-tools -U

# Slow Python packages
RUN pip install psycopg2 \
                pillow \
                uwsgi \
                lxml

# create the script for installing the version of node from .nvmrc
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done

COPY ./scripts/bootstrap-node.sh /usr/bin/
RUN chmod 755 /usr/bin/bootstrap-node.sh

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION}
RUN bootstrap-node.sh

# Python onbuild steps from https://github.com/docker-library/python/blob/master/3.6/onbuild/Dockerfile
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# create the default entry point, command and static build scripts
RUN mkdir /usr/src/app/scripts/
COPY ./scripts/entrypoint.sh /usr/src/app/scripts/entrypoint.sh
COPY ./scripts/run-uwsgi.sh /usr/src/app/scripts/run-uwsgi.sh
COPY ./scripts/build-static.sh /usr/src/app/scripts/build-static.sh
RUN chmod 755 /usr/src/app/scripts/*

# by default run the entry point script
ENTRYPOINT ["scripts/entrypoint.sh"]
CMD ["scripts/run-uwsgi.sh"]

EXPOSE 8000
