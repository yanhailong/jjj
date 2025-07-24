--生成的代码不要手动去修改!
pb_CarLogo={}

--- 请求,msgID=0x9c41,desc=进入房间
pb_CarLogo.ReqCarLogoEnterRoom = 40001
--- 响应,msgID=0x9c42,desc=返回房间信息
pb_CarLogo.ResCarLogoEnterRoom = 40002
--- 请求,msgID=0x9c43,desc=玩家押注上报
pb_CarLogo.ReqCarLogoBetting = 40003
--- 响应,msgID=0x9c44,desc=广播玩家押注信息
pb_CarLogo.ResCarLogoBetting = 40004
--- 响应,msgID=0x9c45,desc=广播切换状态时的信息
pb_CarLogo.ResCarLogoGameStatus = 40005
--- 响应,msgID=0x9c46,desc=广播玩家离开房间的消息
pb_CarLogo.ResCarLogoPlayerLeaveRoom = 40006
--- 响应,msgID=0x9c47,desc=广播玩家进入房间的消息
pb_CarLogo.ResCarLogoPlayerEnterRoom = 40007
--- 响应,msgID=0x9c48,desc=广播结算信息
pb_CarLogo.ResCarLogoGameResult = 40008


PbMsg[40001] = 'ReqCarLogoEnterRoom'
PbMsg[40002] = 'ResCarLogoEnterRoom'
PbMsg[40003] = 'ReqCarLogoBetting'
PbMsg[40004] = 'ResCarLogoBetting'
PbMsg[40005] = 'ResCarLogoGameStatus'
PbMsg[40006] = 'ResCarLogoPlayerLeaveRoom'
PbMsg[40007] = 'ResCarLogoPlayerEnterRoom'
PbMsg[40008] = 'ResCarLogoGameResult'

PBHelper.LoadPB('SingleGames/CarLogo/Protol','carLogo')