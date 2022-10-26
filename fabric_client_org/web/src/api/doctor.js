import service from '@/utils/request'

// @Tags Doctor
// @Summary 创建Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Doctor true "创建Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /doctor/createDoctor [post]
export const createDoctor = (data) => {
  return service({
    url: '/doctor/createDoctor',
    method: 'post',
    data
  })
}

// @Tags Doctor
// @Summary 删除Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Doctor true "删除Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /doctor/deleteDoctor [delete]
export const deleteDoctor = (data) => {
  return service({
    url: '/doctor/deleteDoctor',
    method: 'delete',
    data
  })
}

// @Tags Doctor
// @Summary 删除Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body request.IdsReq true "批量删除Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /doctor/deleteDoctor [delete]
export const deleteDoctorByIds = (data) => {
  return service({
    url: '/doctor/deleteDoctorByIds',
    method: 'delete',
    data
  })
}

// @Tags Doctor
// @Summary 更新Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Doctor true "更新Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"更新成功"}"
// @Router /doctor/updateDoctor [put]
export const updateDoctor = (data) => {
  return service({
    url: '/doctor/updateDoctor',
    method: 'put',
    data
  })
}

// @Tags Doctor
// @Summary 用id查询Doctor
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query model.Doctor true "用id查询Doctor"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"查询成功"}"
// @Router /doctor/findDoctor [get]
export const findDoctor = (params) => {
  return service({
    url: '/doctor/findDoctor',
    method: 'get',
    params
  })
}

// @Tags Doctor
// @Summary 分页获取Doctor列表
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query request.PageInfo true "分页获取Doctor列表"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /doctor/getDoctorList [get]
export const getDoctorList = (params) => {
  return service({
    url: '/doctor/getDoctorList',
    method: 'get',
    params
  })
}
