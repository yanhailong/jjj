---
---Create by Administrator
---DateTime: 2025-07-03 13:19:02
---
---@class BirdsAnimalsTrendModel:BaseModel
local BirdsAnimalsTrendModel=Class("BirdsAnimalsTrendModel",BaseModel)

function BirdsAnimalsTrendModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsTrendCtrl
	self.ctrl=self.ctrl
end

function BirdsAnimalsTrendModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsTrendModel:AddEvent()

end

function BirdsAnimalsTrendModel:RemoveEvent()

end

--region 事件方法

--endregion


return BirdsAnimalsTrendModel