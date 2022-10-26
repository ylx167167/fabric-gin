



#!/bin/bash
#
MODE=$1
export IMAGE_TAG=latest
if [ "${MODE}" == "1" ]; then
    docker-compose -f ./docker/docker-compose-gin.yaml up -d
elif [ "${MODE}" == "2" ]; then
    docker-compose -f ./docker/docker-compose-mysql-redis.yaml up -d
else
    exit
fi

