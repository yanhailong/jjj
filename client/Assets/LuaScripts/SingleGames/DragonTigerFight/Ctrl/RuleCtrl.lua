---
---Create by Administrator
---DateTime: 2025-06-26 17:17:27
---
---@class RuleCtrl:BaseCtrl
local RuleCtrl=Class("RuleCtrl",BaseCtrl)

---构造函数
function RuleCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/DragonTigerFight/prefabs/panel/RulePanel";
    self.prefabName="RulePanel"
    self.super.ctor(self,ctrlName,param);
	---@type RuleView
	self.view = self.view
	---@type RuleViewModel
	self.model = self.model
end

---初始化
function RuleCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function RuleCtrl:InitData()
	
end

function RuleCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function RuleCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function RuleCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function RuleCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return RuleCtrl