#!/bin/bash

set -euo pipefail

if [ -z "${MYSQL_ROOT_PASSWORD:-}" ]; then
	echo "MYSQL_ROOT_PASSWORD must be defined." >&2
	exit 1
fi

MYSQL_DATA_DIR=${MYSQL_DATA_DIR:-/var/lib/mysql}
MYSQL_SOCKET=/run/mysqld/mysqld.sock

# Aligns permissions on bind mounts that may come back owned by root.
chown -R mysql:mysql "${MYSQL_DATA_DIR}" /var/run/mysqld /var/log/mysql
chmod 755 /var/run/mysqld /var/log/mysql

# Initializes an empty datadir; noop on restarts with existing data.
if [ ! -d "${MYSQL_DATA_DIR}/mysql" ] || [ -z "$(ls -A "${MYSQL_DATA_DIR}/mysql" 2>/dev/null)" ]; then
	mariadb-install-db --user=mysql --datadir="${MYSQL_DATA_DIR}"
fi

# Templated SQL seeds the database, users, and root credentials.
envsubst < /usr/local/share/init.sql > /tmp/init.sql

/usr/sbin/mysqld --user=mysql --datadir="${MYSQL_DATA_DIR}" --skip-networking --socket="${MYSQL_SOCKET}" &
MYSQL_TMP_PID=$!

# Waits for mysqld whether root already has a password or not.
until mysqladmin --socket="${MYSQL_SOCKET}" -uroot -p"${MYSQL_ROOT_PASSWORD}" ping >/dev/null 2>&1 \
	|| mysqladmin --socket="${MYSQL_SOCKET}" -uroot --skip-password ping >/dev/null 2>&1; do
	sleep 0.2
done

AUTH_ARGS=(-uroot -p"${MYSQL_ROOT_PASSWORD}")
if ! mariadb --socket="${MYSQL_SOCKET}" "${AUTH_ARGS[@]}" -e "SELECT 1" >/dev/null 2>&1; then
	AUTH_ARGS=(-uroot --skip-password)
fi

mariadb --socket="${MYSQL_SOCKET}" "${AUTH_ARGS[@]}" < /tmp/init.sql

mysqladmin --socket="${MYSQL_SOCKET}" -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "${MYSQL_TMP_PID}"

exec "$@"