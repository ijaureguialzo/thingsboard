#!make

ifneq (,$(wildcard ./.env))
    include .env
    export
else
$(error No se encuentra el fichero .env)
endif

help: _header
	${info }
	@echo Opciones:
	@echo ----------------------
	@echo init
	@echo start / stop / restart
	@echo workspace
	@echo upgrade
	@echo stats
	@echo clean
	@echo ----------------------

_urls: _header
	${info }
	@echo -----------------------------------------------------
	@echo [ThingsBoard] https://thingsboard.test
	@echo [Mailpit] https://mailpit.thingsboard.test
	@echo [Traefik] https://traefik.thingsboard.test/dashboard/
	@echo -----------------------------------------------------

_header:
	@echo -----------
	@echo ThingsBoard
	@echo -----------

init:
	@docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=$$LOAD_DEMO_DATA thingsboard-ce

_start-command:
	@docker-compose up -d --remove-orphans

start: _start-command _urls

stop:
	@docker-compose stop

restart: stop start

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
