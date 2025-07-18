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
--- 请求,msgID=0x18004
pb_Baccarat.ReqBaccaratTableInfo = 98308
--- 请求,msgID=0x18081,desc=断线重连 通知玩家百家乐牌桌信息
pb_Baccarat.NotifyBaccaratTableInfo = 98433
--- 请求,msgID=0x18082,desc=返回房间摘要信息
pb_Baccarat.RespBaccaratTableSummaryList = 98434
--- 请求,msgID=0x18083,desc=返回房间单条摘要信息
pb_Baccarat.RespBaccaratTableSummary = 98435
--- 请求,msgID=0x18084,desc=返回百家乐桌上信息 首次进入
pb_Baccarat.RespBaccaratTableInfo = 98436
--- 请求,msgID=0x18085,desc=百家乐通知新的一局开始
pb_Baccarat.NotifyBaccaratRoundStart = 98437
--- 请求,msgID=0x18086,desc=百家乐结算信息
pb_Baccarat.NotifyBaccaratSettlementInfo = 98438
--- 请求,msgID=0x20001,desc=请求下注
pb_Baccarat.ReqBet = 131073
--- 请求,msgID=0x20002,desc=在游戏中请求加入房间
pb_Baccarat.ReqJoinRoom = 131074
--- 请求,msgID=0x20003,desc=请求获取百人牌桌的玩家信息
pb_Baccarat.ReqTablePlayerInfo = 131075
--- 请求,msgID=0x20081,desc=请求下注返回
pb_Baccarat.NotifyPlayerBet = 131201
--- 请求,msgID=0x20082,desc=在游戏中返回加入房间
pb_Baccarat.RespJoinRoom = 131202
--- 请求,msgID=0x20083,desc=返回百人牌桌玩家列表的下注信息
pb_Baccarat.RespTablePlayerInfo = 131203


PbMsg[20609] = 'RespPlayerExitRoom'
PbMsg[20610] = 'NotifyRoomReadyWait'
PbMsg[98305] = 'ReqBaccaratTableSummaryList'
PbMsg[98306] = 'ReqBaccaratTableSummary'
PbMsg[98308] = 'ReqBaccaratTableInfo'
PbMsg[98433] = 'NotifyBaccaratTableInfo'
PbMsg[98434] = 'RespBaccaratTableSummaryList'
PbMsg[98435] = 'RespBaccaratTableSummary'
PbMsg[98436] = 'RespBaccaratTableInfo'
PbMsg[98437] = 'NotifyBaccaratRoundStart'
PbMsg[98438] = 'NotifyBaccaratSettlementInfo'
PbMsg[131073] = 'ReqBet'
PbMsg[131074] = 'ReqJoinRoom'
PbMsg[131075] = 'ReqTablePlayerInfo'
PbMsg[131201] = 'NotifyPlayerBet'
PbMsg[131202] = 'RespJoinRoom'
PbMsg[131203] = 'RespTablePlayerInfo'

PBHelper.LoadPB('SingleGames/Baccarat/Protol','room')
PBHelper.LoadPB('SingleGames/Baccarat/Protol','table')