---
---Create by Administrator
---DateTime: 2025-06-18 13:55:05
---
---@class USDollarExpressLoadingModel:BaseModel
local USDollarExpressLoadingModel=Class("USDollarExpressLoadingModel",BaseModel)

function USDollarExpressLoadingModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressLoadingCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressLoadingModel:Close()
    self.super.Close(self);
end

function USDollarExpressLoadingModel:AddEvent()

end

function USDollarExpressLoadingModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressLoadingModel