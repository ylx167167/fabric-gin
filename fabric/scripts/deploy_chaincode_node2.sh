

export VERBOSE=false


C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

CC_NAME="marble2chaincode"
CC_SRC_PATH="${PWD}/../chaincode/go/marble"
CC_SRC_LANGUAGE="go"
CC_VERSION="1.0"
CC_SEQUENCE=1
CC_INIT_FCN="NA"
# CC_NAME="marblechaincode"
# CC_SRC_PATH="${PWD}/../chaincode/go/marble"
# CC_SRC_LANGUAGE="go"
# CC_VERSION="2.0"
# CC_SEQUENCE="1"
# CC_INIT_FCN="initMarble"
CC_COLL_CONFIG="NA"
CHANNEL_NAME=mychannel
CC_END_POLICY="AND('Org1MSP.peer','Org2MSP.peer')"
# "OR('Org1MSP.peer','Org2MSP.peer')"
CLI_DELAY=3
DELAY=3
MAX_RETRY=5
DEBUG=""
CC_RUNTIME_LANGUAGE=golang
INIT_REQUIRED="--init-required"


cc_action=""
action_arg=""

export CORE_PEER1_ADDRESS=peer0.org1.ca.com:7051
export CORE_PEER2_ADDRESS=peer0.org2.ca.com:8051
export PEER0_ORG1_CA=${PWD}/../organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/../organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/ca.crt

# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color

function errorln() {
  println "${C_RED}${1}${C_RESET}"
}

function fatalln() {
  errorln "$1"
  exit 1
}

function successln() {
  println "${C_GREEN}${1}${C_RESET}"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

parsePeerConnectionParameters() {
  PEER_CONN_PARMS1=""
  PEER_CONN_PARMS2=""
  TLSINFO1=$(eval echo "--tlsRootCertFiles \$PEER0_ORG1_CA")
  PEER_CONN_PARMS1="$PEER_CONN_PARMS1 --peerAddresses $CORE_PEER1_ADDRESS"
  PEER_CONN_PARMS1="$PEER_CONN_PARMS1 $TLSINFO1"
  TLSINFO2=$(eval echo "--tlsRootCertFiles \$PEER0_ORG2_CA")
  PEER_CONN_PARMS2="$PEER_CONN_PARMS2 --peerAddresses $CORE_PEER2_ADDRESS"
  PEER_CONN_PARMS2="$PEER_CONN_PARMS2 $TLSINFO2"
}

# parsePeerConnectionParameters() {
#   PEER_CONN_PARMS=""
#   PEERS=""
#   while [ "$#" -gt 0 ]; do
#     setGlobals $1
#     PEER="peer0.org$1"
#     ## Set peer addresses
#     PEERS="$PEERS $PEER"
#     PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
#     ## Set path to TLS certificate
#     TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
#     PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
#     # shift by one to get to the next organization
#     shift
#   done
#   # remove leading space for output
#   PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
# }

installChaincode(){
    set -x
    peer lifecycle chaincode install ${CC_NAME}.tar.gz >&chaincode_install.txt
    res=$?
    { set +x; } 2>/dev/null
    verifyResult $res "Chaincode install has failed"
    successln "Chaincode is install"
}


queryInstalled(){
    set -x
    peer lifecycle chaincode queryinstalled >&chaincode_queryInstalled.txt
    res=$?
    { set +x; } 2>/dev/null
    cat chaincode_queryInstalled.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" chaincode_queryInstalled.txt)
    verifyResult $res "Query installed on peer0.org1 has failed"
    successln "Query installed successful on peer0.org1 on channel"
}

approveForMyOrg(){
    set -x
    # peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} ${INIT_REQUIRED} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem ${CC_END_POLICY} ${CC_COLL_CONFIG} >&chaincode_approve.txt
    peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} ${INIT_REQUIRED} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem ${CC_END_POLICY} ${CC_COLL_CONFIG} >&chaincode_approve.txt
    res=$?
    { set +x; } 2>/dev/null
    verifyResult $res "Chaincode definition approved on peer0.org2 on channel '$CHANNEL_NAME' failed"
    successln "Chaincode definition approved on peer0.org2 on channel '$CHANNEL_NAME'"
}


