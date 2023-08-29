ARG BUILD_FROM
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build ps3netsrv:master
FROM ${BUILD_FROM} as builder

# Set PS3NETSRV vars
ARG PS3NETSRV_REPO=https://github.com/aldostools/webMAN-MOD.git
ARG PS3NETSRV_DIR=_Projects_/ps3netsrv
ARG PS3NETSRV_BRANCH=master

# Change working dir
WORKDIR /tmp

# Install deps and build binary
RUN \
  set -ex && \
  echo "Installing build dependencies..." && \
  apk add --update --no-cache \
    git \
    build-base \
    meson \
    mbedtls-dev \
    musl \
    musl-dev \
    musl-dbg \
    musl-utils \
    tar && \
  echo "Building ps3netsrv..." && \
    git clone --depth 1 ${PS3NETSRV_REPO} repo && \
    cd /tmp/repo/${PS3NETSRV_DIR} && \
    git checkout ${PS3NETSRV_BRANCH} && \
    meson build --buildtype=release && \
    ninja -C build/ && \
    mkdir -p /tmp/ps3netsrv-bin && \
    cp -v /tmp/repo/${PS3NETSRV_DIR}/build/ps3netsrv /tmp/ps3netsrv-bin/

# Runtime container
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy binary from build container
COPY --from=builder /tmp/ps3netsrv-bin/ps3netsrv /bin/ps3netsrv

# Install runtime deps and add users
RUN \
  set -ex && \
  echo "Installing runtime dependencies..." && \
  apk add --no-cache \
    coreutils \
    shadow \
    tzdata \
    libstdc++ \
    musl \
    musl-utils \
    mbedtls

# Add files
COPY rootfs/ /

# Corrects permissions for s6 v3
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi
RUN if [ -d /etc/s6-overlay ]; then chmod -R 755 /etc/s6-overlay; fi

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="D-Two <the.dtwo@gmail.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="D-Two <the.dtwo@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
