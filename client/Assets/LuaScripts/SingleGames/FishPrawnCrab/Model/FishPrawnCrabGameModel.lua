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
end

function FishPrawnCrabGameModel:RemoveEvent()
	GlobalEvent.RemoveAllTo(self)
end

---更新玩家信息
function FishPrawnCrabGameModel:OnPlayerMsg()
	look("FishPrawnCrab OnPlayerMsg")
	self.players = {}
	for i=1,50 do
		self.players[i] = {id=i,name="role"..i,coin=Tools.RandomInt(1,100000000)}
	end
	self.ctrl.view:UpdatePlayers(self.players)
end

---更新游戏状态
function FishPrawnCrabGameModel:OnGameStatusMsg(message)
	look("FishPrawnCrabGameModel:UpdateGameStatus" .. message.status)
	if message.status == FishPrawnCrabConfig.GameState.Prepare then
		self.ctrl:SwitchToPrepareState(message)
	elseif message.status == FishPrawnCrabConfig.GameState.Bet then
		self.ctrl:SwitchToBetState(message)
	elseif message.status == FishPrawnCrabConfig.GameState.Settlement then
		self.ctrl:SwitchToSettlementState(message)
	end
end

--region 事件方法

--endregion


return FishPrawnCrabGameModel