# User Documentation

This guide explains how to use the Inception Docker infrastructure as an end user or administrator.

## Services Overview

The Inception stack provides the following services:

- **Web Server (NGINX)**: Serves the WordPress website over HTTPS (port 443)
- **WordPress**: Content management system for creating and managing website content
- **Database (MariaDB)**: Stores WordPress data including posts, users, and configurations

## Starting and Stopping the Project

### Starting the Infrastructure
1. Navigate to the project root directory
2. Run the following command:
   ```bash
   make
   ```
   This will:
   - Build all Docker images
   - Start all services
   - Set up networking and volumes
   - Initialize the database

### Stopping the Infrastructure
```bash
make down
```

### Cleaning Up (Remove all data)
```bash
make fclean
```
⚠️ **Warning**: This will permanently delete all data including the database and uploaded files.

### Restarting Services
```bash
make re
```

## Accessing the Website

### Main Website
- URL: `https://danpalac.42.fr`
- The website will be accessible after the services are running
- Accept the self-signed certificate warning in your browser

### WordPress Administration Panel
- URL: `https://danpalac.42.fr/wp-admin`
- Use the administrator credentials (see Credentials section below)

## Credentials Management

### Location of Credentials
Credentials are stored in the `secrets/` directory:
- `secrets/db_root_password.txt` - Database root password
- `secrets/db_password.txt` - WordPress database user password
- `secrets/credentials.txt` - WordPress admin credentials

### WordPress Admin Access
- **Username**: Check `secrets/credentials.txt` for admin username
- **Password**: Check `secrets/credentials.txt` for admin password
- **Email**: Admin email address (if configured)

### Database Access (Advanced Users)
- **Host**: `mariadb` (internal container name)
- **Port**: 3306 (internal)
- **Database**: `wordpress`
- **Username**: Defined in `.env` file
- **Password**: Stored in `secrets/db_password.txt`

## Checking Service Status

### Verify All Services Are Running
```bash
docker-compose -f srcs/docker-compose.yml ps
```

Expected output should show all services as "Up":
```
Name                 Command               State           Ports
----------------------------------------------------------------
inception_mariadb    docker-entrypoint.sh mysqld     Up      3306/tcp
inception_nginx      nginx -g daemon off;             Up      0.0.0.0:443->443/tcp
inception_wordpress  docker-entrypoint.sh php-fpm    Up      9000/tcp
```

### Check Individual Service Logs
```bash
# NGINX logs
docker-compose -f srcs/docker-compose.yml logs nginx

# WordPress logs
docker-compose -f srcs/docker-compose.yml logs wordpress

# Database logs
docker-compose -f srcs/docker-compose.yml logs mariadb
```

### Test Website Connectivity
```bash
# Test HTTPS connection
curl -k https://danpalac.42.fr

# Check if WordPress is responding
curl -k https://danpalac.42.fr/wp-admin
```

### Verify Data Persistence
Data is stored in the following locations:
- **Database**: `/home/danpalac/data/mariadb/`
- **WordPress files**: `/home/danpalac/data/wordpress/`

Check these directories exist and contain data:
```bash
ls -la /home/danpalac/data/
```

## Troubleshooting

### Service Won't Start
1. Check if ports are already in use:
   ```bash
   sudo netstat -tulpn | grep :443
   ```
2. Verify Docker daemon is running:
   ```bash
   systemctl status docker
   ```
3. Check for syntax errors in configuration:
   ```bash
   docker-compose -f srcs/docker-compose.yml config
   ```

### Website Not Accessible
1. Verify NGINX is running and listening on port 443
2. Check if domain is properly configured in `/etc/hosts`:
   ```bash
   grep danpalac.42.fr /etc/hosts
   ```
   Should contain: `127.0.0.1 danpalac.42.fr`
3. Check SSL certificate is properly generated

### Database Connection Issues
1. Verify MariaDB container is running
2. Check database initialization logs:
   ```bash
   docker-compose -f srcs/docker-compose.yml logs mariadb
   ```
3. Verify environment variables in `srcs/.env` are correct

### Forgot Admin Password
1. Check `secrets/credentials.txt` for current credentials
2. If needed, reset through WordPress CLI in container:
   ```bash
   docker-compose -f srcs/docker-compose.yml exec wordpress wp user update admin --user_pass=newpassword
   ```

## Maintenance Tasks

### Backup Data
```bash
# Backup database
docker-compose -f srcs/docker-compose.yml exec mariadb mysqldump -u root -p wordpress > backup.sql

# Backup WordPress files
tar -czf wordpress_backup.tar.gz /home/danpalac/data/wordpress/
```

### Update WordPress (Manual)
1. Access WordPress admin panel
2. Navigate to Dashboard → Updates
3. Follow on-screen instructions

### Monitor Resource Usage
```bash
# Check container resource usage
docker stats

# Check disk usage of volumes
du -sh /home/danpalac/data/*
```
