---Create by Administrator
---
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameModel:BaseModel
local FishPrawnCrabGameModel=Class("FishPrawnCrabGameModel",BaseModel)
local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")

function FishPrawnCrabGameModel:Awake()
	self.super.Awake(self);
	---@type FishPrawnCrabGameCtrl
	self.ctrl=self.ctrl
end

function FishPrawnCrabGameModel:Close()
    self.super.Close(self);
end

function FishPrawnCrabGameModel:AddEvent()
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS,self.OnGameStatusMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_INFO,self.OnGameInfoMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.RES_BET_RESULT,self.OnBetRusultMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.SYNC_TOTAL_BETS,self.OnSyncTotalBetMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.GAME_SETTLEMENT,self.OnGameSettlementMsg,self)
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.NOTIFY_PLAYER_BET,self.OnPlayerBetMsg,self)
end

function FishPrawnCrabGameModel:RemoveEvent()
	GlobalEvent.RemoveAllTo(self)
end

---更新玩家信息
function FishPrawnCrabGameModel:OnPlayerMsg(message)
	--look("FishPrawnCrab OnPlayerMsg")
	self.players = {}
	for _,v in pairs(message) do
		if v.id == FishPrawnCrabConfig.selfTestPlayerId then
			self.ctrl.goldRealNum = v.coin
			self.view.selfPlayer:UpdatePlayer(v)
		else
			table.insert(self.players, v)
		end
	end
	
	self.ctrl.view:UpdatePlayers(self.players)
	self.view.tmp_total_player_num.text = #self.players + 1
end

--更新游戏信息
function FishPrawnCrabGameModel:OnGameInfoMsg(message)
	self:OnGameStatusMsg(message)
end

---更新游戏状态
function FishPrawnCrabGameModel:OnGameStatusMsg(message)
	--look("FishPrawnCrabGameModel:UpdateGameStatus" .. message.status)
	if message.status == FishPrawnCrabConfig.GameState.Prepare then
		self.ctrl:SwitchToPrepareState(message)
	elseif message.status == FishPrawnCrabConfig.GameState.Bet then
		self.ctrl:SwitchToBetState(message)
	elseif message.status == FishPrawnCrabConfig.GameState.Settlement then
		self.ctrl:SwitchToSettlementState(message)
	end
end

---下注结果消息
function FishPrawnCrabGameModel:OnBetRusultMsg(message)
	self.ctrl:OnBetRusultMsg(message)
end

---其他人下注消息
function FishPrawnCrabGameModel:OnPlayerBetMsg(message)
	self.ctrl:OnPlayerBetMsg(message)
end

---游戏结算数据
function FishPrawnCrabGameModel:OnGameSettlementMsg(message)
	self.ctrl:OnGameSettlementMsg(message)
end

---同步各个区域总下注情况
function FishPrawnCrabGameModel:OnSyncTotalBetMsg(message)
	if message ~= nil and #message == #self.ctrl.totalBets then
		for i = 1, #message do
			self.ctrl.totalBets[i] = message[i]
		end
		
		self.view:UpdateBetAreaInfo()
	end
end

--region 事件方法

--endregion


return FishPrawnCrabGameModel