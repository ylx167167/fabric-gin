package yamltool

import (
	"os"
	"wayne_fabric_client/fabric14sdk/fabricyaml"

	"github.com/kataras/golog"
	"gopkg.in/yaml.v2"
)

func ReadYamlConfig(path string, config interface{}) error {
	f, err := os.Open(path)
	defer f.Close()
	if err != nil {
		golog.Fatalf("打开文件失败:%s", err)
	}

	yaml.NewDecoder(f).Decode(config)
	return nil
}

//init 初始化配置文件
func Init() {
	//初始化数据库配置
	err := ReadYamlConfig("conf/TEST.yaml", &fabricyaml.ChaincodeDB)
	if err != nil {
		golog.Errorf("初始化配置文件错误：%s", err)
	}
	golog.Infof("db.yaml配置文件解析:%v", fabricyaml.ChaincodeDB)
	golog.Infof("db.yaml配置文件解析:%v", fabricyaml.ChaincodeDB.Clinet[1].Org.OrgMspID)
}
