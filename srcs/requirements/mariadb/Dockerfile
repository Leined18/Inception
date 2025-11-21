FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base \
        mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/mysqld /var/log/mysql \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql

COPY requirements/mariadb/tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY requirements/mariadb/tools/init.sql /usr/local/share/init.sql
COPY requirements/mariadb/tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

STOPSIGNAL SIGTERM

ENV MYSQL_DATA_DIR=/var/lib/mysql

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["mysqld", "--user=mysql", "--console"]