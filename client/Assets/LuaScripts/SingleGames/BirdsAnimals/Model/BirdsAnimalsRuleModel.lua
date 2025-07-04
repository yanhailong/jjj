---
---Create by Administrator
---DateTime: 2025-07-03 10:40:03
---
---@class BirdsAnimalsRuleModel:BaseModel
local BirdsAnimalsRuleModel=Class("BirdsAnimalsRuleModel",BaseModel)

function BirdsAnimalsRuleModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsRuleCtrl
	self.ctrl=self.ctrl
end

function BirdsAnimalsRuleModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsRuleModel:AddEvent()

end

function BirdsAnimalsRuleModel:RemoveEvent()

end

--region 事件方法

--endregion


return BirdsAnimalsRuleModel