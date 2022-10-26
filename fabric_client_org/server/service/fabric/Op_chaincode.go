package fabric

import (
	"fmt"
	"net/http"
	"os/exec"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	modelfabric "github.com/flipped-aurora/gin-vue-admin/server/model/fabric"
	utilsfabric "github.com/flipped-aurora/gin-vue-admin/server/utils/fabric"
	"github.com/gin-gonic/gin"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/channel"
	"github.com/hyperledger/fabric-sdk-go/pkg/common/errors/retry"
)

type FabricChaincodeService struct {
}

var PEER_CONN_PARMS1 = " --peerAddresses peer0.org1.ca.com:7051 --tlsRootCertFiles /opt/gopath/src/hyperledger/fabric/peer/organizations/peerOrganizations/org1.ca.com/peers/peer0.org1.ca.com/tls/server.crt "
var PEER_CONN_PARMS2 = " --peerAddresses peer0.org2.ca.com:8051 --tlsRootCertFiles /opt/gopath/src/hyperledger/fabric/peer/organizations/peerOrganizations/org2.ca.com/peers/peer0.org2.ca.com/tls/server.crt "
var ORDERER_CA = "/opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem"
var (
	CC_NAME             string
	CC_SRC_PATH         string
	CC_RUNTIME_LANGUAGE string
	CC_VERSION          string
	CC_SEQUENCE         string
	CHANNEL_NAME        string
	CC_END_POLICY       string
	INIT_REQUIRED       string
	CC_COLL_CONFIG      = ""
)

