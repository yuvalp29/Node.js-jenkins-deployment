#!/bin/bash

kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-base
sleep 12 # waiting before deleteing the unused latest image localy
docker image prune -af
kubectl set image deployment/production-app docker-production-app=yp29/jenkinsmultibranch:production-latest
sleep 12 # waiting before deleteing the unused base image localy
docker image prune -af