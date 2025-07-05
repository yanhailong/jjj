---
---Create by Administrator
---DateTime: 2025-07-04 13:37:43
---
---@class USDollarExpressGameSelectModel:BaseModel
local USDollarExpressGameSelectModel=Class("USDollarExpressGameSelectModel",BaseModel)

function USDollarExpressGameSelectModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressGameSelectCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressGameSelectModel:Close()
    self.super.Close(self);
end

function USDollarExpressGameSelectModel:AddEvent()

end

function USDollarExpressGameSelectModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressGameSelectModel