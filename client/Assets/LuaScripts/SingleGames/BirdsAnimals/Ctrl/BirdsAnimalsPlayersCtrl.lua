---
---Create by Administrator
---DateTime: 2025-07-03 09:54:21
---
---@class BirdsAnimalsPlayersCtrl:BaseCtrl
local BirdsAnimalsPlayersCtrl=Class("BirdsAnimalsPlayersCtrl",BaseCtrl)

---构造函数
function BirdsAnimalsPlayersCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsPlayersPanel";
    self.prefabName="BirdsAnimalsPlayersPanel"
    self.super.ctor(self,ctrlName,param);
	---@type BirdsAnimalsPlayersView
	self.view = self.view
	---@type BirdsAnimalsPlayersModel
	self.model = self.model
end

---初始化
function BirdsAnimalsPlayersCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BirdsAnimalsPlayersCtrl:InitData()
	GlobalEvent.Notify("RECT_BIRDSANIMALS_PLAYER") --测试
end

function BirdsAnimalsPlayersCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BirdsAnimalsPlayersCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function() 
		self:Close()
	end)
end

---移除UI事件
function BirdsAnimalsPlayersCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BirdsAnimalsPlayersCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BirdsAnimalsPlayersCtrl