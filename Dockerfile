FROM python:3.6-slim

# Essentials not included in slim
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# setup github as a known host
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# create the script for installing the version of node from .nvmrc
# gpg keys listed at https://github.com/nodejs/node
RUN for key in \
        9554F04D7259F04124DE6B476D5A82AC7E37093B \
        93C7E9E91B49E432C2F75674B0A78B0A6C481CF6 \
        114F43EE0176B71C7BC219DD50A3051F888C628D \
        7937DFD2AB06298B2293C3187D33FF9D0246406D \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        56730D5401028683275BD23C23EFEFE93C4CFFFE \
        0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    ; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done

COPY ./scripts/bootstrap-node.sh /usr/bin/
RUN chmod 755 /usr/bin/bootstrap-node.sh

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION}
RUN bootstrap-node.sh

# by default run the entry point script
CMD ["scripts/entrypoint.sh"]

EXPOSE 8000
