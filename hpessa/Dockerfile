ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN ( \
        apt-get update && \
        apt-get install -y --no-install-recommends \
		curl \
		gnupg \
		libnginx-mod-http-lua \
        	luarocks \
        	nginx \
        	procps \
    \
    && luarocks install lua-resty-http \
    )

COPY ssa-5.30-6.0_amd64.deb /ssa_amd64.deb
RUN apt-get install -y /ssa_amd64.deb

COPY rootfs /
# Corrects permissions
RUN if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi
RUN chmod -R 755 /nginx.sh
RUN chmod -R 755 /usr/bin/firefox
