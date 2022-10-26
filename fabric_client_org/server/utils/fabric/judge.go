package fabric

import (
	"fmt"
	"strings"

	"errors"

	platform "github.com/flipped-aurora/gin-vue-admin/server/model/fabric"
	"github.com/gin-gonic/gin"
)

func Judge_org(s []string) error {
	if len(s) < 2 {
		fmt.Println("组织数不能小于2")
		return errors.New("组织数不能小于2")
	}
	//解析组织1 2的json文件

	return nil
}
func Printerr(err error, c *gin.Context, b []byte) {
	c.JSON(200, platform.Response{Code: 500, Message: err.Error() + string(b)})
	fmt.Println(err.Error())
}

func Phase_packgeid(byId []byte, c string) (string, error) {
	var c2 string
	index := strings.Index(string(byId), c)
	if index == -1 {
		return "", errors.New("找不到字符")
	}
	string2 := string(byId[index:])
	c2 = ", Label: "
	index2 := strings.Index(string2, c2)
	if index2 == -1 {
		return "", errors.New("找不到字符")
	}
	return string2[:index2], nil
}

func PackArgs(paras []string) [][]byte {
	var args [][]byte
	for _, k := range paras {
		args = append(args, []byte(k))
	}
	return args
}
