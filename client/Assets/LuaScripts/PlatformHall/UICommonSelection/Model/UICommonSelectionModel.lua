---
---Create by Administrator
---DateTime: 2025-06-30 16:37:31
---
---@class UICommonSelectionModel:BaseModel
local UICommonSelectionModel=Class("UICommonSelectionModel",BaseModel)

function UICommonSelectionModel:Awake()
	self.super.Awake(self);
	---@type UICommonSelectionCtrl
	self.ctrl=self.ctrl
end

function UICommonSelectionModel:Close()
    self.super.Close(self);
end

function UICommonSelectionModel:AddEvent()

end

function UICommonSelectionModel:RemoveEvent()

end

--region 事件方法

--endregion


return UICommonSelectionModel