#!/bin/bash
docker rm -f web_demo || echo "No such web_demo"
docker build --tag=web_demo .
docker run -v $(pwd)/challenge:/app -p 1337:1337 --rm --name=web_demo web_demo