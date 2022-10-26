# 内含使用说明 
bs_server/fabric/README.md  启动网络
bs_server/fabric_client_org/README.md 搭建区块链客户端
部署智能合约
编译智能合约

# gopath
https://www.cnblogs.com/ailiailan/p/13454139.html
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn

# golang 倒包顺序
https://blog.csdn.net/benben_2015/article/details/91455497
https://www.jb51.net/article/202410.htm

# go mod 使用方法
GO111MODULE的值为on时
go get -u github.com/gin-gonic/gin，直接下载到GOPATH/pkg/mod里面了
go get github.com/gin-gonic/gin，直接下载到GOPATH/pkg/mod里面了


# vscode 默认会从GOPATH/src 下查找包  并且每个包名是不含tag才行
所以 我们要go mod vendor  将项目依赖的第三方包复制进来  那么跳转的话就会先去vendor 文件夹下 
https://blog.csdn.net/weixin_48860459/article/details/106954017

# vscode 默认会从GOPATH/src 下查找包 我们要打开go.mod的那个最上层
文件夹 才能实现跳转
比如工程目录是fabric_client_org
那么我们vscode就要进入到那个目录下


# 如何相对包名而不用每次都是在GOPATH/src下的包名

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


# 采用的web框架
./web/
github：https://github.com/flipped-aurora/gin-vue-admin.git
文档：https://www.gin-vue-admin.com/
预览效果：http://demo.gin-vue-admin.com/#/layout/dashboard


# mysql安装
sudo apt-get install mysql-server


# IPFS
https://blog.csdn.net/Aaron_Kings/article/details/105256309
文件hash是 QmUvS3J7Z5n8Kvs64H55P7WivgmsGaKFiDTtBCxpUtkxw4
{Aaron Bob 100 200}
安装ipfs-desktop
https://github.com/ipfs/ipfs-desktop/releases
https://www.bilibili.com/video/BV1wU4y1u7aG?from=search&seid=1973314511416817481&spm_id_from=333.337.0.0

# 项目目标 
 * 角色
    医院 医生 病人
 * 行为
    医院：管理医生 病人 
    医生：看病人
    病人：病例，医疗数据
 * 前端网页设计
    
 * 服务器部分
    * 开启区块链服务器 制作区块链浏览器
        * 双链结构 智能合约
        * 加密部分 共享
    * mqtt服务器 便携式呼吸心跳仪入网 
        * emq消息分发
        * 订阅主题
            * 上传数据主题
            * 请求合法性主题
            * 数据共享主题
    * sip服务器

* 病床分机功能
  * 无线呼吸心跳检测 毫米波雷达（最原始的信号处理算法就行）
  * 病人传呼机
  * 神经网络+病例分析 呼吸心跳检测
  * modbus楼宇报警
 