---
---Create by Administrator
---DateTime: 2025-07-23 15:35:06
---
---@class USDollarExpressMapMainModel:BaseModel
local USDollarExpressMapMainModel=Class("USDollarExpressMapMainModel",BaseModel)

function USDollarExpressMapMainModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressMapMainCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressMapMainModel:Close()
    self.super.Close(self);
end

function USDollarExpressMapMainModel:AddEvent()

end

function USDollarExpressMapMainModel:RemoveEvent()

end

return USDollarExpressMapMainModel