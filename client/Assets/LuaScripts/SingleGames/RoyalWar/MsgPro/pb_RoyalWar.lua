--生成的代码不要手动去修改!
pb_RoyalWar={}

--- 响应,msgID=0x5082,desc=通知房间进入
pb_RoyalWar.NotifyRoomReadyWait = 20610
--- 响应,msgID=0x13003,desc=红黑大战结算信息
pb_RoyalWar.NotifyRedBlackWarSettleInfo = 77827
--- 响应,msgID=0x13081,desc=通知红黑大战桌上信息
pb_RoyalWar.NotifyRedBlackWarInfo = 77953
--- 响应,msgID=0x14001,desc=通知龙虎斗桌上信息
pb_RoyalWar.NotifyLoongTigerWarInfo = 81921
--- 响应,msgID=0x14002,desc=龙虎斗结算信息
pb_RoyalWar.NotifyLoongTigerWarSettleInfo = 81922
--- 响应,msgID=0x16081,desc=飞禽走兽桌面信息，下注，结算，断线重连
pb_RoyalWar.NotifyAnimalsTableInfo = 90241
--- 响应,msgID=0x16082,desc=通知飞禽走兽结算信息
pb_RoyalWar.NotifyAnimalsSettlement = 90242
--- 请求,msgID=0x18001,desc=请求获取百家乐房间摘要信息
pb_RoyalWar.ReqBaccaratTableSummaryList = 98305
--- 请求,msgID=0x18002,desc=请求获取百家乐房间摘要信息
pb_RoyalWar.ReqBaccaratTableSummary = 98306
--- 请求,msgID=0x18004
pb_RoyalWar.ReqBaccaratTableInfo = 98308
--- 请求,msgID=0x18005,desc=在游戏中请求加入房间
pb_RoyalWar.ReqJoinRoomInGame = 98309
--- 请求,msgID=0x18006,desc=在游戏中请求退出房间
pb_RoyalWar.ReqExitRoomInGame = 98310
--- 响应,msgID=0x18081,desc=断线重连 通知玩家百家乐牌桌信息
pb_RoyalWar.NotifyBaccaratTableInfo = 98433
--- 响应,msgID=0x18082,desc=返回房间摘要信息
pb_RoyalWar.RespBaccaratTableSummaryList = 98434
--- 响应,msgID=0x18083,desc=返回房间单条摘要信息
pb_RoyalWar.NotifyBaccaratTableSummary = 98435
--- 响应,msgID=0x18084,desc=返回百家乐桌上信息 首次进入
pb_RoyalWar.RespBaccaratTableInfo = 98436
--- 响应,msgID=0x18085,desc=百家乐通知下注开始
pb_RoyalWar.NotifyBaccaratBetStart = 98437
--- 响应,msgID=0x18086,desc=百家乐结算信息
pb_RoyalWar.NotifyBaccaratSettlementInfo = 98438
--- 响应,msgID=0x18087,desc=在游戏中返回加入房间
pb_RoyalWar.RespJoinRoomInGame = 98439
--- 响应,msgID=0x18088,desc=在游戏中返回退出房间
pb_RoyalWar.RespExitRoomInGame = 98440
--- 请求,msgID=0x20001,desc=请求下注
pb_RoyalWar.ReqBet = 131073
--- 请求,msgID=0x20003,desc=请求获取百人牌桌的玩家信息
pb_RoyalWar.ReqTablePlayerInfo = 131075
--- 请求,msgID=0x20004
pb_RoyalWar.ReqRoomBaseInfo = 131076
--- 响应,msgID=0x20081,desc=请求下注返回
pb_RoyalWar.NotifyPlayerBet = 131201
--- 响应,msgID=0x20083,desc=返回牌桌玩家列表的下注信息
pb_RoyalWar.RespTablePlayerInfo = 131203
--- 响应,msgID=0x20088,desc=通知押注类房间玩家信息变化
pb_RoyalWar.NotifyTableRoomPlayerInfoChange = 131208
--- 响应,msgID=0x20089
pb_RoyalWar.NotifyPhaseChangInfo = 131209


PbMsg[20610] = 'NotifyRoomReadyWait'
PbMsg[77827] = 'NotifyRedBlackWarSettleInfo'
PbMsg[77953] = 'NotifyRedBlackWarInfo'
PbMsg[81921] = 'NotifyLoongTigerWarInfo'
PbMsg[81922] = 'NotifyLoongTigerWarSettleInfo'
PbMsg[90241] = 'NotifyAnimalsTableInfo'
PbMsg[90242] = 'NotifyAnimalsSettlement'
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

PBHelper.LoadPB('SingleGames/RoyalWar/Protol','room')
PBHelper.LoadPB('SingleGames/RoyalWar/Protol','table')