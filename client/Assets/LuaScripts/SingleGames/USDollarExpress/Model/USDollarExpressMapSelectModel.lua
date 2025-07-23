---
---Create by Administrator
---DateTime: 2025-07-23 16:48:20
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
	WebNetEvent.AddListener(pb_USDollarExpress.ResInvestArea,self.ResInvestArea,self)
end

function USDollarExpressMapSelectModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

function USDollarExpressMapSelectModel:ReqInvestArea(areaId)
	local data={}
	data.areaId=areaId
	WebNetworkManager.SendMsg(pb_USDollarExpress.ReqInvestArea,data)
end

function USDollarExpressMapSelectModel:ResInvestArea(msg)
	self.ctrl:ResInvestArea(msg)
end


return USDollarExpressMapSelectModel