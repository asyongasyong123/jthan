# Base nga gamay nga Alpine Linux
FROM alpine:3.20

# I-install ang gikinahanglan: Nginx, unzip, ca-certificates
RUN apk update && apk add --no-cache nginx unzip ca-certificates tzdata

# I-download ug i-install ang EKSAKTONG Xray v1.8.26 gikan sa opisyal nga GitHub
RUN wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.26/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm -f /tmp/xray.zip

# I-set ang saktong path para makita ang xray
ENV PATH="/usr/local/bin:${PATH}"

# Kopyaha ang imong config files
COPY xray.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Ihatag permiso sa entrypoint
RUN chmod +x /entrypoint.sh

# Bantayi ang port nga gikinahanglan sa Cloud Run
EXPOSE 8080

CMD ["/entrypoint.sh"]
