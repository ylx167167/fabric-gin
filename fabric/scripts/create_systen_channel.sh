#!/bin/bash
#

#2
# cp ${PWD}/configtx/configtx.yaml ${PWD}/config/configtx.yaml 
# export SYSTEM_CHANNEL_NAME="system-channel"
export FABRIC_CFG_PATH=${PWD}/configtx
# ${PWD}/tools/configtxgen -profile SampleMultiNodeEtcdRaft -channelID $SYSTEM_CHANNEL_NAME -outputBlock ./system-genesis-block/genesis.block
createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config >original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config >modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb >config_update.pb
  configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
  configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >"${OUTPUT}"
  { set +x; } 2>/dev/null
}

export CHANNEL_NAME="mychannel"

# 生成通道交易文件
${PWD}/tools/configtxgen -profile YEtwoChannel -outputCreateChannelTx ${PWD}/channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

# # 生成锚节点配置更新文件 旧
# ${PWD}/tools/configtxgen -profile YEtwoChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
# ${PWD}/tools/configtxgen -profile YEtwoChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

# 创建通道加入通道
BLOCKFILE="/opt/gopath/src/hyperledger/fabric/peer/channel-artifacts/${CHANNEL_NAME}.block"
ORDERER_CA="/opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem"
docker exec Orgcli1 peer channel create -o orderer1.ca.com:7050 -c ${CHANNEL_NAME} --ordererTLSHostnameOverride orderer1.ca.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile ${ORDERER_CA} >&./scripts/org1log0.txt

# org1 org2加入通道
docker exec Orgcli1 peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&./scripts/org1log1.txt
docker exec Orgcli2 peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&./scripts/org2log1.txt

# 锚节点更新
docker exec Orgcli1 ./scripts/setAnchorPeer.sh 1 $CHANNEL_NAME ${ORDERER_CA}
docker exec Orgcli2 ./scripts/setAnchorPeer.sh 2 $CHANNEL_NAME ${ORDERER_CA}
# peer channel update -o localhost:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile ${ORDERER_CA} >&./scripts/org2log2.txt
# peer channel update -o localhost:7050 -c ${CHANNEL_NAME} -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile ${ORDERER_CA} >&./scripts/org2log2.txt