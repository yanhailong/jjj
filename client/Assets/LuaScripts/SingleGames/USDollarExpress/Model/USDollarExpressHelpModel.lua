---
---Create by Administrator
---DateTime: 2025-07-02 13:47:40
---
---@class USDollarExpressHelpModel:BaseModel
local USDollarExpressHelpModel=Class("USDollarExpressHelpModel",BaseModel)

function USDollarExpressHelpModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressHelpCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressHelpModel:Close()
    self.super.Close(self);
end

function USDollarExpressHelpModel:AddEvent()

end

function USDollarExpressHelpModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressHelpModel