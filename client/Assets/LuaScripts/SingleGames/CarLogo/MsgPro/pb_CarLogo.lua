--生成的代码不要手动去修改!
pb_CarLogo={}

--- 响应,msgID=0x5082,desc=通知房间进入
pb_CarLogo.NotifyRoomReadyWait = 20610
--- 响应,msgID=0x13003,desc=红黑大战结算信息
pb_CarLogo.NotifyRedBlackWarSettleInfo = 77827
--- 响应,msgID=0x13081,desc=通知红黑大战桌上信息
pb_CarLogo.NotifyRedBlackWarInfo = 77953
--- 响应,msgID=0x14001,desc=通知龙虎斗桌上信息
pb_CarLogo.NotifyLoongTigerWarInfo = 81921
--- 响应,msgID=0x14002,desc=龙虎斗结算信息
pb_CarLogo.NotifyLoongTigerWarSettleInfo = 81922
--- 响应,msgID=0x16081,desc=飞禽走兽桌面信息，下注，结算，断线重连
pb_CarLogo.NotifyAnimalsTableInfo = 90241
--- 响应,msgID=0x16082,desc=通知飞禽走兽结算信息
pb_CarLogo.NotifyAnimalsSettlement = 90242
--- 响应,msgID=0x17081,desc=豪车俱乐部桌面信息，下注，结算，断线重连
pb_CarLogo.NotifyLuxuryCarClubTableInfo = 94337
--- 响应,msgID=0x17082,desc=通知豪车俱乐部结算信息
pb_CarLogo.NotifyLuxuryCarClubSettlement = 94338
--- 请求,msgID=0x18001,desc=请求获取百家乐房间摘要信息
pb_CarLogo.ReqBaccaratTableSummaryList = 98305
--- 请求,msgID=0x18002,desc=请求获取百家乐房间摘要信息
pb_CarLogo.ReqBaccaratTableSummary = 98306
--- 请求,msgID=0x18004
pb_CarLogo.ReqBaccaratTableInfo = 98308
--- 请求,msgID=0x18005,desc=在游戏中请求加入房间
pb_CarLogo.ReqJoinRoomInGame = 98309
--- 请求,msgID=0x18006,desc=在游戏中请求退出房间
pb_CarLogo.ReqExitRoomInGame = 98310
--- 响应,msgID=0x18081,desc=断线重连 通知玩家百家乐牌桌信息
pb_CarLogo.NotifyBaccaratTableInfo = 98433
--- 响应,msgID=0x18082,desc=返回房间摘要信息
pb_CarLogo.RespBaccaratTableSummaryList = 98434
--- 响应,msgID=0x18083,desc=返回房间单条摘要信息
pb_CarLogo.NotifyBaccaratTableSummary = 98435
--- 响应,msgID=0x18084,desc=返回百家乐桌上信息 首次进入
pb_CarLogo.RespBaccaratTableInfo = 98436
--- 响应,msgID=0x18085,desc=百家乐通知下注开始
pb_CarLogo.NotifyBaccaratBetStart = 98437
--- 响应,msgID=0x18086,desc=百家乐结算信息
pb_CarLogo.NotifyBaccaratSettlementInfo = 98438
--- 响应,msgID=0x18087,desc=在游戏中返回加入房间
pb_CarLogo.RespJoinRoomInGame = 98439
--- 响应,msgID=0x18088,desc=在游戏中返回退出房间
pb_CarLogo.RespExitRoomInGame = 98440
--- 请求,msgID=0x20001,desc=请求下注
pb_CarLogo.ReqBet = 131073
--- 请求,msgID=0x20003,desc=请求获取百人牌桌的玩家信息
pb_CarLogo.ReqTablePlayerInfo = 131075
--- 请求,msgID=0x20004
pb_CarLogo.ReqRoomBaseInfo = 131076
--- 响应,msgID=0x20081,desc=请求下注返回
pb_CarLogo.NotifyPlayerBet = 131201
--- 响应,msgID=0x20083,desc=返回牌桌玩家列表的下注信息
pb_CarLogo.RespTablePlayerInfo = 131203
--- 响应,msgID=0x20088,desc=通知押注类房间玩家信息变化
pb_CarLogo.NotifyTableRoomPlayerInfoChange = 131208
--- 响应,msgID=0x20089
pb_CarLogo.NotifyPhaseChangInfo = 131209


PbMsg[20610] = 'NotifyRoomReadyWait'
PbMsg[77827] = 'NotifyRedBlackWarSettleInfo'
PbMsg[77953] = 'NotifyRedBlackWarInfo'
PbMsg[81921] = 'NotifyLoongTigerWarInfo'
PbMsg[81922] = 'NotifyLoongTigerWarSettleInfo'
PbMsg[90241] = 'NotifyAnimalsTableInfo'
PbMsg[90242] = 'NotifyAnimalsSettlement'
PbMsg[94337] = 'NotifyLuxuryCarClubTableInfo'
PbMsg[94338] = 'NotifyLuxuryCarClubSettlement'
PbMsg[98305] = 'ReqBaccaratTableSummaryList'
PbMsg[98306] = 'ReqBaccaratTableSummary'
PbMsg[98308] = 'ReqBaccaratTableInfo'
PbMsg[98309] = 'ReqJoinRoomInGame'
PbMsg[98310] = 'ReqExitRoomInGame'
PbMsg[98433] = 'NotifyBaccaratTableInfo'
PbMsg[98434] = 'RespBaccaratTableSummaryList'
PbMsg[98435] = 'NotifyBaccaratTableSummary'
PbMsg[98436] = 'RespBaccaratTableInfo'
PbMsg[98437] = 'NotifyBaccaratBetStart'
PbMsg[98438] = 'NotifyBaccaratSettlementInfo'
PbMsg[98439] = 'RespJoinRoomInGame'
PbMsg[98440] = 'RespExitRoomInGame'
PbMsg[131073] = 'ReqBet'
PbMsg[131075] = 'ReqTablePlayerInfo'
PbMsg[131076] = 'ReqRoomBaseInfo'
PbMsg[131201] = 'NotifyPlayerBet'
PbMsg[131203] = 'RespTablePlayerInfo'
PbMsg[131208] = 'NotifyTableRoomPlayerInfoChange'
PbMsg[131209] = 'NotifyPhaseChangInfo'

PBHelper.LoadPB('SingleGames/CarLogo/Protol','room')
PBHelper.LoadPB('SingleGames/CarLogo/Protol','table')