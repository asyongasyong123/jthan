FROM alpine:3.20

# ✅ XHTTP minimum required version: v25.2.1+ (old 1.8.24 walay suporta sa XHTTP!)
ENV XRAY_VERSION=26.2.6

RUN apk update --no-cache && apk add --no-cache \
    nginx wget unzip ca-certificates tzdata

# ✅ Siguroha nga walay sayop sa download link
RUN wget -qO /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && rm /tmp/xray.zip && \
    chmod +x /usr/local/bin/xray

RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/http.d/*

COPY xray.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

# ✅ Mas maayo nga pamaagi: kung usa mapalong, mapalong sad ang lain (dili biyaan nga nagdagan)
ENTRYPOINT ["/bin/sh", "-c", "nginx -g 'daemon off;' & PID1=$!; exec xray run -c /etc/xray/config.json; wait $PID1"]
