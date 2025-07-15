---Create by Administrator
---
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameModel:BaseModel
local FishPrawnCrabGameModel=Class("FishPrawnCrabGameModel",BaseModel)

local GameEventName = {
	UPDATE_PLAYER = "UPDATE_PLAYER",
}

function FishPrawnCrabGameModel:Awake()
	self.super.Awake(self);
	---@type FishPrawnCrabGameCtrl
	self.ctrl=self.ctrl
end

function FishPrawnCrabGameModel:Close()
    self.super.Close(self);
end

function FishPrawnCrabGameModel:AddEvent()
	GlobalEvent.AddListener(GameEventName.UPDATE_PLAYER,self.OnPlayerMsg,self)
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

--region 事件方法

--endregion


return FishPrawnCrabGameModel