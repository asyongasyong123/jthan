#!/bin/sh
set -e

echo "✅ Starting Xray..."
xray run -c /etc/xray/config.json &
XRAY_PID=$!

sleep 3

echo "✅ Starting Nginx..."
nginx -g "daemon off;" &
NGINX_PID=$!

# Mamonitor ang duha — kung usa mohunong, mohunong tanan
wait -n $XRAY_PID $NGINX_PID
echo "⚠️ Service stopped, shutting down..."
kill $XRAY_PID $NGINX_PID
