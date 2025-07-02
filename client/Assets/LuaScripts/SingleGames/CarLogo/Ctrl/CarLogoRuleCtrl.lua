---
---Create by Administrator
---DateTime: 2025-06-30 15:05:25
---
---@class CarLogoRuleCtrl:BaseCtrl
local CarLogoRuleCtrl=Class("CarLogoRuleCtrl",BaseCtrl)

---构造函数
function CarLogoRuleCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoRulePanel";
    self.prefabName="CarLogoRulePanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoRuleView
	self.view = self.view
	---@type CarLogoRuleModel
	self.model = self.model
end

---初始化
function CarLogoRuleCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function CarLogoRuleCtrl:InitData()
	
end

function CarLogoRuleCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function CarLogoRuleCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function CarLogoRuleCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function CarLogoRuleCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoRuleCtrl