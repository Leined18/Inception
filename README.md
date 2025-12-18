# Inception

*This project has been created as part of the 42 curriculum by danpalac.*

## Description

Inception is a system administration project focused on Docker containerization and orchestration. The goal is to set up a small infrastructure composed of different services using Docker Compose, following specific rules and best practices. The project virtualizes several Docker images including NGINX with TLS, WordPress with PHP-FPM, and MariaDB, all running in separate containers with proper networking and volume management.

This infrastructure simulates a real-world web application deployment scenario, teaching essential DevOps skills including container orchestration, security configuration, and service isolation.

## Instructions

### Prerequisites
- Virtual Machine (required)
- Docker and Docker Compose installed
- Make utility

### Setup and Execution
1. Clone the repository and navigate to the project directory
2. Configure your domain name to point to your local IP address (danpalac.42.fr)
3. Set up environment variables in `srcs/.env` file
4. Configure secrets in the `secrets/` directory
5. Build and run the infrastructure:
   ```bash
   make
   ```

### Project Structure
```
├── Makefile                 # Main build automation
├── secrets/                 # Credentials and sensitive data
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/                    # Source files
    ├── docker-compose.yml   # Service orchestration
    ├── .env                 # Environment variables
    └── requirements/        # Service configurations
        ├── mariadb/         # Database container
        ├── nginx/           # Web server container
        └── wordpress/       # WordPress container
```

### Services
- **NGINX**: Web server with TLS 1.2/1.3, acts as reverse proxy (port 443)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server for WordPress

### Volumes
- WordPress database volume (`/home/{user}/data`)
- WordPress website files volume

## Resources

### Documentation
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/support/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

### AI Usage
AI was used throughout this project for:
- **Dockerfile optimization**: Generating and reviewing Dockerfiles following best practices (multi-stage builds, security hardening, Alpine base images)
- **docker-compose.yml configuration**: Structuring service definitions, network configuration, and volume management
- **Shell script automation**: Creating initialization scripts for services (database setup, WordPress configuration)
- **Documentation generation**: Drafting README files, user guides, and technical documentation
- **Troubleshooting**: Debugging container connectivity issues and service configuration problems
- **Security review**: Analyzing configurations for security vulnerabilities and implementing best practices

All AI-generated content was thoroughly reviewed, tested, and modified to ensure correctness and adherence to project requirements.

## Project Design Choices

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
