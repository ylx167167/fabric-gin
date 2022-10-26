#!/bin/bash
#

COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
COMPOSE_FILE_ORDERER=docker/docker-compose-orderer.yaml
COMPOSE_FILE_ORG=docker/docker-compose-org-node1.yaml
COMPOSE_FILE_COUCHDB=docker/docker-compose-couch-node1.yaml
COMPOSE_FILE_EXPLORER=docker/docker-compose-explorer.yaml
# docker-compose -f $COMPOSE_FILE_EXPLORER -f $COMPOSE_FILE_CA -f $COMPOSE_FILE_ORDERER -f $COMPOSE_FILE_ORG -f $COMPOSE_FILE_COUCHDB down --volumes --remove-orphans
docker-compose -f $COMPOSE_FILE_EXPLORER -f $COMPOSE_FILE_CA -f $COMPOSE_FILE_ORDERER -f $COMPOSE_FILE_ORG -f $COMPOSE_FILE_COUCHDB down --volumes
docker stop $(docker ps -q) 
docker rm $(docker ps -a -q)
docker network prune
sudo rm -rf ./organizations/*
sudo rm -rf ./system-genesis-block/*
sudo rm ./channel-artifacts/*
sudo rm ./scripts/*.txt
sudo rm -rf ./chaincode/pkg/*
docker volume prune



