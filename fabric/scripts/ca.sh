#!/bin/bash
#
#1
export PATH=${PWD}/tools:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export IMAGE_TAG=latest
export VERBOSE=false
. ${PWD}/tools/utils.sh

function createOrgs(){
    if [ -d "organizations/peerOrganizations" ]; then
        rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
    fi
    infoln "Generating certificates using Fabric CA"

    docker-compose -f $COMPOSE_FILE_CA up -d 2>&1
    . tools/register_certificate.sh 
   
   sleep 1
    while :; do
        if [ ! -f "organizations/fabric-ca/org1/tls-cert.pem" ]; then
            sleep 1
        else
                break  
         fi
    done
        infoln "Creating Org1 Identities"
        createOrg1 
        infoln "Creating Org2 Identities"
        createOrg2 
        infoln "Creating Orderer1 Org Identities"
        createOrderer 
}

COMPOSE_FILE_CA=docker/docker-compose-ca.yaml


MODE=$1
if [ "${MODE}" == "up" ]; then
    createOrgs
else
    exit 1
fi


# 生成排序系统的创世区块
cp ${PWD}/configtx/configtx.yaml ${PWD}/config/configtx.yaml 
export SYSTEM_CHANNEL_NAME="system-channel"
set -x
${PWD}/tools/configtxgen -profile SampleMultiNodeEtcdRaft -channelID $SYSTEM_CHANNEL_NAME -outputBlock ./system-genesis-block/genesis.block
res=$?
{ set +x; } 2>/dev/null
if [ $res -ne 0 ]; then
fatalln "Failed to generate orderer genesis block..."
fi
