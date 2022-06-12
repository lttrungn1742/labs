#!/bin/bash
docker-compose --file src/docker-compose.yml up -d database mongo
echo "Sleep to start database - 30s"
sleep 30
docker-compose --file src/docker-compose.yml up -d app_flask nginx sqli