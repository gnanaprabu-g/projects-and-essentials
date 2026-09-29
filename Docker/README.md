# DOCKER commands - A quick reference

docker pull httpd

docker images -a

docker ps -a

# create and run container
docker run -itd --name container-name -p modified-port:default-port image-name

EG:
docker run -itd --name webapp1 -p 8001:80 httpd

docker stats

# Access container directory
docker exec -it webapp1 /bin/bash

exit

# create image from running container "webapp1"
docker commit webapp1 webapp-image

docker images -a

docker stop webapp1

docker rm webapp1

# creating offline backup of "webapp-image"
docker save -o webapp-image-local.tar webapp-image

ls -lart

docker rmi webapp-image

# loading image from offline backup "webapp-image-local.tar"
docker load -i webapp-image-local.tar

docker images -a

# creating online backup of "webapp-image"
docker login

docker tag webapp-image gnanaprabu/custom-image

docker images -a

docker push gnanaprabu/custom-image

# creating image from Dockerfile
docker build -t custom-webapp-image .

docker images -a

# bind mount
docker run -itd --name server1 -p 8002:80 -v "/root/source_code_sync_dir:/usr/local/apache2/htdocs" httpd

# volume mount
docker volume create demo

docker volume ls

docker volume inspect demo

docker run -itd --name server2 -p 8003:80 --mount source=demo,destination=/usr/local/apache2/error httpd