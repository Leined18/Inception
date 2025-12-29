
# Redirige HTTP a HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};
    return 301 https://$server_name$request_uri;
}

# HTTPS: la raíz (/) va a la web estática, /wp y /wordpress a WordPress
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};

    ssl_certificate /etc/nginx/certs/${DOMAIN_NAME}/cert.pem;
    ssl_certificate_key /etc/nginx/certs/${DOMAIN_NAME}/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Proxy a la web estática (contenedor static) para la raíz
    location / {
        proxy_pass http://static:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Proxy a WordPress para /wp y /wordpress
    location ~ ^/(wp|wordpress)(/|$) {
        proxy_pass http://wordpress:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Proxy PHP directamente a WordPress para compatibilidad
    location ~ [^/]\.php(/|$) {
        proxy_pass http://wordpress:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
