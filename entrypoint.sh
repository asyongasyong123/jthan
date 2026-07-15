#!/bin/sh
xray run -c /etc/xray/config.json &
nginx -g 'daemon off;'
