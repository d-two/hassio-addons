ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG OSCAM_VERSION

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    gcc \
    g++ \
    libusb-dev \
    linux-headers \
    make \
    openssl-dev \
    pcsc-lite-dev \
    subversion \
    tar \
    shadow

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ccid \
    curl \
    libcrypto1.1 \
    libssl1.1 \
    libusb \
    pcsc-lite \
    pcsc-lite-libs

RUN \
  echo "**** compile oscam ****" && \
  if [ -z ${OSCAM_VERSION+x} ]; then \
    OSCAM_VERSION=$(svn info --show-item revision https://svn.streamboard.tv/oscam/trunk ); \
  fi && \
  svn checkout https://svn.streamboard.tv/oscam/trunk@${OSCAM_VERSION} /tmp/oscam-svn && \
  cd /tmp/oscam-svn && \
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
    pcsc-libusb

RUN \
  echo "**** fix broken permissions from pcscd install ****" && \
  chown root:root \
    /usr/sbin/pcscd && \
  chmod 755 \
    /usr/sbin/pcscd

RUN \
  echo "**** install PCSC drivers ****" && \
  mkdir -p \
    /tmp/omnikey && \
  curl -o \
  /tmp/omnikey.tar.gz -L \
    https://www.hidglobal.com/sites/default/files/drivers/ifdokccid_linux_x86_64-v4.2.8.tar.gz && \
  tar xzf \
  /tmp/omnikey.tar.gz -C \
    /tmp/omnikey --strip-components=2 && \
  cd /tmp/omnikey && \
  ./install

RUN \
  echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc
  
RUN \
  echo "**** fix group for card readers and add abc to dialout group ****" && \
  groupmod -g 24 cron && \
  groupmod -g 16 dialout && \
  usermod -a -G 16 abc

RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

RUN \
  chown root:root /etc/cont-init.d/30-config && \
  chmod a+x /etc/cont-init.d/30-config && \
  chown root:root /etc/services.d/pcscd/run && \
  chmod a+x /etc/services.d/pcscd/run && \
  chown root:root /etc/services.d/oscam/run && \
  chmod a+x /etc/services.d/oscam/run
    
# Ports and volumes
EXPOSE 8888
EXPOSE 9999

VOLUME /config
