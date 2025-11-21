-- Creates the WordPress schema with utf8mb4 support in case it was purged.
CREATE DATABASE IF NOT EXISTS `${DB_NAME}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Ensures the application user exists and owns only its schema.
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON `${DB_NAME}`.* TO '${DB_USER}'@'%';

-- Aligns root credentials across localhost variants without failing on missing rows.
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
ALTER USER IF EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
ALTER USER IF EXISTS 'root'@'::1' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Drops anonymous accounts created by the stock packages.
DELETE FROM mysql.user WHERE User='' OR (User='root' AND Host NOT IN ('localhost','127.0.0.1','::1'));

FLUSH PRIVILEGES;