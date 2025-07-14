--生成的代码不要手动去修改!
pb_Baccarat={}

--- 响应,msgID=0x5081
pb_Baccarat.RespPlayerExitRoom = 20609
--- 请求,msgID=0x5082,desc=
pb_Baccarat.NotifyRoomReadyWait = 20610
--- 请求,msgID=0x18001,desc=请求获取百家乐房间摘要信息
pb_Baccarat.ReqBaccaratTableSummaryList = 98305
--- 请求,msgID=0x18002,desc=请求获取百家乐房间摘要信息
pb_Baccarat.ReqBaccaratTableSummary = 98306
--- 请求,msgID=0x18081,desc=通知百家乐桌上信息
pb_Baccarat.NotifyBaccaratTableInfo = 98433
--- 请求,msgID=0x18082,desc=返回房间摘要信息
pb_Baccarat.RespBaccaratTableSummaryList = 98434
--- 请求,msgID=0x18083,desc=返回房间单条摘要信息
pb_Baccarat.RespBaccaratTableSummary = 98435
--- 请求,msgID=0x20001,desc=请求下注
pb_Baccarat.ReqBet = 131073
--- 请求,msgID=0x20081,desc=请求下注返回
pb_Baccarat.RespBet = 131201


PbMsg[20609] = 'RespPlayerExitRoom'
PbMsg[20610] = 'NotifyRoomReadyWait'
PbMsg[98305] = 'ReqBaccaratTableSummaryList'
PbMsg[98306] = 'ReqBaccaratTableSummary'
PbMsg[98433] = 'NotifyBaccaratTableInfo'
PbMsg[98434] = 'RespBaccaratTableSummaryList'
PbMsg[98435] = 'RespBaccaratTableSummary'
PbMsg[131073] = 'ReqBet'
PbMsg[131201] = 'RespBet'

PBHelper.LoadPB('SingleGames/Baccarat/Protol','room')
PBHelper.LoadPB('SingleGames/Baccarat/Protol','table')