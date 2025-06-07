---
---Create by Administrator
---DateTime: 2025-06-06 18:16:33
---
---@class GameTemp1Model:BaseModel
local GameTemp1Model=Class("GameTemp1Model",BaseModel)

function GameTemp1Model:Awake()
	self.super.Awake(self);
	---@type GameTemp1Ctrl
	self.ctrl=self.ctrl
end

function GameTemp1Model:Close()
    self.super.Close(self);
end

function GameTemp1Model:AddEvent()
	self:InitCardData()
end

function GameTemp1Model:InitCardData()
	self.CardPos={}
	for i=1,5 do
		self.CardPos[i]={}
		for j=1,3 do
			self.CardPos[i][j]=1
		end
	end
end

function GameTemp1Model:RemoveEvent()

end

--region 事件方法

--endregion


return GameTemp1Model