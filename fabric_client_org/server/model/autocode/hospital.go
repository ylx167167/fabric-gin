// 自动生成模板Hospital
package autocode

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

// Hospital 结构体
// 如果含有time.Time 请自行import time包
type Hospital struct {
      global.GVA_MODEL
      Name  string `json:"name" form:"name" gorm:"column:name;comment:医院名"`
      Level  *int `json:"level" form:"level" gorm:"column:level;comment:等级;type:int"`
      Address  string `json:"address" form:"address" gorm:"column:address;comment:address"`
      Telephone  *int `json:"telephone" form:"telephone" gorm:"column:telephone;comment:telephone;type:int"`
}


// TableName Hospital 表名
func (Hospital) TableName() string {
  return "Hospital"
}

