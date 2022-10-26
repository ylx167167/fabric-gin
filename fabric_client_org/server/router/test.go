package router

import (
	v1 "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

func TestUserRouter(Router *gin.RouterGroup) {
	testRouter := Router.Group("test").Use(middleware.OperationRecord())
	{
		testRouter.POST("test", v1.TestT)
	}
}
