build:
	docker-compose --file src/docker-compose.yml build
deploy:
	docker-compose --file src/docker-compose.yml up -d database mongo
	echo "Sleep to start database - 30s"
	sleep 30
	docker-compose --file src/docker-compose.yml up -d app_flask nginx sqli
logs:
	docker-compose --file src/docker-compose.yml logs -f
down:
	docker-compose --file src/docker-compose.yml down
scan:
	docker-compose --file src/docker-compose.yml up scaner 
deploy_lfi:
	docker-compose --file src/docker-compose.yml up -d database lfi
restart:
	docker-compose --file src/docker-compose.yml restart