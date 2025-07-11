---
---Create by Administrator
---DateTime: 2025-07-10 15:47:34
---
---@class VietnamChessRuleModel:BaseModel
local VietnamChessRuleModel=Class("VietnamChessRuleModel",BaseModel)

function VietnamChessRuleModel:Awake()
	self.super.Awake(self);
	---@type VietnamChessRuleCtrl
	self.ctrl=self.ctrl
end

function VietnamChessRuleModel:Close()
    self.super.Close(self);
end

function VietnamChessRuleModel:AddEvent()

end

function VietnamChessRuleModel:RemoveEvent()

end

--region 事件方法

--endregion


return VietnamChessRuleModel