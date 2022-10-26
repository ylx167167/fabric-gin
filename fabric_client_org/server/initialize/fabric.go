package initialize

import (
	"fmt"
	"log"
	"strings"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/channel"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/ledger"
	"github.com/hyperledger/fabric-sdk-go/pkg/client/resmgmt"
	"github.com/hyperledger/fabric-sdk-go/pkg/common/providers/core"
	"github.com/hyperledger/fabric-sdk-go/pkg/common/providers/fab"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config/lookup"
	"github.com/hyperledger/fabric-sdk-go/pkg/fabsdk"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

const (
	configPath  = "../conf/org1client.yaml"
	configPath2 = "../conf/org2client.yaml"
	channelID   = "mychannel"
	username    = "Admin"
	chaincodeId = "basic"
	org1        = "Org1"
	org2        = "Org2"
)

var (
	sdk             = &global.SDK
	sdk2            = &global.SDK2
	ledgerClient    = &global.LEDGER_CLIENT
	channelClient   = &global.CHANNEL_CLIENT
	channelProvider = &global.CHANNEL_PROVIDER
	clientProvider  = &global.CLIENT_PROVIDER
	clientProvider2 = &global.CLIENT_PROVIDER2
	gw              = &global.GW
	network         = &global.NETWORK
	contract        = &global.CONTRACT
	rc              = &global.RC
	rc2             = &global.RC2
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
	*clientProvider = (*sdk).Context(fabsdk.WithUser(username), fabsdk.WithOrg(org1))

	//客户端2
	configProvider2 := config.FromFile(configPath2)
	*sdk2, err = fabsdk.New(configProvider2)
	if err != nil {
		log.Fatalf("Failed to create new SDK: %s\n", err)
		return
	}
	// 根据channelID获取到通道。
	*clientProvider2 = (*sdk2).Context(fabsdk.WithUser(username), fabsdk.WithOrg(org2))
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
	*rc2, err = resmgmt.New(*clientProvider2)
	if err != nil {
		log.Panicf("failed to create resource client: %s", err)
	}
	// peer := "peer0.org1.ca.com"
	// channelQueryResponse, err := global.RC.QueryChannels(
	// 	resmgmt.WithTargetEndpoints(peer),
	// 	resmgmt.WithRetry(retry.DefaultResMgmtOpts))

	// for _, channel := range channelQueryResponse.Channels {
	// 	// channels = append(channels, channel.ChannelId)
	// 	log.Printf("加入的通道: %s", channel)
	// 	log.Printf("加入的通道: ==================================================================")
	// }

}
func orgTargetPeers(orgs []string, configBackend ...core.ConfigBackend) ([]string, error) {

	networkConfig := fab.NetworkConfig{}

	err := lookup.New(configBackend...).UnmarshalKey("organizations", &networkConfig.Organizations)
	if err != nil {
		return nil, err
	}
	var peers []string
	for _, org1 := range orgs {
		orgConfig, ok := networkConfig.Organizations[strings.ToLower(org1)]
		if !ok {
			continue
		}
		peers = append(peers, orgConfig.Peers...)
	}
	return peers, nil
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

func FabricInit() {
	sdkInit()
	rcInit()
	ledgerClientInit()
	channelClientInit()
	gatewayInit()
	networkInit()

	// contractInit()
	fmt.Println("初始化完成")
}
