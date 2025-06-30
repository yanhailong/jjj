---
---Create by Administrator
---DateTime: 2025-06-26 11:45:34
---
---@class UIHallModel:BaseModel
local UIHallModel=Class("UIHallModel",BaseModel)

function UIHallModel:Awake()
	self.super.Awake(self);
	---@type UIHallCtrl
	self.ctrl=self.ctrl
end

function UIHallModel:Close()
    self.super.Close(self);
end

function UIHallModel:AddEvent()

end

function UIHallModel:RemoveEvent()

end

--region 事件方法

--endregion


return UIHallModel