---
---Create by Administrator
---DateTime: 2025-07-10 15:47:41
---
---@class VietnamChessPlayersModel:BaseModel
local VietnamChessPlayersModel=Class("VietnamChessPlayersModel",BaseModel)

function VietnamChessPlayersModel:Awake()
	self.super.Awake(self);
	---@type VietnamChessPlayersCtrl
	self.ctrl=self.ctrl
end

function VietnamChessPlayersModel:Close()
    self.super.Close(self);
end

function VietnamChessPlayersModel:AddEvent()

end

function VietnamChessPlayersModel:RemoveEvent()

end

--region 事件方法

--endregion


return VietnamChessPlayersModel