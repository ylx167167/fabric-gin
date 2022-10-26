# 参考项目
Gin
https://github.com/flipped-aurora/gin-vue-admin.git
Gin+getway+Fabric2.4.4
https://blog.csdn.net/lakersssss24/article/details/126434147

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

# 1:启动 gin
## npm cnpm下载
    https://www.jianshu.com/p/157b8ca81446
## 启动gin工程
    ./web/Readme.md
    ./server/Readme.md go run main.go
    在web目录下运行
    npm run serve
    在server目录下运行
    go run main.go 在这之前要启东docker 部署的mysql和redis 端口13306
# docker部署mysql+redis
    https://blog.51cto.com/u_15314183/5116804
    ./startdocker.sh 2 
    docker 文件在 docker/目录下
# 2：更改Gin支持fabric
启动客户端后进入
http://127.0.0.1:8888/swagger/index.html
选择post各个post请求 请求json格式 在server/command.json内
后期应用可自行扩张


