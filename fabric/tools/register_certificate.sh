#!/bin/bash
source ${PWD}/tools/utils.sh
FABRIC_CA_CLIENT_ENRLL="${PWD}/tools/fabric-ca-client enroll -d"
FABRIC_CA_CLIENT_REGISTER="${PWD}/tools/fabric-ca-client register -d"

function createOrg1() {
    mkdir -p organizations/peerOrganizations/org1.ca.com/

    #export设置FABRIC_CA_CLIENT_HOME CA的根目录
    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.ca.com/
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-org1.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org1.ca.com/msp/config.yaml
    #为这个组织注册一个peer0
    infoln "Registering peer0"
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null
    #为这个组织注册一个用户
    infoln "Registering user"
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null
    #为这个组织注册一个admin用户
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null

    mkdir -p organizations/peerOrganizations/org1.ca.com/peers
    mkdir -p organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com

    #为peer0生成一个msp文件
    infoln "Generating the peer0 msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/msp --csr.hosts peer0.org1.ca.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null
    #将peer0的组织证书msp拷贝到peer0的属性msp文档中
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/msp/config.yaml
    #生成peer0的tls证书
    infoln "Generating the peer0-tls certificates"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls --enrollment.profile tls --csr.hosts peer0.org1.ca.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    { set +x; } 2>/dev/null
    #将peer0组织中的tlscacerts证书文件夹 signcerts签名证书文件夹 keystone私钥文件夹拷贝到peer节点tls根属性文件中
    #的           ca.crt        server.crt       server.key
    #Key 是私用密钥，通常是rsa算法
    #crt是CA认证后的证书文，（windows下面的，其实是crt），签署人用自己的key给你签署的凭证。
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/server.key

 

    #以下三个拷贝工作是为了让org管理所有的peer节点
    #即每一个org下的peer都必须拷贝一份 ca.crt        server.crt       server.key
    #到org中
    #将/peers/peer0.org1.ca.com下的tlscacerts证书文件夹的文件拷贝到org下的msp/tlscerts中
    #           ca.crt
    mkdir -p ${PWD}/organizations/peerOrganizations/org1.ca.com/msp/tlscacerts
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.ca.com/msp/tlscacerts/ca.crt
    #将/peers/peer0.org1.ca.com下的tlscacerts证书文件夹的文件拷贝到org下的tlsca/tlsca.org1.ca.com-cert.pem中
    #          tlsca.org1.ca.com-cert.pem
    mkdir -p ${PWD}/organizations/peerOrganizations/org1.ca.com/tlsca
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.ca.com/tlsca/tlsca.org1.ca.com-cert.pem
    #将/peers/peer0.org1.ca.com下的msp/cacerts证书文件夹的文件拷贝到org下的org1.ca.com/ca中
    #          ca.org1.ca.com-cert.pem
    mkdir -p ${PWD}/organizations/peerOrganizations/org1.ca.com/ca
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.ca.com/ca/ca.org1.ca.com-cert.pem


    #在org1下的user角色也同样需要有msp身份管理中心
    mkdir -p organizations/peerOrganizations/org1.ca.com/users
    mkdir -p organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com

    #生成usr的msp管理内的文件
    infoln "Generating the user msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    mv ${PWD}/organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp/keystore/priv_sk
    # chmod 775 ${PWD}/organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp/keystore/priv_sk
    { set +x; } 2>/dev/null
    #将peerOrganizations/org1.ca.com/msp/config.yaml拷贝到peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp/config.yaml
    #如果msp中没有config.yaml，可能导致peer和orderer通信不成功
    #同理一个组织下的user peer order client就是靠这个配置文件去相互识别的
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.ca.com/users/User1@org1.ca.com/msp/config.yaml

    #生成admin的msp管理
    infoln "Generating the org admin msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.ca.com/users/Admin@org1.ca.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/users/Admin@org1.ca.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org1.ca.com/users/Admin@org1.ca.com/msp/keystore/priv_sk
    # chmod 775 ${PWD}/organizations/peerOrganizations/org1.ca.com/users/Admin@org1.ca.com/msp/keystore/priv_sk
    { set +x; } 2>/dev/null

    cp ${PWD}/organizations/peerOrganizations/org1.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.ca.com/users/Admin@org1.ca.com/msp/config.yaml
}

function createOrg2() {
    mkdir -p organizations/peerOrganizations/org2.ca.com/

    #export设置FABRIC_CA_CLIENT_HOME CA的根目录
    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.ca.com/
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-org2.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-org2.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-org2.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-org2.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org2.ca.com/msp/config.yaml
    infoln "Registering peer0"
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null
    infoln "Registering user"
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null
    set -x
    ${FABRIC_CA_CLIENT_REGISTER} --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null

    mkdir -p organizations/peerOrganizations/org2.ca.com/peers
    mkdir -p organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com

    infoln "Generating the peer0 msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/msp --csr.hosts peer0.org2.ca.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/msp/config.yaml
    infoln "Generating the peer0-tls certificates"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls --enrollment.profile tls --csr.hosts peer0.org2.ca.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    { set +x; } 2>/dev/null
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/server.key

 

    mkdir -p ${PWD}/organizations/peerOrganizations/org2.ca.com/msp/tlscacerts
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.ca.com/msp/tlscacerts/ca.crt
    mkdir -p ${PWD}/organizations/peerOrganizations/org2.ca.com/tlsca
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.ca.com/tlsca/tlsca.org2.ca.com-cert.pem
    mkdir -p ${PWD}/organizations/peerOrganizations/org2.ca.com/ca
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.ca.com/ca/ca.org2.ca.com-cert.pem

    mkdir -p organizations/peerOrganizations/org2.ca.com/users
    mkdir -p organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com

    #生成usr的msp管理内的文件
    infoln "Generating the user msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com/msp/keystore/priv_sk
    # chmod 775 ${PWD}/organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com/msp/keystore/priv_sk
    { set +x; } 2>/dev/null

    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.ca.com/users/User1@org2.ca.com/msp/config.yaml

    infoln "Generating the org admin msp"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/keystore/* ${PWD}/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/keystore/priv_sk
    # chmod 775 ${PWD}/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/keystore/priv_sk
    { set +x; } 2>/dev/null

    cp ${PWD}/organizations/peerOrganizations/org2.ca.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/config.yaml
}



function createOrderer() {
    infoln "Enrolling the CA admin"

    ##创建存储Order节点证书的子文件夹。
    mkdir -p organizations/ordererOrganizations/ca.com

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/ca.com
    infoln "$FABRIC_CA_CLIENT_HOME"
    #123
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -d -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
    { set +x; } 2>/dev/null

    infoln "#生成节点类型分类配置文件"
    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-orderer.pem
        OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/ca.com/msp/config.yaml"
    
    infoln "#之后注册网络中初始的3个Orderer节点:"

    set -x
    ${FABRIC_CA_CLIENT_REGISTER} -u https://admin:adminpw@localhost:9054 --caname ca-orderer --id.name orderer1 --id.secret ordererpw --id.type orderer --id.attrs '"hf.Registrar.Roles=orderer"' --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
    { set +x; } 2>/dev/null
    infoln "#之后注册admin点:"
    ${FABRIC_CA_CLIENT_REGISTER} -u https://admin:adminpw@localhost:9054 --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --id.attrs '"hf.Registrar.Roles=admin"' --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"

    infoln "#为刚刚创建的几个用户创建各自的文件夹用于存储证书文件:"

    mkdir -p ${PWD}/organizations/ordererOrganizations/ca.com/orderers
    mkdir -p ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com

    infoln "#接下来获取每一个Orderer节点的MSP证书文件:"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://orderer1:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp" --csr.hosts orderer1.ca.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
    { set +x; } 2>/dev/null

    infoln "# 将之前生成的节点类型分类配置文件拷贝到每一个节点的MSP文件夹:"
    cp ${PWD}/organizations/ordererOrganizations/ca.com/msp/config.yaml "${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/config.yaml"

    infoln "#还有每一个节点的TLS证书:"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://orderer1:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls --enrollment.profile tls --csr.hosts orderer1.ca.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
    { set +x; } 2>/dev/null

    infoln "#然后为每一个节点的TLS证书以及秘钥文件修改名字，方便之后的使用:"
    cp ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/ca.crt
    cp ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/server.crt
    cp ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/server.key

    infoln "# 然后在MSP文件夹内创建tlscacerts文件夹，并将TLS文件拷贝过去:"
    mkdir -P ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem

    infoln "#复制TLS根证书:"
    mkdir -p ${PWD}/organizations/ordererOrganizations/ca.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem

    # infoln "#最后是Admin节点的证书文件:"
    # infoln "##首先也是创建文件夹"
    # mkdir -p crypto-config/orderOrganization/ca.com/users
    # mkdir -p crypto-config/orderOrganization/ca.com/users/Admin@ca.com

    mkdir -p organizations/ordererOrganizations/ca.com/users
    mkdir -p organizations/ordererOrganizations/ca.com/users/Admin@ca.com

    infoln "##获取证书文件"
    set -x
    ${FABRIC_CA_CLIENT_ENRLL} -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/ca.com/users/Admin@ca.com/msp --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
    cp ${PWD}/organizations/ordererOrganizations/ca.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/ca.com/users/Admin@ca.com/msp/config.yaml
    { set +x; } 2>/dev/null
}
