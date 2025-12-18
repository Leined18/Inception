# Developer Documentation

This guide provides detailed instructions for developers working on the Inception project infrastructure.

## Environment Setup from Scratch

### Prerequisites
1. **Virtual Machine**: The project must run in a VM environment
2. **Operating System**: Linux distribution (Ubuntu/Debian recommended)
3. **Software Requirements**:
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER
   
   # Install Docker Compose
   sudo apt install docker-compose -y
   
   # Install Make
   sudo apt install make -y
   ```
4. **Network Configuration**:
   ```bash
   # Add domain to hosts file
   echo "127.0.0.1 danpalac.42.fr" | sudo tee -a /etc/hosts
   ```

### Configuration Files Setup

#### 1. Environment Variables (`srcs/.env`)
Create and configure the environment file:
```bash
DOMAIN_NAME=danpalac.42.fr

# MySQL/MariaDB Configuration
MYSQL_USER=wpuser
MYSQL_DATABASE=wordpress
MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password
MYSQL_PASSWORD_FILE=/run/secrets/db_password

# WordPress Configuration
WORDPRESS_DB_HOST=mariadb:3306
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wpuser
WORDPRESS_DB_PASSWORD_FILE=/run/secrets/db_password
```

#### 2. Secrets Configuration
Create the secrets directory and files:
```bash
# Create secrets directory
mkdir -p secrets

# Database root password
echo "strong_root_password_123" > secrets/db_root_password.txt

# WordPress database user password
echo "strong_wp_password_456" > secrets/db_password.txt

# WordPress admin credentials
cat > secrets/credentials.txt << EOF
WordPress Admin Credentials:
Username: danpalac_admin
Password: admin_secure_pass_789
Email: admin@danpalac.42.fr
EOF

