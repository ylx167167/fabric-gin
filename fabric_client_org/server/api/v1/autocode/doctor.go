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

type DoctorApi struct {
}

var doctorService = service.ServiceGroupApp.AutoCodeServiceGroup.DoctorService


// CreateDoctor 创建Doctor
// @Tags Doctor
// @Summary 创建Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Doctor true "创建Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /doctor/createDoctor [post]
func (doctorApi *DoctorApi) CreateDoctor(c *gin.Context) {
	var doctor autocode.Doctor
	_ = c.ShouldBindJSON(&doctor)
	if err := doctorService.CreateDoctor(doctor); err != nil {
        global.GVA_LOG.Error("创建失败!", zap.Error(err))
		response.FailWithMessage("创建失败", c)
	} else {
		response.OkWithMessage("创建成功", c)
	}
}

// DeleteDoctor 删除Doctor
// @Tags Doctor
// @Summary 删除Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Doctor true "删除Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /doctor/deleteDoctor [delete]
func (doctorApi *DoctorApi) DeleteDoctor(c *gin.Context) {
	var doctor autocode.Doctor
	_ = c.ShouldBindJSON(&doctor)
	if err := doctorService.DeleteDoctor(doctor); err != nil {
        global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
	} else {
		response.OkWithMessage("删除成功", c)
	}
}

// DeleteDoctorByIds 批量删除Doctor
// @Tags Doctor
// @Summary 批量删除Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body request.IdsReq true "批量删除Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"批量删除成功"}"
// @Router /doctor/deleteDoctorByIds [delete]
func (doctorApi *DoctorApi) DeleteDoctorByIds(c *gin.Context) {
	var IDS request.IdsReq
    _ = c.ShouldBindJSON(&IDS)
	if err := doctorService.DeleteDoctorByIds(IDS); err != nil {
        global.GVA_LOG.Error("批量删除失败!", zap.Error(err))
		response.FailWithMessage("批量删除失败", c)
	} else {
		response.OkWithMessage("批量删除成功", c)
	}
}

// UpdateDoctor 更新Doctor
// @Tags Doctor
// @Summary 更新Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body autocode.Doctor true "更新Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"更新成功"}"
// @Router /doctor/updateDoctor [put]
func (doctorApi *DoctorApi) UpdateDoctor(c *gin.Context) {
	var doctor autocode.Doctor
	_ = c.ShouldBindJSON(&doctor)
	if err := doctorService.UpdateDoctor(doctor); err != nil {
        global.GVA_LOG.Error("更新失败!", zap.Error(err))
		response.FailWithMessage("更新失败", c)
	} else {
		response.OkWithMessage("更新成功", c)
	}
}

// FindDoctor 用id查询Doctor
// @Tags Doctor
// @Summary 用id查询Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query autocode.Doctor true "用id查询Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"查询成功"}"
// @Router /doctor/findDoctor [get]
func (doctorApi *DoctorApi) FindDoctor(c *gin.Context) {
	var doctor autocode.Doctor
	_ = c.ShouldBindQuery(&doctor)
	if err, redoctor := doctorService.GetDoctor(doctor.ID); err != nil {
        global.GVA_LOG.Error("查询失败!", zap.Error(err))
		response.FailWithMessage("查询失败", c)
	} else {
		response.OkWithData(gin.H{"redoctor": redoctor}, c)
	}
}

// GetDoctorList 分页获取Doctor列表
// @Tags Doctor
// @Summary 分页获取Doctor列表
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query autocodeReq.DoctorSearch true "分页获取Doctor列表"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /doctor/getDoctorList [get]
func (doctorApi *DoctorApi) GetDoctorList(c *gin.Context) {
	var pageInfo autocodeReq.DoctorSearch
	_ = c.ShouldBindQuery(&pageInfo)
	if err, list, total := doctorService.GetDoctorInfoList(pageInfo); err != nil {
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
