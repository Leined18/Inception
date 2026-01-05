# User Documentation

This guide explains how to use the Inception Docker infrastructure as an end user or administrator.

## Services Overview

The Inception stack provides the following services:

- **NGINX**: Reverse proxy and web server with TLS encryption (port 443)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server for WordPress data persistence
- **Redis**: Cache server for improved WordPress performance (bonus)
- **Static Site**: Portfolio website showcasing 42 projects (bonus)

## Starting and Stopping the Project

### Starting the Infrastructure
Navigate to the project root directory and run:
```bash
make
```
This will:
- Build all Docker images from source
- Initialize the database with proper credentials
- Start all services with health checks
- Set up networking and volume management

### Stopping the Infrastructure
```bash
make down
```

### Complete Cleanup (Remove all data)
```bash
make fclean
```
⚠️ **Warning**: This permanently deletes all data including database and uploaded files.

## Accessing the Website

### Main Website
- **URL**: `https://danpalac.42.fr`
- **Content**: Static portfolio site served from root path
- **Features**: 42 project showcase with Redis status indicator

### WordPress Site
- **Admin Panel**: `https://danpalac.42.fr/wp-admin`
- **Public Site**: Available via WordPress-specific routes
- **Features**: Full CMS with Redis caching integration

### SSL Certificate
The site uses a self-signed certificate. Accept the browser security warning to proceed.
## Credentials Management

### Credential Locations
All sensitive information is stored in the `secrets/` directory:
- `secrets/db_root_password.txt` - MariaDB root password
- `secrets/db_password.txt` - WordPress database user password
- `secrets/credentials.txt` - WordPress admin credentials

### WordPress Access
Check the `secrets/credentials.txt` file for:
- Admin username (must not contain "admin" per requirements)
- Admin password
- Admin email address

## Service Health Monitoring

### Check All Services
```bash
docker-compose -f srcs/docker-compose.yml ps
```

Expected output shows all services as "Up":
```
NAME      IMAGE                  STATUS         PORTS
mariadb   inception_mariadb      Up (healthy)   3306/tcp
nginx     inception_nginx        Up             0.0.0.0:443->443/tcp
redis     inception_redis        Up             6379/tcp
static    inception_static       Up             8080/tcp
wordpress inception_wordpress    Up (healthy)   9000/tcp
```

### Individual Service Logs
```bash
# View logs for specific services
docker-compose -f srcs/docker-compose.yml logs nginx
docker-compose -f srcs/docker-compose.yml logs wordpress
docker-compose -f srcs/docker-compose.yml logs mariadb
docker-compose -f srcs/docker-compose.yml logs redis
```

### Test Website Connectivity
```bash
# Test HTTPS connection
curl -k https://danpalac.42.fr

# Verify WordPress is responding
curl -k https://danpalac.42.fr/wp-admin
```
docker-compose -f srcs/docker-compose.yml logs mariadb
```

### Test Website Connectivity
```bash
# Test HTTPS connection
curl -k https://danpalac.42.fr

# Check if WordPress is responding
curl -k https://danpalac.42.fr/wp-admin
```

## Data Persistence

### Volume Locations
- **Database Data**: Managed by `mysql_data` Docker volume
- **WordPress Files**: Managed by `wordpress_data` Docker volume
- **Host Mapping**: Available in `/home/danpalac/data/` directory structure

### Backup Procedures
```bash
# Backup database
docker-compose -f srcs/docker-compose.yml exec mariadb mysqldump -u root -p$(cat secrets/db_root_password.txt) wordpress > backup.sql

# Backup WordPress files
docker run --rm -v wordpress_data:/data -v $(pwd):/backup alpine tar czf /backup/wp_backup.tar.gz /data
```

## Troubleshooting

### Common Issues

#### Domain Resolution
Ensure your `/etc/hosts` file contains:
```
127.0.0.1 danpalac.42.fr
```

#### Port Conflicts
Check if port 443 is available:
```bash
sudo netstat -tulpn | grep :443
```

#### Service Dependencies
Services start in order: MariaDB → WordPress → NGINX
Check logs if startup fails:
```bash
docker-compose -f srcs/docker-compose.yml logs --tail=50
```

#### Redis Cache Issues
Verify Redis is connected to WordPress:
- Check the WordPress admin dashboard for Redis status
- Look for the Redis status banner on the homepage
