--生成的代码不要手动去修改!
pb_VietnamChess={}

--- 响应,msgID=0x5082,desc=通知房间进入
pb_VietnamChess.NotifyRoomReadyWait = 20610
--- 请求,msgID=0x18001,desc=请求获取百家乐房间摘要信息
pb_VietnamChess.ReqBaccaratTableSummaryList = 98305
--- 请求,msgID=0x18002,desc=请求获取百家乐房间摘要信息
pb_VietnamChess.ReqBaccaratTableSummary = 98306
--- 请求,msgID=0x18004
pb_VietnamChess.ReqBaccaratTableInfo = 98308
--- 请求,msgID=0x18005,desc=在游戏中请求加入房间
pb_VietnamChess.ReqJoinRoomInGame = 98309
--- 响应,msgID=0x18081,desc=断线重连 通知玩家百家乐牌桌信息
pb_VietnamChess.NotifyBaccaratTableInfo = 98433
--- 响应,msgID=0x18082,desc=返回房间摘要信息
pb_VietnamChess.RespBaccaratTableSummaryList = 98434
--- 响应,msgID=0x18083,desc=返回房间单条摘要信息
pb_VietnamChess.NotifyBaccaratTableSummary = 98435
--- 响应,msgID=0x18084,desc=返回百家乐桌上信息 首次进入
pb_VietnamChess.RespBaccaratTableInfo = 98436
--- 响应,msgID=0x18085,desc=百家乐通知新的一局开始
pb_VietnamChess.NotifyBaccaratRoundStart = 98437
--- 响应,msgID=0x18086,desc=百家乐结算信息
pb_VietnamChess.NotifyBaccaratSettlementInfo = 98438
--- 响应,msgID=0x18087,desc=在游戏中返回加入房间
pb_VietnamChess.RespJoinRoomInGame = 98439
--- 请求,msgID=0x20001,desc=请求下注
pb_VietnamChess.ReqBet = 131073
--- 请求,msgID=0x20003,desc=请求获取百人牌桌的玩家信息
pb_VietnamChess.ReqTablePlayerInfo = 131075
--- 响应,msgID=0x20081,desc=请求下注返回
pb_VietnamChess.NotifyPlayerBet = 131201
--- 响应,msgID=0x20083,desc=返回百人牌桌玩家列表的下注信息
pb_VietnamChess.RespTablePlayerInfo = 131203
--- 请求,msgID=0x20088,desc=通知押注类房间玩家信息变化
pb_VietnamChess.NotifyTableRoomPlayerInfoChange = 131208


PbMsg[20610] = 'NotifyRoomReadyWait'
PbMsg[98305] = 'ReqBaccaratTableSummaryList'
PbMsg[98306] = 'ReqBaccaratTableSummary'
PbMsg[98308] = 'ReqBaccaratTableInfo'
PbMsg[98309] = 'ReqJoinRoomInGame'
PbMsg[98433] = 'NotifyBaccaratTableInfo'
PbMsg[98434] = 'RespBaccaratTableSummaryList'
PbMsg[98435] = 'NotifyBaccaratTableSummary'
PbMsg[98436] = 'RespBaccaratTableInfo'
PbMsg[98437] = 'NotifyBaccaratRoundStart'
PbMsg[98438] = 'NotifyBaccaratSettlementInfo'
PbMsg[98439] = 'RespJoinRoomInGame'
PbMsg[131073] = 'ReqBet'
PbMsg[131075] = 'ReqTablePlayerInfo'
PbMsg[131201] = 'NotifyPlayerBet'
PbMsg[131203] = 'RespTablePlayerInfo'
PbMsg[131208] = 'NotifyTableRoomPlayerInfoChange'

PBHelper.LoadPB('SingleGames/VietnamChess/Protol','room')
PBHelper.LoadPB('SingleGames/VietnamChess/Protol','table')