FROM alpine:latest
MAINTAINER Yuval Podoksik ”ypodoksik29@cs.colman.ac.il”
RUN apk add --update nodejs nodejs-npm
COPY . /app
WORKDIR /app
ENTRYPOINT ["node"]
EXPOSE 8081
EXPOSE 80
<<<<<<< HEAD:Dockerfile
EXPOSE 81
CMD ["app/main.js"]
=======
CMD ["app/main_dev.js"]
>>>>>>> master:DockerFiles/Development/Dockerfile
