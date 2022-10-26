// 自动生成模板Doctor
package autocode

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

// Doctor 结构体
// 如果含有time.Time 请自行import time包
type Doctor struct {
	global.GVA_MODEL
	Name   string     `json:"name" form:"name" gorm:"column:name;comment:name"`
	Age    *int       `json:"age" form:"age" gorm:"column:age;comment:age;type:int"`
	Gender string     `json:"gender" form:"gender" gorm:"column:gender;comment:gender"`
	Time   *time.Time `json:"time" form:"time" gorm:"column:time;comment:time"`
	Secret string     `json:"secret" form:"secret" gorm:"column:secret;comment:secret"`
}

// TableName Doctor 表名
func (Doctor) TableName() string {
	return "doctor"
}
