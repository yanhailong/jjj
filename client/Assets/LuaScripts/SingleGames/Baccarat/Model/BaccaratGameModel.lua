---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameModel:BaseModel
local BaccaratGameModel=Class("BaccaratGameModel",BaseModel)

function BaccaratGameModel:Awake()
	self.super.Awake(self);
	---@type BaccaratGameCtrl
	self.ctrl=self.ctrl
end

function BaccaratGameModel:Close()
    self.super.Close(self);
end

function BaccaratGameModel:AddEvent()

end

function BaccaratGameModel:RemoveEvent()

end



--region 事件方法

--endregion


return BaccaratGameModel