---
---Create by Administrator
---DateTime: 2025-07-01 16:18:52
---
---@class UICommonSlotTopModel:BaseModel
local UICommonSlotTopModel=Class("UICommonSlotTopModel",BaseModel)

function UICommonSlotTopModel:Awake()
	self.super.Awake(self);
	---@type UICommonSlotTopCtrl
	self.ctrl=self.ctrl
end

function UICommonSlotTopModel:Close()
    self.super.Close(self);
end

function UICommonSlotTopModel:AddEvent()

end

function UICommonSlotTopModel:RemoveEvent()

end

--region 事件方法

--endregion


return UICommonSlotTopModel