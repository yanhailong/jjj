---
---Create by Administrator
---DateTime: 2025-07-22 10:18:39
---
---@class DicePointsSumSizeGameModel:BaseModel
local DicePointsSumSizeGameModel=Class("DicePointsSumSizeGameModel",BaseModel)

local DicePointsSumSizeConfig = require("SingleGames/DicePointsSumSize/DicePointsSumSizeConfig")

function DicePointsSumSizeGameModel:Awake()
	self.super.Awake(self);
	---@type DicePointsSumSizeGameCtrl
	self.ctrl=self.ctrl
end

function DicePointsSumSizeGameModel:Close()
    self.super.Close(self);
end

function DicePointsSumSizeGameModel:AddEvent()
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_STATUS,self.OnGameStatusMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_INFO,self.OnGameInfoMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.RES_BET_RESULT,self.OnBetRusultMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.SYNC_TOTAL_BETS,self.OnSyncTotalBetMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.GAME_SETTLEMENT,self.OnGameSettlementMsg,self)
	GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.NOTIFY_PLAYER_BET,self.OnPlayerBetMsg,self)
end

function DicePointsSumSizeGameModel:RemoveEvent()
	GlobalEvent.RemoveAllTo(self)
end

---更新玩家信息
function DicePointsSumSizeGameModel:OnPlayerMsg(message)
	--look("DicePointsSumSize OnPlayerMsg")
	self.players = {}
	for _,v in pairs(message) do
		if v.id == DicePointsSumSizeConfig.selfTestPlayerId then
			self.ctrl.goldRealNum = v.coin
			self.view.selfPlayer:UpdatePlayer(v)
		else
			table.insert(self.players, v)
		end
	end

	self.ctrl.view:UpdatePlayers(self.players)
	self.view.tmp_AllOtherNumber.text = #self.players + 1
end

--更新游戏信息
function DicePointsSumSizeGameModel:OnGameInfoMsg(message)
	self:OnGameStatusMsg(message)
end

---更新游戏状态
function DicePointsSumSizeGameModel:OnGameStatusMsg(message)
	--look("DicePointsSumSizeGameModel:UpdateGameStatus" .. message.status)
	if message.status == DicePointsSumSizeConfig.GameState.Prepare then
		self.ctrl:SwitchToPrepareState(message)
	elseif message.status == DicePointsSumSizeConfig.GameState.Bet then
		self.ctrl:SwitchToBetState(message)
	elseif message.status == DicePointsSumSizeConfig.GameState.Settlement then
		self.ctrl:SwitchToSettlementState(message)
	end
end

---下注结果消息
function DicePointsSumSizeGameModel:OnBetRusultMsg(message)
	self.ctrl:OnBetRusultMsg(message)
end

---其他人下注消息
function DicePointsSumSizeGameModel:OnPlayerBetMsg(message)
	self.ctrl:OnPlayerBetMsg(message)
end

---游戏结算数据
function DicePointsSumSizeGameModel:OnGameSettlementMsg(message)
	self.ctrl:OnGameSettlementMsg(message)
end

---同步各个区域总下注情况
function DicePointsSumSizeGameModel:OnSyncTotalBetMsg(message)
	if message ~= nil and #message == #self.ctrl.totalBets then
		for i = 1, #message do
			self.ctrl.totalBets[i] = message[i]
		end

		self.view:UpdateTotalBetAreaInfo(-1)
	end
end

--region 事件方法

--endregion


return DicePointsSumSizeGameModel