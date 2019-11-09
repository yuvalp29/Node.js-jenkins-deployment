#!/bin/bash

# sh 'docker pull yp29/jenkinsmultibranch:yp29-web-app-9'
# sh 'docker run --name docker-production-ap -p 80:8081 -d yp29/jenkinsmultibranch:yp29-web-app-9'

# Just to notice:
# $1 = docker_name
# $2 = registry
# $3 = rep_name
# $4 = commit_id

if [ "$(docker ps -q -f name=$1)" ]; then
    docker stop $1
fi
docker run -p 81:8081 -d --rm --name $1 $2:$3-$4
