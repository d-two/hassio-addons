#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDB
# Configures NGINX for use with the Chronograf
# ==============================================================================
declare port
declare certfile
declare dns_host
declare ingress_interface
declare ingress_port
declare ingress_entry
declare keyfile

port=$(bashio::addon.port 80)
ingress_entry=$(bashio::addon.ingress_entry)
if bashio::var.has_value "${port}"; then
    bashio::config.require.ssl

    if bashio::config.true 'ssl'; then
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        cp -f /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf

    else
        cp -f /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi

    sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/direct.conf
	sed -i "s/%%SSA_PORT%%/${@}/g" /etc/nginx/servers/direct.conf
fi

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
if bashio::var.has_value "${ingress_port}"; then
	cp -f /etc/nginx/servers/ingress.disabled /etc/nginx/servers/ingress.conf
	sed -i "s/%%SSA_PORT%%/${@}/g" /etc/nginx/servers/ingress.conf
	sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
	sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
	sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/ingress.conf
fi

dns_host=$(bashio::dns.host)
sed -i "s/%%dns_host%%/${dns_host}/g" /etc/nginx/includes/resolver.conf

cp -f /etc/nginx/includes/upstream.disabled /etc/nginx/includes/upstream.conf
sed -i "s/%%SSA_PORT%%/${@}/g" /etc/nginx/includes/upstream.conf

