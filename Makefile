#DEFINE FILE PATHS, ENVIRONMENT SETTINGS AND DOCKER IDENTIFIERS.
INCEPTION_LOGIN	=	uboudigu
WP_DIR			=	/home/$(INCEPTION_LOGIN)/data/wordpress
DB_DIR			=	/home/$(INCEPTION_LOGIN)/data/database
BU_DIR			=	/home/$(INCEPTION_LOGIN)/data/backup
#DEFINE SHELL COMMANDS TO LIST NETWORK, IMAGES, VOLUMES AND CONTAINERS.
NETWORKS		=	$$(docker network ls -q --filter "type=custom")
IMAGES			=	$$(docker image ls -aq)
VOLUMES			=	$$(docker volume ls -q)
CONTAINERS		=	$$(docker ps -aq)

COMPOSEFILE		=	srcs/docker-compose.yml

GREEN			=	\033[0;32m
RESET			=	\033[0m

#TERMINAL WIDTH AND SEPARATOR LINE CHARACTER 
cols			=	$$(tput cols)
SE				=	$$(printf "%-$(cols)s" "_" | tr ' ' '_')

all: up

#START CONTAINERS
up: mkdir
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@ --build -d
#STOP CONTAINERS
down:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@
#REBUILD CONTAINERS
build:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@
#LIST RUNNING AND STOPPED CONTAINERS
ps:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@ --all
#RUN DOCKER COMPOSE TOP (DISPLAY RUNNING PROCESSES)
top:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@
#RUN DOCKER COMPOSE STOP (STOP RUNNING PROCESSES WITHOUT REMOVING THEM)
stop:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@
#RUN DOCKER COMPOSE RESTART (RESTART ALL RUNNING AND STOPPED PROCESSES)
restart:
	@INCEPTION_LOGIN=$(INCEPTION_LOGIN) docker compose -f $(COMPOSEFILE) $@

mkdir:
	@echo -n " ✔ creating volume folders ..."
	@sudo mkdir -p $(WP_DIR) $(DB_DIR) $(BU_DIR)
	@echo "$(GREEN)\tDone$(RESET)"
rmdir:
	@echo -n " ✔ cleaning volume folders ..."
	@sudo rm -rf $(WP_DIR) $(DB_DIR) $(BU_DIR)
	@echo "$(GREEN)\tDone$(RESET)"
#LIST IMAGES, CONTAINERS, VOLUMES AND NETWORKS
ls:
	@echo $(SE) && docker images && echo $(SE) && docker ps --all
	@echo $(SE) && docker volume ls && echo $(SE) && docker network ls --filter "type=custom"

#STOP AND REMOVE CONTAINERS
cleancontainers:
	@echo -n " ✔ cleaning containers ..."
	@docker stop $(CONTAINERS) > /dev/null 2>&1 || true
	@docker rm -f $(CONTAINERS) > /dev/null 2>&1 || true
	@echo "$(GREEN)\tDone$(RESET)"

#REMOVE DOCKER IMAGES
cleanimages:
	@echo -n " ✔ cleaning images ..."
	@docker image rm -f $(IMAGES) > /dev/null 2>&1 || true
	@echo "$(GREEN)\t\tDone$(RESET)"

#REMOVE NETWORKS
cleannetworks:
	@echo -n " ✔ cleaning networks ..."
	@docker network rm -f $(NETWORKS) > /dev/null 2>&1 || true
	@echo "$(GREEN)\tDone$(RESET)"

#REMOVE DOCKER VOLUMES
cleanvolumes:
	@echo -n " ✔ cleaning volumes ..."
	@docker volume rm -f $(VOLUMES) > /dev/null 2>&1 || true
	@echo "$(GREEN)\t\tDone$(RESET)"

clean: cleancontainers cleanimages cleannetworks

fclean: clean cleanvolumes rmdir

#RUN DOCKER PRUNE: REMOVING EVERYTHING
prune: fclean
	@echo -n " ✔ system prune ..."
	@docker system prune --all --force > /dev/null 2>&1 || true
	@echo "$(GREEN)\t\tDone$(RESET)"

re: fclean up

#PREVENTS CONFLICTS IF FILES HAVE THE SAME NAMES AS THE TARGETS
.PHONY: up down build ps top stop restart mkdir rmdir ls cleancontainers cleanimages cleannetworks cleanvolumes clean fclean prune re