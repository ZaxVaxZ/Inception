FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y nginx openssl && mkdir -p /etc/nginx/ssl

COPY ./tools/entry.sh /usr/local/bin

RUN chmod 711 /usr/local/bin/entry.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entry.sh"]
