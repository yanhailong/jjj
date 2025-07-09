---
---Create by Administrator
---DateTime: 2025-07-08 17:28:05
---
---@class BaccaratMainModel:BaseModel
local BaccaratMainModel=Class("BaccaratMainModel",BaseModel)

function BaccaratMainModel:Awake()
	self.super.Awake(self);
	---@type BaccaratMainCtrl
	self.ctrl=self.ctrl
end

function BaccaratMainModel:Close()
    self.super.Close(self);
end

function BaccaratMainModel:AddEvent()

end

function BaccaratMainModel:RemoveEvent()

end

--region 事件方法

--endregion


return BaccaratMainModel