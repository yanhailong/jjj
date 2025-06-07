---
---Create by Administrator
---DateTime: 2025-06-06 17:07:38
---
---@class GameTempModel:BaseModel
local GameTempModel=Class("GameTempModel",BaseModel)

function GameTempModel:Awake()
	self.super.Awake(self);
	---@type GameTempCtrl
	self.ctrl=self.ctrl
end

function GameTempModel:Close()
    self.super.Close(self);
end

function GameTempModel:AddEvent()
	self:InitCardData()
end

function GameTempModel:RemoveEvent()

end

function GameTempModel:InitCardData()
	self.CardPos={}
	for i=1,5 do
		self.CardPos[i]={}
		for j=1,3 do
			self.CardPos[i][j]=Tools.RandomInt(1,10)
		end
	end
end


--region 事件方法

--endregion


return GameTempModel