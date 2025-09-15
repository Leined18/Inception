FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    php8.2-fpm \
    php8.2-redis \
    php8.2-mysql \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm8.2", "-F"]

EXPOSE 9000
