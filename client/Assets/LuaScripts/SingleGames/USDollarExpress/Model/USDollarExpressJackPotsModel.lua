---
---Create by Administrator
---DateTime: 2025-07-19 11:25:15
---
---@class USDollarExpressJackPotsModel:BaseModel
local USDollarExpressJackPotsModel=Class("USDollarExpressJackPotsModel",BaseModel)

function USDollarExpressJackPotsModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressJackPotsCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressJackPotsModel:Close()
    self.super.Close(self);
end

function USDollarExpressJackPotsModel:AddEvent()

end

function USDollarExpressJackPotsModel:RemoveEvent()

end

--region 事件方法

--endregion


return USDollarExpressJackPotsModel