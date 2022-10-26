package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/autocode"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
    autoCodeReq "github.com/flipped-aurora/gin-vue-admin/server/model/autocode/request"
)

type DoctorService struct {
}

// CreateDoctor 创建Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService) CreateDoctor(doctor autocode.Doctor) (err error) {
	err = global.GVA_DB.Create(&doctor).Error
	return err
}

// DeleteDoctor 删除Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService)DeleteDoctor(doctor autocode.Doctor) (err error) {
	err = global.GVA_DB.Delete(&doctor).Error
	return err
}

// DeleteDoctorByIds 批量删除Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService)DeleteDoctorByIds(ids request.IdsReq) (err error) {
	err = global.GVA_DB.Delete(&[]autocode.Doctor{},"id in ?",ids.Ids).Error
	return err
}

// UpdateDoctor 更新Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService)UpdateDoctor(doctor autocode.Doctor) (err error) {
	err = global.GVA_DB.Save(&doctor).Error
	return err
}

// GetDoctor 根据id获取Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService)GetDoctor(id uint) (err error, doctor autocode.Doctor) {
	err = global.GVA_DB.Where("id = ?", id).First(&doctor).Error
	return
}

// GetDoctorInfoList 分页获取Doctor记录
// Author [piexlmax](https://github.com/piexlmax)
func (doctorService *DoctorService)GetDoctorInfoList(info autoCodeReq.DoctorSearch) (err error, list interface{}, total int64) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
    // 创建db
	db := global.GVA_DB.Model(&autocode.Doctor{})
    var doctors []autocode.Doctor
    // 如果有条件搜索 下方会自动创建搜索语句
    if info.Name != "" {
        db = db.Where("name = ?",info.Name)
    }
    if info.Age != nil {
        db = db.Where("age = ?",info.Age)
    }
    if info.Gender != "" {
        db = db.Where("gender = ?",info.Gender)
    }
    if info.Time != nil {
         db = db.Where("time > ?",info.Time)
    }
    if info.Secret != "" {
        db = db.Where("secret = ?",info.Secret)
    }
	err = db.Count(&total).Error
	if err!=nil {
    	return
    }
	err = db.Limit(limit).Offset(offset).Find(&doctors).Error
	return err, doctors, total
}
