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
PbMsg={}

PbMsg[4097] = 'ReqHeartBeat'
PbMsg[4098] = 'ResHeartBeat'
PbMsg[4099] = 'NoticeServerStatus'
PbMsg[12289] = 'ReqLogin'
PbMsg[12290] = 'ResLogin'

PBHelper.LoadPB('core')