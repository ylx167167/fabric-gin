import service from '@/utils/request'

// @Tags Hospital
// @Summary 创建Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Hospital true "创建Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /hospital/createHospital [post]
export const createHospital = (data) => {
  return service({
    url: '/hospital/createHospital',
    method: 'post',
    data
  })
}

// @Tags Hospital
// @Summary 删除Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Hospital true "删除Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /hospital/deleteHospital [delete]
export const deleteHospital = (data) => {
  return service({
    url: '/hospital/deleteHospital',
    method: 'delete',
    data
  })
}

// @Tags Hospital
// @Summary 删除Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body request.IdsReq true "批量删除Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"删除成功"}"
// @Router /hospital/deleteHospital [delete]
export const deleteHospitalByIds = (data) => {
  return service({
    url: '/hospital/deleteHospitalByIds',
    method: 'delete',
    data
  })
}

// @Tags Hospital
// @Summary 更新Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body model.Hospital true "更新Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"更新成功"}"
// @Router /hospital/updateHospital [put]
export const updateHospital = (data) => {
  return service({
    url: '/hospital/updateHospital',
    method: 'put',
    data
  })
}

// @Tags Hospital
// @Summary 用id查询Hospital
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query model.Hospital true "用id查询Hospital"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"查询成功"}"
// @Router /hospital/findHospital [get]
export const findHospital = (params) => {
  return service({
    url: '/hospital/findHospital',
    method: 'get',
    params
  })
}

// @Tags Hospital
// @Summary 分页获取Hospital列表
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data query request.PageInfo true "分页获取Hospital列表"
// @Success 200 {string} string "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /hospital/getHospitalList [get]
export const getHospitalList = (params) => {
  return service({
    url: '/hospital/getHospitalList',
    method: 'get',
    params
  })
}
