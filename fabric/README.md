所有需要密码的都默认 admin adminpw
http://127.0.0.1:6984/_utils/#login-
# 采用hyperledger 项目
hyperledger fabric 生成网络
hyperledger explorer 区块链浏览器 只能看什么都做不了

# docker的方法  安装docker 和 docker-compose
docker 权限问题
https://blog.csdn.net/u011337602/article/details/104541261
手动拉取hyperledger 2.2
sudo docker pull couchdb
sudo docker pull hyperledger/fabric-ca:1.5
sudo docker pull hyperledger/fabric-tools:2.2
sudo docker pull hyperledger/fabric-peer:2.2
sudo docker pull hyperledger/fabric-orderer:2.2
sudo docker pull hyperledger/fabric-ccenv:2.2
sudo docker pull hyperledger/fabric-baseos:2.2
修改标签
sudo docker tag hyperledger/fabric-ca:1.5 hyperledger/fabric-ca:latest
sudo docker tag hyperledger/fabric-tools:2.2 hyperledger/fabric-tools:latest
sudo docker tag hyperledger/fabric-peer:2.2 hyperledger/fabric-peer:latest
sudo docker tag hyperledger/fabric-orderer:2.2 hyperledger/fabric-orderer:latest
sudo docker tag hyperledger/fabric-ccenv:2.2 hyperledger/fabric-ccenv:latest
sudo docker tag hyperledger/fabric-baseos:2.2 hyperledger/fabric-baseos:latest


# 启动顺序
ca.sh up
startdocker.sh 1
create_systen_channel.sh
startdocker.sh 2

docker logs -f orderer1.ca.com 看一下排序节点有没有问题 红的就说明有问题 黄的我没去追究过

http://127.0.0.1:7070/#/login //这个要删掉/etc/hosts 下的映射才能用  up.sh里的startdocker.sh 2打开 仅限测试



关闭整个网络
down.sh


├── ca.sh
├── chaincode 连码
│   └── go
├── channel-artifacts
├── config  放着整个fabric的配置文件
│   ├── configtx.yaml
│   ├── core.yaml 是peer的配置文件,需要配置的内容比较多,凡是peer需要设置的内容,全在这里找就对了
│   └── orderer.yaml 配置文件是Orderer节点的示例配置文件
├── configtx
│   └── configtx.yaml 用于生成通道创世块或通道交易的配置文件,
├── create_systen_channel.sh
├── docker    通过docker-compose启动的docker 后期可以改用k8s启动
│   ├── docker-compose-ca.yaml
│   ├── docker-compose-couch-node1.yaml  
│   ├── docker-compose-couch-node2.yaml
│   ├── docker-compose-orderer-base.yaml
│   ├── docker-compose-orderer.yaml
│   ├── docker-compose-org-node1.yaml
│   └── docker-compose-org-node2.yaml
├── docker_env_node2.sh
├── down.sh
├── organizations  证书等都在这个文件夹下
├── README.md 
├── scp.sh  多机部署会用到
├── scripts 部署合约的一些脚本 被舍弃
│   ├── bschaincode.tar.gz
│   ├── deploy_chaincode_node2.sh
│   ├── deploy_chaincode.sh
│   ├── docker_env_node1.sh
│   └── test.sh
├── startdocker.sh 
├── system-genesis-block
└── tools
    ├── configtxgen
    ├── configtxlator
    ├── cryptogen
    ├── discover
    ├── fabric-ca-client  用来管理身份（包括属性管理）和证书（包括续订和回收）
    ├── fabric-ca-server  证书颁发 服务端
    ├── idemixgen
    ├── orderer
    ├── peer
    ├── register_certificate.sh  注册证书脚本
    └── utils.sh


端口映射列表 
=================================================
主机：容器
fabric-ca-server
ca_org1 7054:7054
ca_org2 8054:8054
ca_org3 10054:10054

peer node start
node1
7051:7051
7052:7052
couchdb1
6984:5984

node1
8051:8051
8052:8052
couchdb2
5984:5984

orderer
7050:7050
==================================================



organization文件夹
=================================================
https://blog.csdn.net/No_Game_No_Life_/article/details/103102287
==========================================================


创建+加入+更新通道
====================================================
org1 
export FABRIC_CFG_PATH=${PWD}/../config 
peer channel create -o orderer1.ca.com:7050 -c mychannel -f /opt/gopath/src/hyperledger/fabric/peer/channel-artifacts/mychannel.tx --outputBlock /opt/gopath/src/hyperledger/fabric/peer/channel-artifacts/mychannel.block --tls --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem >&log0.txt
sleep 2
peer channel join -b ../channel-artifacts/mychannel.block >&log1.txt
sleep 2
peer channel update -o orderer1.ca.com:7050 -c mychannel -f /opt/gopath/src/hyperledger/fabric/peer/channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem >&log2.txt

org2
export FABRIC_CFG_PATH=${PWD}/../config
sleep 2
peer channel join -b ../channel-artifacts/mychannel.block >&log1.txt
sleep 2
peer channel update -o orderer1.ca.com:7050 -c mychannel -f /opt/gopath/src/hyperledger/fabric/peer/channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/orderers/orderer1.ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem >&log2.txt
====================================================





# openssl x509 -in ca-cert.pem -text
