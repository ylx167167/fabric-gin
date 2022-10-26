package fabric

type Op_chaincode struct {
	Cc_Name    string   //链码名称
	Cc_Version string   //链码版本
	Cc_Path    string   //链码绝对路径
	Op_Org     []string //组织路径
	Op_User    string
	Cc_func    string
	Cc_Args    string
}

type Fabric_client struct {
	ConfigPath  string
	ChannelID   string
	Username    string
	ChaincodeId string
	Org         string
}
type Op_excute struct {
	Name string //链码名称
	Func string //调用函数
	Args []string
}

type InstallCC struct {
	Name     string
	Version  string
	Sequence string
	Channel  string
	Path     string   //节点容器内的路径 这个后期可以更改
	Org      []string `json:"org"` //可能有多个组织
	User     string   `json:"user"`
	Cclang   string   //智能合约语言golang
	Ccpolicy string   //签名策略
	Initreq  string   //是否初始化启动链
}
