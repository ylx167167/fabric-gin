package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/api/v1"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type DoctorRouter struct {
}

// InitDoctorRouter 初始化 Doctor 路由信息
func (s *DoctorRouter) InitDoctorRouter(Router *gin.RouterGroup) {
	doctorRouter := Router.Group("doctor").Use(middleware.OperationRecord())
	doctorRouterWithoutRecord := Router.Group("doctor")
	var doctorApi = v1.ApiGroupApp.AutoCodeApiGroup.DoctorApi
	{
		doctorRouter.POST("createDoctor", doctorApi.CreateDoctor)   // 新建Doctor
		doctorRouter.DELETE("deleteDoctor", doctorApi.DeleteDoctor) // 删除Doctor
		doctorRouter.DELETE("deleteDoctorByIds", doctorApi.DeleteDoctorByIds) // 批量删除Doctor
		doctorRouter.PUT("updateDoctor", doctorApi.UpdateDoctor)    // 更新Doctor
	}
	{
		doctorRouterWithoutRecord.GET("findDoctor", doctorApi.FindDoctor)        // 根据ID获取Doctor
		doctorRouterWithoutRecord.GET("getDoctorList", doctorApi.GetDoctorList)  // 获取Doctor列表
	}
}
