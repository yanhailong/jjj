--生成的代码不要手动去修改!
pb_BirdsAnimals={}

--- 请求,msgID=0x7531,desc=进入房间
pb_BirdsAnimals.ReqBirdsAnimalsEnterRoom = 30001
--- 响应,msgID=0x7532,desc=返回房间信息
pb_BirdsAnimals.ResBirdsAnimalsEnterRoom = 30002
--- 请求,msgID=0x7533,desc=玩家押注上报
pb_BirdsAnimals.ReqBirdsAnimalsBetting = 30003
--- 响应,msgID=0x7534,desc=广播玩家押注信息
pb_BirdsAnimals.ResBirdsAnimalsBetting = 30004
--- 响应,msgID=0x7535,desc=广播切换状态时的信息
pb_BirdsAnimals.ResBirdsAnimalsGameStatus = 30005
--- 响应,msgID=0x7536,desc=广播玩家离开房间的消息
pb_BirdsAnimals.ResBirdsAnimalsPlayerLeaveRoom = 30006
--- 响应,msgID=0x7537,desc=广播玩家进入房间的消息
pb_BirdsAnimals.ResBirdsAnimalsPlayerEnterRoom = 30007
--- 响应,msgID=0x7538,desc=广播结算信息
pb_BirdsAnimals.ResBirdsAnimalsGameResult = 30008


PbMsg[30001] = 'ReqBirdsAnimalsEnterRoom'
PbMsg[30002] = 'ResBirdsAnimalsEnterRoom'
PbMsg[30003] = 'ReqBirdsAnimalsBetting'
PbMsg[30004] = 'ResBirdsAnimalsBetting'
PbMsg[30005] = 'ResBirdsAnimalsGameStatus'
PbMsg[30006] = 'ResBirdsAnimalsPlayerLeaveRoom'
PbMsg[30007] = 'ResBirdsAnimalsPlayerEnterRoom'
PbMsg[30008] = 'ResBirdsAnimalsGameResult'

PBHelper.LoadPB('SingleGames/BirdsAnimals/Protol','birdsAnimals')