# 总结
 本项目单纯只是为了验证fabric+gin的功能性验证 
 参考多个GitHub项目 粗略让大家熟悉fabric流程

# 内含使用说明 
1:fabric/README.md  启动网络 fabric+explorer
2:fabric_client_org/README.md gin搭建区块链客户端(智能合约部署查询部分)
停止整改项目 调用fabric/down.sh就行

# IPFS
https://blog.csdn.net/Aaron_Kings/article/details/105256309
文件hash是 QmUvS3J7Z5n8Kvs64H55P7WivgmsGaKFiDTtBCxpUtkxw4
{Aaron Bob 100 200}
安装ipfs-desktop
https://github.com/ipfs/ipfs-desktop/releases
https://www.bilibili.com/video/BV1wU4y1u7aG?from=search&seid=1973314511416817481&spm_id_from=333.337.0.0


# 项目参考过的fabric项目
gin-vue-admin https://github.com/flipped-aurora/gin-vue-admin
fabric-samples ttps://github.com/hyperledger/fabric-samples
fabric https://goreportcard.com/badge/github.com/hyperledger/fabric
blockchain-explorer-gin https://github.com/pixel-revolve/blockchain-explorer-gin

# 项目启动的路径更改
所有 /home/wayne/samba/bs_server 路径都改成您主机下的路径
比如 /home/wayne/samba/bs_server/fabric/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/keystore/priv_sk
改成 当前您主机下的工程路径+fabric/organizations/peerOrganizations/org2.ca.com/users/Admin@org2.ca.com/msp/keystore/priv_sk


启动网络时要更改 /etc/hosts文件 文件内容如下
#127.0.0.1      orderer1.ca.com
#127.0.0.1      peer0.org1.ca.com
#127.0.0.1      peer0.org2.ca.com
调用链码时要更改 /etc/hosts文件 文件内容如下
127.0.0.1      orderer1.ca.com
127.0.0.1      peer0.org1.ca.com
127.0.0.1      peer0.org2.ca.com
