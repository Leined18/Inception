#!/bin/bash
set -eo pipefail

MYSQL_DATA_DIR=/var/lib/mysql

# Variables desde .env
DB_NAME=${DB_NAME:-wp_db}
DB_USER=${DB_USER:-danpalac}
DB_ADMIN=${DB_ADMIN:-Adanpalac}

# Leer contraseñas desde secrets
DB_PASSWORD=$(cat /run/secrets/db_user_password)
DB_ADMIN_PASSWORD=$(cat /run/secrets/db_root_password)

# Inicializa la base de datos si no existe
if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
    echo "Inicializando MariaDB..."
    mysql_install_db --user=mysql --datadir="$MYSQL_DATA_DIR"
fi

# Inicia MariaDB temporalmente
/usr/bin/mysqld_safe --datadir="$MYSQL_DATA_DIR" &

# Espera a que MariaDB esté lista
until mysqladmin ping >/dev/null 2>&1; do
  echo -n "."; sleep 0.2
done

# Crear DB y usuarios con contraseñas de secrets
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "CREATE USER IF NOT EXISTS '$DB_ADMIN'@'%' IDENTIFIED BY '$DB_ADMIN_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_ADMIN'@'%' WITH GRANT OPTION;"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Detener MariaDB temporal
mysqladmin shutdown

# Inicia MariaDB en primer plano
exec mysqld --user=mysql --console
