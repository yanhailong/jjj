---
---Create by Administrator
---DateTime: 2025-05-07 16:45:54
---
---@class UIDeckModel:BaseModel
local UIDeckModel=Class("UIDeckModel",BaseModel)

function UIDeckModel:Awake()
	self.super.Awake(self);
	---@type UIDeckCtrl
	self.ctrl=self.ctrl
end

function UIDeckModel:Close()
    self.super.Close(self);
end

function UIDeckModel:AddEvent()

end

function UIDeckModel:RemoveEvent()

end

function UIDeckModel:InitData()
	self.data = {}
	self.data.test = 0
	self.data.test1 = 0
end

function UIDeckModel:GetDataBles()
	
end


return UIDeckModel