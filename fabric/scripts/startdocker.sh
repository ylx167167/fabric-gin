#!/bin/bash
#
export IMAGE_TAG=latest


#!/bin/bash
#
MODE=$1
if [ "${MODE}" == "1" ]; then
    docker-compose -f ./docker/docker-compose-orderer.yaml up -d
    docker-compose -f ./docker/docker-compose-couch-node1.yaml up -d
    docker-compose -f ./docker/docker-compose-org-node1.yaml up -d
    docker-compose -f ./docker/docker-compose-couch-node2.yaml up -d
    docker-compose -f ./docker/docker-compose-org-node2.yaml up -d
elif [ "${MODE}" == "2" ]; then
    docker-compose -f ./docker/docker-compose-explorer.yaml up -d
else
    exit
fi

