---
---Create by Administrator
---DateTime: 2025-07-03 10:40:03
---
---@class BirdsAnimalsRuleCtrl:BaseCtrl
local BirdsAnimalsRuleCtrl=Class("BirdsAnimalsRuleCtrl",BaseCtrl)

---构造函数
function BirdsAnimalsRuleCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsRulePanel";
    self.prefabName="BirdsAnimalsRulePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BirdsAnimalsRuleView
	self.view = self.view
	---@type BirdsAnimalsRuleModel
	self.model = self.model
end

---初始化
function BirdsAnimalsRuleCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BirdsAnimalsRuleCtrl:InitData()
	
end

function BirdsAnimalsRuleCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BirdsAnimalsRuleCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function BirdsAnimalsRuleCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BirdsAnimalsRuleCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BirdsAnimalsRuleCtrl