#!/bin/bash
docker-compose --file web/docker-compose.yml up -d database
echo "Sleep to start database - 30s"
sleep 30
docker-compose --file web/docker-compose.yml up -d web nginx sqli