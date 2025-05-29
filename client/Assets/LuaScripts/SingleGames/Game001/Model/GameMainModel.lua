---
---Create by Administrator
---DateTime: 2025-05-29 13:45:59
---
---@class GameMainModel:BaseModel
local GameMainModel=Class("GameMainModel",BaseModel)

function GameMainModel:Awake()
	self.super.Awake(self);
	---@type GameMainCtrl
	self.ctrl=self.ctrl
end

function GameMainModel:Close()
    self.super.Close(self);
end

function GameMainModel:AddEvent()

end

function GameMainModel:RemoveEvent()

end

--region 事件方法

--endregion


return GameMainModel