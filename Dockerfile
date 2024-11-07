FROM ubuntu:18.04

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Ubuntu Base Image" \
    org.opencontainers.image.description="Docker Images for Ubuntu. (amd64, arm32v7, arm64,ppc64le,riscv64,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/ubuntu" \
    org.opencontainers.image.base.name="snowdreamtech/ubuntu:latest" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/ubuntu" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="18.04" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/ubuntu"

ENV DEBIAN_FRONTEND=noninteractive \
    # keep the docker container running
    KEEPALIVE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/ubuntu#locales)
    LANG=C.UTF-8 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    procps \
    sudo \
    vim \ 
    unzip \
    tzdata \
    openssl \
    wget \
    curl \
    iputils-ping \
    lsof \
    apt-transport-https \
    ca-certificates \                                                                                                                                                                                                      
    && update-ca-certificates\
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /etc/bash.bashrc 

COPY vimrc.local /etc/vim/vimrc.local

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]