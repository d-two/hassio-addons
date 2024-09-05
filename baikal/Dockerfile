ARG BUILD_FROM
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV VERSION 0.9.5

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        nginx \
        php81-curl \
        php81-fpm \
        php81-mbstring \
        php81-xml \
        php81 \
	php81-sqlite3 \
	php81-pdo \
	php81-pdo_mysql \
	php81-pdo_sqlite \
	php81-session \
	php81-dom \
	php81-xmlreader \
	php81-xmlwriter \
    \
    && curl -Ls "https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip" -o baikal-$VERSION.zip \
        && unzip -q baikal-$VERSION.zip -d /var/www/ \
		&& rm baikal-$VERSION.zip \
    \
	&& rm -f -r \
        /tmp/* \
        /etc/nginx 

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6 v3
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi

WORKDIR "/data"

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
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
