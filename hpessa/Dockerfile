FROM hassioaddons/debian-base:3.2.2

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN ( \
        apt-get update && \
        apt-get install -y --no-install-recommends \
		curl \
		gnupg \
		libnginx-mod-http-lua=1.14.2-2+deb10u3 \
        luarocks=2.4.2+dfsg-1 \
        nginx=1.14.2-2+deb10u3 \
        procps=2:3.3.15-2 \
    \
    && luarocks install lua-resty-http 0.15-0 \
    )

RUN ( \
		curl https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | apt-key add - && \
        ( echo "deb http://downloads.linux.HPE.com/SDR/repo/mcp/ buster/current non-free" > /etc/apt/sources.list.d/proliant.sources.list ) && \
        apt-get update && \
        apt-get install -y ssa \
    )

COPY rootfs /
