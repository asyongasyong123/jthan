#!/bin/bash
set -e

echo "=== Cloud Run PORT: $PORT ==="

# Auto-generate nginx.conf gamit ang PORT ni Cloud Run
cat > /usr/local/openresty/nginx/conf/nginx.conf <<EOF
worker_processes auto;
events { worker_connections 1024; }

http {
    server {
        listen ${PORT};
        listen [::]:${PORT};
        
        location /health {
            return 200 'OK';
            add_header Content-Type text/plain;
        }

        location / {
            return 200 'Cloud Run OK';
        }

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

echo "=== Starting OpenResty on port $PORT ==="
exec /usr/local/openresty/bin/openresty -g 'daemon off;'
