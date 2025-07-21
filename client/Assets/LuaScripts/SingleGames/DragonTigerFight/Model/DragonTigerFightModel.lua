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
    self.players = {}
    self.sideBetInfos={}
    self.history = {}
    self.Result = {}
    self.AreaChipTotals = {0,0,0}
end

function DragonTigerFightModel:Close()
    self.super.Close(self);
end
---流程
---获取房间信息和状态 历史数据 获取排名
---注册推送的状态信息 根据状态显示界面和倒计时
---注册玩家进入和离开的更新
---个人未下注提示和退出管理
function DragonTigerFightModel:AddEvent()
    WebNetEvent.AddListener(pb_DragonTigerFight.ResEnterRoom, self.OnEnterRoom, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.ResBetting, self.OnBetting, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.ResGameStatus, self.OnGameStatus, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.ResPlayerEnterRoom, self.OnPlayerEnterRoom, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.ResPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
    WebNetEvent.AddListener(pb_DragonTigerFight.ResGameResult, self.OnGameResult, self)
end

function DragonTigerFightModel:RemoveEvent()
    WebNetEvent.Remove(pb_DragonTigerFight.ResEnterRoom, self.OnEnterRoom, self)
    WebNetEvent.Remove(pb_DragonTigerFight.ResBetting, self.OnBetting, self)
    WebNetEvent.Remove(pb_DragonTigerFight.ResGameStatus, self.OnGameStatus, self)
    WebNetEvent.Remove(pb_DragonTigerFight.ResPlayerEnterRoom, self.OnPlayerEnterRoom, self)
    WebNetEvent.Remove(pb_DragonTigerFight.ResPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
    WebNetEvent.Remove(pb_DragonTigerFight.ResGameResult, self.OnGameResult, self)
end

--region 事件方法
-- 进入房间返回
function DragonTigerFightModel:OnEnterRoom(msg)
    self.roomId = msg.roomId
    self.config = msg.config
    self.sideBetInfos = msg.sideBetInfos
    self.players = msg.players
    self.history = msg.history
    self.status = msg.status
    self.seconds = msg.seconds
    if self.ctrl and self.ctrl.view and self.ctrl.view.UpdateRoomInfo then
        self.ctrl.view:UpdateRoomInfo(self)
    end
end

-- 广播玩家押注信息
function DragonTigerFightModel:OnBetting(msg)
    -- msg.betList: {BetInfo}
    if self.ctrl and self.ctrl.view and self.ctrl.view.PayOtherXiaZhuCoinFly then
        for _, bet in ipairs(msg.betList or {}) do
            self.ctrl.view:PayOtherXiaZhuCoinFly(bet)
        end
    end
end

-- 广播切换状态
function DragonTigerFightModel:OnGameStatus(msg)
    self.status = msg.status
    self.seconds = msg.seconds
    if self.ctrl and self.ctrl.view and self.ctrl.view.OnGameStatus then
        self.ctrl.view:OnGameStatus(msg.status, msg.seconds)
    end
end

-- 广播玩家进入房间
function DragonTigerFightModel:OnPlayerEnterRoom(msg)
    if msg.player then
        for _, p in ipairs(msg.player) do
            table.insert(self.players, p)
        end
        if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
            self.ctrl.view:UpdatePlayers(self.players)
        end
    end
end

-- 广播玩家离开房间
function DragonTigerFightModel:OnPlayerLeaveRoom(msg)
    if msg.userId then
        for i, p in ipairs(self.players) do
            if p.id == msg.userId then
                table.remove(self.players, i)
                break
            end
        end
        if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
            self.ctrl.view:UpdatePlayers(self.players)
        end
    end
end

-- 广播结算信息
function DragonTigerFightModel:OnGameResult(msg)
    self.Result = msg;
    if #self.history>=64 then
        self.history = {}
    end
    table.insert(self.history,msg.winSide)
    
    if self.ctrl and self.ctrl.view and self.ctrl.view.ResultEffect then
        ---显示牌面结果
        self.ctrl.view:ResultEffect(msg.cards)
        ---金币回收动画
        self.ctrl.view:PlayCompeleCoinFLy(msg.players)
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

return DragonTigerFightModel