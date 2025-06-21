---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarModel:BaseModel
local USDollarExpressCarModel=Class("USDollarExpressCarModel",BaseModel)

function USDollarExpressCarModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressCarCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressCarModel:Close()
    self.super.Close(self);
end

function USDollarExpressCarModel:AddEvent()

end

function USDollarExpressCarModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressCarModel