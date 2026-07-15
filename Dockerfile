# ✅ Sakto nga opisyal nga imahe
FROM ghcr.io/xtls/xray-core:1.8.26-alpine

# I-install ang Nginx
RUN apk add --no-cache nginx

# Kopyaha ang imong mga file
COPY xray.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Ihatag permiso
RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
