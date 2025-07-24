---
---Create by Administrator
---DateTime: 2025-06-26 17:12:30
---
---@class PlayerRankModel:BaseModel
local PlayerRankModel=Class("PlayerRankModel",BaseModel)

function PlayerRankModel:Awake()
	self.super.Awake(self);
	---@type PlayerRankCtrl
	self.ctrl=self.ctrl
end

function PlayerRankModel:Close()
    self.super.Close(self);
end

function PlayerRankModel:AddEvent()
	
end

function PlayerRankModel:RemoveEvent()
	
end

--region 事件方法

--endregion


return PlayerRankModel