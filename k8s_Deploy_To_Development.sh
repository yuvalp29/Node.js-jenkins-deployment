#!/bin/bash

kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-base
sleep 10
kubectl set image deployment/development-app docker-development-app=yp29/jenkinsmultibranch:development-latest
sleep 10