#!/bin/bash

# remove running containers
docker rm -f $(docker ps -qa)

# make the network
docker network create trio-network

# build images
docker build -t trio-task-flask:latest flask-app
docker build -t trio-task-db:latest db

# run sql container
docker run -d \
    --network trio-network \
    --name mysql \
    trio-task-db:latest

# run flask app
docker run -d \
    --network trio-network \
    --name flask-app \
    trio-task-flask:latest

# run nginx container
docker run -d \
    --network trio-network \
    --name nginx \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    -p 80:80 \
    nginx:alpine