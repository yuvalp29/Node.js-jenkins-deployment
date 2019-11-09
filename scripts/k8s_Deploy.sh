#!/bin/bash

docker image prune -af

kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-base
kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-base

sleep 30 # waiting before deleteing the unused latest images localy
docker image prune -af

kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-latest
kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-latest

sleep 30 # waiting before deleteing the unused base images localy
docker image prune -af