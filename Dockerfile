FROM alpine:3.20

ENV XRAY_VERSION=26.2.6

RUN apk update --no-cache && apk add --no-cache \
    nginx wget unzip ca-certificates tzdata

RUN wget -qO /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && rm /tmp/xray.zip && \
    chmod +x /usr/local/bin/xray

RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/http.d/*

COPY xray.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