checkCommitReadiness(){
    local rc=1
    local COUNTER=1
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
        sleep $DELAY
        infoln "Attempting to check the commit readiness of the chaincode definition on peer0.org1 , Retry after $DELAY seconds."
        set -x
        peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --output json >&chaincode_checkCommit.txt
        res=$?
        { set +x; } 2>/dev/null
        let rc=0
        for var in "$@"; do
            grep "$var" chaincode_checkCommit.txt &>/dev/null || let rc=1
        done
        COUNTER=$(expr $COUNTER + 1)
    done
}

commitChaincodeDefinition(){
    parsePeerConnectionParameters 2
    set -x
    # peer lifecycle chaincode commit -o orderer1.ca.com:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem >&chaincoed_commitChaincode.txt    
    # peer lifecycle chaincode commit -o orderer1.ca.com:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem $PEER_CONN_PARMS >&chaincoed_commitChaincode.txt
    peer lifecycle chaincode commit -o orderer1.ca.com:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem $PEER_CONN_PARMS1 $PEER_CONN_PARMS2 >&chaincoed_commitChaincode.txt 
    res=$?
    { set +x; } 2>/dev/null
    cat chaincoed_commitChaincode.txt
    verifyResult $res "Chaincode definition commit failed on peer0.org1 on channel '$CHANNEL_NAME' failed"
    successln "Chaincode definition committed on channel '$CHANNEL_NAME'"
}


chaincodeInvokeInit(){
    parsePeerConnectionParameters 
    set -x
    # fcn_call='{"Args":["'${CC_INIT_FCN}'"，"asdf","blue","35","bob"]}'
    infoln "invoke fcn call:${fcn_call}"
    # peer chaincode invoke -o orderer1.ca.com:7050 --isInit --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS1 $PEER_CONN_PARMS2 -c ${fcn_call} --waitForEvent >&chaincode_firstinvoke.txt
    peer chaincode invoke -o orderer1.ca.com:7050 --isInit --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS1 $PEER_CONN_PARMS2 -c '{"Args":["initMarble","marble1","blue","35","tom"]}' --waitForEvent >&chaincode_firstinvoke.txt
    res=$?
    { set +x; } 2>/dev/null
    cat chaincode_firstinvoke.txt
    verifyResult $res "Invoke execution on peer0.org1 failed "
    successln "Invoke transaction successful on peer0.org1 on channel '$CHANNEL_NAME'"
}

chaincode_action(){
    parsePeerConnectionParameters 
    if [ "${cc_action}" = "invoke" ]; then
        set -x
        peer chaincode invoke -o orderer1.ca.com:7050 --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS1 $PEER_CONN_PARMS2 -c $action_arg --waitForEvent >&chaincode_firstinvoke.txt
        res=$?
        cat chaincode_invoke.txt
    elif [ "${cc_action}" = "query" ]; then
        set -x
        peer chaincode query -o orderer1.ca.com:7050  -C $CHANNEL_NAME -n ${CC_NAME} -c $action_arg >&chaincode_query.txt
        res=$?
        cat chaincode_query.txt
    else
     exit
    fi
}



if [ "$CC_INIT_FCN" = "NA" ]; then
    INIT_REQUIRED=""
fi

if [ "$CC_END_POLICY" = "NA" ]; then
    CC_END_POLICY=""
else
    CC_END_POLICY="--signature-policy $CC_END_POLICY"
fi

if [ "$CC_COLL_CONFIG" = "NA" ]; then
    CC_COLL_CONFIG=""
else
    CC_COLL_CONFIG="--collections-config $CC_COLL_CONFIG"
fi

MODE=$1
if [ "${MODE}" == "1" ]; then
sleep 2
installChaincode
elif [ "${MODE}" == "2" ]; then
queryInstalled
sleep 2
approveForMyOrg
elif [ "${MODE}" == "3" ]; then
sleep 2
checkCommitReadiness
elif [ "${MODE}" == "4" ]; then
sleep 2
commitChaincodeDefinition
elif [ "${MODE}" == "5" ]; then
sleep 2
chaincodeInvokeInit
elif [ "${MODE}" == "6" ]; then
cc_action=$2
action_arg=$3
sleep 2
chaincode_action
else
    exit
fi
