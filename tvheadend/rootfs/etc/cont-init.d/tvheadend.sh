#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: TVHeadend
# Executes user customizations on startup
# ==============================================================================

check_picons(){
    if [ -z "$(ls -A /config/tvheadend/picons)" ]; then return 1; else return 0; fi
}

picons_install(){
    if apk update; then
        bashio::log.info '[Picons] APK: Installing required packages.'
        if apk add --no-cache --virtual .build-deps xz; then
            bashio::log.info '[Picons] Installing Picons.'
            bashio::log.info '[Picons] SNP-Picons Download.'
            wget -O /config/tvheadend/snp.tar.xz $(bashio::config 'snp_url')
            bashio::log.info '[Picons] SRP-Picons Download.'
            wget -O /config/tvheadend/srp.tar.xz $(bashio::config 'srp_url')
            bashio::log.info '[Picons] SNP-Picons extract.'
            mkdir -p /config/tvheadend/picons/snp
            tar -xf /config/tvheadend/snp.tar.xz --strip-components=1 -C /config/tvheadend/picons/snp
            rm /config/tvheadend/snp.tar.xz
            bashio::log.info '[Picons] SRP-Picons extract.'
            mkdir -p /config/tvheadend/picons/srp
            tar -xf /config/tvheadend/srp.tar.xz --strip-components=1 -C /config/tvheadend/picons/srp
            rm /config/tvheadend/srp.tar.xz
            bashio::log.info '[Picons] Update config.'
            sed -i 's|.*chiconpath.*|	"chiconpath": "file:///config/tvheadend/picons/snp/%C.png",|g' /config/tvheadend/config
            sed -i 's|.*piconpath.*|	"piconpath": "file:///config/tvheadend/picons/srp",|g' /config/tvheadend/config
        fi
    fi
}

check_webgrabplus(){
    if [ -z "$(ls -A /config/tvheadend/wg++)" ]; then return 1; else return 0; fi
}

webgrabplus_install(){
    if apk update; then
        bashio::log.info '[Webgrab+] APK: Installing required packages.'
        if apk add --no-cache --virtual .build-deps git mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing; then
            bashio::log.info '[Webgrab+] Installing Webgrab+.'
            cd /tmp \
            && wget http://webgrabplus.com/sites/default/files/download/SW/V3.2.0/WebGrabPlus_V3.2_install.tar.gz  \
            && tar -zxvf WebGrabPlus_V3.2_install.tar.gz \
            && rm WebGrabPlus_V3.2_install.tar.gz  \
            && mv .wg++/ /config/tvheadend/wg++  \
            && cd /config/tvheadend/wg++  \
            && ./install.sh \
            && rm -rf siteini.pack/  \
            && wget http://webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip \
            && unzip SiteIniPack_current.zip \
            && rm SiteIniPack_current.zip \
            && cp siteini.pack/India/* siteini.user/ \
            && wget -O /usr/bin/tv_grab_wg++ http://www.webgrabplus.com/sites/default/files/tv_grab_wg.txt \
            && sed -i 's|~/.wg++/guide.xml|/config/tvheadend/wg++/guide.xml|g' /usr/bin/tv_grab_wg++ \
            && chmod a+x /usr/bin/tv_grab_wg++
        else
            bashio::log.info '[Webgrab+] APK: Critical error. Unable install required packages.'
            exit 1
        fi
        bashio::log.info '[Webgrab+] APK: Removing packages no longer required.'
        apk del --no-cache --purge .build-deps
    else
        bashio::log.error '[Webgrab+] APK: Critical error. Unable to update pkg list. Check connectivity.'
        exit 1
    fi
    bashio::log.info '[Webgrab+] Finsihed all APK and PIP3 updates and installs.'
}

# Ensure directory exists
if ! bashio::fs.directory_exists '/config/tvheadend/'; then
    bashio::log.info "Creating default configuration directory at /config/tvheadend/"
    timeout 20s /usr/bin/tvheadend --firstrun -u root -g root -c /config/tvheadend
fi

if check_picons; then
    bashio::log.info "[Picons] Picons already installed"
else
    bashio::log.info "[Picons] No Picons installation found"
    if [ $(bashio::config 'picons') = true ]; then
        bashio::log.info "[Picons] Installing Picons"
        picons_install
        chmod +x /usr/bin/restart_addon
        exec /usr/bin/restart_addon
    fi
fi

if check_webgrabplus; then
    bashio::log.info "[Webgrab+] Webgrab+ already installed"
else
    bashio::log.info "[Webgrab+] No webgrab+ installation found"
    if [ $(bashio::config 'webgrabplus') = true ]; then
        bashio::log.info "[Webgrab+] Installing webgrab+"
        webgrabplus_install
        chmod +x /usr/bin/restart_addon
        exec /usr/bin/restart_addon
    fi
fi

bashio::log.info 'Setup completed without errors!!'
