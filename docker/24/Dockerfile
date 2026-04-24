FROM ubuntu:24.04

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Ubuntu Base Image" \
    org.opencontainers.image.description="Docker Images for Ubuntu. (amd64, arm32v7, arm64, ppc64le, riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/ubuntu" \
    org.opencontainers.image.base.name="ubuntu:24.04" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/ubuntu" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="24.04" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/ubuntu"

# Build arguments
ARG DEBIAN_FRONTEND=noninteractive \
    KEEPALIVE=0 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root

# Environment variables
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
    KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR}

# Install essential packages
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy install --no-install-recommends \
    lsb-release \
    procps \
    sudo \
    vim \
    zip \
    unzip \
    bzip2 \
    xz-utils \
    file \
    gzip \
    jq \
    tzdata \
    openssl \
    gnupg \
    aptitude \
    sysstat \
    wget \
    curl \
    git \
    libcap2-bin \
    gosu \
    dnsutils \
    netcat-traditional \
    traceroute \
    iputils-ping \
    net-tools \
    lsof \
    apt-transport-https \
    ca-certificates \
    && update-ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy --purge autoremove \
    && DEBIAN_FRONTEND=noninteractive apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /etc/bash.bashrc

# Create a user with PUID and PGID
RUN if [ "${USER}" != "root" ] && [ ! -d "/home/${USER}" ] && [ "${PUID}" -ne 0 ] && [ "${PGID}" -ne 0 ]; then \
    addgroup --gid ${PGID} ${USER}; \
    adduser --home /home/${USER} --uid ${PUID} --gid ${PGID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    fi

# Copy configuration files
COPY vimrc.local /etc/vim/vimrc.local

# Copy entrypoint scripts
COPY entrypoint.d /usr/local/bin/entrypoint.d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Set execute permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

# Set working directory
WORKDIR /root

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
