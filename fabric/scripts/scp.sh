#!/bin/bash
#
MODE=$1
if [ "${MODE}" == "1" ]; then
    sudo scp -P 22 -r ./configtx/ ./channel-artifacts/ ./config/ ./system-genesis-block/ ./organizations/ ./chaincode/ lucy@10.8.13.67:/home/lucy/sambaFile/bsunion
    scp -P 22 -r ./docker/docker-compose-org-node2.yaml ./docker/docker-compose-couch-node2.yaml lucy@10.8.13.67:/home/lucy/sambaFile/bsunion/docker
    scp -P 22 docker_env_node2.sh lucy@10.8.13.67:/home/lucy/sambaFile/bsunion/scripts
elif [ "${MODE}" == "2" ]; then
    scp -P 22 ./channel-artifacts/mychannel.block lucy@10.8.13.67:/home/lucy/sambaFile/bsunion/channel-artifacts
elif [ "${MODE}" == "3" ]; then
    sudo scp -P 22 ./docker_env_node2.sh ./scripts/deploy_chaincode_node2.sh ./scripts/*.tar.gz lucy@10.8.13.67:/home/lucy/sambaFile/bsunion/scripts
else
    exit
fi
