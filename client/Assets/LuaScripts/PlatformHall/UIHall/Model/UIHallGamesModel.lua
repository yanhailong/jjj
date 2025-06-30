---
---Create by Administrator
---DateTime: 2025-06-26 11:27:13
---
---@class UIHallGamesModel:BaseModel
local UIHallGamesModel=Class("UIHallGamesModel",BaseModel)

function UIHallGamesModel:Awake()
	self.super.Awake(self);
	---@type UIHallGamesCtrl
	self.ctrl=self.ctrl
end

function UIHallGamesModel:Close()
    self.super.Close(self);
end

function UIHallGamesModel:AddEvent()
	WebNetEvent.AddListener(pb_PlatformHall.ResChooseGame,self.ResChooseGame,self)
end

function UIHallGamesModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
	GlobalEvent.RemoveAllTo(self)
end

function UIHallGamesModel:ResChooseGame(msg)

end

--region 事件方法

--endregion


return UIHallGamesModel