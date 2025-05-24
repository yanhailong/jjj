---
---Create by Administrator
---DateTime: 2025-05-24 09:23:06
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