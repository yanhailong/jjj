---
---Create by Administrator
---DateTime: 2025-05-29 13:46:04
---
---@class Game002MainModel:BaseModel
local Game002MainModel=Class("Game002MainModel",BaseModel)

function Game002MainModel:Awake()
	self.super.Awake(self);
	---@type Game002MainCtrl
	self.ctrl=self.ctrl
end

function Game002MainModel:Close()
    self.super.Close(self);
end

function Game002MainModel:AddEvent()

end

function Game002MainModel:RemoveEvent()

end

--region 事件方法

--endregion


return Game002MainModel