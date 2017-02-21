FROM python:3.6-slim

# Essentials not included in slim
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git-core \
        ssh \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Database drivers 
RUN apt-get update && apt-get install -y \
        postgresql-client libpq-dev \
        gdal-bin binutils libgdal1-dev \
        gcc \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

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
        libxslt-dev

RUN apt-get update && apt-get install -y \
        libffi-dev \
        g++

# Upgrade pip
RUN pip install pip pip-tools -U

# Slow Python packages
RUN pip install psycopg2 \
                pillow \
                uwsgi \
                lxml

# Python onbuild steps from https://github.com/docker-library/python/blob/master/3.4/onbuild/Dockerfile
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# create the script for installing the version of node from .nvmrc
COPY ./scripts/bootstrap-node.sh /usr/bin/
RUN chmod 755 /usr/bin/bootstrap-node.sh

# setup github as a known host
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# by default run the entry point script
CMD ["scripts/entrypoint.sh"]

EXPOSE 8000
