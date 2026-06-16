FROM alpine:3.20 AS builder
WORKDIR /app
RUN apk add --no-cache curl unzip ca-certificates
ARG XRAY_VERSION=v24.9.30
RUN curl -fL --retry 3 --retry-delay 2 https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip -o xray.zip \
 && unzip xray.zip xray && chmod +x xray && mv xray /usr/local/bin/ \
 && rm -f xray.zip

FROM openresty/openresty:1.25.3.1-alpine
RUN apk add --no-cache ca-certificates bash tzdata curl
COPY --from=builder /usr/local/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray.json
COPY entrypoint.sh /entrypoint.sh
# Importante: Kuhaa ang CRLF kung naa
RUN dos2unix /entrypoint.sh || true && chmod +x /usr/local/bin/xray /entrypoint.sh
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
