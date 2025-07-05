---
---Create by Administrator
---DateTime: 2025-07-01 13:53:15
---
---@class UICommonSlotBtnsModel:BaseModel
local UICommonSlotBtnsModel=Class("UICommonSlotBtnsModel",BaseModel)

function UICommonSlotBtnsModel:Awake()
	self.super.Awake(self);
	---@type UICommonSlotBtnsCtrl
	self.ctrl=self.ctrl
end

function UICommonSlotBtnsModel:Close()
    self.super.Close(self);
end

function UICommonSlotBtnsModel:AddEvent()

end

function UICommonSlotBtnsModel:RemoveEvent()

end

--region 事件方法

--endregion


return UICommonSlotBtnsModel