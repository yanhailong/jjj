---
---Create by Administrator
---DateTime: 2025-07-21 16:36:00
---
---@class UIGMModel:BaseModel
local UIGMModel=Class("UIGMModel",BaseModel)


function UIGMModel:Awake()
	self.super.Awake(self);
	---@type UIGMCtrl
	self.ctrl=self.ctrl
end

function UIGMModel:Close()
    self.super.Close(self);
end

function UIGMModel:AddEvent()
	WebNetEvent.AddListener(pb_PlatformHall.ResGm,self.ResGm,self)
	
end

function UIGMModel:RemoveEvent()

end

function UIGMModel:ReqGm(codeStr)
	local data={}
	data.order=codeStr
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqGm,data)
end

function UIGMModel:ResGm(msg)
	SuspensionTipsUtil.SuspensionTips("GM 操作成功！"..msg.result)
end


return UIGMModel