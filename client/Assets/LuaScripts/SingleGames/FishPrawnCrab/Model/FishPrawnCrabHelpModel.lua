---
---Create by Administrator
---DateTime: 2025-07-18 15:45:49
---
---@class FishPrawnCrabHelpModel:BaseModel
local FishPrawnCrabHelpModel=Class("FishPrawnCrabHelpModel",BaseModel)

function FishPrawnCrabHelpModel:Awake()
	self.super.Awake(self);
	---@type FishPrawnCrabHelpCtrl
	self.ctrl=self.ctrl
end

function FishPrawnCrabHelpModel:Close()
    self.super.Close(self);
end

function FishPrawnCrabHelpModel:AddEvent()

end

function FishPrawnCrabHelpModel:RemoveEvent()

end

--region 事件方法

--endregion


return FishPrawnCrabHelpModel