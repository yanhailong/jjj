---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightModel:BaseModel
local DragonTigerFightModel=Class("DragonTigerFightModel",BaseModel)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

function DragonTigerFightModel:Awake()
    self.super.Awake(self);
    self.ctrl=self.ctrl
    
    self.initState = false
    self.status = 1
    self.endTime = 0
    self.betPointList = {}
    self.players = {} -- 前6玩家信息
    self.sideBetInfos={}
    self.history = {}
    self.Result = {}
    self.bettingDataMap = {}
    self.AreaChipTotals = {0,0,0}
    self.playersNum=0
    --请求进入房间
    self:ReqEnterRoom()
end

function DragonTigerFightModel:Close()
    self.super.Close(self);
end

function DragonTigerFightModel:AddEvent()
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyLoongTigerWarInfo, self.OnEnterRoom, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyRoomReadyWait, self.OnGameStatus, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyLoongTigerWarSettleInfo, self.OnGameResult, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyPlayerBet, self.OnBetting, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyTableRoomPlayerInfoChange, self.UpdatePlayerInfo, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.RespTablePlayerInfo,self.UpdateAllPlayers,self)
    WebNetEvent.AddListener(pb_DragonTigerFight.NotifyPhaseChangInfo,self.OnStartXiaZhu,self)
end

function DragonTigerFightModel:RemoveEvent()
    WebNetEvent.RemoveAllTo(self)
end

--region 事件方法
-- 进入房间请求
function DragonTigerFightModel:ReqEnterRoom()
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqRoomBaseInfo)
end
-- 押注
function DragonTigerFightModel:Bet(data)
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqBet, data)
end
--退出房间
function DragonTigerFightModel:ExitRoom()
    WebNetworkManager.SendMsg(pb_PlatformHall.ReqExitGame)
end
--获取房间玩家信息
function DragonTigerFightModel:ReqRoomPlayers()
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqTablePlayerInfo)
end
-- 进入房间返回 NotifyLoongTigerWarInfo
function DragonTigerFightModel:OnEnterRoom(msg)
    self.betPointList = msg.betPointList 
    self.sideBetInfos = msg.tableAreaInfos
    self.history = msg.histories
    self.players = msg.playerInfos
    self.status = self:TransEGamePhase(msg.gamePhase)
    self.endTime = msg.tableCountDownTime
    self.playersNum = msg.totalPlayerNum
    self.Result = msg.settleInfos --NotifyLoongTigerWarSettleInfo 结算信息
    self.ctrl.view:UpdateRoomInfo(self)
    self.initState = true
    --如果有结果直接显示
    if self.Result then
        self:ShowResult()
    end
end


function updateUI()
    for playerId, info in pairs(playerDataMap) do
        if not info.handled then
            print("刷新玩家", playerId, "数据", info.data)
            -- updatePlayerUI(playerId, info.data)
            info.handled = true
        end
    end
end
-- 广播玩家押注信息 NotifyPlayerBet 
function DragonTigerFightModel:OnBetting(msg)
    if msg and msg.code == 200 and self.initState then
        msg.handled = false
        if self.bettingDataMap[msg.playerId] and not self.bettingDataMap[msg.playerId].handled and msg.playerId == PlayerManager:GetPlayerInfo().playerId  then
            --自己的数据需要统计所以必须完整
            for i = 1, #msg.betTableInfoList do
                table.insert(self.bettingDataMap[msg.playerId].betTableInfoList, msg.betTableInfoList[i])
            end
            msg.betTableInfoList = self.bettingDataMap[msg.playerId].betTableInfoList
            self.bettingDataMap[msg.playerId] = msg
        else--其他玩家直接用最新数据 允许丢掉几个筹码
            self.bettingDataMap[msg.playerId] = msg
        end
    end
end

-- 重新开始游戏的消息 NotifyRoomReadyWait
function DragonTigerFightModel:OnGameStatus(msg)
    if  not self.initState then return end
    self.status = 1
    self.endTime = msg.waitEndTime
    self.ctrl.view:OnGameStatus(self.status)
end
--收到开始下注消息
function DragonTigerFightModel:OnStartXiaZhu(msg)
    self.status = 2
    self.endTime = msg.waitEndTime
    self.ctrl.view:OnGameStatus(self.status)
end

-- 房间玩家信息更新
function DragonTigerFightModel:UpdatePlayerInfo(msg)
    if self.initState and msg.tableChangedPlayerInfos then
        self.players = msg.tableChangedPlayerInfos
        self.playersNum = msg.totalPlayerNum
        self.ctrl.view:UpdatePlayers(self.players)
    end
end

-- 广播结算信息 NotifyLoongTigerWarSettleInfo
function DragonTigerFightModel:OnGameResult(msg)
    if not self.initState then return end
    self.Result = msg;
    if #self.history>=50 then
        self.history = {}
    end
    table.insert(self.history,msg.winState)
    
    --切换状态
    self.status = 3
    self.ctrl.view:OnGameStatus(self.status)
    
    self:ShowResult()
end

function DragonTigerFightModel:ShowResult()
    self.players = self.Result.playerInfos --前6玩家信息
    ---显示牌面结果
    self.ctrl.view:ResultEffect(self.Result)
end
--玩家列表信息返回 
function DragonTigerFightModel:UpdateAllPlayers(msg)
    if msg.code == 200 and msg.tablePlayerInfo then
        require("Logic/Common/PlayerRankPanel/MVCHead")
        CtrlManager.SingleShow(CtrlNames.PlayerRankPanel,msg.tablePlayerInfo)
    end
end

function DragonTigerFightModel:ResetConfig()
    for i=1,#config.selfDiZhuNums do
        config.selfDiZhuNums[i]=0
        config.totalDiZhuNums[i]=0
    end
    self.sideBetInfos={}
    self.Result = {}
    self.AreaChipTotals = {0,0,0}
    self.bettingDataMap = {}
end

--endregion
function DragonTigerFightModel:FindBetIndex(value)
    for i=1,#self.betPointList do
        if self.betPointList[i]==value then
            return i
        end
    end
    return nil
end


--  START_GAME = 0;  //游戏开始
--  BET = 1;  //下注
--  PLAY_CART = 2;  //出牌
--  DISS_MISS = 3;  //解散房间
--  WAIT_READY = 4;  //等待开始
--  GAME_ROUND_OVER_SETTLEMENT = 5;  //游戏一个回合结束进行结算
function DragonTigerFightModel:TransEGamePhase(value)
    --[准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
    if value == "WAIT_READY" or "START_GAME" == 0  then return 1 end
    if value == "BET" then return 2 end
    if value == "PLAY_CART" then return 3 end
    if value == "GAME_ROUND_OVER_SETTLEMENT" then return 4 end
    return 5
end

return DragonTigerFightModel