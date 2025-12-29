# Dockerfile para el servicio de sitio web estático (bonus Inception)
FROM nginx:alpine


# Copia el contenido estático y los assets (css, js) al directorio de NGINX
COPY html/ /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/

# Expone el puerto 80 para HTTP
EXPOSE 80


# Sobrescribe la configuración de nginx para redirigir todo a index.html
COPY nginx.conf /etc/nginx/nginx.conf
