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
	GlobalEvent.AddListener(UpdateGameEvent.updateError,self.UpdateError,self);
	GlobalEvent.AddListener(UpdateGameEvent.updateProgress,self.UpdateProgress,self);
	GlobalEvent.AddListener(UpdateGameEvent.updateFinished,self.UpdateFinished,self);
	GlobalEvent.AddListener(UpdateGameEvent.waitUpdate,self.WaitUpdate,self);
	GlobalEvent.AddListener(UpdateGameEvent.cancelWaitUpdate,self.CancelWaitUpdate,self);
end

function UIHallGamesModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
	GlobalEvent.RemoveAllTo(self)
end
--region 事件方法
---更新错误通知
function UIHallGamesModel:UpdateError(gameName,state,msg)
	self.ctrl.view:UpdateError(gameName);
end

---更新进度
function UIHallGamesModel:UpdateProgress(gameName,cur,total)
	self.ctrl.view:SetUpdateProgress(gameName,cur,total);
end

---更新完成
function UIHallGamesModel:UpdateFinished(gameName)
	self.ctrl.view:UpdateFinished(gameName);
end

---等待更新
function UIHallGamesModel:WaitUpdate(gameName)
	self.ctrl.view:WaitUpdate(gameName);
end

---取消等待更新
function UIHallGamesModel:CancelWaitUpdate(gameName)
	self.ctrl.view:CancelWaitUpdate(gameName);
end
--endregion


return UIHallGamesModel