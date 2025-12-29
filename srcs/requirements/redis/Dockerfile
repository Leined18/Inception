# Dockerfile para el servicio Redis (bonus Inception)
# Usamos la imagen oficial de redis basada en Alpine para cumplir el subject
FROM alpine:3.19

# Instalamos redis
RUN apk update && apk add --no-cache redis

# Copiamos la configuración por defecto (puedes personalizar si lo deseas)
COPY tools/redis.conf /etc/redis.conf

# Exponemos el puerto por defecto de Redis
EXPOSE 6379

# Iniciamos Redis en primer plano (sin hacks)
CMD ["redis-server", "/etc/redis.conf"]
