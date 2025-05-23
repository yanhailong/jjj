---
---Create by Administrator
---DateTime: 2025-05-08 14:49:10
---
---@class UILoginModel:BaseModel
local UILoginModel=Class("UILoginModel",BaseModel)

function UILoginModel:Awake()
	self.super.Awake(self);
	---@type UILoginCtrl
	self.ctrl=self.ctrl
end

function UILoginModel:Close()
    self.super.Close(self);
end

function UILoginModel:AddEvent()

end

function UILoginModel:RemoveEvent()

end

--region 事件方法

--endregion


return UILoginModel