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
--- ReqEnterGame
MsgId.ReqEnterGame = 24579
--- 响应,msgID=0x6004,desc=进入游戏返回
MsgId.ResEnterGame = 24580
--- NoticeDollarExpressBaseConfig
MsgId.NoticeDollarExpressBaseConfig = 28825
PbMsg={}

PbMsg[4097] = 'ReqHeartBeat'
PbMsg[4098] = 'ResHeartBeat'
PbMsg[4099] = 'NoticeServerStatus'
PbMsg[12289] = 'ReqLogin'
PbMsg[12290] = 'ResLogin'
PbMsg[16385] = 'ReqGm'
PbMsg[16386] = 'ResGm'
PbMsg[16537] = 'NoticeMoneyChange'
PbMsg[24579] = 'ReqEnterGame'
PbMsg[24580] = 'ResEnterGame'
PbMsg[28825] = 'NoticeDollarExpressBaseConfig'

PBHelper.LoadPB('core')
PBHelper.LoadPB('dollarexpress')
PBHelper.LoadPB('hall')