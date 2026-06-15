#!/bin/bash
set -e

echo "Cloud Run PORT: $PORT"

# I-replace ang ${PORT} sa nginx.conf
export DOLLAR='$'
envsubst '${PORT},${DOLLAR}' < /usr/local/openresty/nginx/conf/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

echo "Starting Xray..."
/usr/local/bin/xray -config /etc/xray.json &

echo "Starting OpenResty..."
/usr/local/openresty/bin/openresty -g 'daemon off;' &

# Importante: Hulaton kung naay mamatay nga process
wait -n
echo "One process exited, shutting down container"
exit 1
