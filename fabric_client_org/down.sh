#!/bin/bash
#

COMPOSE_FILE_GIN=docker/docker-compose-gin.yaml
COMPOSE_FILE_DATABASE=docker/docker-compose-mysql-redis.yaml
# docker-compose -f $COMPOSE_FILE_GIN -f $COMPOSE_FILE_DATABASE down --volumes --remove-orphans
# docker-compose -f $COMPOSE_FILE_DATABASE down --volumes --remove-orphans

MODE=$1
if [ "${MODE}" == "1" ]; then
    # docker-compose -f $COMPOSE_FILE_GIN down --volumes --remove-orphans
    docker-compose -f $COMPOSE_FILE_GIN down 
elif [ "${MODE}" == "2" ]; then
    # docker-compose -f $COMPOSE_FILE_DATABASE down --volumes --remove-orphans
    docker-compose -f $COMPOSE_FILE_DATABASE down
else
    exit
fi
