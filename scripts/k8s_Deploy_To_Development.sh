#!/bin/bash

kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-base
sleep 12 # waiting before deleteing the unused latest image localy
docker image prune -af
kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-latest
sleep 12 # waiting before deleteing the unused base image localy
docker image prune -af