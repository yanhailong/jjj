---
---Create by Administrator
---DateTime: 2025-07-28 14:41:11
---
---@class CommFightBtnsModel:BaseModel
local CommFightBtnsModel=Class("CommFightBtnsModel",BaseModel)

function CommFightBtnsModel:Awake()
	self.super.Awake(self);
	---@type CommFightBtnsCtrl
	self.ctrl=self.ctrl
end

function CommFightBtnsModel:Close()
    self.super.Close(self);
end

function CommFightBtnsModel:AddEvent()

end

function CommFightBtnsModel:RemoveEvent()

end

--region 事件方法

--endregion


return CommFightBtnsModel