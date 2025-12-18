#!/bin/bash
set -eo pipefail #check

# Expandir variables de entorno en el archivo .sql
envsubst < /init.sql > /tmp/init_expanded.sql #check
#echo "Archivo SQL con variables de entorno expandido:"
#cat /tmp/init_expanded.sql 




# Si el directorio de datos está vacío, inicializa MariaDB
if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
    mysql_install_db --user=mysql --datadir="$MYSQL_DATA_DIR" #check
fi

# Inicia MariaDB en segundo plano
/usr/bin/mysqld_safe --datadir="$MYSQL_DATA_DIR" & #check

# Espera a que MariaDB esté listo
until mysqladmin ping >/dev/null 2>&1; do
  echo -n "."; sleep 0.2
done


mysql < /tmp/init_expanded.sql #check

# Detiene MariaDB
mysqladmin shutdown

# Inicia MariaDB en primer plano
exec mysqld --user=mysql --console