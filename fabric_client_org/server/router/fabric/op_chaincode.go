package fabric

import (
	"github.com/flipped-aurora/gin-vue-admin/server/service"
	"github.com/gin-gonic/gin"
)

type FabricRouter struct{}

func (s *FabricRouter) InitFabricRouter(Router *gin.RouterGroup) {
	// fabricRouter := Router.Group("fabricClient").Use(middleware.OperationRecord())
	fabricRouter := Router.Group("fabricClient")
	// fabricRouterWithoutRecord := Router.Group("fabric")
	// var fabricApi = v1.ApiGroupApp.FabricApiGroup.FabricChaincodeApi
	// var fabricApi = v1.ApiGroupApp.FabricApiGroup.FabricChaincodeApi
	var fabricApi = service.ServiceGroupApp.FabricServiceGroup

	// {
	// 	// fabricRouterWithoutRecord.POST("")
	// }
	{ //channel get
		fabricRouter.GET("getHighestBlock", fabricApi.FabricBlockChainService.GetHighestBlock)                     // 获取最高区块信息
		fabricRouter.GET("getBlockByNumber/:number", fabricApi.FabricBlockChainService.GetBlockByNumber)           // 通过区块序号获取区块信息
		fabricRouter.GET("getBlockByHash/:hash", fabricApi.FabricBlockChainService.GetBlockByHash)                 // 通过区块hash获取区块信息
		fabricRouter.GET("getBlockByTxHash/:hash", fabricApi.FabricBlockChainService.GetBlockByTxHash)             /// 通过交易id获取所属区块信息
		fabricRouter.GET("getTransactionByTxHash/:hash", fabricApi.FabricBlockChainService.GetTransactionByTxHash) /// 通过交易id获取交易信息
		fabricRouter.GET("getChannelConfig", fabricApi.FabricBlockChainService.GetChannelConfig)                   /// 获取通道配置信息
		fabricRouter.GET("getChannelConfigBlock", fabricApi.FabricBlockChainService.GetChannelConfigBlock)         /// 获取当前指定通道配置块信息
		fabricRouter.GET("getChannels", fabricApi.FabricBlockChainService.GetChannels)                             /// 获取所有通道
		fabricRouter.GET("getInstalledCC", fabricApi.FabricBlockChainService.GetInstalledCC)                       /// 获取安装的链码
		fabricRouter.GET("getPeerNameList", fabricApi.FabricBlockChainService.GetPeerNameList)                     /// 获取所有的节点
		fabricRouter.GET("getPeerList", fabricApi.FabricBlockChainService.GetPeerList)                             /// 获取所有的节点详细信息
		fabricRouter.GET("getTransactionList", fabricApi.FabricBlockChainService.GetTransactionList)               /// 获取所有的交易
		fabricRouter.GET("getBlockList", fabricApi.FabricBlockChainService.GetBlockList)                           /// 获取所有区块
		fabricRouter.GET("getChannelList", fabricApi.GetChannelList)                                               /// 获取所有通道详细信息 实验
	}
	{
		fabricRouter.POST("fabricInit", fabricApi.FabricClientService.FabricInit)
		fabricRouter.POST("fabricPosttest", fabricApi.FabricClientService.FabricPosttest)
	}
	{
		fabricRouter.POST("fabriccinstall", fabricApi.FabricChaincodeService.Fabric_CCop_install)
		fabricRouter.POST("fabriccexecute", fabricApi.FabricChaincodeService.Fabric_CCop_excute)

	}
}
