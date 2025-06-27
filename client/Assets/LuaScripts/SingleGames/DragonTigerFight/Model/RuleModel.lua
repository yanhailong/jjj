---
---Create by Administrator
---DateTime: 2025-06-27 09:43:04
---
---@class RuleModel:BaseModel
local RuleModel=Class("RuleModel",BaseModel)

function RuleModel:Awake()
	self.super.Awake(self);
	---@type RuleCtrl
	self.ctrl=self.ctrl
end

function RuleModel:Close()
    self.super.Close(self);
end

function RuleModel:AddEvent()

end

function RuleModel:RemoveEvent()

end

--region 事件方法

--endregion


return RuleModel