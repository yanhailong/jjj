---
---Create by Administrator
---DateTime: 2025-07-22 17:17:10
---
---@class CarLogoSelectModel:BaseModel
local CarLogoSelectModel=Class("CarLogoSelectModel",BaseModel)

function CarLogoSelectModel:Awake()
	self.super.Awake(self);
	---@type CarLogoSelectCtrl
	self.ctrl=self.ctrl
end

function CarLogoSelectModel:Close()
    self.super.Close(self);
end

function CarLogoSelectModel:AddEvent()

end

function CarLogoSelectModel:RemoveEvent()

end

--region 事件方法

--endregion


return CarLogoSelectModel