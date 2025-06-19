--生成的代码不要手动去修改!
MsgId={}

--- 请求,msgID=0x1001,desc=心跳请求
MsgId.ReqHeartBeat = 4097
--- 响应,msgID=0x1002,desc=心跳返回
MsgId.ResHeartBeat = 4098
--- 响应,msgID=0x1003,desc=通知网络状态
MsgId.NoticeServerStatus = 4099
--- 请求,msgID=0x3001,desc=登录请求
MsgId.ReqLogin = 12289
--- 响应,msgID=0x3002,desc=登录返回
MsgId.ResLogin = 12290
--- 请求,msgID=0x4001,desc=gm请求
MsgId.ReqGm = 16385
--- 响应,msgID=0x4002,desc=gm返回
MsgId.ResGm = 16386
--- 响应,msgID=0x4099,desc=推送金钱变化
MsgId.NoticeMoneyChange = 16537
--- 请求,msgID=0x6003,desc=请求进入游戏
MsgId.ReqChooseGame = 24579
--- 响应,msgID=0x6004,desc=进入游戏返回
MsgId.ResChooseGame = 24580
--- 请求,msgID=0x6005,desc=选择游戏场次进入
MsgId.ReqChooseWare = 24581
--- 响应,msgID=0x6006,desc=选择游戏场次进入
MsgId.ResChooseWare = 24582
--- 请求,msgID=0x7005,desc=请求开始游戏
MsgId.ReqStartGame = 28677
--- 响应,msgID=0x7006,desc=开始游戏结果返回
MsgId.ResStartGame = 28678
--- NoticeConfigInfo
MsgId.NoticeConfigInfo = 28825
PbMsg={}

PbMsg[4097] = 'ReqHeartBeat'
PbMsg[4098] = 'ResHeartBeat'
PbMsg[4099] = 'NoticeServerStatus'
PbMsg[12289] = 'ReqLogin'
PbMsg[12290] = 'ResLogin'
PbMsg[16385] = 'ReqGm'
PbMsg[16386] = 'ResGm'
PbMsg[16537] = 'NoticeMoneyChange'
PbMsg[24579] = 'ReqChooseGame'
PbMsg[24580] = 'ResChooseGame'
PbMsg[24581] = 'ReqChooseWare'
PbMsg[24582] = 'ResChooseWare'
PbMsg[28677] = 'ReqStartGame'
PbMsg[28678] = 'ResStartGame'
PbMsg[28825] = 'NoticeConfigInfo'

PBHelper.LoadPB('core')
PBHelper.LoadPB('dollarexpress')
PBHelper.LoadPB('hall')