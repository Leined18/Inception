FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base \
        nginx \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copia los archivos de configuración personalizados
COPY requirements/nginx/tools/nginx.conf /etc/nginx/nginx.conf
COPY requirements/nginx/tools/default.conf /etc/nginx/templates/default.conf.tpl
COPY requirements/nginx/tools/certs /etc/nginx/certs
COPY requirements/nginx/tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]