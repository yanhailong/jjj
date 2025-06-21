---
---Create by Administrator
---DateTime: 2025-06-21 16:49:45
---
---@class UITestScrollModel:BaseModel
local UITestScrollModel=Class("UITestScrollModel",BaseModel)

function UITestScrollModel:Awake()
	self.super.Awake(self);
	---@type UITestScrollCtrl
	self.ctrl=self.ctrl
end

function UITestScrollModel:Close()
    self.super.Close(self);
end

function UITestScrollModel:AddEvent()

end

function UITestScrollModel:RemoveEvent()

end

--region 事件方法

--endregion


return UITestScrollModel