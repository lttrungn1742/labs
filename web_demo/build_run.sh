docker rm -f web || echo "Not found container /web"
docker build web_demo -t web_demo || docker ps 
docker run -d --rm --name web web_demo 
