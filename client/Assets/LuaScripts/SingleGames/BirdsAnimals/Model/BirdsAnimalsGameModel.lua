---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameModel:BaseModel
local BirdsAnimalsGameModel=Class("BirdsAnimalsGameModel",BaseModel)
local config =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

function BirdsAnimalsGameModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsGameCtrl
	self.ctrl=self.ctrl
	
	self.players = {}
	self.sideBetInfos={}
	self.history = {}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

function BirdsAnimalsGameModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsGameModel:AddEvent()
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsEnterRoom, self.OnEnterRoom, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsBetting, self.OnBetting, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsGameStatus, self.OnGameStatus, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsPlayerEnterRoom, self.OnPlayerEnterRoom, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.ResBirdsAnimalsGameResult, self.OnGameResult, self)
end

function BirdsAnimalsGameModel:RemoveEvent()
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsEnterRoom, self.OnEnterRoom, self)
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsBetting, self.OnBetting, self)
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsGameStatus, self.OnGameStatus, self)
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsPlayerEnterRoom, self.OnPlayerEnterRoom, self)
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
	WebNetEvent.Remove(pb_BirdsAnimals.ResBirdsAnimalsGameResult, self.OnGameResult, self)
end

--region 事件方法
-- 进入房间返回
function BirdsAnimalsGameModel:OnEnterRoom(msg)
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
function BirdsAnimalsGameModel:OnBetting(msg)
	-- msg.betList: {BetInfo}
	if self.ctrl and self.ctrl.view and self.ctrl.view.PayOtherXiaZhuCoinFly then
		for _, bet in ipairs(msg.betList or {}) do
			self.ctrl.view:PayOtherXiaZhuCoinFly(bet)
		end
	end
end

-- 广播切换状态
function BirdsAnimalsGameModel:OnGameStatus(msg)
	self.status = msg.status
	self.seconds = msg.seconds
	if self.ctrl and self.ctrl.view and self.ctrl.view.OnGameStatus then
		self.ctrl.view:OnGameStatus(msg.status, msg.seconds)
	end
end

-- 广播玩家进入房间
function BirdsAnimalsGameModel:OnPlayerEnterRoom(msg)
	if msg.player then
		for _, p in ipairs(msg.player) do
			table.insert(self.players, p)
		end
		if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
			self.ctrl.view:UpdatePlayerTotal(#self.players)
		end
	end
end

-- 广播玩家离开房间
function BirdsAnimalsGameModel:OnPlayerLeaveRoom(msg)
	if msg.userId then
		for i, p in ipairs(self.players) do
			if p.id == msg.userId then
				table.remove(self.players, i)
				break
			end
		end
		if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
			self.ctrl.view:UpdatePlayerTotal(#self.players)
		end
	end
end

-- 广播结算信息
function BirdsAnimalsGameModel:OnGameResult(msg)
	self.Result = msg;
	if #self.history>=64 then
		self.history = {}
	end
	table.insert(self.history,msg.winSide)
	if self.ctrl and self.ctrl.view and self.ctrl.view.ResultEffect then
		---显示结果
		self.ctrl.view:ResultEffect(msg)
	end
end

function BirdsAnimalsGameModel:ResetConfig()
	for i=1,#config.selfDiZhuNums do
		config.selfDiZhuNums[i]=0
		config.totalDiZhuNums[i]=0
	end
	self.sideBetInfos={}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

--endregion


return BirdsAnimalsGameModel