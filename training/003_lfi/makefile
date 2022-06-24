build:
	docker-compose --file src/docker-compose.yml build
up:
	docker-compose --file src/docker-compose.yml up -d database 
	echo "Sleep to start database - 30s"
	sleep 30
	docker-compose --file src/docker-compose.yml up -d lfi 
logs:
	docker-compose --file src/docker-compose.yml logs -f
down:
	docker-compose --file src/docker-compose.yml down
restart:
	docker-compose --file src/docker-compose.yml restart