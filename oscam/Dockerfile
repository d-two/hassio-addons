ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG OSCAM_VERSION

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    libdvbcsa-dev \
    libusb-dev \
    linux-headers \
    openssl-dev \
    pcsc-lite-dev \
    shadow && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ccid \
    libdvbcsa \
    openssl \
    libusb \
    pcsc-lite \
    pcsc-lite-libs && \
  echo "**** compile oscam ****" && \
  if [ -z ${OSCAM_VERSION+x} ]; then \
    OSCAM_VERSION=$(curl -s https://git.streamboard.tv/api/v4/projects/11/repository/tags | jq -r '.[0].name'); \
  fi && \
  mkdir -p /tmp/oscam && \
  curl -o \
    /tmp/oscam.tar.gz -L \
    "https://git.streamboard.tv/common/oscam/-/archive/${OSCAM_VERSION}/oscam-${OSCAM_VERSION}.tar.gz" && \
  tar xf \
    /tmp/oscam.tar.gz -C \
    /tmp/oscam --strip-components=1 && \
  cd /tmp/oscam && \
  ./config.sh \
    --enable all \
    --disable \
    CARDREADER_DB2COM \
    CARDREADER_INTERNAL \
    CARDREADER_STINGER \
    CARDREADER_STAPI \
    CARDREADER_STAPI5 \
    IPV6SUPPORT \
    LCDSUPPORT \
    LEDSUPPORT \
    READ_SDT_CHARSETS && \
  make \
    CONF_DIR=/config \
    DEFAULT_PCSC_FLAGS="-I/usr/include/PCSC" \
    NO_PLUS_TARGET=1 \
    OSCAM_BIN=/usr/bin/oscam \
    pcsc-libusb && \
  echo "**** fix broken permissions from pcscd install ****" && \
  chmod 755 \
    /usr/sbin/pcscd && \
  echo "**** install PCSC drivers ****" && \
  mkdir -p \
    /tmp/omnikey && \
  curl -o \
  /tmp/omnikey.tar.gz -L \
    "https://raw.githubusercontent.com/d-two/hassio-addons/main/oscam/ifdokccid_linux_x86_64-v4.2.8.tar.gz" && \
  tar xzf \
  /tmp/omnikey.tar.gz -C \
    /tmp/omnikey --strip-components=2 && \
  cd /tmp/omnikey && \
  ./install && \
  echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  echo "**** fix group for card readers and add abc to dialout group ****" && \
  groupmod -g 24 cron && \
  groupmod -g 16 dialout && \
  usermod -a -G 16 abc && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

RUN \
  chmod a+x /etc/cont-init.d/30-config && \
  chmod a+x /etc/services.d/pcscd/run && \
  chmod a+x /etc/services.d/oscam/run
    
# Ports and volumes
EXPOSE 8888
EXPOSE 9999

VOLUME /config
