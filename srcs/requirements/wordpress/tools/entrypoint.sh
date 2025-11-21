#!/bin/bash

set -euo pipefail

WP_PATH=/var/www/html
WP_URL="https://${DOMAIN_NAME:-localhost}"

if [[ "${WP_ADMIN_USER,,}" == *admin* ]]; then
	echo "WP_ADMIN_USER must not contain 'admin'." >&2
	exit 1
fi

if [ -n "${TZ:-}" ] && [ -f "/usr/share/zoneinfo/${TZ}" ]; then
	ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
	echo "${TZ}" > /etc/timezone
fi

mkdir -p "${WP_PATH}" /run/php
chown -R www-data:www-data "${WP_PATH}" /run/php

if [ ! -f "${WP_PATH}/wp-includes/version.php" ]; then
	wp core download --allow-root --path="${WP_PATH}" --force
fi

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
	wp config create \
		--allow-root \
		--path="${WP_PATH}" \
		--dbname="${DB_NAME}" \
		--dbuser="${DB_USER}" \
		--dbpass="${DB_PASSWORD}" \
		--dbhost="${DB_HOST}" \
		--skip-check \
		--extra-php <<'PHP'
define('FS_METHOD', 'direct');
define('FS_CHMOD_FILE', 0644);
define('FS_CHMOD_DIR', 0755);
define('WP_ALLOW_REPAIR', true);
PHP
	wp config shuffle-salts --allow-root --path="${WP_PATH}"
fi

if ! wp core is-installed --allow-root --path="${WP_PATH}"; then
	wp core install \
		--allow-root \
		--path="${WP_PATH}" \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email
fi

if [ -n "${WP_USER:-}" ] && ! wp user get "${WP_USER}" --allow-root --path="${WP_PATH}" >/dev/null 2>&1; then
	wp user create \
		"${WP_USER}" \
		"${WP_EMAIL}" \
		--role=author \
		--user_pass="${WP_PASSWORD}" \
		--allow-root
fi

sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's|;clear_env = no|clear_env = no|' /etc/php/8.2/fpm/pool.d/www.conf

chown -R www-data:www-data "${WP_PATH}" /run/php

exec php-fpm8.2 -F
