docker rm web || echo "No find container /web"
docker build web_demo -t web_demo
docker run -d --rm --name web web_demo