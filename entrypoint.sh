#!/bin/sh
/usr/bin/xray run -c /etc/xray/config.json &
nginx -g 'daemon off;'
