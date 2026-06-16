#!/bin/bash
set -e

echo "=== PORT=$PORT ==="

# Test xray config first - kung naay sala, mu-gawas diri ang error
/usr/local/bin/xray -test -config /etc/xray.json

# Generate nginx.conf
cat > /etc/nginx.conf <<EOF
events { worker_connections 1024; }
http {
    server {
        listen $PORT;
        location /health { return 200 'OK'; }
        location / { return 200 'OK'; }
    }
}
EOF

echo "=== Starting Xray ==="
/usr/local/bin/xray -config /etc/xray.json &

echo "=== Starting Nginx ==="
# Importante ang exec - para dili mamatay ang container
exec /usr/local/openresty/bin/openresty -c /etc/nginx.conf -g 'daemon off;'
