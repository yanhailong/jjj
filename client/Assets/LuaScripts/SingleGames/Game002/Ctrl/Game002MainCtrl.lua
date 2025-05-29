---
---Create by Administrator
---DateTime: 2025-05-29 13:46:04
---
---@class Game002MainCtrl:BaseCtrl
local Game002MainCtrl=Class("Game002MainCtrl",BaseCtrl)

---构造函数
function Game002MainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Game002/prefabs/Game002Main";
    self.prefabName="Game002Main"
    self.super.ctor(self,ctrlName,param);
	---@type Game002MainView
	self.view = self.view
	---@type Game002MainModel
	self.model = self.model
end

---初始化
function Game002MainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function Game002MainCtrl:InitData()
	
end

function Game002MainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function Game002MainCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:Close()
	end)
end

---移除UI事件
function Game002MainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function Game002MainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return Game002MainCtrl