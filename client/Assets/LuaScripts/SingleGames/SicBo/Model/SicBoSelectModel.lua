---
---Create by Administrator
---DateTime: 2025-07-31 17:40:22
---
---@class SicBoSelectModel:BaseModel
local SicBoSelectModel=Class("SicBoSelectModel",BaseModel)

function SicBoSelectModel:Awake()
	self.super.Awake(self);
	---@type SicBoSelectCtrl
	self.ctrl=self.ctrl
end

function SicBoSelectModel:Close()
    self.super.Close(self);
end

function SicBoSelectModel:AddEvent()

end

function SicBoSelectModel:RemoveEvent()

end

--region 事件方法

--endregion


return SicBoSelectModel