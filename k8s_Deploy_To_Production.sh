#!/bin/bash

kubectl set image deployment/production-app production-app=yp29/jenkinsmultibranch:production-base
sleep 10
kubectl set image deployment/production-app production-app=yp29/jenkinsmultibranch:production-latest
sleep 10