---
---Create by Administrator
---DateTime: 2025-06-30 15:05:25
---
---@class CarLogoRuleModel:BaseModel
local CarLogoRuleModel=Class("CarLogoRuleModel",BaseModel)

function CarLogoRuleModel:Awake()
	self.super.Awake(self);
	---@type CarLogoRuleCtrl
	self.ctrl=self.ctrl
end

function CarLogoRuleModel:Close()
    self.super.Close(self);
end

function CarLogoRuleModel:AddEvent()

end

function CarLogoRuleModel:RemoveEvent()

end

--region 事件方法

--endregion


return CarLogoRuleModel