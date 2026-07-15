#!/bin/sh
set -e

echo "✅ Starting Xray..."
xray run -c /etc/xray/config.json &
XRAY_PID=$!

sleep 3

echo "✅ Starting Nginx..."
nginx -g "daemon off;" &
NGINX_PID=$!

# Kung asa man ni ang mohunong, mohunong sad ang tibuok script
wait -n $XRAY_PID $NGINX_PID
echo "⚠️ Usa ka serbisyo nahunong, gipatong ang tibuok proseso..."
kill $XRAY_PID $NGINX_PID
