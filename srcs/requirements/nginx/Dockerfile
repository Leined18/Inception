# Usa debian:bookworm-slim como base
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala Nginx y otras dependencias necesarias
RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log 




# Copia los archivos de configuración personalizados y plantilla
COPY tools/nginx.conf /etc/nginx/nginx.conf
COPY tools/default.conf.tpl /etc/nginx/templates/default.conf.tpl
COPY tools/certs /etc/nginx/certs
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Expone el puerto 443
EXPOSE 443

# Usa entrypoint personalizado
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]