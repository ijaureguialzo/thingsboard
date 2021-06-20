help:
	@echo Opciones:
	@echo -------------------
	@echo start / stop / restart / stop-all
	@echo workspace
	@echo update
	@echo stats
	@echo clean
	@echo -------------------

_start-command:
	@docker-compose up -d --remove-orphans

start: _start-command _urls

stop:
	@docker-compose stop

restart: stop start

stop-all:
	@docker stop `docker ps -aq`

workspace:
	@docker-compose exec mytb /bin/bash

_build:
	@docker pull thingsboard/tb-cassandra
	@docker run -it -v mytb-data:/data --rm thingsboard/tb-cassandra upgrade-tb.sh
	@docker-compose rm mytb

update: stop _build start

stats:
	@docker stats

clean:
	@docker-compose down -v --remove-orphans

_urls:
	${info }
	@echo -------------------
	@echo [ThingsBoard] http://localhost:8080
	@echo -------------------
