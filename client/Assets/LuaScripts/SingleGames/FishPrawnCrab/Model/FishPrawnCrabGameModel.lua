---
---Create by Administrator
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameModel:BaseModel
local FishPrawnCrabGameModel=Class("FishPrawnCrabGameModel",BaseModel)

function FishPrawnCrabGameModel:Awake()
	self.super.Awake(self);
	---@type FishPrawnCrabGameCtrl
	self.ctrl=self.ctrl
end

function FishPrawnCrabGameModel:Close()
    self.super.Close(self);
end

function FishPrawnCrabGameModel:AddEvent()

end

function FishPrawnCrabGameModel:RemoveEvent()

end

--region 事件方法

--endregion


return FishPrawnCrabGameModel