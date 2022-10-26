# 如何相对包名而不用每次都是在GOPATH/src下的包名
root
zxcv7410.


# go-kit版本问题
go get github.com/go-kit/kit@v0.8.0 

# fabric-client分三步进行
*  创建通道
*  安装和实例化链码
*  通道客户端

# 签名和加密的区别
https://www.cnblogs.com/wgj-master/p/10435753.html
公钥一般用来加密，私钥用来签名。
通常公钥是公开出去的，但是私钥只能自己私密持有。

# 群加密
https://github.com/yunfeiyangbuaa/BBS04_signature

# 增加fabric-gosdk模块
1.4版本
https://blog.csdn.net/zhanglingge/article/details/107655443
https://blog.csdn.net/qq_43681877/article/details/119670662
https://www.it610.com/article/1282288096125140992.htm
 安装 fabirc-sdk-go的cauthdsl包  
 go get github.com/hyperledger/fabric/common/cauthdsl
 go mod download github.com/go-kit/kit
需要配置conf/config_fabric.y
在config_fabric中 所有url 都换成localhost 
比如url：peer0.org1.ca.com:7051 -> localhost:7051
2.2版本

# 重启docker 
docker restart $(docker ps -a -q)


************************
# 解决问题
1 ：../fabric-sdk-go/internal/github.com/hyperledger/fabric/core/operations/system.go:227:23: not enough arguments in call to s.statsd.SendLoop
   have (<-chan time.Time, string, string)
    want (context.Context, <-chan time.Time, string, string)
https://stackoom.com/question/3mBEX

2：2021/12/14 14:48:13.232 [E]  Failed to instantiate chaincode: sending deploy transaction proposal failed: Multiple errors occurred: - Transaction processing for endorser [peer0.org2.ca.com:8051]: Endorser Client Status Code: (2) CONNECTION_FAILED. Description: dialing connection on target [peer0.org2.ca.com:8051]: connection is in TRANSIENT_FAILURE - Transaction processing for endorser [peer0.org1.ca.com:7051]: Endorser Client Status Code: (2) CONNECTION_FAILED. Description: dialing connection on target [peer0.org1.ca.com:7051]: connection is in TRANSIENT_FAILURE
    /etc/hosts
    #127.0.0.1      peer0.org1.ca.com
    #127.0.0.1      peer0.org2.ca.com

# 启动 gin
## npm cnpm下载
    https://www.jianshu.com/p/157b8ca81446
## 启动gin工程
    ../web/Readme.md
# docker部署mysql+redis
    https://blog.51cto.com/u_15314183/5116804
    ./startdocker.sh 2

