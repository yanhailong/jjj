---
---Create by Administrator
---DateTime: 2025-07-02 15:39:02
---
---@class USDollarExpressMapSelectModel:BaseModel
local USDollarExpressMapSelectModel=Class("USDollarExpressMapSelectModel",BaseModel)

function USDollarExpressMapSelectModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressMapSelectCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressMapSelectModel:Close()
    self.super.Close(self);
end

function USDollarExpressMapSelectModel:AddEvent()

end

function USDollarExpressMapSelectModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressMapSelectModel