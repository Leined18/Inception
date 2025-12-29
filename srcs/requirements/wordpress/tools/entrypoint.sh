#!/bin/bash
set -e  # Detener si hay errores

# Copiar wp-config.php al directorio de WordPress
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root
fi
cp /tmp/wp-config.php /var/www/html/wp-config.php
echo "Config WordPress copiado."

# Instalar WordPress si no está instalado
wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$(cat /run/secrets/db_root_password)" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
echo "WordPress instalado correctamente."


# Crear usuario normal si no existe
USER_EXISTS=$(wp user get "$WP_USER" --field=user_login --allow-root 2>/dev/null || echo "no")
EMAIL_EXISTS=$(wp user list --field=user_email --allow-root | grep -Fx "$WP_EMAIL" || echo "no")

if [ "$USER_EXISTS" = "no" ] && [ "$EMAIL_EXISTS" = "no" ]; then
    wp user create "$WP_USER" "$WP_EMAIL" \
        --role=author \
        --user_pass="$(cat /run/secrets/db_user_password)" \
        --allow-root
    echo "Usuario '$WP_USER' creado correctamente."
else
    echo "Usuario '$WP_USER' o correo '$WP_EMAIL' ya existe, omitiendo creación."
fi

# Instalar y activar el plugin Redis Object Cache automáticamente
# Esto permite que WordPress use Redis como cache de objetos
if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
    echo "Plugin Redis Object Cache instalado y activado."
else
    wp plugin activate redis-cache --allow-root
    echo "Plugin Redis Object Cache ya estaba instalado, activado."
fi

# Habilitar el cache de objetos en Redis desde WP-CLI
wp redis enable --allow-root || true
echo "Redis Object Cache habilitado en WordPress."

# Ajustes PHP-FPM
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's/;clear_env = no/clear_env = no/' /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php
chown -R www-data:www-data /var/www/html

# Inicia PHP-FPM
echo "Iniciando PHP-FPM..."
exec php-fpm8.2 -F
