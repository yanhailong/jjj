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
    
    self.status = 1
    self.endTime = 0
    self.betPointList = {}
    self.players = {}
    self.sideBetInfos={}
    self.history = {}
    self.Result = {}
    self.AreaChipTotals = {0,0,0}
    
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
end

function DragonTigerFightModel:RemoveEvent()
    WebNetEvent.Remove(pb_DragonTigerFight.NotifyLoongTigerWarInfo, self.OnEnterRoom, self)
    WebNetEvent.Remove(pb_DragonTigerFight.NotifyRoomReadyWait, self.OnGameStatus, self)
    WebNetEvent.Remove(pb_DragonTigerFight.NotifyLoongTigerWarSettleInfo, self.OnGameResult, self)
    WebNetEvent.Remove(pb_DragonTigerFight.NotifyPlayerBet, self.OnBetting, self)
    WebNetEvent.Remove(pb_DragonTigerFight.NotifyTableRoomPlayerInfoChange, self.UpdatePlayerInfo, self)
end

--region 事件方法
-- 进入房间请求
function DragonTigerFightModel:ReqEnterRoom()
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqRoomBaseInfo, {})
end
-- 押注
function DragonTigerFightModel:Bet(data)
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqBet, data)
end
--退出房间
function DragonTigerFightModel:ExitRoom()
    WebNetworkManager.SendMsg(pb_DragonTigerFight.ReqExitRoomInGame, {})
end

-- 进入房间返回 NotifyLoongTigerWarInfo
function DragonTigerFightModel:OnEnterRoom(msg)
    self.betPointList = msg.betPointList 
    self.sideBetInfos = msg.tableAreaInfos
    self.history = msg.histories
    self.status = self:TransEGamePhase(msg.gamePhase)
    self.endTime = msg.tableCountDownTime
    self.Result = msg.settleInfos --NotifyLoongTigerWarSettleInfo 结算信息
    if self.ctrl and self.ctrl.view and self.ctrl.view.UpdateRoomInfo then
        self.ctrl.view:UpdateRoomInfo(self)
    end
end

-- 广播玩家押注信息 NotifyPlayerBet 
function DragonTigerFightModel:OnBetting(msg)
    if msg and msg.code == 200 then
        for _, value in ipairs(msg.betTableInfoList or {}) do
            local bet = {
                side = msg.betIdx-config.gameID*100,
                amounts = self:FindBetIndex(msg.betValue),
                currency = msg.playerCurGold,
                playerId = msg.playerId,
                betValue = msg.betValue,
            }
            self.ctrl.view:PayOtherXiaZhuCoinFly(bet)
        end
    end
end

-- 重新开始游戏的消息 NotifyRoomReadyWait
function DragonTigerFightModel:OnGameStatus(msg)
    self.status = 1
    self.endTime = msg.waitEndTime
    if self.ctrl and self.ctrl.view and self.ctrl.view.OnGameStatus then
        self.ctrl.view:OnGameStatus(self.status)
    end
end

-- 房间玩家信息更新
function DragonTigerFightModel:UpdatePlayerInfo(msg)
    if msg.tableChangedPlayerInfos then
        self.players = msg.tableChangedPlayerInfos
        self.ctrl.view:UpdatePlayers(self.players)
    end
end

-- 广播结算信息 NotifyLoongTigerWarSettleInfo
function DragonTigerFightModel:OnGameResult(msg)
    self.Result = msg;
    if #self.history>=50 then
        self.history = {}
    end
    table.insert(self.history,msg.winState)
    
    if self.ctrl and self.ctrl.view and self.ctrl.view.ResultEffect then
        local cards = {msg.loongCard,msg.tigerCard}
        local playerSettleInfos = msg.playerSettleInfos
        for i=1,#playerSettleInfos do
            if playerSettleInfos[i].amount>0 then
                self:RewardPlayer(playerSettleInfos[i].playerId,playerSettleInfos[i].amount)
            end
        end
        ---显示牌面结果
        self.ctrl.view:ResultEffect(cards)
        ---金币回收动画
        self.ctrl.view:PlayCompeleCoinFLy(playerSettleInfos)
        --- 更新获奖玩家金币
        self.ctrl.view:UpdatePlayers(self.players)
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

function DragonTigerFightModel:RewardPlayer(playerId,gold)
    for i=1,#self.players do
        if self.players[i].playerId == playerId then
            self.players[i].goldNum = self.players[i].goldNum + gold
        end 
    end
end

--  START_GAME = 0;  //游戏开始
--  BET = 1;  //下注
--  PLAY_CART = 2;  //出牌
--  DISS_MISS = 3;  //解散房间
--  WAIT_READY = 4;  //等待开始
--  GAME_ROUND_OVER_SETTLEMENT = 5;  //游戏一个回合结束进行结算
function DragonTigerFightModel:TransEGamePhase(value)
    --[准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
    if value == 4 or value == 0  then return 1 end
    if value == 1 then return 2 end
    if value == 2 then return 3 end
    if value == 5 then return 4 end
    return 5
end

return DragonTigerFightModel