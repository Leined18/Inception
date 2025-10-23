# **************************************************************************** #
#                               INCEPTION MAKEFILE                             #
# **************************************************************************** #

DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

# ──────────────────────────────────────────────────────────────────────────────
# COMANDOS PRINCIPALES
# ──────────────────────────────────────────────────────────────────────────────

.PHONY: all build up down stop restart logs fclean

all: build up

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

restart: down up

logs:
	$(DOCKER_COMPOSE) logs -f

# ──────────────────────────────────────────────────────────────────────────────
# LIMPIEZA TOTAL
# ──────────────────────────────────────────────────────────────────────────────

fclean:
	@echo "🧹 Deteniendo y eliminando contenedores, volúmenes y redes..."
	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi all
	@sudo rm -rf /home/$(USER)/data/mariadb
	@sudo rm -rf /home/$(USER)/data/wordpress
	@echo "✅ Limpieza completa"

# ──────────────────────────────────────────────────────────────────────────────
# INFORMACIÓN
# ──────────────────────────────────────────────────────────────────────────────

ps:
	$(DOCKER_COMPOSE) ps

help:
	@echo "Makefile para gestionar Inception con Docker Compose"
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make all        - Construye y levanta los contenedores (predeterminado)"
	@echo "  make build      - Construye los contenedores"
	@echo "  make up         - Levanta los contenedores en segundo plano"
	@echo "  make down       - Detiene y elimina los contenedores, volúmenes y redes"
	@echo "  make stop       - Detiene los contenedores"
	@echo "  make restart    - Reinicia los contenedores"
	@echo "  make logs       - Muestra los logs de los contenedores en tiempo real"
	@echo "  make fclean     - Limpieza total de contenedores, volúmenes y datos persistentes"
	@echo "  make ps         - Muestra el estado de los contenedores"
	@echo "  make help       - Muestra esta ayuda"	