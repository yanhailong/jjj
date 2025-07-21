--生成的代码不要手动去修改!
pb_DragonTigerFight={}

--- 请求,msgID=0x2775,desc=进入房间
pb_DragonTigerFight.ReqEnterRoom = 10101
--- 响应,msgID=0x2776,desc=返回房间信息
pb_DragonTigerFight.ResEnterRoom = 10102
--- 请求,msgID=0x2777,desc=玩家押注上报
pb_DragonTigerFight.ReqBetting = 10103
--- 响应,msgID=0x2778,desc=广播玩家押注信息
pb_DragonTigerFight.ResBetting = 10104
--- 响应,msgID=0x2779,desc=广播切换状态时的信息
pb_DragonTigerFight.ResGameStatus = 10105
--- 响应,msgID=0x2780,desc=广播玩家离开房间的消息
pb_DragonTigerFight.ResPlayerLeaveRoom = 10106
--- 响应,msgID=0x2781,desc=广播玩家进入房间的消息
pb_DragonTigerFight.ResPlayerEnterRoom = 10107
--- 响应,msgID=0x2782,desc=广播结算信息
pb_DragonTigerFight.ResGameResult = 10108


PbMsg[10101] = 'ReqEnterRoom'
PbMsg[10102] = 'ResEnterRoom'
PbMsg[10103] = 'ReqBetting'
PbMsg[10104] = 'ResBetting'
PbMsg[10105] = 'ResGameStatus'
PbMsg[10106] = 'ResPlayerLeaveRoom'
PbMsg[10107] = 'ResPlayerEnterRoom'
PbMsg[10108] = 'ResGameResult'

PBHelper.LoadPB('SingleGames/DragonTigerFight/Protol','dragonTigerFight')