build:
	docker-compose --file src/docker-compose.yml build
up:
	docker-compose --file src/docker-compose.yml up -d database mongo
	echo "Sleep to start database - 30s"
	sleep 30
	docker-compose --file src/docker-compose.yml up -d app_flask nginx sqli lfi 
logs:
	docker-compose --file src/docker-compose.yml logs -f
down:
	docker-compose --file src/docker-compose.yml down
scan:
	docker-compose --file src/docker-compose.yml up scaner 
restart:
	docker-compose --file src/docker-compose.yml restart