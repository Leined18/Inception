DOCKER_COMPOSE ?= docker compose
ENV_FILE := .env
CURRENT_USER := $(shell id -un)

# Extract the bind mount root from the .env file, defaulting to ~/data if missing.
DATA_DIR := $(shell awk -F= '/^DATA_DIR=/{print $$2}' $(ENV_FILE) 2>/dev/null)
DATA_DIR := $(strip $(DATA_DIR))
ifeq ($(DATA_DIR),)
DATA_DIR := $(HOME)/data
endif

WORDPRESS_DIR := $(DATA_DIR)/wordpress
MARIADB_DIR := $(DATA_DIR)/mariadb
NGINX_CACHE_DIR := $(DATA_DIR)/nginx-cache

.PHONY: all build build-% up up-% down down-% logs-% stop status prepare fclean

all: build up

prepare:
	# Creates bind mount folders and aborts with guidance if permissions block it.
	@mkdir -p $(DATA_DIR) 2>/dev/null || true
	@if [ ! -d $(DATA_DIR) ]; then \
		echo "DATA_DIR $(DATA_DIR) could not be created. Check the path in $(ENV_FILE)."; \
		exit 1; \
	fi
	@if [ ! -w $(DATA_DIR) ]; then \
		echo "DATA_DIR $(DATA_DIR) is not writable by user $(CURRENT_USER)."; \
		echo "Fix the permissions, e.g.: sudo chown -R $(CURRENT_USER):$(CURRENT_USER) $(DATA_DIR)"; \
		exit 1; \
	fi
	@mkdir -p $(WORDPRESS_DIR) $(MARIADB_DIR) $(NGINX_CACHE_DIR)

build: prepare
	$(DOCKER_COMPOSE) build --pull

build-%: prepare
	$(DOCKER_COMPOSE) build $*

up: prepare
	$(DOCKER_COMPOSE) up -d

up-%: prepare
	$(DOCKER_COMPOSE) up $* -d

down:
	$(DOCKER_COMPOSE) down

down-%:
	$(DOCKER_COMPOSE) down $*

stop:
	$(DOCKER_COMPOSE) stop

status:
	$(DOCKER_COMPOSE) ps

logs-%:
	$(DOCKER_COMPOSE) logs $*

fclean:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans --rmi all
	@rm -rf $(WORDPRESS_DIR) $(MARIADB_DIR) $(NGINX_CACHE_DIR)

re: fclean all
