---
---Create by Administrator
---DateTime: 2025-07-09 15:01:09
---
---@class BaccaratRuleModel:BaseModel
local BaccaratRuleModel=Class("BaccaratRuleModel",BaseModel)

function BaccaratRuleModel:Awake()
	self.super.Awake(self);
	---@type BaccaratRuleCtrl
	self.ctrl=self.ctrl
end

function BaccaratRuleModel:Close()
    self.super.Close(self);
end

function BaccaratRuleModel:AddEvent()

end

function BaccaratRuleModel:RemoveEvent()

end

--region 事件方法

--endregion


return BaccaratRuleModel