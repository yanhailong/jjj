---
---Create by Administrator
---DateTime: 2025-06-26 11:45:34
---
---@class UIHallModel:BaseModel
local UIHallModel=Class("UIHallModel",BaseModel)

function UIHallModel:Awake()
	self.super.Awake(self);
	---@type UIHallCtrl
	self.ctrl=self.ctrl
end

function UIHallModel:Close()
    self.super.Close(self);
end

function UIHallModel:AddEvent()
	WebNetEvent.AddListener(pb_PlatformHall.NoticeBaseInfoChange,self.NoticeBaseInfoChange,self)
end

function UIHallModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

function UIHallModel:NoticeBaseInfoChange(msg)
	self.ctrl:RefreshPlayerInfos(msg)
end


return UIHallModel