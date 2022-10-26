
#!/bin/bash
 
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/
 
./fabric-ca-client enroll -u http://admin:adminpw@localhost:7054 --caname ca-org1
 
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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml
 
#组织1 peer0的msp证书
./fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --id.attrs '"hf.Registrar.Roles=peer"'
 
./fabric-ca-client enroll -u http://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts aa,peer0.org1.example.com
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp
 
./fabric-ca-client enroll -u http://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts aa,peer0.org1.example.com
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
 
mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt
 
mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
 
mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/ca
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
 
#组织1 user的证书
./fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --id.attrs '"hf.Registrar.Roles=client"'
 
./fabric-ca-client enroll -u http://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp  
 
./fabric-ca-client enroll -u http://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls  --enrollment.profile tls
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/client.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/tls/client.key
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml
 
#组织1 admin的证书
./fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --id.attrs '"hf.Registrar.Roles=admin"'
 
./fabric-ca-client enroll -u http://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp 
 
./fabric-ca-client enroll -u http://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls  --enrollment.profile tls 
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.key
 
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/
 
./fabric-ca-client enroll -u http://admin:adminpw@localhost:8054 --caname ca-org2
 
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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml
 
#组织2 peer0的msp证书
./fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --id.attrs '"hf.Registrar.Roles=peer"'
 
./fabric-ca-client enroll -u http://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp --csr.hosts aa,peer0.org2.example.com
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp
 
./fabric-ca-client enroll -u http://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls --enrollment.profile tls --csr.hosts aa,peer0.org2.example.com
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
 
mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt
 
mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
 
mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/ca
cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem
 
#组织2 user的证书
./fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --id.attrs '"hf.Registrar.Roles=client"'
 
./fabric-ca-client enroll -u http://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp 
 
./fabric-ca-client enroll -u http://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls  --enrollment.profile tls 
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/client.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/tls/client.key
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/config.yaml
 
#组织2 admin的证书
./fabric-ca-client register --caname ca-org2 --id.name org1admin --id.secret org1adminpw --id.type admin --id.attrs '"hf.Registrar.Roles=admin"'
 
./fabric-ca-client enroll -u http://org1admin:org1adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp 
 
./fabric-ca-client enroll -u http://org1admin:org1adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls  --enrollment.profile tls 
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/client.crt
cp ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/tls/client.key
 
cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml
 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
 
./fabric-ca-client enroll -u http://admin:adminpw@localhost:9054 --caname ca-orderer
 
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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml
#orderer的证书
./fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --id.attrs '"hf.Registrar.Roles=orderer"'
 
./fabric-ca-client enroll -u http://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts aa,orderer.example.com
 
cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml
 
./fabric-ca-client enroll -u http://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts aa,orderer.example.com
 
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
 
mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
 
mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/ca.crt
 
 
 
#orderer2的证书
./fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --id.attrs '"hf.Registrar.Roles=orderer"'
 
./fabric-ca-client enroll -u http://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts aa,orderer2.example.com
 
cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml
 
./fabric-ca-client enroll -u http://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts aa,orderer2.example.com
 
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key
 
mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
 
 
#orderer3的证书
./fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret orderer3pw --id.type orderer --id.attrs '"hf.Registrar.Roles=orderer"'
 
./fabric-ca-client enroll -u http://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts aa,orderer3.example.com 
 
cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml
 
./fabric-ca-client enroll -u http://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts aa,orderer3.example.com 
 
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key
 
mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
 
 
#orderer admin的证书
./fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --id.attrs '"hf.Registrar.Roles=admin"'
 
./fabric-ca-client enroll -u http://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp 
 
cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
 
./fabric-ca-client enroll -u http://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls --enrollment.profile tls 
 
cp ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/ca.crt
 
cp ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/client.crt
 
cp ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/tls/client.key
