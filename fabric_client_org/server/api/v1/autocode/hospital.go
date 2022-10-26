package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
    "github.com/flipped-aurora/gin-vue-admin/server/model/autocode"
    "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
    autocodeReq "github.com/flipped-aurora/gin-vue-admin/server/model/autocode/request"
    "github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
    "github.com/flipped-aurora/gin-vue-admin/server/service"
    "github.com/gin-gonic/gin"
    "go.uber.org/zap"
)

type HospitalApi struct {
}

var hospitalService = service.ServiceGroupApp.AutoCodeServiceGroup.HospitalService


// CreateHospital 创建Hospital
// @Tags Hospital
// @Summary 创建Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Hospital true "创建Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /hospital/createHospital [post]
func (hospitalApi *HospitalApi) CreateHospital(c *gin.Context) {
	var hospital autocode.Hospital
	_ = c.ShouldBindJSON(&hospital)
	if err := hospitalService.CreateHospital(hospital); err != nil {
        global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败", c)
	} else {
		response.OkWithMessage("创建成功", c)
	}
}

// DeleteHospital 删除Hospital
// @Tags Hospital
// @Summary 删除Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Hospital true "删除Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /hospital/deleteHospital [delete]
func (hospitalApi *HospitalApi) DeleteHospital(c *gin.Context) {
	var hospital autocode.Hospital
	_ = c.ShouldBindJSON(&hospital)
	if err := hospitalService.DeleteHospital(hospital); err != nil {
        global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
	} else {
		response.OkWithMessage("删除成功", c)
	}
}

// DeleteHospitalByIds 批量删除Hospital
// @Tags Hospital
// @Summary 批量删除Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body request.IdsReq true "批量删除Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"批量删除成功"}"
// @Router /hospital/deleteHospitalByIds [delete]
func (hospitalApi *HospitalApi) DeleteHospitalByIds(c *gin.Context) {
	var IDS request.IdsReq
    _ = c.ShouldBindJSON(&IDS)
	if err := hospitalService.DeleteHospitalByIds(IDS); err != nil {
        global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		response.FailWithMessage("批量删除失败", c)
	} else {
		response.OkWithMessage("批量删除成功", c)
	}
}

// UpdateHospital 更新Hospital
// @Tags Hospital
// @Summary 更新Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Hospital true "更新Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"更新成功"}"
// @Router /hospital/updateHospital [put]
func (hospitalApi *HospitalApi) UpdateHospital(c *gin.Context) {
	var hospital autocode.Hospital
	_ = c.ShouldBindJSON(&hospital)
	if err := hospitalService.UpdateHospital(hospital); err != nil {
        global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败", c)
	} else {
		response.OkWithMessage("更新成功", c)
	}
}

// FindHospital 用id查询Hospital
// @Tags Hospital
// @Summary 用id查询Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query autocode.Hospital true "用id查询Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"查询成功"}"
// @Router /hospital/findHospital [get]
func (hospitalApi *HospitalApi) FindHospital(c *gin.Context) {
	var hospital autocode.Hospital
	_ = c.ShouldBindQuery(&hospital)
	if err, rehospital := hospitalService.GetHospital(hospital.ID); err != nil {
        global.GVA_LOG.Error("查询失败!", zap.Error(err))
		response.FailWithMessage("查询失败", c)
	} else {
		response.OkWithData(gin.H{"rehospital": rehospital}, c)
	}
}

// GetHospitalList 分页获取Hospital列表
// @Tags Hospital
// @Summary 分页获取Hospital列表
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query autocodeReq.HospitalSearch true "分页获取Hospital列表"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /hospital/getHospitalList [get]
func (hospitalApi *HospitalApi) GetHospitalList(c *gin.Context) {
	var pageInfo autocodeReq.HospitalSearch
	_ = c.ShouldBindQuery(&pageInfo)
	if err, list, total := hospitalService.GetHospitalInfoList(pageInfo); err != nil {
	    global.GVA_LOG.Error("获取失败!", zap.Error(err))
        response.FailWithMessage("获取失败", c)
    } else {
        response.OkWithDetailed(response.PageResult{
            List:     list,
            Total:    total,
            Page:     pageInfo.Page,
            PageSize: pageInfo.PageSize,
        }, "获取成功", c)
    }
}
