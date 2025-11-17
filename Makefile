#!make

ifneq (,$(wildcard ./.env))
    include .env
    export
else
$(error No se encuentra el fichero .env)
endif

help:
	@echo Opciones:
	@echo -------------------
	@echo init
	@echo start / stop / restart / stop-all
	@echo workspace
	@echo upgrade
	@echo stats
	@echo clean
	@echo -------------------

init:
	@docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true thingsboard-ce

_start-command:
	@docker-compose up -d --remove-orphans

start: _start-command _urls

stop:
	@docker-compose stop

restart: stop start

stop-all:
	@docker stop `docker ps -aq`

workspace:
	@docker-compose exec thingsboard-ce /bin/bash

upgrade:
	@docker pull thingsboard/tb-node:$$THINGSBOARD_VERSION
	@docker compose stop thingsboard-ce
	@docker compose run --rm -e UPGRADE_TB=true thingsboard-ce
	@docker compose up -d

stats:
	@docker stats

clean:
	@docker-compose down -v --remove-orphans

_urls:
	${info }
	@echo -------------------
	@echo [ThingsBoard] http://localhost:8080
	@echo -------------------
