---
---Create by Administrator
---DateTime: 2025-06-06 18:16:33
---
---@class GameTemp2Model:BaseModel
local GameTemp2Model=Class("GameTemp2Model",BaseModel)

function GameTemp2Model:Awake()
	self.super.Awake(self);
	---@type GameTemp2Ctrl
	self.ctrl=self.ctrl
end

function GameTemp2Model:Close()
    self.super.Close(self);
end

function GameTemp2Model:AddEvent()
	self:InitCardData()
end

function GameTemp2Model:InitCardData()
	self.CardPos={}
	for i=1,5 do
		self.CardPos[i]={}
		for j=1,4 do
			self.CardPos[i][j]=1
		end
	end
end

function GameTemp2Model:RemoveEvent()

end

--region 事件方法

--endregion


return GameTemp2Model