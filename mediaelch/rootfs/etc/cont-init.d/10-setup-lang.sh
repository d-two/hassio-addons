#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: MediaElch
# Setup the application language
# ==============================================================================

declare app_lang="system"

if bashio::config.has_value 'app_lang'; then
	app_lang=$(bashio::config 'app_lang')
fi

sed -i "s#%%app_lang%%#${app_lang}#g" /app/advancedsettings.xml
