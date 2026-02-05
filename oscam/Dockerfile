ARG BUILD_FROM=lscr.io/linuxserver/oscam:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# copy local files
COPY root/ /

RUN chmod a+x /etc/s6-overlay/s6-rc.d/svc-oscam/run

# Ports and volumes
EXPOSE 8888
EXPOSE 9999

VOLUME /config
