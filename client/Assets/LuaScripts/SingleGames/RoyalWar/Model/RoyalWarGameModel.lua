---
---Create by Administrator
---DateTime: 2025-06-30 16:46:28
---
---@class RoyalWarGameModel:BaseModel
local RoyalWarGameModel=Class("RoyalWarGameModel",BaseModel)

function RoyalWarGameModel:Awake()
	self.super.Awake(self);
	---@type RoyalWarGameCtrl
	self.ctrl=self.ctrl
end

function RoyalWarGameModel:Close()
    self.super.Close(self);
end

function RoyalWarGameModel:AddEvent()

end

function RoyalWarGameModel:RemoveEvent()

end

--region 事件方法

--endregion


return RoyalWarGameModel