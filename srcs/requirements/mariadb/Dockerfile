FROM debian:bookworm

RUN apt update && apt install -y \
    mariadb-server mariadb-client

USER root

COPY ./tools/script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]