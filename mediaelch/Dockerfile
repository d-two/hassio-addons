ARG BUILD_FROM
ARG BUILD_ARCH

#
# baseimage-gui Dockerfile
#
# https://github.com/jlesage/docker-baseimage-gui
#

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILD_ARCH tonistiigi/xx AS xx

# Build Nginx.
FROM --platform=$BUILD_ARCH ${BUILD_FROM} AS nginx
ARG TARGETPLATFORM
COPY --from=xx / /
COPY src/nginx/build.sh /tmp/build-nginx.sh
RUN chmod -R 755 /tmp/build-nginx.sh
RUN /tmp/build-nginx.sh
RUN xx-verify --static /tmp/nginx-install/sbin/nginx
# NOTE: Extended attributes are kept by buildx when using the COPY command.
#       See https://wildwolf.name/multi-stage-docker-builds-and-xattrs/.
RUN apk --no-cache add libcap && setcap cap_net_bind_service=ep /tmp/nginx-install/sbin/nginx

# Build noVNC.
FROM --platform=$BUILD_ARCH ${BUILD_FROM} AS noVNC
ARG NOVNC_VERSION=1.3.0
ARG BOOTSTRAP_VERSION=5.1.3
ARG BOOTSTRAP_NIGHTSHADE_VERSION=1.1.3
ARG FONTAWESOME_VERSION=4.7.0
ARG NOVNC_URL=https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz
ARG BOOTSTRAP_URL=https://github.com/twbs/bootstrap/releases/download/v${BOOTSTRAP_VERSION}/bootstrap-${BOOTSTRAP_VERSION}-dist.zip
ARG BOOTSTRAP_NIGHTSHADE_URL=https://github.com/vinorodrigues/bootstrap-dark-5/archive/refs/tags/v${BOOTSTRAP_NIGHTSHADE_VERSION}.tar.gz
ARG FONTAWESOME_URL=https://fontawesome.com/v${FONTAWESOME_VERSION}/assets/font-awesome-${FONTAWESOME_VERSION}.zip
WORKDIR /tmp
COPY rootfs/opt/noVNC/index.html /opt/noVNC/index.html
RUN \
    # Install required tools.
    apk --no-cache add \
        curl \
        sed \
        jq \
        npm \
        && \
    npm install clean-css-cli -g
RUN \
    # Create required directories.
    mkdir -p \
        /opt/noVNC/app/styles \
        /opt/noVNC/app/fonts
RUN \
    # Install noVNC.
    mkdir /tmp/noVNC && \
    curl -# -L ${NOVNC_URL} | tar -xz --strip 1 -C /tmp/noVNC && \
    cp -vr /tmp/noVNC/core /opt/noVNC/ && \
    cp -vr /tmp/noVNC/vendor /opt/noVNC/
RUN \
    # Install Bootstrap.
    # NOTE: Only copy the JS bundle, since the CSS is taken from Bootstrap
    #       Nightshade.
    curl -sS -L -O ${BOOTSTRAP_URL} && \
    unzip bootstrap-${BOOTSTRAP_VERSION}-dist.zip && \
    #cp -v bootstrap-${BOOTSTRAP_VERSION}-dist/css/bootstrap.min.css /opt/noVNC/app/styles/ && \
    cp -v bootstrap-${BOOTSTRAP_VERSION}-dist/js/bootstrap.bundle.min.js* /opt/noVNC/app/
RUN \
    # Install Bootstrap Nightshade.
    mkdir /tmp/bootstrap-nightshade && \
    curl -# -L ${BOOTSTRAP_NIGHTSHADE_URL} | tar -xz --strip 1 -C /tmp/bootstrap-nightshade && \
    cleancss \
        -O1 \
        --format breakWith=lf \
        --output /opt/noVNC/app/styles/bootstrap-nightshade.min.css \
        /tmp/bootstrap-nightshade/dist/css/bootstrap-nightshade.css
RUN \
    # Install Font Awesome.
    curl -sS -L -O ${FONTAWESOME_URL} && \
    unzip font-awesome-${FONTAWESOME_VERSION}.zip && \
    cp -v font-awesome-${FONTAWESOME_VERSION}/fonts/fontawesome-webfont.* /opt/noVNC/app/fonts/ && \
    cp -v font-awesome-${FONTAWESOME_VERSION}/css/font-awesome.min.css /opt/noVNC/app/styles/
RUN \
    # Set version of CSS and JavaScript file URLs.
    sed "s/UNIQUE_VERSION/$(date | md5sum | cut -c1-10)/g" -i /opt/noVNC/index.html

# Pull base image.
FROM ${BUILD_FROM} AS MediaElchBuild
WORKDIR /tmp

# Define software versions.
ARG REPO_TAG=v2.10.0
# Define software download URLs.
ARG REPO_URL=https://github.com/Komet/MediaElch

RUN \
	apk add --update \
		git \
		build-base \
		qtchooser \
		qt5-qtbase-dev \
		qt5-qtquickcontrols2-dev \
		qt5-qtsvg-dev \
		qt5-qtmultimedia-dev \
		qt5-qttools-dev \
		qt5-qtdeclarative-dev \
		libmediainfo-dev

# Download MediaElch
RUN \
	REPO_DIR=/tmp/$(basename $REPO_URL .git) && \
	cd /tmp && \
	git clone --single-branch $REPO_URL && \
	git --work-tree=$REPO_DIR --git-dir=$REPO_DIR/.git checkout tags/$REPO_TAG

RUN \
	cd /tmp/MediaElch && \
	git submodule update --init && \
	mkdir build && cd build && \
	qmake .. CONFIG+=release && \
	make install -j$(nproc)

# Pull base image.
FROM ${BUILD_FROM}

#zenity
ARG VNC_PKGS="ttf-dejavu tigervnc openbox"
ARG RUNTIME_PKG="qtchooser qt5-qtbase qt5-qtquickcontrols2 qt5-qtsvg qt5-qtmultimedia qt5-qttools qt5-qtbase-sqlite libmediainfo"

# Add files.
COPY rootfs/ /
COPY --from=nginx /tmp/nginx-install /opt/base/
COPY --from=noVNC /opt/noVNC /opt/noVNC
COPY --from=MediaElchBuild /usr/bin/MediaElch /app/
COPY --from=MediaElchBuild /usr/share/pixmaps/MediaElch.png /opt/noVNC/app/images/icons/master_icon.png

# Install dependencies.
RUN \
    apk add --update \
        ${VNC_PKGS} \
		${RUNTIME_PKG}

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="MediaElch" \
    S6_KILL_GRACETIME=8000 \
	USER_ID=0 \
	GROUP_ID=0

# Corrects permissions for s6 v3
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi
	
WORKDIR /data

# Metadata.
LABEL \
      org.label-schema.name="MediaElch" \
      org.label-schema.description="Docker container for MediaElch"