---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightModel:BaseModel
local DragonTigerFightModel=Class("DragonTigerFightModel",BaseModel)

function DragonTigerFightModel:Awake()
	self.super.Awake(self);
	---@type DragonTigerFightCtrl
	self.ctrl=self.ctrl
end

function DragonTigerFightModel:Close()
    self.super.Close(self);
end
---网络监听
function DragonTigerFightModel:AddEvent()

end

function DragonTigerFightModel:RemoveEvent()

end

--region 事件方法

--endregion


return DragonTigerFightModel