package v1

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"

	"github.com/gin-gonic/gin"
)

/*
*Filename         :test.go
*Description      :
*Author           :wayneyao
*Time             :2021/12/28 15:10:16
* /test/testT
 */

func TestT(c *gin.Context) {
	response.Ok(c)
}
