# Gamit ang opisyal nga 1.8.26
FROM ghcr.io/xtls/xray-core:1.8.26

# I-install ang Nginx
RUN apk add --no-cache nginx

# Kopyaha ang imong files
COPY xray.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
