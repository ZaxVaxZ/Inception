FROM debian:bookworm

RUN apt update && apt install -y \
    curl mariadb-client sendmail \
    php php-fpm php-mysql \
    && mkdir -p /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY ./tools/script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh && chmod 777 /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/script.sh"]
