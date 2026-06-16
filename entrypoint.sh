#!/bin/bash
set -e

echo "=== PORT=$PORT ==="

/usr/local/bin/xray -test -config /etc/xray.json

# KEY FIX: Walay SSL, walay http2, plain HTTP lang
cat > /etc/nginx.conf <<EOF
worker_processes auto;
events { worker_connections 1024; }

http {
    server {
        listen $PORT;
        listen [::]:$PORT;
        
        # Dili ni SSL kay si Cloud Run na ang TLS termination
        # Ayaw butangi ug 'http2 on' kung walay ssl
        
        location /health { return 200 'OK'; }
        location / { return 200 'OK'; }

        location /JonathanTrWS {
            proxy_pass http://127.0.0.1:10001;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanVlWS {
            proxy_pass http://127.0.0.1:10002;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanVmWS {
            proxy_pass http://127.0.0.1:10003;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanSsWS {
            proxy_pass http://127.0.0.1:10004;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanTrHU {
            proxy_pass http://127.0.0.1:11001;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanVlHU {
            proxy_pass http://127.0.0.1:11002;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanVmHU {
            proxy_pass http://127.0.0.1:11003;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }

        location /JonathanSsHU {
            proxy_pass http://127.0.0.1:11004;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$host;
            proxy_read_timeout 86400;
        }
    }
}
EOF

echo "=== Starting Xray ==="
/usr/local/bin/xray -config /etc/xray.json &

echo "=== Starting Nginx ==="
exec /usr/local/openresty/bin/openresty -c /etc/nginx.conf -g 'daemon off;'
