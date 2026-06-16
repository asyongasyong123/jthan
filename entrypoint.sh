#!/bin/bash
set -e

echo "Cloud Run PORT: $PORT"

# Gamita ang envsubst instead of sed para sure mu-work bisan unsa ang PORT
export DOLLAR='$'
envsubst '${PORT},${DOLLAR}' < /usr/local/openresty/nginx/conf/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

echo "Starting Xray..."
/usr/local/bin/xray -config /etc/xray.json &

echo "Starting OpenResty on port $PORT..."
/usr/local/openresty/bin/openresty -g 'daemon off;' &

# Importante: Hulaton kung naay process nga mamatay
wait -n
echo "A process exited. Shutting down."
exit 1
