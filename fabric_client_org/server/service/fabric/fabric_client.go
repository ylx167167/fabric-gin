package fabric

import (
	"fmt"
	"log"
	"net/http"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	modelfabric "github.com/flipped-aurora/gin-vue-admin/server/model/fabric"
	"github.com/gin-gonic/gin"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/channel"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/ledger"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/resmgmt"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/fabsdk"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

type FabricClientService struct{}

var (
	configPath  = "../conf/wayne_e2e.yaml"
	username    = "Admin"
	channelID   = "mychannel"
	org         = "Org1"
	chaincodeId string
)

var (
	sdk             = &global.SDK
	ledgerClient    = &global.LEDGER_CLIENT
	channelClient   = &global.CHANNEL_CLIENT
	channelProvider = &global.CHANNEL_PROVIDER
	clientProvider  = &global.CLIENT_PROVIDER
	gw              = &global.GW
	network         = &global.NETWORK
	contract        = &global.CONTRACT
	rc              = &global.RC
)

// 下次编写的时候尽量把initialize和global给写到一块去
func sdkInit() {
	if *sdk != nil {
		return
	}
	var err error
	// 通过config包方法从e2e.yaml加载配置。
	configProvider := config.FromFile(configPath)
	// 通过配置初始化sdk
	*sdk, err = fabsdk.New(configProvider)
	if err != nil {
		log.Fatalf("Failed to create new SDK: %s\n", err)
		return
	}

	// 根据channelID获取到通道。
	*channelProvider = (*sdk).ChannelContext(channelID, fabsdk.WithUser(username))
	*clientProvider = (*sdk).Context(fabsdk.WithUser(username), fabsdk.WithOrg(org))
	return
}

// 初始化资源管理客户端
func rcInit() {
	if *rc != nil {
		return
	}
	var err error
	*rc, err = resmgmt.New(*clientProvider)
	if err != nil {
		log.Panicf("failed to create resource client: %s", err)
	}
}

// 在这个例子中ledger用于查询区块链的基本信息，例如区块数量等。
func ledgerClientInit() {
	if *ledgerClient != nil {
		return
	}
	var err error
	*ledgerClient, err = ledger.New(*channelProvider)
	if err != nil {
		log.Fatalln("Failed to create new ledgerClient: ", err)
		return
	}

}

// 获取channel客户吨
func channelClientInit() {
	if *channelClient != nil {
		return
	}
	var err error
	*channelClient, err = channel.New(*channelProvider)
	if err != nil {
		log.Fatalln("Failed to create new channelClient: ", err)
		return
	}
}

// gateway还是用于连接fabric网络，然后调用合约
func gatewayInit() {
	if *gw != nil {
		return
	}
	var err error
	*gw, err = gateway.Connect(gateway.WithSDK(*sdk), gateway.WithUser("Admin"))
	if err != nil {
		fmt.Printf("Failed to create gateway: %s", err)
		return
	}
}

func networkInit() {
	if *network != nil {
		return
	}
	var err error
	*network, err = (*gw).GetNetwork(channelID)
	if err != nil {
		fmt.Printf("Failed to connect network %s", err)
		return
	}
}

func contractInit() {
	if *contract != nil {
		return
	}
	*contract = (*network).GetContract(chaincodeId)
}

func GetContract() *gateway.Contract {
	return *contract
}

type req struct {
	Id   int    `json:"id" form:"id" example:"1"`          //用户id
	Name string `json:"name" form:"name" example:"用户name"` //用户姓名
	Age  int    `json:"age" form:"age" example:"123"`      //用户年龄
}

func (service *FabricClientService) FabricPosttest(c *gin.Context) {
	var r req
	_ = c.ShouldBindJSON(&r)
	fmt.Println("初始化完成")
	fmt.Println(r.Name)
	res := Response{Code: 1001, Message: 1, Data: "connect success !!!"}
	c.JSON(http.StatusOK, res)
}

func (service *FabricClientService) FabricInit(c *gin.Context) {
	// "$ref": "#/definitions/response.SysAuthorityCopyResponse"
	// global.SDK.Close()
	if global.SDK != nil { //默认只启动一个sdk
		// global.SDK.Close()
		res := Response{Code: 1001, Message: 1, Data: "已经启动了一个sdk客户端 !!!"}
		c.JSON(http.StatusOK, res)
		return
	}
	var r modelfabric.SdkInit
	_ = c.ShouldBindJSON(&r)
	configPath = r.ConfigPath
	channelID = r.ChannelID
	org = r.Org
	username = r.Username

	sdkInit()
	rcInit()
	ledgerClientInit()
	channelClientInit()
	gatewayInit()
	networkInit()
	contractInit()
	res := Response{Code: 1001, Message: 1, Data: "启动sdk客户端成功 !!!"}
	c.JSON(http.StatusOK, res)
}
