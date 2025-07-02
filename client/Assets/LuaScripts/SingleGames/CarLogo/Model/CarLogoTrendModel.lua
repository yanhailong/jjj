---
---Create by Administrator
---DateTime: 2025-06-30 15:05:35
---
---@class CarLogoTrendModel:BaseModel
local CarLogoTrendModel=Class("CarLogoTrendModel",BaseModel)

function CarLogoTrendModel:Awake()
	self.super.Awake(self);
	---@type CarLogoTrendCtrl
	self.ctrl=self.ctrl
end

function CarLogoTrendModel:Close()
    self.super.Close(self);
end

function CarLogoTrendModel:AddEvent()

end

function CarLogoTrendModel:RemoveEvent()

end

--region 事件方法

--endregion


return CarLogoTrendModel