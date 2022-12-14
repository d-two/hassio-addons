#!/bin/bash

# Copy data
cp -rnf /var/www/baikal/* /data/

# Fix permissions
chown -R nginx:nginx /data

