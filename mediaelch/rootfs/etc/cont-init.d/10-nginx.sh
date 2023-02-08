#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

#
# Adjust nginx virtual server configuration.
#

NGINX_DIRS="\
    /var/run/nginx \
    /var/tmp/nginx \
	/var/lib/nginx/logs
"

# Make sure required directories exist.
for DIR in $NGINX_DIRS; do
    mkdir -p "$DIR"
done

# vim:ft=sh:ts=4:sw=4:et:sts=4
