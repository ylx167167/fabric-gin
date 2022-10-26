#!/bin/bash
#
# 注意一下 以下脚本内的路径都是只针对当前up.sh的相对路径 
# 比如 ca.sh中的 . tools/register_certificate.sh 
# tools是up.sh这层路径下的文件 而我们看到ca.sh在scripts这层路径下而这层路径下没有tools这个文件夹 
# 所以以下脚本内的路径都是只针对当前up.sh的相对路径 
./scripts/ca.sh up
./scripts/startdocker.sh 1
./scripts/create_systen_channel.sh
docker ps -a
# ./scripts/startdocker.sh 2

