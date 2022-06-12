build:
	docker-compose -f docker-compose.yml build
up:
	docker-compose -f docker-compose.yml up -d database mongo
	echo "wait 30s for starting database"
	sleep 30
	docker-compose -f docker-compose.yml up -d web nginx sqli
query_mongo:
	docker-compose -f docker-compose.yml up testing_query_mongo
down:
	docker-compose -f docker-compose.yml down
restart:
	docker-compose -f docker-compose.yml restart
logs:
	docker-compose -f docker-compose.yml logs -f