--生成的代码不要手动去修改!
pb_PlatformHall={}

--- 请求,msgID=0x1001,desc=心跳请求
pb_PlatformHall.ReqHeartBeat = 4097
--- 响应,msgID=0x1002,desc=心跳返回
pb_PlatformHall.ResHeartBeat = 4098
--- 响应,msgID=0x1003,desc=通知网络状态
pb_PlatformHall.NoticeServerStatus = 4099
--- 请求,msgID=0x3001,desc=登录请求
pb_PlatformHall.ReqLogin = 12289
--- 响应,msgID=0x3002,desc=登录返回
pb_PlatformHall.ResLogin = 12290
--- 响应,msgID=0x4001,desc=gm请求
pb_PlatformHall.ReqGm = 16385
--- 响应,msgID=0x4002,desc=gm返回
pb_PlatformHall.ResGm = 16386
--- 响应,msgID=0x4099,desc=推送金钱变化
pb_PlatformHall.NoticeBaseInfoChange = 16537
--- 请求,msgID=0x5001,desc=gm请求刷新服务器状态
pb_PlatformHall.ReqRefreshGameStatus = 20481
--- 请求,msgID=0x5002,desc=退出游戏请求
pb_PlatformHall.ReqExitGame = 20482
--- 响应,msgID=0x5003,desc=退出游戏
pb_PlatformHall.ResExitGame = 20483
--- 请求,msgID=0x6003,desc=请求进入游戏
pb_PlatformHall.ReqChooseGame = 24579
--- 响应,msgID=0x6004,desc=进入游戏返回
pb_PlatformHall.ResChooseGame = 24580
--- 请求,msgID=0x6005,desc=选择游戏场次进入
pb_PlatformHall.ReqChooseWare = 24581
--- 响应,msgID=0x6006,desc=选择游戏场次进入
pb_PlatformHall.ResChooseWare = 24582


PbMsg[4097] = 'ReqHeartBeat'
PbMsg[4098] = 'ResHeartBeat'
PbMsg[4099] = 'NoticeServerStatus'
PbMsg[12289] = 'ReqLogin'
PbMsg[12290] = 'ResLogin'
PbMsg[16385] = 'ReqGm'
PbMsg[16386] = 'ResGm'
PbMsg[16537] = 'NoticeBaseInfoChange'
PbMsg[20481] = 'ReqRefreshGameStatus'
PbMsg[20482] = 'ReqExitGame'
PbMsg[20483] = 'ResExitGame'
PbMsg[24579] = 'ReqChooseGame'
PbMsg[24580] = 'ResChooseGame'
PbMsg[24581] = 'ReqChooseWare'
PbMsg[24582] = 'ResChooseWare'

PBHelper.LoadPB('PlatformHall/Protol','core')
PBHelper.LoadPB('PlatformHall/Protol','hall')