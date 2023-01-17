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

RUN ( \
	curl https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | apt-key add - && \
        ( echo "deb http://downloads.linux.HPE.com/SDR/repo/mcp/ buster/current non-free" > /etc/apt/sources.list.d/proliant.sources.list ) && \
        apt-get update && \
        apt-get install -y ssa \
    )

COPY rootfs /
# Corrects permissions
RUN if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi
RUN chmod -R 755 /nginx.sh
RUN chmod -R 755 /usr/bin/firefox
