FROM teddysun/xray:latest AS xray-bin
FROM openresty/openresty:alpine-fat

COPY --from=xray-bin /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8080

CMD ["/bin/sh", "-c", "/usr/local/openresty/bin/openresty -g 'daemon off;' & /usr/local/bin/xray run -c /etc/xray.json"]
