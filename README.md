# Inception

*This project has been created as part of the 42 curriculum by danpalac.*

## Description

Inception is a system administration project focused on Docker containerization and orchestration. The goal is to set up a small infrastructure composed of different services using Docker Compose, following specific rules and best practices. The project virtualizes several Docker images including NGINX with TLS, WordPress with PHP-FPM, and MariaDB, all running in separate containers with proper networking and volume management.

This infrastructure simulates a real-world web application deployment scenario, teaching essential DevOps skills including container orchestration, security configuration, and service isolation.

## Instructions

### Prerequisites
- Virtual Machine (required by 42 subject)
- Docker and Docker Compose installed
- Make utility
- Domain configuration: `danpalac.42.fr` pointing to localhost

### Setup and Execution
1. Clone the repository and navigate to the project directory
2. Configure environment variables and secrets:
   ```bash
   # Set up secrets directory with credentials
   mkdir -p secrets
   echo "your_root_password" > secrets/db_root_password.txt
   echo "your_user_password" > secrets/db_password.txt
   echo "admin_credentials_info" > secrets/credentials.txt
   chmod 600 secrets/*
   ```
3. Configure domain in `/etc/hosts`:
   ```bash
   echo "127.0.0.1 danpalac.42.fr" | sudo tee -a /etc/hosts
   ```
4. Build and run the infrastructure:
   ```bash
   make
   ```

### Accessing the Services
- **Main Website**: https://danpalac.42.fr (WordPress site)
- **WordPress Admin**: https://danpalac.42.fr/wp-admin
- **Static Portfolio Site**: https://danpalac.42.fr/static/ (bonus service)
- **Redis Integration**: Visible through WordPress performance improvements

## Project Design Choices

### Docker Architecture
This project uses Docker containerization with the following design decisions:

#### Virtual Machines vs Docker
- **Virtual Machines**: Complete OS virtualization with full isolation but higher resource overhead
- **Docker** (chosen): Container-based virtualization providing:
  - Lightweight resource usage compared to VMs
  - Faster startup and deployment times
  - Better scalability and portability
  - Process-level isolation sufficient for web services
  - Easier development and production parity

#### Secrets vs Environment Variables
- **Environment Variables**: Used for non-sensitive configuration (domain names, service endpoints, ports)
- **Docker Secrets** (implemented): Used for sensitive data:
  - Database passwords stored in `secrets/` directory
  - Mounted as files in containers at `/run/secrets/`
  - Not exposed in process environment or logs
  - Proper file permissions (600) for security
  - Git-ignored to prevent credential exposure

#### Docker Network vs Host Network
- **Docker Bridge Network** (implemented): Custom network `inception_network` providing:
  - Service isolation and segmentation
  - DNS-based service discovery between containers
  - Port isolation from host system
  - Security through network policies
  - Container-to-container communication without exposing internal ports

#### Docker Volumes vs Bind Mounts
- **Docker Named Volumes** (chosen): Used for persistent data:
  - Database storage: `mysql_data` volume
  - WordPress files: `wordpress_data` volume
  - Managed by Docker with automatic cleanup
  - Better performance and portability
  - Easier backup and migration strategies

### Service Architecture
The infrastructure consists of:

- **NGINX**: Reverse proxy with TLS termination (only port 443 exposed)
- **WordPress**: PHP-FPM application server (internal communication)
- **MariaDB**: Database server with persistent storage
- **Redis**: Caching layer for WordPress (bonus service)
- **Static Site**: Portfolio website served via separate container
## Resources

### Documentation
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/support/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

### AI Usage
AI tools were utilized throughout this project for:

- **Infrastructure Design**: Architecting the multi-container setup and service communication patterns
- **Dockerfile Optimization**: Creating secure, efficient container builds following best practices
- **Configuration Management**: Generating and reviewing NGINX, PHP-FPM, and MariaDB configurations
- **Security Implementation**: Implementing TLS configuration, secrets management, and container hardening
- **Automation Scripts**: Creating initialization scripts for database setup and WordPress configuration
- **Documentation**: Generating comprehensive user and developer documentation
- **Troubleshooting**: Debugging container networking, volume mounting, and service dependency issues

All AI-generated content was thoroughly tested, validated, and adapted to meet project requirements and security standards.

### Virtual Machines vs Docker
- **Virtual Machines**: Full OS virtualization with complete isolation but higher resource overhead
- **Docker**: Container-based virtualization sharing the host kernel, providing:
  - Lighter resource usage
  - Faster startup times
  - Better scalability
  - Easier deployment and versioning
  - Process-level isolation (sufficient for this use case)

### Secrets vs Environment Variables
- **Environment Variables**: Used for non-sensitive configuration (domain names, service names, ports)
- **Secrets**: Used for sensitive data (passwords, API keys, certificates):
  - Stored in separate files outside the main codebase
  - Not tracked in version control
  - Mounted into containers at runtime
  - Better security through restricted file permissions

### Docker Network vs Host Network
- **Docker Network**: Custom bridge network for service communication:
  - Service isolation and segmentation
  - DNS-based service discovery
  - Port isolation from host
  - Better security through network policies
- **Host Network**: Avoided to maintain container isolation and security

### Docker Volumes vs Bind Mounts
- **Docker Volumes**: Used for persistent data (databases, WordPress files):
  - Managed by Docker daemon
  - Better performance on non-Linux hosts
  - Easier backup and migration
  - Automatic cleanup capabilities
- **Bind Mounts**: Used sparingly for configuration files:
  - Direct host filesystem access
  - Useful for development and configuration injection

## Additional Documentation

- [USER_DOC.md](./USER_DOC.md) - End user and administrator guide
- [DEV_DOC.md](./DEV_DOC.md) - Developer setup and management guide
