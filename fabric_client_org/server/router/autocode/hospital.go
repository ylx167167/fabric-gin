package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type HospitalRouter struct {
}

// InitHospitalRouter 初始化 Hospital 路由信息
func (s *HospitalRouter) InitHospitalRouter(Router *gin.RouterGroup) {
	hospitalRouter := Router.Group("hospital").Use(middleware.OperationRecord())
	hospitalRouterWithoutRecord := Router.Group("hospital")
	var hospitalApi = v1.ApiGroupApp.AutoCodeApiGroup.HospitalApi
	{
		hospitalRouter.POST("createHospital", hospitalApi.CreateHospital)   // 新建Hospital
		hospitalRouter.DELETE("deleteHospital", hospitalApi.DeleteHospital) // 删除Hospital
		hospitalRouter.DELETE("deleteHospitalByIds", hospitalApi.DeleteHospitalByIds) // 批量删除Hospital
		hospitalRouter.PUT("updateHospital", hospitalApi.UpdateHospital)    // 更新Hospital
	}
	{
		hospitalRouterWithoutRecord.GET("findHospital", hospitalApi.FindHospital)        // 根据ID获取Hospital
		hospitalRouterWithoutRecord.GET("getHospitalList", hospitalApi.GetHospitalList)  // 获取Hospital列表
	}
}
