
---@class MahjongWaysMainModel:BaseModel
local MahjongWaysMainModel=Class("MahjongWaysMainModel",BaseModel)

function MahjongWaysMainModel:Awake()
	self.super.Awake(self);
	---@type MahjongWaysMainCtrl
	self.ctrl=self.ctrl
end

function MahjongWaysMainModel:Close()
    self.super.Close(self);
end

function MahjongWaysMainModel:AddEvent()

end

function MahjongWaysMainModel:RemoveEvent()

end

--region 事件方法

--endregion


return MahjongWaysMainModel