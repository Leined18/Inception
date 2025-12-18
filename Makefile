# Makefile para proyecto WordPress + MariaDB + NGINX
DOCKER_COMPOSE = docker compose --project-directory srcs

# Variables

.PHONY: all build up down logs fclean


all: build up

build:
	$(DOCKER_COMPOSE) build

build-%:
	$(DOCKER_COMPOSE) build $*

up:
	$(DOCKER_COMPOSE) up -d

up-%:
	$(DOCKER_COMPOSE) up $* -d

down:
	$(DOCKER_COMPOSE) down

down-%:
	$(DOCKER_COMPOSE) down $*

logs-%:
	$(DOCKER_COMPOSE) logs $*

# Limpiar servicios y volúmenes bindados
fclean:
	@echo "Deteniendo y eliminando servicios y volúmenes bindados..."
	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi all
	@echo "¡Limpieza completa!"

re: fclean all