func (service *FabricChaincodeService) Fabric_CCop_install(c *gin.Context) {
	var r modelfabric.InstallCC
	_ = c.ShouldBindJSON(&r)
	var result []byte
	var err error
	err = utilsfabric.Judge_org(r.Org)
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	CC_NAME = r.Name
	CC_SRC_PATH = r.Path
	CC_RUNTIME_LANGUAGE = r.Cclang
	CC_VERSION = r.Version
	CC_SEQUENCE = r.Sequence
	CHANNEL_NAME = r.Channel
	CC_END_POLICY = r.Ccpolicy
	INIT_REQUIRED = r.Initreq
	fmt.Println("================= InstantiateCC start =================")
	package_cmd := "docker exec Orgcli1 peer lifecycle chaincode package " + CC_NAME + ".tar.gz " + "--path " + CC_SRC_PATH + " --lang " + CC_RUNTIME_LANGUAGE + " --label " + CC_NAME + "_" + CC_VERSION
	result, err = exec.Command("/bin/bash", "-c", package_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	package_cp := "docker exec Orgcli1 cp " + "/opt/gopath/src/hyperledger/fabric/peer/" + CC_NAME + ".tar.gz " + " /opt/gopath/src/hyperledger/fabric/peer/chaincode/pkg"
	result, err = exec.Command("/bin/bash", "-c", package_cp).Output()

	fmt.Println("=================组织1 2安装 =================")
	install_cmd := "docker exec Orgcli1 peer lifecycle chaincode install /opt/gopath/src/hyperledger/fabric/peer/chaincode/pkg/" + CC_NAME + ".tar.gz"
	result, err = exec.Command("/bin/bash", "-c", install_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	install2_cmd := "docker exec Orgcli2 peer lifecycle chaincode install /opt/gopath/src/hyperledger/fabric/peer/chaincode/pkg/" + CC_NAME + ".tar.gz"
	result, err = exec.Command("/bin/bash", "-c", install2_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}

	fmt.Println("=================组织1请求+批准 =================")
	query_cmd := "docker exec Orgcli1 peer lifecycle chaincode queryinstalled"
	result, err = exec.Command("/bin/bash", "-c", query_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	buf1, err := utilsfabric.Phase_packgeid(result, CC_NAME+"_"+CC_VERSION+":")
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	package_id := buf1
	approve_cmd := "docker exec Orgcli1 peer lifecycle chaincode approveformyorg --channelID " + CHANNEL_NAME + " --name " + CC_NAME + " --version " + CC_VERSION + " " + INIT_REQUIRED + " --package-id " + package_id + " --sequence " + CC_SEQUENCE + " --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem " + CC_END_POLICY + " " + CC_COLL_CONFIG
	result, err = exec.Command("/bin/bash", "-c", approve_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}

	fmt.Println("=================组织1请求+批准 =================")
	query2_cmd := "docker exec Orgcli2 peer lifecycle chaincode queryinstalled"
	result, err = exec.Command("/bin/bash", "-c", query2_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	buf2, err := utilsfabric.Phase_packgeid(result, CC_NAME+"_"+CC_VERSION+":")
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	package_id = buf2
	approve2_cmd := "docker exec Orgcli2 peer lifecycle chaincode approveformyorg --channelID " + CHANNEL_NAME + " --name " + CC_NAME + " --version " + CC_VERSION + " " + INIT_REQUIRED + " --package-id " + package_id + " --sequence " + CC_SEQUENCE + " --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem " + CC_END_POLICY + " " + CC_COLL_CONFIG
	result, err = exec.Command("/bin/bash", "-c", approve2_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}

	fmt.Println("=================组织1 2查询是否可提交 =================")
	checkCommit_cmd := "docker exec Orgcli1 peer lifecycle chaincode checkcommitreadiness --channelID " + CHANNEL_NAME + " --name " + CC_NAME + " --version " + CC_VERSION + " --sequence " + CC_SEQUENCE + " " + INIT_REQUIRED + " " + CC_END_POLICY + " " + CC_COLL_CONFIG
	result, err = exec.Command("/bin/bash", "-c", checkCommit_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	checkCommit2_cmd := "docker exec Orgcli2 peer lifecycle chaincode checkcommitreadiness --channelID " + CHANNEL_NAME + " --name " + CC_NAME + " --version " + CC_VERSION + " --sequence " + CC_SEQUENCE + " " + INIT_REQUIRED + " " + CC_END_POLICY + " " + CC_COLL_CONFIG
	result, err = exec.Command("/bin/bash", "-c", checkCommit2_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}

	fmt.Println("=================组织1提交链码 =================")
	commit1_cmd := "docker exec Orgcli1 peer lifecycle chaincode commit -o orderer1.ca.com:7050 --channelID " + CHANNEL_NAME + " --name " + CC_NAME + " --version " + CC_VERSION + " --sequence " + CC_SEQUENCE + " " + INIT_REQUIRED + " " + CC_END_POLICY + " " + CC_COLL_CONFIG + " --tls true --cafile /opt/gopath/src/hyperledger/fabric/peer/organizations/ordererOrganizations/ca.com/msp/tlscacerts/tlsca.ca.com-cert.pem " + PEER_CONN_PARMS1 + PEER_CONN_PARMS2
	fmt.Println(commit1_cmd)
	result, err = exec.Command("/bin/bash", "-c", commit1_cmd).Output()
	if err != nil {
		utilsfabric.Printerr(err, c, result)
		return
	}
	c.JSON(http.StatusOK, Response{Code: 1001, Message: 1, Data: "安装链码成功 !!!" + string(result)})

}
func (service *FabricChaincodeService) Fabric_CCop_excute(c *gin.Context) {
	var r modelfabric.Op_excute
	_ = c.ShouldBindJSON(&r)
	req := channel.Request{
		ChaincodeID: r.Name,
		Fcn:         r.Func,
		Args:        utilsfabric.PackArgs(r.Args),
	}
	resp2, err := global.CHANNEL_CLIENT.Execute(req, channel.WithRetry(retry.DefaultChannelOpts))
	if err != nil {
		utilsfabric.Printerr(err, c, resp2.Payload)
		return
	}
	c.JSON(http.StatusOK, Response{Code: 1001, Message: 1, Data: "success !!!" + string(resp2.Payload)})

}

// func()
