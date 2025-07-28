---
---Create by Administrator
---DateTime: 2025-07-28 09:55:32
---
---@class DragonTigerSelectModel:BaseModel
local DragonTigerSelectModel=Class("DragonTigerSelectModel",BaseModel)

function DragonTigerSelectModel:Awake()
	self.super.Awake(self);
	---@type DragonTigerSelectCtrl
	self.ctrl=self.ctrl
end

function DragonTigerSelectModel:Close()
    self.super.Close(self);
end

function DragonTigerSelectModel:AddEvent()

end

function DragonTigerSelectModel:RemoveEvent()

end

--region 事件方法

--endregion


return DragonTigerSelectModel