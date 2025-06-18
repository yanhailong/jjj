---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainModel:BaseModel
local USDollarExpressMainModel=Class("USDollarExpressMainModel",BaseModel)

function USDollarExpressMainModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressMainCtrl
	self.ctrl=self.ctrl
	self:InitCardData()
end

function USDollarExpressMainModel:Close()
    self.super.Close(self);
end

function USDollarExpressMainModel:AddEvent()

end

function USDollarExpressMainModel:RemoveEvent()

end

--region 事件方法
function USDollarExpressMainModel:InitCardData()
	self.CardPos={}
	for i=1,5 do
		self.CardPos[i]={}
		for j=1,4 do
			self.CardPos[i][j]=1
		end
	end
end
--endregion


return USDollarExpressMainModel