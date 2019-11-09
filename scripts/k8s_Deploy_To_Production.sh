#!/bin/bash

kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-base
sleep 60 # waiting before deleteing the unused latest image localy
docker image prune -af
sleep 5 # waiting before setting the new latest image localy
kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-latest
sleep 15 # waiting before deleteing the unused base image localy
docker image prune -af