# Set proper permissions
chmod 600 secrets/*
```

#### 3. SSL Certificates
Generate self-signed certificates for NGINX:
```bash
mkdir -p srcs/requirements/nginx/tools/certs/danpalac.42.fr

# Generate private key and certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout srcs/requirements/nginx/tools/certs/danpalac.42.fr/key.pem \
  -out srcs/requirements/nginx/tools/certs/danpalac.42.fr/cert.pem \
  -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=danpalac.42.fr"
```

## Building and Launching the Project

### Using Makefile (Recommended)
```bash
# Build and start all services
make

# Rebuild everything (clean build)
make re

# Stop services
make down

# Clean everything (including volumes and images)
make fclean
```

### Using Docker Compose Directly
```bash
# Build images
docker-compose -f srcs/docker-compose.yml build

# Start services
docker-compose -f srcs/docker-compose.yml up -d

# Stop services
docker-compose -f srcs/docker-compose.yml down

# View logs
docker-compose -f srcs/docker-compose.yml logs -f
```

### Manual Build Process
```bash
# Build individual services
docker build -t inception_nginx srcs/requirements/nginx/
docker build -t inception_wordpress srcs/requirements/wordpress/
docker build -t inception_mariadb srcs/requirements/mariadb/

# Create network
docker network create inception_network

# Create volumes
docker volume create inception_wp_data
docker volume create inception_db_data
```

## Container Management

### Access Running Containers
```bash
# Access NGINX container
docker-compose -f srcs/docker-compose.yml exec nginx sh

# Access WordPress container
docker-compose -f srcs/docker-compose.yml exec wordpress bash

# Access MariaDB container
docker-compose -f srcs/docker-compose.yml exec mariadb bash
```

### Container Inspection
```bash
# List running containers
docker-compose -f srcs/docker-compose.yml ps

# View container resource usage
docker stats

# Inspect container configuration
docker inspect inception_nginx
docker inspect inception_wordpress
docker inspect inception_mariadb
```

### Log Management
```bash
# Follow logs for all services
docker-compose -f srcs/docker-compose.yml logs -f

# Follow logs for specific service
docker-compose -f srcs/docker-compose.yml logs -f nginx
docker-compose -f srcs/docker-compose.yml logs -f wordpress
docker-compose -f srcs/docker-compose.yml logs -f mariadb

# View last 100 log lines
docker-compose -f srcs/docker-compose.yml logs --tail=100 nginx
```

## Volume Management

### Data Persistence Locations
- **Database Data**: `/home/danpalac/data/mariadb/`
- **WordPress Files**: `/home/danpalac/data/wordpress/`

### Volume Operations
```bash
# List volumes
docker volume ls

# Inspect volume details
docker volume inspect inception_wp_data
docker volume inspect inception_db_data

# Backup volume data
docker run --rm -v inception_db_data:/data -v $(pwd):/backup alpine tar czf /backup/db_backup.tar.gz /data
docker run --rm -v inception_wp_data:/data -v $(pwd):/backup alpine tar czf /backup/wp_backup.tar.gz /data

# Restore volume data
docker run --rm -v inception_db_data:/data -v $(pwd):/backup alpine tar xzf /backup/db_backup.tar.gz -C /

# Remove volumes (careful - data loss!)
docker volume rm inception_wp_data inception_db_data
```

### Host Directory Mapping
```bash
# Check actual volume locations on host
docker volume inspect inception_wp_data | grep Mountpoint
docker volume inspect inception_db_data | grep Mountpoint

# Direct access to volume data
sudo ls -la /var/lib/docker/volumes/inception_wp_data/_data
sudo ls -la /var/lib/docker/volumes/inception_db_data/_data
```

## Network Management

### Network Configuration
```bash
# List networks
docker network ls

# Inspect network details
docker network inspect inception_network

# Test connectivity between containers
docker-compose -f srcs/docker-compose.yml exec nginx ping wordpress
docker-compose -f srcs/docker-compose.yml exec wordpress ping mariadb
```

## Development Workflow

### Testing Changes
1. **Dockerfile modifications**:
   ```bash
   # Rebuild specific service
   docker-compose -f srcs/docker-compose.yml build nginx
   docker-compose -f srcs/docker-compose.yml up -d nginx
   ```

2. **Configuration changes**:
   ```bash
   # Restart affected services
   docker-compose -f srcs/docker-compose.yml restart nginx
   ```

3. **Full rebuild**:
   ```bash
   make re
   ```

### Debugging
```bash
# Check service health
docker-compose -f srcs/docker-compose.yml exec nginx nginx -t
docker-compose -f srcs/docker-compose.yml exec mariadb mysqladmin ping

# Test database connection
docker-compose -f srcs/docker-compose.yml exec wordpress wp db check

# Monitor resource usage
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

### Performance Optimization
```bash
# Analyze image sizes
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Check for unused resources
docker system df
docker system prune -f

# Monitor container logs for errors
docker-compose -f srcs/docker-compose.yml logs --tail=50 | grep -i error
```

## Troubleshooting Common Issues

### Build Failures
1. **Permission denied errors**:
   ```bash
   sudo chmod +x srcs/requirements/*/tools/*.sh
   ```

2. **Network conflicts**:
   ```bash
   docker network prune
   ```

3. **Port already in use**:
   ```bash
   sudo netstat -tulpn | grep :443
   sudo lsof -i :443
   ```

### Runtime Issues
1. **Container crashes**:
   ```bash
   docker-compose -f srcs/docker-compose.yml logs mariadb
   docker-compose -f srcs/docker-compose.yml restart mariadb
   ```

2. **Database connection issues**:
   ```bash
   # Test database connectivity
   docker-compose -f srcs/docker-compose.yml exec wordpress wp db check
   
   # Reset database if needed
   docker-compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p -e "SHOW DATABASES;"
   ```

### Security Considerations
```bash
# Check for running processes in containers
docker-compose -f srcs/docker-compose.yml exec nginx ps aux
docker-compose -f srcs/docker-compose.yml exec wordpress ps aux

# Verify no passwords in images
docker history inception_nginx --no-trunc
docker history inception_wordpress --no-trunc
docker history inception_mariadb --no-trunc
```
