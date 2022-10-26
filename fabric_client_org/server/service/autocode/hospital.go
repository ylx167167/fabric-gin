package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/autocode"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
    autoCodeReq "github.com/flipped-aurora/gin-vue-admin/server/model/autocode/request"
)

type HospitalService struct {
}

// CreateHospital 创建Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService) CreateHospital(hospital autocode.Hospital) (err error) {
	err = global.GVA_DB.Create(&hospital).Error
	return err
}

// DeleteHospital 删除Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService)DeleteHospital(hospital autocode.Hospital) (err error) {
	err = global.GVA_DB.Delete(&hospital).Error
	return err
}

// DeleteHospitalByIds 批量删除Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService)DeleteHospitalByIds(ids request.IdsReq) (err error) {
	err = global.GVA_DB.Delete(&[]autocode.Hospital{},"id in ?",ids.Ids).Error
	return err
}

// UpdateHospital 更新Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService)UpdateHospital(hospital autocode.Hospital) (err error) {
	err = global.GVA_DB.Save(&hospital).Error
	return err
}

// GetHospital 根据id获取Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService)GetHospital(id uint) (err error, hospital autocode.Hospital) {
	err = global.GVA_DB.Where("id = ?", id).First(&hospital).Error
	return
}

// GetHospitalInfoList 分页获取Hospital记录
// Author [piexlmax](https://github.com/piexlmax)
func (hospitalService *HospitalService)GetHospitalInfoList(info autoCodeReq.HospitalSearch) (err error, list interface{}, total int64) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
    // 创建db
	db := global.GVA_DB.Model(&autocode.Hospital{})
    var hospitals []autocode.Hospital
    // 如果有条件搜索 下方会自动创建搜索语句
    if info.Name != "" {
        db = db.Where("name = ?",info.Name)
    }
    if info.Level != nil {
        db = db.Where("level = ?",info.Level)
    }
    if info.Address != "" {
        db = db.Where("address = ?",info.Address)
    }
    if info.Telephone != nil {
        db = db.Where("telephone = ?",info.Telephone)
    }
	err = db.Count(&total).Error
	if err!=nil {
    	return
    }
	err = db.Limit(limit).Offset(offset).Find(&hospitals).Error
	return err, hospitals, total
}
